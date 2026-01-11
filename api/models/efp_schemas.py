"""
Simple schema definitions for eFP databases that only expose a sample_data table.

This module provides the single source of truth for all simple eFP database schemas,
including column definitions, indexes, seed data, and metadata. These schemas are used
by both the ORM model generator and the database bootstrap scripts.
"""

from __future__ import annotations

from typing import Any, Dict, List

ColumnSpec = Dict[str, Any]
DatabaseSpec = Dict[str, Any]


def _column(
    name: str,
    col_type: str,
    *,
    length: int | None = None,
    unsigned: bool = False,
    nullable: bool = True,
    default: Any | None = None,
    primary_key: bool = False,
) -> ColumnSpec:
    """
    Create a column specification dictionary for schema definitions.

    Helper function to construct column metadata with type, constraints, and defaults
    in a consistent format.

    :param name: Column name (e.g., 'data_probeset_id', 'data_signal')
    :type name: str
    :param col_type: Column type ('string', 'integer', 'float', or 'text')
    :type col_type: str
    :param length: Maximum length for string types (required for 'string')
    :type length: int or None
    :param unsigned: Whether integer type is unsigned (MySQL-specific)
    :type unsigned: bool
    :param nullable: Whether column allows NULL values
    :type nullable: bool
    :param default: Default value for the column
    :type default: Any or None
    :param primary_key: Whether column is part of primary key
    :type primary_key: bool
    :return: Column specification dictionary
    :rtype: ColumnSpec

    Example::

        col = _column("data_signal", "float", nullable=False, default=0)
        # Returns: {"name": "data_signal", "type": "float", "nullable": False, "default": 0}
    """
    column: ColumnSpec = {"name": name, "type": col_type, "nullable": nullable}
    if length is not None:
        column["length"] = length
    if unsigned:
        column["unsigned"] = True
    if default is not None:
        column["default"] = default
    if primary_key:
        column["primary_key"] = True
    return column


# base column specs keep every schema consistent unless an override is provided
BASE_COLUMNS: Dict[str, ColumnSpec] = {
    "proj_id": _column("proj_id", "string", length=5, nullable=False, default="0"),
    "sample_id": _column("sample_id", "integer", unsigned=True, nullable=False, default=0),
    "data_probeset_id": _column("data_probeset_id", "string", length=24, nullable=False, primary_key=True),
    "data_signal": _column("data_signal", "float", nullable=False, default=0, primary_key=True),
    "data_bot_id": _column("data_bot_id", "string", length=16, nullable=False, primary_key=True),
}

# blueprint defines the order we hydrate into tables
DEFAULT_BLUEPRINT: List[str] = ["proj_id", "sample_id", "data_probeset_id", "data_signal", "data_bot_id"]
DEFAULT_INDEX = ["data_probeset_id", "data_bot_id", "data_signal"]


def _build_schema(
    *,
    charset: str = "latin1",
    table_name: str = "sample_data",
    column_overrides: Dict[str, Dict[str, Any]] | None = None,
    extra_columns: List[ColumnSpec] | None = None,
    index: List[str] | None = None,
    seed_rows: List[Dict[str, Any]] | None = None,
    identifier_type: str = "agi",
    metadata: Dict[str, Any] | None = None,
) -> DatabaseSpec:
    """
    Build a complete database schema specification from base columns and customizations.

    Constructs a schema by starting with the default BASE_COLUMNS, applying any
    overrides, and adding extra columns. The resulting schema dictionary is used by
    both the ORM generator and bootstrap scripts to ensure consistency.

    :param charset: MySQL character set (e.g., 'latin1', 'utf8mb4')
    :type charset: str
    :param table_name: Name of the table to create (typically 'sample_data')
    :type table_name: str
    :param column_overrides: Dictionary of column names to property overrides
    :type column_overrides: Dict[str, Dict[str, Any]] or None
    :param extra_columns: Additional columns beyond the base set
    :type extra_columns: List[ColumnSpec] or None
    :param index: List of column names to include in the index
    :type index: List[str] or None
    :param seed_rows: Initial rows to insert if table is empty
    :type seed_rows: List[Dict[str, Any]] or None
    :param identifier_type: Gene ID format ('agi' or 'probeset')
    :type identifier_type: str
    :param metadata: Additional metadata (species, sample_regex, etc.)
    :type metadata: Dict[str, Any] or None
    :return: Complete database schema specification
    :rtype: DatabaseSpec

    Example::

        schema = _build_schema(
            charset="utf8mb4",
            column_overrides={"proj_id": {"length": 5}},
            metadata={"species": "arabidopsis"}
        )
    """
    overrides = column_overrides or {}
    columns: List[ColumnSpec] = []

    for column_name in DEFAULT_BLUEPRINT:
        spec = dict(BASE_COLUMNS[column_name])
        if column_name in overrides:
            spec.update(overrides[column_name])
        columns.append(spec)

    if extra_columns:
        columns.extend(extra_columns)

    # schema dict is the single source of truth for each database
    schema: DatabaseSpec = {
        "table_name": table_name,
        "charset": charset,
        "columns": columns,
        "index": index if index is not None else list(DEFAULT_INDEX),
        "identifier_type": identifier_type,
    }

    if seed_rows:
        schema["seed_rows"] = seed_rows
    if metadata:
        schema["metadata"] = metadata

    return schema


