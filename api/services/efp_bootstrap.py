"""
Utilities to bootstrap the simple eFP databases directly from the shared schema
definitions. Shared by the CLI script and the Flask endpoint so we only maintain
one implementation.
"""

from __future__ import annotations

from typing import Dict, Iterable, List

from sqlalchemy import Column, Index, MetaData, Table, create_engine, text
from sqlalchemy.dialects.mysql import FLOAT, INTEGER, TEXT, VARCHAR
from sqlalchemy.engine import URL

from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS


def _column_type(column_spec):
    """Return the MySQL column type for a schema entry."""
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
        Index(f"ix_{db_name}_{'_'.join(index_cols)}", *[table.c[col] for col in index_cols])
    return table


def _build_url(host: str, port: int, user: str, password: str, database: str | None = None) -> URL:
    return URL.create(
        drivername="mysql+mysqldb",
        username=user,
        password=password,
        host=host,
        port=port,
        database=database,
    )


def ensure_database(server_url: URL, db_name: str, charset: str) -> None:
    server_engine = create_engine(server_url)
    with server_engine.begin() as conn:
        conn.execute(text(f"CREATE DATABASE IF NOT EXISTS `{db_name}` DEFAULT CHARACTER SET {charset}"))


def ensure_schema(db_url: URL, spec, db_name: str) -> Dict[str, object]:
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
    Ensure that all requested simple eFP databases exist in MySQL and their schema
    matches the definitions in SIMPLE_EFP_DATABASE_SCHEMAS.
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
