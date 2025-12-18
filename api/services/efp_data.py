"""
shared helper utilities for querying efp databases
"""

from __future__ import annotations

import traceback
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Tuple

from flask import has_app_context
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.engine import Engine
from sqlalchemy.orm import Session

from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.models.bar_utils import BARUtils
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS

# absolute path to the config/databases directory where the sqlite mirrors live
ROOT_DIR = Path(__file__).resolve().parents[2]
DATABASE_DIR = ROOT_DIR / "config" / "databases"

DEFAULT_SAMPLE_SCHEMA = {
    "table": "sample_data",
    "gene_column": "data_probeset_id",
    "sample_column": "data_bot_id",
    "value_column": "data_signal",
}

# manual list covers datasets still backed by shipped dumps
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


def _build_schema_catalog() -> Dict[str, Dict[str, Any]]:
    # stitch together the python schemas + legacy dumps into one lookup table
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


DYNAMIC_DATABASE_SCHEMAS = _build_schema_catalog()


def agi_to_probset(gene_id: str) -> Optional[str]:
    """convert an arabidopsis agi to its probeset when needed"""
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
            # safest pick is the newest mapping because the array design changed over time
            return sq_query[0][0]
        return None
    except Exception as exc:  # pragma: no cover - defensive logging path
        print(f"[error] agi to probeset conversion failed {exc}")
        return None


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

        for engine_type, engine, is_sqlite in _iter_engine_candidates('cannabis'):
            try:
                result = engine.execute('SELECT * FROM sample_data LIMIT 1')
                break  # Found working engine
            except:
                continue  # Try next engine
    """
    # prefer live mysql binds but fall back to sqlite mirrors when needed
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
        yield ("sqlite_mirror", sqlite_engine, True)


def query_efp_database_dynamic(
    database: str,
    gene_id: str,
    sample_ids: Optional[List[str]] = None,
    allow_empty_results: bool = False,
    sample_case_insensitive: bool = False,
) -> Dict[str, object]:
    """dynamically query any efp database using the shared schema catalog"""
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

        query_id = gene_id
        probset_display = None
        gene_case_insensitive = False
        upper_id = gene_id.upper()
        is_agi_id = upper_id.startswith("AT") and "G" in upper_id

        if is_agi_id:
            if not BARUtils.is_arabidopsis_gene_valid(upper_id):
                return {
                    "success": False,
                    "error": "Invalid Arabidopsis gene ID format",
                    "error_code": 400,
                }

            if schema["identifier_type"] == "probeset":
                probset = agi_to_probset(upper_id)
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

        engine_candidates = list(_iter_engine_candidates(database))
        if not engine_candidates:
            return {
                "success": False,
                "error": f"Database {database} is not available (no active bind or sqlite mirror).",
                "error_code": 404,
            }

        gene_column_expr = (
            f"UPPER({schema['gene_column']})" if gene_case_insensitive else schema["gene_column"]
        )
        params = {"gene_id": query_id.upper() if gene_case_insensitive else query_id}
        where_clauses = [f"{gene_column_expr} = :gene_id"]

        if sample_ids:
            filtered = [s for s in sample_ids if s]
            if filtered:
                sample_column_expr = (
                    f"UPPER({schema['sample_column']})"
                    if sample_case_insensitive
                    else schema["sample_column"]
                )
                sample_conditions = []
                for idx, sample in enumerate(filtered):
                    key = f"sample_{idx}"
                    params[key] = sample.upper() if sample_case_insensitive else sample
                    sample_conditions.append(f"{sample_column_expr} = :{key}")
                where_clauses.append(f"({' OR '.join(sample_conditions)})")

        query_sql = text(
            f"SELECT {schema['sample_column']} AS sample, {schema['value_column']} AS value "
            f"FROM {schema['table']} "
            f"WHERE {' AND '.join(where_clauses)}"
        )

        results = None
        last_error = None

        for source_label, engine, dispose_after in engine_candidates:
            try:
                with Session(engine) as session:
                    results = session.execute(query_sql, params).all()
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

        if results is None:
            return {
                "success": False,
                "error": (
                    f"Database query failed for {database}. "
                    f"{'Last error: ' + last_error if last_error else ''}"
                ).strip(),
                "error_code": 500,
            }

        if not results and not allow_empty_results:
            return {
                "success": False,
                "error": (
                    f"No expression data found for {gene_id} "
                    f"(query identifier: {query_id})"
                ),
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