# Schema pattern helpers - group databases with similar column structures
def _simple_schema(
    species: str,
    sample_regex: str,
    probeset_len: int = 24,
    bot_id_len: int = 16,
    proj_id_len: int = 5,
    charset: str = "latin1",
    **kwargs,
) -> DatabaseSpec:
    """
    Helper for simple 5-column schemas (most common pattern).

    :param species: Species name for metadata
    :param sample_regex: Regular expression for sample validation
    :param probeset_len: Length of data_probeset_id column
    :param bot_id_len: Length of data_bot_id column
    :param proj_id_len: Length of proj_id column
    :param charset: MySQL character set
    :param kwargs: Additional arguments passed to _build_schema
    :return: Database schema specification
    """
    overrides = {
        "data_probeset_id": {"length": probeset_len},
        "data_bot_id": {"length": bot_id_len},
    }
    if proj_id_len != 5:
        overrides["proj_id"] = {"length": proj_id_len}
    if "proj_id_default" in kwargs:
        overrides.setdefault("proj_id", {})["default"] = kwargs.pop("proj_id_default")
    if "signal_nullable" in kwargs:
        overrides.setdefault("data_signal", {})["nullable"] = kwargs.pop("signal_nullable")
    if "bot_id_nullable" in kwargs:
        overrides.setdefault("data_bot_id", {})["nullable"] = kwargs.pop("bot_id_nullable")

    return _build_schema(
        charset=charset,
        column_overrides=overrides,
        metadata={"species": species, "sample_regex": sample_regex},
        **kwargs,
    )


def _schema_with_qa_columns(
    species: str,
    sample_regex: str,
    probeset_len: int = 24,
    bot_id_len: int = 16,
    **kwargs,
) -> DatabaseSpec:
    """
    Helper for schemas with quality assurance columns (sample_file_name, data_call, data_p_val).

    :param species: Species name for metadata
    :param sample_regex: Regular expression for sample validation
    :param probeset_len: Length of data_probeset_id column
    :param bot_id_len: Length of data_bot_id column
    :param kwargs: Additional arguments passed to _build_schema
    :return: Database schema specification
    """
    extra_cols = [
        _column("sample_file_name", kwargs.pop("file_name_type", "text"), nullable=True),
        _column("data_call", kwargs.pop("call_type", "text"), nullable=True),
        _column("data_p_val", "float", nullable=True, default=0),
    ]
    return _simple_schema(
        species=species,
        sample_regex=sample_regex,
        probeset_len=probeset_len,
        bot_id_len=bot_id_len,
        extra_columns=extra_cols,
        index=["data_probeset_id"],
        **kwargs,
    )


