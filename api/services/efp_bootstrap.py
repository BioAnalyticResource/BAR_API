"""
Utilities to bootstrap the simple eFP databases directly from the shared schema
definitions. Shared by the CLI script and the Flask endpoint so we only maintain
one implementation.
"""

from __future__ import annotations

import re
import hashlib
from typing import Dict, Iterable, List

from sqlalchemy import Column, Index, MetaData, Table, create_engine, text
from sqlalchemy.dialects.mysql import FLOAT, INTEGER, TEXT, VARCHAR
from sqlalchemy.engine import URL

from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS


def _column_type(column_spec):
    """
    Convert a column specification dictionary to a SQLAlchemy MySQL column type.

    :param column_spec: Dictionary containing column metadata from schema definition
    :type column_spec: Dict[str, Any]
    :return: SQLAlchemy column type object (VARCHAR, INTEGER, FLOAT, or TEXT)
    :rtype: sqlalchemy.types.TypeEngine
    :raises ValueError: If column type is not one of: string, integer, float, text
    """
    col_type = column_spec.get("type")
    if col_type == "string":
        return VARCHAR(column_spec["length"])
    if col_type == "integer":
        return INTEGER(unsigned=column_spec.get("unsigned", False))
    if col_type == "float":
        # explicit mysql float keeps parity with the original dumps
        return FLOAT()
    if col_type == "text":
        return TEXT()
    raise ValueError(f"Unsupported column type: {col_type}")


def _build_table(metadata: MetaData, spec, db_name: str) -> Table:
    """
    Build a SQLAlchemy Table object from a schema specification.

    Creates columns with proper types, constraints, defaults, and indexes based on
    the schema definition. This Table object can be used to generate CREATE TABLE
    SQL statements.

    :param metadata: SQLAlchemy MetaData object to attach the table to
    :type metadata: sqlalchemy.schema.MetaData
    :param spec: Database schema specification from SIMPLE_EFP_DATABASE_SCHEMAS
    :type spec: Dict[str, Any]
    :param db_name: Name of the database (used for index naming)
    :type db_name: str
    :return: SQLAlchemy Table object with all columns and indexes defined
    :rtype: sqlalchemy.schema.Table
    """
    columns = []
    for column in spec["columns"]:
        kwargs = {"nullable": column.get("nullable", True)}
        if column.get("primary_key"):
            kwargs["primary_key"] = True
        default_value = column.get("default")
        if default_value is not None:
            if isinstance(default_value, str):
                kwargs["server_default"] = text(f"'{default_value}'")
            else:
                kwargs["server_default"] = text(str(default_value))

        columns.append(Column(column["name"], _column_type(column), **kwargs))

    table = Table(spec["table_name"], metadata, *columns, mysql_charset=spec.get("charset"))
    index_cols = spec.get("index") or []
    if index_cols:
        index_name = _make_index_name(db_name, index_cols)
        Index(index_name, *[table.c[col] for col in index_cols])
    return table


def _make_index_name(db_name: str, index_cols: Iterable[str], max_len: int = 64) -> str:
    """
    Create a MySQL-safe index name capped at 64 characters.

    If the generated name is too long, fall back to a truncated db_name with a stable hash
    to keep names deterministic and avoid collisions.
    """
    base = f"ix_{db_name}_{'_'.join(index_cols)}"
    if len(base) <= max_len:
        return base

    digest = hashlib.sha1(base.encode("utf-8")).hexdigest()[:8]
    reserved = len("ix_") + 1 + len(digest)
    db_len = max_len - reserved
    if db_len <= 0:
        return f"ix_{digest}"
    return f"ix_{db_name[:db_len]}_{digest}"


def _build_url(host: str, port: int, user: str, password: str, database: str | None = None) -> URL:
    """
    Build a SQLAlchemy database URL for MySQL connections.

    :param host: MySQL server hostname (e.g., 'localhost', 'BAR_mysqldb')
    :type host: str
    :param port: MySQL server port number (typically 3306)
    :type port: int
    :param user: MySQL username for authentication
    :type user: str
    :param password: MySQL password for authentication
    :type password: str
    :param database: Optional database name to connect to; if None, connects to server without selecting a database
    :type database: str or None
    :return: SQLAlchemy URL object for mysql+mysqldb connections
    :rtype: sqlalchemy.engine.URL
    """
    return URL.create(
        drivername="mysql+mysqldb",
        username=user,
        password=password,
        host=host,
        port=port,
        database=database,
    )


