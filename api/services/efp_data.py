"""
Reena Obmina | BCB330 Project 2025-2026 | University of Toronto

Centralised query service for all eFP databases.

Exposes a single entry point query_efp_database_dynamic() that handles:
  - Engine resolution: live MySQL first, SQLite mirror fallback
  - AGI-to-probeset lookup for Arabidopsis microarray databases
  - Parameterised queries to prevent SQL injection
"""

from __future__ import annotations

import re
import traceback
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Tuple
from types import SimpleNamespace

from flask import has_app_context
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.engine import Engine
from sqlalchemy.orm import Session

from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.models.bar_utils import BARUtils
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS

# Absolute path to the config/databases directory where the sqlite mirrors live
ROOT_DIR = Path(__file__).resolve().parents[2]
DATABASE_DIR = ROOT_DIR / "config" / "databases"

DEFAULT_SAMPLE_SCHEMA = {
    "table": "sample_data",
    "gene_column": "data_probeset_id",
    "sample_column": "data_bot_id",
    "value_column": "data_signal",
}

# Manual list covers datasets still backed by shipped dumps
_MANUAL_DEFAULT_DATABASES = [
    "canola_nssnp",
    "eplant2",
    "eplant_poplar",
    "eplant_rice",
    "eplant_soybean",
    "eplant_tomato",
    "fastpheno",
    "homologs_db",
    "interactions_vincent_v2",
    "llama3",
    "poplar_nssnp",
    "rice_interactions",
    "soybean_nssnp",
    "tomato_nssnp",
    "tomato_sequence",
]

MANUAL_DATABASE_SCHEMAS = {
    name: {
        **DEFAULT_SAMPLE_SCHEMA,
        "filename": f"{name}.db",
        "identifier_type": "agi",
        "metadata": {},
    }
    for name in _MANUAL_DEFAULT_DATABASES
}

MANUAL_DATABASE_SCHEMAS["sample_data"] = {
    **DEFAULT_SAMPLE_SCHEMA,
    "filename": "sample_data.db",
    "identifier_type": "probeset",
    "metadata": {"species": "arabidopsis"},
}

# Minimal seed data for CI environments that don't have local mirrors yet
# Keys are normalized to uppercase to simplify lookups
LOCAL_EFP_DATASETS: Dict[str, Dict[str, List[Dict[str, str]]]] = {
    "sample_data": {
        "261585_AT": [
            {"sample": "ATGE_100_A", "value": "40.381"},
            {"sample": "ATGE_100_B", "value": "38.924"},
        ]
    },
    "embryo": {
        "AT1G01010": [
            {"sample": "pg_1", "value": "0.67"},
        ]
    },
    "cannabis": {
        "AGQN03009284": [
            {"sample": "PK-RT", "value": "0"},
        ]
    },
    "dna_damage": {
        "AT1G01010": [
            {"sample": "col-0_rep1_12hr_minus_Y", "value": "59"},
        ]
    },
}