# simple canonical schema for the easiest efp mirrors so the orm code and bootstrap script stay in sync
SIMPLE_EFP_DATABASE_SCHEMAS: Dict[str, DatabaseSpec] = {
    # Schemas with QA columns (sample_file_name, data_call, data_p_val)
    "arabidopsis_ecotypes": _schema_with_qa_columns(
        species="arabidopsis",
        sample_regex=r"^[A-Z0-9_]{1,20}$|Med_CTRL$",
        probeset_len=30,
        proj_id_len=15,
        signal_nullable=True,
        bot_id_nullable=True,
    ),
    "shoot_apex": _schema_with_qa_columns(
        species="arabidopsis",
        sample_regex=r"^\D{1,5}\d{0,2}|MED_CTRL$",
        probeset_len=12,
        bot_id_len=8,
        proj_id_len=2,
        proj_id_default=None,
        file_name_type="string",
        call_type="string",
    ),
    # Simple 5-column schemas
    "cannabis": _simple_schema(
        species="cannabis",
        sample_regex=r"^PK-\D{1,4}|MED_CTRL$",
        probeset_len=24,
        bot_id_len=8,
        proj_id_len=2,
        seed_rows=[
            {"proj_id": "1", "sample_id": 1, "data_probeset_id": "AGQN03009284", "data_signal": 0, "data_bot_id": "PK-RT"}
        ],
    ),
    "dna_damage": _simple_schema(
        species="arabidopsis",
        sample_regex=r"^\D{1,3}.{1,30}_plus_Y|\D{1,3}.{1,30}_minus_Y|Med_CTRL$",
        charset="utf8mb4",
        probeset_len=10,
        bot_id_len=32,
        bot_id_nullable=True,
        seed_rows=[
            {
                "proj_id": "1",
                "sample_id": 1,
                "data_probeset_id": "AT1G01010",
                "data_signal": 59,
                "data_bot_id": "col-0_rep1_12hr_minus_Y",
            }
        ],
    ),
    "embryo": _simple_schema(
        species="arabidopsis",
        sample_regex=r"^\D{1,3}_\d$|Med_CTRL$",
        proj_id_len=3,
        bot_id_len=8,
        signal_nullable=True,
        seed_rows=[
            {"proj_id": "1", "sample_id": 1, "data_probeset_id": "AT1G01010", "data_signal": 0.67, "data_bot_id": "pg_1"}
        ],
    ),
    "germination": _simple_schema(
        species="arabidopsis",
        sample_regex=r"^\d{1,3}\D{1,4}_\d{1,3}|harvest_\d|Med_CTRL$",
        proj_id_len=3,
        probeset_len=30,
    ),
    "kalanchoe": _simple_schema(
        species="kalanchoe",
        sample_regex=r"^\D{1,4}_\D{1,5}_rep\d|MED_CTRL$",
        proj_id_len=2,
    ),
    "phelipanche": _simple_schema(
        species="phelipanche",
        sample_regex=r"^[a-z_-]{1,35}|MED_CTRL$",
        charset="utf8mb4",
        proj_id_len=5,
        proj_id_default=None,
        bot_id_len=32,
    ),
    "selaginella": _simple_schema(
        species="selaginella",
        sample_regex=r"^[\D\d]{1,33}|MED_CTRL$",
        proj_id_len=5,
        probeset_len=18,
        bot_id_len=36,
    ),
    "silique": _simple_schema(
        species="arabidopsis",
        sample_regex=r"^\d{1,3}_dap.{1,58}_R1_001|Med_CTRL$",
        proj_id_len=5,
        proj_id_default=None,
        probeset_len=12,
        bot_id_len=64,
    ),
    "single_cell": _simple_schema(
        species="arabidopsis",
        sample_regex=r"^\D+\d+_WT\d+.ExprMean|MED_CTRL$",
        proj_id_len=5,
        proj_id_default=None,
        bot_id_len=32,
    ),
    "strawberry": _simple_schema(
        species="strawberry",
        sample_regex=r"^\D{1,12}_.{1,8}_\D{1,2}|MED_CTRL$",
        charset="utf8mb4",
        proj_id_len=5,
        proj_id_default=None,
        bot_id_len=24,
    ),
    "striga": _simple_schema(
        species="striga",
        sample_regex=r"^\D{1,35}|MED_CTRL$",
        proj_id_len=5,
        proj_id_default=None,
        bot_id_len=42,
    ),
    "triphysaria": _simple_schema(
        species="triphysaria",
        sample_regex=r"^[a-z_]{1,35}|MED_CTRL$",
        charset="utf8mb4",
        proj_id_len=5,
        proj_id_default=None,
        bot_id_len=32,
    ),
    # Schema with data_call column
    "klepikova": _simple_schema(
        species="arabidopsis",
        sample_regex=r"^SRR\d{1,9}|Med_CTRL$",
        proj_id_len=3,
        probeset_len=30,
        extra_columns=[_column("data_call", "string", length=2, nullable=True)],
    ),
    # Schemas with string sample_id column (non-standard)
    "arachis": _build_schema(
        column_overrides={
            "proj_id": {"length": 24, "default": None},
            "sample_id": {"type": "string", "length": 5, "unsigned": False, "default": None},
            "data_probeset_id": {"length": 30},
            "data_bot_id": {"length": 65},
        },
        metadata={
            "species": "arachis",
            "sample_regex": r"^[\D\d_]{1,30}|MED_CTRL$",
        },
    ),
    "physcomitrella_db": _build_schema(
        column_overrides={
            "proj_id": {"length": 30, "default": ""},
            "sample_id": {"type": "string", "length": 30, "unsigned": False, "default": ""},
            "data_probeset_id": {"length": 40, "default": "", "primary_key": True},
            "data_bot_id": {"length": 40},
        },
        metadata={
            "species": "physcomitrella",
            "sample_regex": r"^[a-z_123]{1,15}|MED_CTRL$",
        },
    ),
}

__all__: List[str] = ["SIMPLE_EFP_DATABASE_SCHEMAS", "ColumnSpec", "DatabaseSpec"]