def ensure_database(server_url: URL, db_name: str, charset: str) -> None:
    """
    Create a MySQL database if it doesn't already exist.

    Executes CREATE DATABASE IF NOT EXISTS with the specified character set.
    Safe to call multiple times - will not error if database already exists.

    :param server_url: SQLAlchemy URL for MySQL server connection (without database selected)
    :type server_url: sqlalchemy.engine.URL
    :param db_name: Name of the database to create
    :type db_name: str
    :param charset: MySQL character set (e.g., 'latin1', 'utf8mb4')
    :type charset: str
    :return: None
    :rtype: None
    :raises ValueError: If db_name or charset contains invalid characters
    """
    # Validate database name to prevent SQL injection - only allow safe identifier characters
    if not re.match(r'^[a-zA-Z0-9_$]+$', db_name):
        raise ValueError(f"Invalid database name: {db_name}. Only alphanumeric, underscore, and dollar sign characters are allowed.")

    # Validate charset name to prevent SQL injection - only allow safe characters
    if not re.match(r'^[a-zA-Z0-9_]+$', charset):
        raise ValueError(f"Invalid charset name: {charset}. Only alphanumeric and underscore characters are allowed.")

    server_engine = create_engine(server_url)
    with server_engine.begin() as conn:
        # Safe to use f-string here since we've validated the inputs above
        conn.execute(text(f"CREATE DATABASE IF NOT EXISTS `{db_name}` DEFAULT CHARACTER SET {charset}"))


def ensure_schema(db_url: URL, spec, db_name: str) -> Dict[str, object]:
    """
    Create database tables and insert seed data if the table is empty.

    Uses SQLAlchemy's metadata.create_all() to generate CREATE TABLE statements
    from the schema specification. If seed_rows are defined in the spec and the
    table is empty, inserts the seed data.

    :param db_url: SQLAlchemy URL for the specific database connection
    :type db_url: sqlalchemy.engine.URL
    :param spec: Database schema specification from SIMPLE_EFP_DATABASE_SCHEMAS
    :type spec: Dict[str, Any]
    :param db_name: Name of the database (used for table naming)
    :type db_name: str
    :return: Dictionary with 'table' (table name) and 'seeded_rows' (count of inserted rows)
    :rtype: Dict[str, object]
    """
    metadata = MetaData()
    table = _build_table(metadata, spec, db_name)
    engine = create_engine(db_url)
    metadata.create_all(engine, checkfirst=True)

    seed_rows = spec.get("seed_rows") or []
    inserted = 0
    if seed_rows:
        with engine.connect() as conn:
            count = conn.execute(text(f"SELECT COUNT(1) FROM {table.name}")).scalar() or 0
            if count == 0:
                with engine.begin() as write_conn:
                    write_conn.execute(table.insert(), seed_rows)
                    inserted = len(seed_rows)

    return {"table": table.name, "seeded_rows": inserted}


def bootstrap_simple_efp_databases(
    *,
    host: str,
    port: int,
    user: str,
    password: str,
    databases: Iterable[str] | None = None,
) -> List[Dict[str, object]]:
    """
    Bootstrap simple eFP databases in MySQL from schema definitions.

    This is the main entry point for creating eFP databases. For each database:
    1. Creates the database if it doesn't exist
    2. Creates the sample_data table with schema from SIMPLE_EFP_DATABASE_SCHEMAS
    3. Inserts seed rows if the table is empty and seed_rows are defined

    Used by:
    - scripts/bootstrap_simple_efp_dbs.py (CLI tool)
    - config/init.sh (Docker/CI initialization)
    - api/resources/efp_proxy.py (HTTP bootstrap endpoint)

    :param host: MySQL server hostname (e.g., 'localhost', 'BAR_mysqldb' for Docker)
    :type host: str
    :param port: MySQL server port number (typically 3306)
    :type port: int
    :param user: MySQL username with CREATE DATABASE privileges
    :type user: str
    :param password: MySQL password for authentication
    :type password: str
    :param databases: Optional list of specific databases to bootstrap; if None, bootstraps all databases in SIMPLE_EFP_DATABASE_SCHEMAS
    :type databases: Iterable[str] or None
    :return: List of result dictionaries, each containing 'database' (name), 'table' (table name), and 'seeded_rows' (count)
    :rtype: List[Dict[str, object]]
    :raises ValueError: If a requested database is not defined in SIMPLE_EFP_DATABASE_SCHEMAS

    Example::

        results = bootstrap_simple_efp_databases(
            host='localhost',
            port=3306,
            user='root',
            password='password',
            databases=['cannabis', 'dna_damage']
        )
        # Returns: [
        #     {'database': 'cannabis', 'table': 'sample_data', 'seeded_rows': 1},
        #     {'database': 'dna_damage', 'table': 'sample_data', 'seeded_rows': 1}
        # ]
    """

    results: List[Dict[str, object]] = []
    target_dbs = list(databases) if databases is not None else list(SIMPLE_EFP_DATABASE_SCHEMAS.keys())

    server_url = _build_url(host, port, user, password, database=None)
    for db_name in target_dbs:
        if db_name not in SIMPLE_EFP_DATABASE_SCHEMAS:
            raise ValueError(f"Unknown simple eFP database: {db_name}")

        spec = SIMPLE_EFP_DATABASE_SCHEMAS[db_name]
        charset = spec.get("charset", "utf8mb4")
        ensure_database(server_url, db_name, charset)
        db_url = _build_url(host, port, user, password, database=db_name)
        schema_result = ensure_schema(db_url, spec, db_name)
        results.append(
            {
                "database": db_name,
                "table": schema_result["table"],
                "seeded_rows": schema_result["seeded_rows"],
            }
        )

    return results


__all__ = ["bootstrap_simple_efp_databases"]
