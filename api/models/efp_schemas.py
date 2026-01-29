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


class EfpSchemaBuilder:
    """Factory for shared schema helpers used across eFP databases."""

    @staticmethod
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

            col = EfpSchemaBuilder._column("data_signal", "float", nullable=False, default=0)
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

    @staticmethod
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

            schema = EfpSchemaBuilder._build_schema(
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

    @staticmethod
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

        Note: Field lengths (probeset_len, bot_id_len, proj_id_len) are determined by the actual
        data in each database and can vary even between databases with similar structures.
        These lengths are set based on the maximum observed values in the source data.

        :param species: Species name for metadata
        :param sample_regex: Regular expression for sample validation
        :param probeset_len: Length of data_probeset_id column (varies by database, default 24)
        :param bot_id_len: Length of data_bot_id column (varies by database, default 16)
        :param proj_id_len: Length of proj_id column (varies by database, default 5)
        :param charset: MySQL character set
        :param kwargs: Additional arguments passed to _build_schema
        :return: Database schema specification
        """
        overrides = {}

        # Handle data_probeset_id
        if "probeset_type" in kwargs:
            probeset_type = kwargs.pop("probeset_type")
            overrides["data_probeset_id"] = {"type": probeset_type, "length": None}
            # TEXT columns cannot be primary keys in MySQL
            if probeset_type == "text":
                overrides["data_probeset_id"]["primary_key"] = False
        else:
            overrides["data_probeset_id"] = {"length": probeset_len}

        # Handle data_bot_id
        if "bot_id_type" in kwargs:
            bot_id_type = kwargs.pop("bot_id_type")
            overrides["data_bot_id"] = {"type": bot_id_type, "length": None}
            # TEXT columns cannot be primary keys in MySQL
            if bot_id_type == "text":
                overrides["data_bot_id"]["primary_key"] = False
        else:
            overrides["data_bot_id"] = {"length": bot_id_len}

        # Handle proj_id
        if proj_id_len != 5:
            overrides["proj_id"] = {"length": proj_id_len}

        # Handle type changes for base columns
        if "proj_id_type" in kwargs:
            proj_type = kwargs.pop("proj_id_type")
            overrides.setdefault("proj_id", {})["type"] = proj_type
            if proj_type == "integer":
                overrides["proj_id"]["unsigned"] = True

        if "sample_id_type" in kwargs:
            sample_type = kwargs.pop("sample_id_type")
            overrides.setdefault("sample_id", {})["type"] = sample_type
            overrides["sample_id"]["unsigned"] = False
            if "sample_id_len" in kwargs:
                overrides["sample_id"]["length"] = kwargs.pop("sample_id_len")

        # Handle nullable flags and defaults
        if "proj_id_default" in kwargs:
            overrides.setdefault("proj_id", {})["default"] = kwargs.pop("proj_id_default")
        if "signal_nullable" in kwargs:
            overrides.setdefault("data_signal", {})["nullable"] = kwargs.pop("signal_nullable")
        if "bot_id_nullable" in kwargs:
            overrides.setdefault("data_bot_id", {})["nullable"] = kwargs.pop("bot_id_nullable")
        if "probeset_nullable" in kwargs:
            overrides.setdefault("data_probeset_id", {})["nullable"] = kwargs.pop("probeset_nullable")

        # Build index list, excluding TEXT columns (can't be indexed in MySQL)
        index_columns = list(DEFAULT_INDEX)
        if "data_probeset_id" in overrides and overrides["data_probeset_id"].get("type") == "text":
            index_columns = [col for col in index_columns if col != "data_probeset_id"]
        if "data_bot_id" in overrides and overrides["data_bot_id"].get("type") == "text":
            index_columns = [col for col in index_columns if col != "data_bot_id"]

        # Allow manual index override if specified
        if "index" not in kwargs:
            kwargs["index"] = index_columns

        return EfpSchemaBuilder._build_schema(
            charset=charset,
            column_overrides=overrides,
            metadata={"species": species, "sample_regex": sample_regex},
            **kwargs,
        )

    @staticmethod
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
        # Handle file_name column type/length
        file_name_type = kwargs.pop("file_name_type", "text")
        file_name_len = kwargs.pop("file_name_len", 16) if file_name_type == "string" else None

        # Handle call column type/length
        call_type = kwargs.pop("call_type", "text")
        call_len = kwargs.pop("call_len", 2) if call_type == "string" else None

        # Build QA columns
        qa_cols = [
            EfpSchemaBuilder._column("sample_file_name", file_name_type, length=file_name_len, nullable=True),
            EfpSchemaBuilder._column("data_call", call_type, length=call_len, nullable=True),
            EfpSchemaBuilder._column("data_p_val", "float", nullable=True, default=0),
        ]

        # Merge with any extra columns passed in
        extra_columns = kwargs.pop("extra_columns", [])
        all_extra_cols = qa_cols + extra_columns

        # Build index list - exclude data_probeset_id if it's TEXT type
        index_columns = ["data_probeset_id"]
        if kwargs.get("probeset_type") == "text":
            index_columns = []

        return EfpSchemaBuilder._simple_schema(
            species=species,
            sample_regex=sample_regex,
            probeset_len=probeset_len,
            bot_id_len=bot_id_len,
            extra_columns=all_extra_cols,
            index=index_columns,
            **kwargs,
        )


# base column specs keep every schema consistent unless an override is provided
BASE_COLUMNS: Dict[str, ColumnSpec] = {
    "proj_id": EfpSchemaBuilder._column("proj_id", "string", length=5, nullable=False, default="0"),
    "sample_id": EfpSchemaBuilder._column("sample_id", "integer", unsigned=True, nullable=False, default=0),
    "data_probeset_id": EfpSchemaBuilder._column(
        "data_probeset_id", "string", length=24, nullable=False, primary_key=True
    ),
    "data_signal": EfpSchemaBuilder._column("data_signal", "float", nullable=False, default=0, primary_key=True),
    "data_bot_id": EfpSchemaBuilder._column("data_bot_id", "string", length=16, nullable=False, primary_key=True),
}

# blueprint defines the order we hydrate into tables
DEFAULT_BLUEPRINT: List[str] = ["proj_id", "sample_id", "data_probeset_id", "data_signal", "data_bot_id"]
DEFAULT_INDEX = ["data_probeset_id", "data_bot_id", "data_signal"]

# Replace the existing SIMPLE_EFP_DATABASE_SCHEMAS dict in efp_schemas.py with this:

SIMPLE_EFP_DATABASE_SCHEMAS: Dict[str, DatabaseSpec] = {
    'actinidia_bud_development': EfpSchemaBuilder._simple_schema(
        species='actinidia',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'actinidia_flower_fruit_development': EfpSchemaBuilder._simple_schema(
        species='actinidia',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'actinidia_postharvest': EfpSchemaBuilder._simple_schema(
        species='actinidia',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'actinidia_vegetative_growth': EfpSchemaBuilder._simple_schema(
        species='actinidia',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'affydb': EfpSchemaBuilder._schema_with_qa_columns(
        species='arabidopsis',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_type='integer',
        probeset_len=30,
        probeset_nullable=True,
        bot_id_type='text',
        bot_id_nullable=True,
        extra_columns=[
            EfpSchemaBuilder._column('data_num', 'integer', default=0),
        ],
    ),
    'apple': EfpSchemaBuilder._simple_schema(
        species='apple',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=18,
        bot_id_len=12,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'arabidopsis_ecotypes': EfpSchemaBuilder._schema_with_qa_columns(
        species='arabidopsis',
        sample_regex=r"^[A-Z0-9_]{1,20}$|Med_CTRL$",
        proj_id_len=15,
        probeset_len=30,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_nullable=True,
    ),
    'arachis': EfpSchemaBuilder._simple_schema(
        species='arachis',
        sample_regex=r"^[\D\d_]{1,30}|MED_CTRL$",
        sample_id_type='string',
        sample_id_len=5,
        proj_id_len=24,
        proj_id_default=None,
        probeset_len=30,
        bot_id_len=65,
    ),
    'atgenexp': EfpSchemaBuilder._schema_with_qa_columns(
        species='arabidopsis',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_type='integer',
        probeset_len=30,
        probeset_nullable=True,
        bot_id_len=50,
    ),
    'atgenexp_hormone': EfpSchemaBuilder._simple_schema(
        species='arabidopsis',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_type='integer',
        probeset_len=30,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=50,
        bot_id_nullable=True,
    ),
    'atgenexp_pathogen': EfpSchemaBuilder._simple_schema(
        species='arabidopsis',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=50,
        bot_id_nullable=True,
    ),
    'atgenexp_plus': EfpSchemaBuilder._schema_with_qa_columns(
        species='arabidopsis',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=50,
    ),
    'atgenexp_stress': EfpSchemaBuilder._simple_schema(
        # TODO: atgenexp_stress needs manual review for data_call/sample_file_name columns
        species='arabidopsis',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        probeset_nullable=True,
        bot_id_len=40,
        bot_id_nullable=True,
    ),
    'barley_mas': EfpSchemaBuilder._schema_with_qa_columns(
        species='barley',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=24,
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'string', length=20, nullable=True),
        ],
    ),
    'barley_rma': EfpSchemaBuilder._schema_with_qa_columns(
        species='barley',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=24,
    ),
    'barley_seed': EfpSchemaBuilder._simple_schema(
        species='barley',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'barley_spike_meristem': EfpSchemaBuilder._simple_schema(
        species='barley',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'barley_spike_meristem_v3': EfpSchemaBuilder._simple_schema(
        species='barley',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'brachypodium': EfpSchemaBuilder._simple_schema(
        species='brachypodium',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=50,
    ),
    'brachypodium_Bd21': EfpSchemaBuilder._simple_schema(
        species='brachypodium',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'brachypodium_embryogenesis': EfpSchemaBuilder._simple_schema(
        species='brachypodium',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=50,
    ),
    'brachypodium_grains': EfpSchemaBuilder._simple_schema(
        species='brachypodium',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'brachypodium_metabolites_map': EfpSchemaBuilder._simple_schema(
        species='brachypodium',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=64,
        signal_nullable=True,
        bot_id_len=45,
        charset='utf8mb4',
    ),
    'brachypodium_photo_thermocycle': EfpSchemaBuilder._simple_schema(
        species='brachypodium',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=12,
    ),
    'brassica_rapa': EfpSchemaBuilder._simple_schema(
        species='brassica',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=16,
        bot_id_len=10,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_developmental_atlas': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_developmental_atlas_sca': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_drought_diurnal_atlas': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_drought_diurnal_atlas_sca': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_infection': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=18,
        bot_id_len=24,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_leaf': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=18,
        bot_id_len=12,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_meristem_atlas_sca': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_len=24,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cacao_seed_atlas_sca': EfpSchemaBuilder._simple_schema(
        species='cacao',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_len=24,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'camelina': EfpSchemaBuilder._simple_schema(
        # TODO: camelina needs manual review for data_call/sample_file_name columns
        species='camelina',
        sample_regex=r'.*',  # TODO: Add specific pattern
        sample_id_type='string',
        sample_id_len=5,
        proj_id_default=None,
        probeset_len=20,
        bot_id_len=40,
    ),
    'camelina_tpm': EfpSchemaBuilder._simple_schema(
        # TODO: camelina_tpm needs manual review for data_call/sample_file_name columns
        species='camelina',
        sample_regex=r'.*',  # TODO: Add specific pattern
        sample_id_type='string',
        sample_id_len=5,
        proj_id_default=None,
        probeset_len=20,
        bot_id_len=40,
    ),
    'cannabis': EfpSchemaBuilder._simple_schema(
        species='cannabis',
        sample_regex=r"^PK-\D{1,4}|MED_CTRL$",
        proj_id_len=2,
        bot_id_len=8,
    ),
    'canola': EfpSchemaBuilder._schema_with_qa_columns(
        species='canola',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'text'),
        ],
    ),
    'canola_original': EfpSchemaBuilder._schema_with_qa_columns(
        species='canola',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'text'),
        ],
    ),
    'canola_original_v2': EfpSchemaBuilder._schema_with_qa_columns(
        species='canola',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'text'),
        ],
    ),
    'canola_seed': EfpSchemaBuilder._simple_schema(
        species='canola',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'cassava_atlas': EfpSchemaBuilder._simple_schema(
        species='cassava',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'cassava_cbb': EfpSchemaBuilder._simple_schema(
        species='cassava',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'cassava_eacmv': EfpSchemaBuilder._simple_schema(
        species='cassava',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'circadian_mutants': EfpSchemaBuilder._simple_schema(
        species='circadian mutants',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        bot_id_len=18,
        charset='utf8mb4',
    ),
    'cuscuta': EfpSchemaBuilder._simple_schema(
        species='cuscuta',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        probeset_len=16,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=12,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'cuscuta_early_haustoriogenesis': EfpSchemaBuilder._simple_schema(
        species='cuscuta',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'cuscuta_lmd': EfpSchemaBuilder._simple_schema(
        species='cuscuta',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'dna_damage': EfpSchemaBuilder._simple_schema(
        species='arabidopsis',
        sample_regex=r"^\D{1,3}.{1,30}_plus_Y|\D{1,3}.{1,30}_minus_Y|Med_CTRL$",
        probeset_len=10,
        bot_id_len=32,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'durum_wheat_abiotic_stress': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'durum_wheat_biotic_stress': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=42,
        charset='utf8mb4',
    ),
    'durum_wheat_development': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'embryo': EfpSchemaBuilder._simple_schema(
        species='arabidopsis',
        sample_regex=r"^\D{1,3}_\d$|Med_CTRL$",
        proj_id_len=3,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=8,
    ),
    'eucalyptus': EfpSchemaBuilder._simple_schema(
        species='eucalyptus',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=42,
        charset='utf8mb4',
    ),
    'euphorbia': EfpSchemaBuilder._simple_schema(
        species='euphorbia',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'gc_drought': EfpSchemaBuilder._simple_schema(
        species='gc drought',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'germination': EfpSchemaBuilder._simple_schema(
        species='arabidopsis',
        sample_regex=r"^\d{1,3}\D{1,4}_\d{1,3}|harvest_\d|Med_CTRL$",
        proj_id_len=3,
        probeset_len=30,
        signal_nullable=True,
    ),
    'grape_developmental': EfpSchemaBuilder._schema_with_qa_columns(
        species='grape',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_type='integer',
        proj_id_default=None,
        probeset_len=40,
        bot_id_len=50,
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'text'),
        ],
    ),
    'guard_cell': EfpSchemaBuilder._schema_with_qa_columns(
        species='guard cell',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=24,
    ),
    'gynoecium': EfpSchemaBuilder._simple_schema(
        species='gynoecium',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'heterodera_schachtii': EfpSchemaBuilder._simple_schema(
        species='heterodera',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'hnahal': EfpSchemaBuilder._simple_schema(
        species='hnahal',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
        extra_columns=[
            EfpSchemaBuilder._column('channel', 'string', length=5, nullable=True),
        ],
    ),
    'human_body_map_2': EfpSchemaBuilder._schema_with_qa_columns(
        species='human',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=28,
        signal_nullable=True,
        bot_id_len=20,
    ),
    'human_developmental': EfpSchemaBuilder._schema_with_qa_columns(
        species='human',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=32,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=24,
        bot_id_nullable=True,
    ),
    'human_developmental_SpongeLab': EfpSchemaBuilder._schema_with_qa_columns(
        species='human',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
    ),
    'human_diseased': EfpSchemaBuilder._schema_with_qa_columns(
        species='human',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
    ),
    'kalanchoe': EfpSchemaBuilder._simple_schema(
        species='kalanchoe',
        sample_regex=r"^\D{1,4}_\D{1,5}_rep\d|MED_CTRL$",
        proj_id_len=2,
    ),
    'kalanchoe_time_course_analysis': EfpSchemaBuilder._simple_schema(
        species='kalanchoe',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'klepikova': EfpSchemaBuilder._simple_schema(
        # TODO: klepikova needs manual review for data_call/sample_file_name columns
        species='arabidopsis',
        sample_regex=r"^SRR\d{1,9}|Med_CTRL$",
        proj_id_len=3,
        probeset_len=30,
        signal_nullable=True,
    ),
    # TODO: 'lateral_root_initiation': Complex schema (missing base columns) - needs manual definition
    'light_series': EfpSchemaBuilder._schema_with_qa_columns(
        species='light series',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=30,
    ),
    'lipid_map': EfpSchemaBuilder._simple_schema(
        species='lipid map',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=64,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'little_millet': EfpSchemaBuilder._simple_schema(
        species='little_millet',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        probeset_len=32,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=12,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'lupin_lcm_leaf': EfpSchemaBuilder._simple_schema(
        species='lupin',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'lupin_lcm_pod': EfpSchemaBuilder._simple_schema(
        species='lupin',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'lupin_lcm_stem': EfpSchemaBuilder._simple_schema(
        species='lupin',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'lupin_pod_seed': EfpSchemaBuilder._simple_schema(
        species='lupin',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'lupin_whole_plant': EfpSchemaBuilder._simple_schema(
        species='lupin',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'maize_RMA_linear': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        signal_nullable=True,
        bot_id_len=30,
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'text'),
        ],
    ),
    'maize_RMA_log': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        signal_nullable=True,
        bot_id_len=30,
    ),
    'maize_atlas': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        sample_id_type='string',
        sample_id_len=5,
        proj_id_default=None,
        probeset_len=25,
        bot_id_len=40,
    ),
    'maize_atlas_v5': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=25,
        signal_nullable=True,
        bot_id_len=40,
        charset='utf8mb4',
    ),
    'maize_buell_lab': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_len=50,
    ),
    'maize_early_seed': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        bot_id_len=50,
    ),
    'maize_ears': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        signal_nullable=True,
    ),
    'maize_embryonic_leaf_development': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'maize_enzyme': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=40,
        signal_nullable=True,
        bot_id_len=8,
    ),
    'maize_gdowns': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        sample_id_type='string',
        sample_id_len=30,
        proj_id_len=30,
        proj_id_default=None,
        probeset_len=40,
        bot_id_len=40,
    ),
    'maize_iplant': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        signal_nullable=True,
    ),
    'maize_kernel_v5': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=25,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'maize_leaf_gradient': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        signal_nullable=True,
        bot_id_len=12,
    ),
    'maize_lipid_map': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'maize_metabolite': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=64,
        signal_nullable=True,
        bot_id_len=5,
    ),
    'maize_nitrogen_use_efficiency': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'maize_rice_comparison': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=12,
    ),
    'maize_root': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=255,
    ),
    'maize_stress_v5': EfpSchemaBuilder._simple_schema(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=25,
        signal_nullable=True,
        bot_id_len=20,
        charset='utf8mb4',
    ),
    'mangosteen_aril_vs_rind': EfpSchemaBuilder._simple_schema(
        species='mangosteen',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        proj_id_default=None,
        probeset_len=8,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'mangosteen_callus': EfpSchemaBuilder._simple_schema(
        species='mangosteen',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        proj_id_default=None,
        probeset_len=8,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'mangosteen_diseased_vs_normal': EfpSchemaBuilder._simple_schema(
        species='mangosteen',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        proj_id_default=None,
        probeset_len=8,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'mangosteen_fruit_ripening': EfpSchemaBuilder._simple_schema(
        species='mangosteen',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        proj_id_default=None,
        probeset_len=8,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'mangosteen_seed_development': EfpSchemaBuilder._simple_schema(
        species='mangosteen',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        proj_id_default=None,
        probeset_len=8,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'mangosteen_seed_development_germination': EfpSchemaBuilder._simple_schema(
        species='mangosteen',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        proj_id_default=None,
        probeset_len=8,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'mangosteen_seed_germination': EfpSchemaBuilder._simple_schema(
        species='mangosteen',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        proj_id_default=None,
        probeset_len=8,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'marchantia_organ_stress': EfpSchemaBuilder._simple_schema(
        species='marchantia',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'medicago_mas': EfpSchemaBuilder._schema_with_qa_columns(
        species='medicago',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=28,
        signal_nullable=True,
        bot_id_len=22,
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'text'),
        ],
    ),
    'medicago_rma': EfpSchemaBuilder._schema_with_qa_columns(
        species='medicago',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=28,
        signal_nullable=True,
        bot_id_len=22,
    ),
    'medicago_root': EfpSchemaBuilder._simple_schema(
        species='medicago',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'medicago_root_v5': EfpSchemaBuilder._simple_schema(
        species='medicago',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=64,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'medicago_seed': EfpSchemaBuilder._simple_schema(
        species='medicago',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=15,
    ),
    'meristem_db': EfpSchemaBuilder._simple_schema(
        species='meristem db',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=18,
        extra_columns=[
            EfpSchemaBuilder._column('channel', 'string', length=5, nullable=True),
        ],
    ),
    'meristem_db_new': EfpSchemaBuilder._simple_schema(
        species='meristem db new',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
        extra_columns=[
            EfpSchemaBuilder._column('channel', 'string', length=5, nullable=True),
        ],
    ),
    # TODO: 'mouse_db': Complex schema (missing base columns) - needs manual definition
    # TODO: 'oat': Complex schema (missing base columns) - needs manual definition
    'phelipanche': EfpSchemaBuilder._simple_schema(
        species='phelipanche',
        sample_regex=r"^[a-z_-]{1,35}|MED_CTRL$",
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'physcomitrella_db': EfpSchemaBuilder._simple_schema(
        species='physcomitrella',
        sample_regex=r"^[a-z_123]{1,15}|MED_CTRL$",
        sample_id_type='string',
        sample_id_len=30,
        proj_id_len=30,
        proj_id_default=None,
        probeset_len=40,
        bot_id_len=40,
    ),
    'poplar': EfpSchemaBuilder._schema_with_qa_columns(
        species='poplar',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        file_name_type='string',
        file_name_len=40,
        probeset_len=70,
        call_type='string',
        call_len=12,
        bot_id_len=40,
        bot_id_nullable=True,
        extra_columns=[
            EfpSchemaBuilder._column('data_num', 'integer', default=0),
        ],
    ),
    'poplar_hormone': EfpSchemaBuilder._simple_schema(
        species='poplar',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'poplar_leaf': EfpSchemaBuilder._simple_schema(
        species='poplar',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=70,
        bot_id_len=40,
        bot_id_nullable=True,
    ),
    'poplar_xylem': EfpSchemaBuilder._simple_schema(
        species='poplar',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=70,
        bot_id_len=40,
        bot_id_nullable=True,
    ),
    'potato_dev': EfpSchemaBuilder._simple_schema(
        species='potato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=40,
        signal_nullable=True,
        bot_id_len=15,
    ),
    'potato_stress': EfpSchemaBuilder._simple_schema(
        species='potato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=40,
        signal_nullable=True,
        bot_id_len=12,
    ),
    'potato_wounding': EfpSchemaBuilder._simple_schema(
        species='potato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=40,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'rice_abiotic_stress_sc_pseudobulk': EfpSchemaBuilder._simple_schema(
        species='rice',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=64,
        charset='utf8mb4',
    ),
    'rice_drought_heat_stress': EfpSchemaBuilder._simple_schema(
        species='rice',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'rice_leaf_gradient': EfpSchemaBuilder._schema_with_qa_columns(
        species='rice',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=12,
    ),
    'rice_maize_comparison': EfpSchemaBuilder._schema_with_qa_columns(
        species='maize',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=12,
    ),
    'rice_mas': EfpSchemaBuilder._schema_with_qa_columns(
        species='rice',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=28,
        signal_nullable=True,
        bot_id_len=26,
        extra_columns=[
            EfpSchemaBuilder._column('sample_tissue', 'text'),
        ],
    ),
    'rice_metabolite': EfpSchemaBuilder._schema_with_qa_columns(
        species='rice',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=25,
        signal_nullable=True,
        bot_id_len=6,
    ),
    'rice_rma': EfpSchemaBuilder._schema_with_qa_columns(
        species='rice',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=28,
        signal_nullable=True,
        bot_id_len=26,
    ),
    'rice_root': EfpSchemaBuilder._simple_schema(
        species='rice',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'rohan': EfpSchemaBuilder._schema_with_qa_columns(
        species='rohan',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
    ),
    'root': EfpSchemaBuilder._schema_with_qa_columns(
        species='root',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=24,
    ),
    'root_Schaefer_lab': EfpSchemaBuilder._simple_schema(
        species='root Schaefer lab',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=16,
        bot_id_len=20,
        bot_id_nullable=True,
    ),
    'rpatel': EfpSchemaBuilder._schema_with_qa_columns(
        species='rpatel',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_type='text',
        signal_nullable=True,
        bot_id_type='text',
    ),
    'seed_db': EfpSchemaBuilder._schema_with_qa_columns(
        species='seed db',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=20,
        file_name_type='string',
        file_name_len=100,
        probeset_len=30,
        signal_nullable=True,
        call_type='string',
        call_len=40,
        bot_id_len=64,
    ),
    'seedcoat': EfpSchemaBuilder._schema_with_qa_columns(
        species='oat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=22,
        signal_nullable=True,
        bot_id_len=12,
    ),
    'selaginella': EfpSchemaBuilder._simple_schema(
        species='selaginella',
        sample_regex=r"^[\D\d]{1,33}|MED_CTRL$",
        probeset_len=18,
        bot_id_len=36,
    ),
    'shoot_apex': EfpSchemaBuilder._schema_with_qa_columns(
        species='arabidopsis',
        sample_regex=r"^\D{1,5}\d{0,2}|MED_CTRL$",
        proj_id_len=2,
        proj_id_default=None,
        file_name_type='string',
        file_name_len=16,
        probeset_len=12,
        call_type='string',
        call_len=2,
        bot_id_len=8,
    ),
    'silique': EfpSchemaBuilder._simple_schema(
        species='arabidopsis',
        sample_regex=r"^\d{1,3}_dap.{1,58}_R1_001|Med_CTRL$",
        proj_id_default=None,
        probeset_len=12,
        signal_nullable=True,
        bot_id_len=64,
    ),
    'single_cell': EfpSchemaBuilder._simple_schema(
        species='arabidopsis',
        sample_regex=r"^\D+\d+_WT\d+.ExprMean|MED_CTRL$",
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=32,
    ),
    'sorghum_atlas_w_BS_cells': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'sorghum_comparative_transcriptomics': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=18,
        signal_nullable=True,
        bot_id_len=40,
        charset='utf8mb4',
    ),
    'sorghum_developmental': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'sorghum_developmental_2': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_flowering_activation': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_low_phosphorus': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'sorghum_nitrogen_stress': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_nitrogen_use_efficiency': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'sorghum_phosphate_stress': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_plasma': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'sorghum_saline_alkali_stress': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_stress': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=12,
        charset='utf8mb4',
    ),
    'sorghum_strigolactone_variation': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_sulfur_stress': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_temperature_stress': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'sorghum_vascularization_and_internode': EfpSchemaBuilder._simple_schema(
        species='sorghum',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'soybean': EfpSchemaBuilder._schema_with_qa_columns(
        species='soybean',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        proj_id_default=None,
        probeset_len=36,
        bot_id_len=22,
    ),
    'soybean_embryonic_development': EfpSchemaBuilder._simple_schema(
        species='soybean',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=42,
        charset='utf8mb4',
    ),
    'soybean_heart_cotyledon_globular': EfpSchemaBuilder._simple_schema(
        species='soybean',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=42,
        charset='utf8mb4',
    ),
    'soybean_senescence': EfpSchemaBuilder._simple_schema(
        species='soybean',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=8,
        charset='utf8mb4',
    ),
    'soybean_severin': EfpSchemaBuilder._schema_with_qa_columns(
        species='soybean',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        proj_id_default=None,
        probeset_len=18,
        bot_id_len=18,
    ),
    'spruce': EfpSchemaBuilder._simple_schema(
        species='spruce',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'strawberry': EfpSchemaBuilder._simple_schema(
        species='strawberry',
        sample_regex=r"^\D{1,12}_.{1,8}_\D{1,2}|MED_CTRL$",
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'striga': EfpSchemaBuilder._simple_schema(
        species='striga',
        sample_regex=r"^\D{1,35}|MED_CTRL$",
        proj_id_default=None,
        signal_nullable=True,
        bot_id_len=42,
    ),
    'sugarcane_culms': EfpSchemaBuilder._simple_schema(
        species='sugarcane',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=32,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'sugarcane_leaf': EfpSchemaBuilder._simple_schema(
        species='sugarcane',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=12,
        probeset_len=32,
        bot_id_len=32,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'sunflower': EfpSchemaBuilder._simple_schema(
        species='sunflower',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=16,
        bot_id_nullable=True,
    ),
    'thellungiella_db': EfpSchemaBuilder._simple_schema(
        # TODO: thellungiella_db needs manual review for data_call/sample_file_name columns
        species='thellungiella',
        sample_regex=r'.*',  # TODO: Add specific pattern
        sample_id_type='string',
        sample_id_len=30,
        proj_id_len=30,
        proj_id_default=None,
        probeset_len=40,
        bot_id_len=40,
    ),
    'tomato': EfpSchemaBuilder._schema_with_qa_columns(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=18,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=18,
        bot_id_nullable=True,
    ),
    'tomato_ils': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=12,
        bot_id_nullable=True,
    ),
    'tomato_ils2': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=12,
        bot_id_nullable=True,
        extra_columns=[
            EfpSchemaBuilder._column('log', 'float'),
            EfpSchemaBuilder._column('p_val', 'float'),
        ],
    ),
    'tomato_ils3': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_nullable=True,
    ),
    'tomato_meristem': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        probeset_len=18,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=24,
        bot_id_nullable=True,
    ),
    'tomato_renormalized': EfpSchemaBuilder._schema_with_qa_columns(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=18,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=18,
        bot_id_nullable=True,
    ),
    'tomato_root': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        probeset_len=18,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=12,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'tomato_root_field_pot': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        probeset_len=18,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=12,
        bot_id_nullable=True,
        charset='utf8mb4',
    ),
    'tomato_s_pennellii': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=20,
        probeset_nullable=True,
        signal_nullable=True,
        bot_id_len=24,
        bot_id_nullable=True,
    ),
    'tomato_seed': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'tomato_shade_mutants': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=20,
        charset='utf8mb4',
    ),
    'tomato_shade_timecourse': EfpSchemaBuilder._simple_schema(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'tomato_trait': EfpSchemaBuilder._schema_with_qa_columns(
        species='tomato',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=30,
        probeset_len=100,
        signal_nullable=True,
        bot_id_type='text',
        extra_columns=[
            EfpSchemaBuilder._column('qvalue', 'float', nullable=True),
        ],
    ),
    'triphysaria': EfpSchemaBuilder._simple_schema(
        species='triphysaria',
        sample_regex=r"^[a-z_]{1,35}|MED_CTRL$",
        proj_id_default=None,
        probeset_len=16,
        signal_nullable=True,
        bot_id_len=32,
        charset='utf8mb4',
    ),
    'triticale': EfpSchemaBuilder._schema_with_qa_columns(
        species='triticale',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=18,
    ),
    'triticale_mas': EfpSchemaBuilder._schema_with_qa_columns(
        species='triticale',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=30,
        signal_nullable=True,
        bot_id_len=30,
    ),
    'tung_tree': EfpSchemaBuilder._simple_schema(
        species='tung_tree',
        sample_regex=r'.*',  # TODO: Add specific pattern
        probeset_len=16,
        bot_id_nullable=True,
    ),
    'wheat': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=32,
        signal_nullable=True,
    ),
    'wheat_abiotic_stress': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=32,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'wheat_embryogenesis': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=50,
    ),
    'wheat_meiosis': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=32,
        signal_nullable=True,
        bot_id_len=24,
        charset='utf8mb4',
    ),
    'wheat_root': EfpSchemaBuilder._simple_schema(
        species='wheat',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=15,
        probeset_len=32,
        signal_nullable=True,
        charset='utf8mb4',
    ),
    'willow': EfpSchemaBuilder._simple_schema(
        species='willow',
        sample_regex=r'.*',  # TODO: Add specific pattern
        proj_id_len=2,
        probeset_len=32,
    ),
    # Complex/non-standard schemas (manually defined)
    'lateral_root_initiation': EfpSchemaBuilder._build_schema(
        column_overrides={
            "sample_id": {"type": "string", "length": 30, "unsigned": False, "default": None},
            "data_probeset_id": {"length": 40, "default": None},
            "data_bot_id": {"length": 64, "nullable": True},
        },
        extra_columns=[
            EfpSchemaBuilder._column("project_id", "string", length=30, nullable=False),
            EfpSchemaBuilder._column("sample_file_name", "string", length=80, nullable=True),
        ],
        charset="utf8mb4",
        metadata={"species": "arabidopsis", "sample_regex": r".*"},
    ),
    'mouse_db': EfpSchemaBuilder._build_schema(
        column_overrides={
            "data_probeset_id": {"length": 15, "primary_key": True},
            "data_bot_id": {"length": 18, "primary_key": True},
        },
        index=["data_probeset_id", "data_bot_id"],
        metadata={"species": "mouse", "sample_regex": r".*"},
    ),
    'oat': EfpSchemaBuilder._build_schema(
        column_overrides={
            "data_probeset_id": {"length": 36, "primary_key": True},
            "data_bot_id": {"length": 24, "primary_key": True},
            "data_signal": {"nullable": True},
        },
        extra_columns=[
            EfpSchemaBuilder._column("genome", "string", length=16, nullable=False),
            EfpSchemaBuilder._column("genome_id", "string", length=16, nullable=False),
            EfpSchemaBuilder._column("orthogroup", "string", length=16, nullable=False),
            EfpSchemaBuilder._column("version", "string", length=2, nullable=False),
        ],
        charset="utf8mb4",
        index=["data_probeset_id", "data_bot_id"],
        metadata={"species": "oat", "sample_regex": r".*"},
    ),
}

__all__: List[str] = ["SIMPLE_EFP_DATABASE_SCHEMAS", "ColumnSpec", "DatabaseSpec"]