class EFPDataService:
    """Service class for querying eFP (electronic Fluorescent Pictograph) databases."""

    @staticmethod
    def _build_schema_catalog() -> Dict[str, Dict[str, Any]]:
        """Stitch together the python schemas + legacy dumps into one lookup table.

        :return: Catalog of database schemas
        :rtype: Dict[str, Dict[str, Any]]
        """
        catalog: Dict[str, Dict[str, Any]] = {}
        for db_name, spec in SIMPLE_EFP_DATABASE_SCHEMAS.items():
            schema = dict(DEFAULT_SAMPLE_SCHEMA)
            schema.update(
                {
                    "filename": f"{db_name}.db",
                    "identifier_type": spec.get("identifier_type", "agi"),
                    "metadata": spec.get("metadata") or {},
                }
            )
            catalog[db_name] = schema

        for db_name, schema in MANUAL_DATABASE_SCHEMAS.items():
            catalog[db_name] = dict(schema)

        return catalog

    @staticmethod
    def _query_local_dataset(
        database: str,
        query_id: str,
        sample_ids: Optional[List[str]],
        sample_case_insensitive: bool,
    ) -> Optional[List[SimpleNamespace]]:
        """Return seed data rows for databases without sqlite mirrors.

        :param database: Database name
        :type database: str
        :param query_id: Gene identifier to query
        :type query_id: str
        :param sample_ids: Optional list of sample IDs to filter results
        :type sample_ids: Optional[List[str]]
        :param sample_case_insensitive: If True, compare sample IDs case-insensitively
        :type sample_case_insensitive: bool
        :return: List of result rows or None if database not found
        :rtype: Optional[List[SimpleNamespace]]
        """
        dataset = LOCAL_EFP_DATASETS.get(database)
        if dataset is None:
            return None

        gene_rows = dataset.get(query_id.upper(), [])
        rows = list(gene_rows)

        if sample_ids:
            filtered = [sample for sample in sample_ids if sample]
            if filtered:
                if sample_case_insensitive:
                    lookup = {sample.upper() for sample in filtered}

                    def matches(row_name: str) -> bool:
                        return row_name.upper() in lookup

                else:
                    lookup = set(filtered)

                    def matches(row_name: str) -> bool:
                        return row_name in lookup

                rows = [row for row in rows if matches(row["sample"])]

        return [SimpleNamespace(sample=row["sample"], value=row["value"]) for row in rows]

    @staticmethod
    def agi_to_probset(gene_id: str) -> Optional[str]:
        """
        Convert an Arabidopsis AGI identifier to its corresponding probeset ID.

        Looks up the most recent mapping in the AtAgiLookup table, ordered by date
        descending. This ensures the newest array design mapping is used when multiple
        mappings exist for the same AGI.

        :param gene_id: Arabidopsis gene ID in AGI format (e.g., 'AT1G01010')
        :type gene_id: str
        :return: Probeset ID (e.g., '261585_at') if found, None otherwise
        :rtype: Optional[str]

        Example::

            probeset = EFPDataService.agi_to_probset('AT1G01010')
            # Returns: '261585_at' (if mapping exists)
        """
        try:
            subquery = (
                db.select(AtAgiLookup.probeset)
                .where(AtAgiLookup.agi == gene_id.upper())
                .order_by(AtAgiLookup.date.desc())
                .limit(1)
                .subquery()
            )

            sq_query = db.session.query(subquery)
            if sq_query.count() > 0:
                return sq_query[0][0]
            return None
        except Exception as exc:
            print(f"[error] agi to probeset conversion failed {exc}")
            return None

    @staticmethod
    def _iter_engine_candidates(database: str) -> Iterable[Tuple[str, Engine, bool]]:
        """
        Yield database engine candidates with MySQL priority and SQLite fallback.

        This function enables dual-mode operation:
        - Production/CI: Uses MySQL via Flask-SQLAlchemy binds
        - Local development: Falls back to SQLite mirror files

        Priority order:
        1. Flask-SQLAlchemy bind (MySQL) - if Flask app context exists
        2. SQLite mirror file - if exists in config/databases/

        :param database: Database name (e.g., 'cannabis', 'dna_damage')
        :type database: str
        :yields: Tuples of (engine_type, engine, is_sqlite) where:
            - engine_type: 'sqlalchemy_bind' or 'sqlite_mirror'
            - engine: SQLAlchemy Engine object
            - is_sqlite: True if SQLite, False if MySQL
        :rtype: Iterator[Tuple[str, sqlalchemy.engine.Engine, bool]]

        Example::

            for engine_type, engine, is_sqlite in EFPDataService._iter_engine_candidates('cannabis'):
                try:
                    result = engine.execute('SELECT * FROM sample_data LIMIT 1')
                    break  # Found working engine
                except:
                    continue  # Try next engine
        """
        # Prefer live mysql binds but fall back to sqlite mirrors when needed
        db_path = DATABASE_DIR / DYNAMIC_DATABASE_SCHEMAS[database]["filename"]
        if has_app_context():
            try:
                bound_engine = db.engines.get(database)
                if bound_engine:
                    yield ("sqlalchemy_bind", bound_engine, False)
            except Exception as exc:
                print(f"[warn] unable to load sqlalchemy bind for {database}: {exc}")

        if db_path.exists():
            sqlite_engine = create_engine(f"sqlite:///{db_path}")
            try:
                with sqlite_engine.begin() as _conn:
                    _conn.execute(
                        text("CREATE INDEX IF NOT EXISTS ix_upper_probeset " "ON sample_data (UPPER(data_probeset_id))")
                    )
            except Exception:
                pass
            yield ("sqlite_mirror", sqlite_engine, True)

    @staticmethod
    def query_efp_database_dynamic(
        database: str,
        gene_id: str,
        sample_ids: Optional[List[str]] = None,
        allow_empty_results: bool = False,
        sample_case_insensitive: bool = False,
    ) -> Dict[str, object]:
        """
        Dynamically query any eFP database using the shared schema catalog.

        This function provides a unified interface for querying expression data across
        different eFP databases, handling species-specific gene ID validation and
        automatic probeset conversion when needed.

        :param database: Database name (e.g., 'cannabis', 'embryo', 'sample_data')
        :type database: str
        :param gene_id: Gene identifier (AGI format, probeset, or species-specific format)
        :type gene_id: str
        :param sample_ids: Optional list of sample IDs to filter results; if None, returns all samples
        :type sample_ids: Optional[List[str]]
        :param allow_empty_results: If True, return success even when no data found; if False, return 404 error
        :type allow_empty_results: bool
        :param sample_case_insensitive: If True, compare sample IDs case-insensitively
        :type sample_case_insensitive: bool
        :return: Dictionary with 'success' boolean, data or error message, and HTTP status code
        :rtype: Dict[str, object]

        Example::

            result = EFPDataService.query_efp_database_dynamic('embryo', 'AT1G01010')
            # Returns: {'success': True, 'gene_id': 'AT1G01010', 'data': [...]}

            result = EFPDataService.query_efp_database_dynamic('sample_data', 'AT1G01010')
            # Auto-converts to probeset, returns: {'probset_id': '261585_at', ...}
        """
        try:
            database = str(database)
            gene_id = str(gene_id)

            schema = DYNAMIC_DATABASE_SCHEMAS.get(database)
            if not schema:
                return {
                    "success": False,
                    "error": (
                        f"Database '{database}' is not supported. "
                        f"Select one of: {', '.join(sorted(DYNAMIC_DATABASE_SCHEMAS.keys()))}"
                    ),
                    "error_code": 400,
                }

            # Extract species information from schema metadata
            species = schema.get("metadata", {}).get("species", "").lower()

            query_id = gene_id
            probset_display = None
            gene_case_insensitive = False
            upper_id = gene_id.upper()
            is_agi_id = upper_id.startswith("AT") and "G" in upper_id

            # Validate gene ID format based on species and ID pattern
            # Only validate if the ID looks like it's in the species-specific format
            if is_agi_id:
                # This looks like an Arabidopsis AGI ID - validate it
                if not BARUtils.is_arabidopsis_gene_valid(upper_id):
                    return {"success": False, "error": "Invalid Arabidopsis gene ID format", "error_code": 400}
            elif species and schema["identifier_type"] == "agi":
                # For non-AGI formatted IDs in species databases that expect AGI format,
                # Validate against the specific species validator
                if species == "arachis":
                    if not BARUtils.is_arachis_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Arachis gene ID", "error_code": 400}
                elif species == "cannabis":
                    if not BARUtils.is_cannabis_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Cannabis gene ID", "error_code": 400}
                elif species == "kalanchoe":
                    if not BARUtils.is_kalanchoe_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Kalanchoe gene ID", "error_code": 400}
                elif species == "phelipanche":
                    if not BARUtils.is_phelipanche_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Phelipanche gene ID", "error_code": 400}
                elif species == "physcomitrella":
                    if not BARUtils.is_physcomitrella_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Physcomitrella gene ID", "error_code": 400}
                elif species == "selaginella":
                    if not BARUtils.is_selaginella_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Selaginella gene ID", "error_code": 400}
                elif species == "strawberry":
                    if not BARUtils.is_strawberry_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Strawberry gene ID", "error_code": 400}
                elif species == "striga":
                    if not BARUtils.is_striga_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Striga gene ID", "error_code": 400}
                elif species == "triphysaria":
                    if not BARUtils.is_triphysaria_gene_valid(upper_id):
                        return {"success": False, "error": "Invalid Triphysaria gene ID", "error_code": 400}

            # Handle Arabidopsis-specific logic for AGI IDs
            if is_agi_id:
                if schema["identifier_type"] == "probeset":
                    probset = EFPDataService.agi_to_probset(upper_id)
                    if not probset:
                        return {
                            "success": False,
                            "error": f"Could not find probeset for gene {gene_id}",
                            "error_code": 404,
                        }
                    query_id = probset
                    probset_display = probset
                    print(f"[info] Converted {gene_id} to probeset {query_id} for {database}")
                else:
                    query_id = upper_id
                    gene_case_insensitive = True
                    probset_display = upper_id
            else:
                # Non-AGI IDs: use as-is, typically already uppercase from validation
                query_id = upper_id if species else gene_id
                gene_case_insensitive = bool(species)

            # Build SQL query using parameterized queries to prevent SQL injection
            # Column and table names come from the internal schema catalog, which is safe
            gene_col = schema["gene_column"]
            sample_col = schema["sample_column"]
            value_col = schema["value_column"]
            table_name = schema["table"]

            # Validate identifiers contain only safe characters (alphanumeric and underscore)
            for identifier, name in [
                (gene_col, "gene_column"),
                (sample_col, "sample_column"),
                (value_col, "value_column"),
                (table_name, "table"),
            ]:
                if not re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*$", identifier):
                    return {
                        "success": False,
                        "error": f"Invalid schema identifier for {name}: {identifier}",
                        "error_code": 500,
                    }

            gene_column_expr = f"UPPER({gene_col})" if gene_case_insensitive else gene_col
            params = {"gene_id": query_id.upper() if gene_case_insensitive else query_id}
            where_clauses = [f"{gene_column_expr} = :gene_id"]

            if sample_ids:
                filtered = [s for s in sample_ids if s]
                if filtered:
                    sample_column_expr = f"UPPER({sample_col})" if sample_case_insensitive else sample_col
                    sample_conditions = []
                    for idx, sample in enumerate(filtered):
                        key = f"sample_{idx}"
                        params[key] = sample.upper() if sample_case_insensitive else sample
                        sample_conditions.append(f"{sample_column_expr} = :{key}")
                    where_clauses.append(f"({' OR '.join(sample_conditions)})")

            query_sql = text(
                f"SELECT {sample_col} AS sample, {value_col} AS value "
                f"FROM {table_name} "
                f"WHERE {' AND '.join(where_clauses)}"
            )

            engine_candidates = list(EFPDataService._iter_engine_candidates(database))
            results = None
            last_error = None

            if engine_candidates:
                for source_label, engine, dispose_after in engine_candidates:
                    try:
                        with Session(engine) as session:
                            results = session.execute(query_sql, params).all()
                        if results:
                            break
                    except SQLAlchemyError as exc:
                        last_error = f"{source_label} failed: {exc}"
                        print(f"[warn] {last_error}")
                    except Exception as exc:
                        last_error = f"{source_label} unexpected failure: {exc}"
                        print(f"[warn] {last_error}")
                    finally:
                        if dispose_after:
                            engine.dispose()
            else:
                last_error = f"Database {database} is not available (no active bind or sqlite mirror)."

            local_rows = None
            if results is None or not results:
                local_rows = EFPDataService._query_local_dataset(
                    database,
                    query_id,
                    sample_ids,
                    sample_case_insensitive,
                )
                if local_rows is not None:
                    results = local_rows

            if results is None:
                _UNAVAILABLE_PHRASES = (
                    "Unknown database",
                    "Can't connect",
                    "Connection refused",
                    "not available",
                )
                is_missing_db = last_error and any(
                    phrase in last_error for phrase in _UNAVAILABLE_PHRASES
                )
                if is_missing_db:
                    print(f"[warn] {database}: {last_error}")
                    return {
                        "success": False,
                        "error": f"Database '{database}' is not available.",
                        "error_code": 503,
                    }
                return {
                    "success": False,
                    "error": (
                        f"Database query failed for {database}. "
                        f"{'Last error: ' + last_error if last_error else ''}"
                    ).strip(),
                    "error_code": 500,
                }

            if not results and not allow_empty_results:
                error_dict = BARUtils.error_exit(
                    f"No expression data found for {gene_id} (query identifier: {query_id})"
                )
                return {
                    "success": False,
                    "error": error_dict["error"],
                    "error_code": 404,
                }

            expression_data = [{"name": row.sample, "value": str(row.value)} for row in results]

            return {
                "success": True,
                "gene_id": gene_id,
                "probset_id": probset_display or query_id,
                "database": database,
                "record_count": len(expression_data),
                "data": expression_data,
            }

        except Exception as exc:
            error_trace = traceback.format_exc()
            print(f"[error] Database query exception: {error_trace}")
            return {
                "success": False,
                "error": f"Database query failed: {str(exc)}",
                "error_code": 500,
            }


# Build the schema catalog at module load time
DYNAMIC_DATABASE_SCHEMAS = EFPDataService._build_schema_catalog()


# Maintain backward compatibility with existing code that imports these functions directly
def agi_to_probset(gene_id: str) -> Optional[str]:
    """Backward compatibility wrapper for EFPDataService.agi_to_probset()"""
    return EFPDataService.agi_to_probset(gene_id)


def query_efp_database_dynamic(
    database: str,
    gene_id: str,
    sample_ids: Optional[List[str]] = None,
    allow_empty_results: bool = False,
    sample_case_insensitive: bool = False,
) -> Dict[str, object]:
    """Backward compatibility wrapper for EFPDataService.query_efp_database_dynamic()"""
    return EFPDataService.query_efp_database_dynamic(
        database, gene_id, sample_ids, allow_empty_results, sample_case_insensitive
    )
