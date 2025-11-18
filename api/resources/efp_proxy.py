import requests
import json
import os
import traceback
from pathlib import Path
from typing import Dict, List, Optional
from collections import OrderedDict
from flask_restx import Namespace, Resource
from flask import request, has_app_context
from markupsafe import escape
from sqlalchemy import create_engine, text
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.models.bar_utils import BARUtils

# efp proxy namespace - provides two endpoints for gene expression data:
# 1. /values talks to the live BAR ePlant CGI
# 2. /expression reads from our local/remote databases using one shared query
efp_proxy_ns = Namespace(
    'efp Proxy', 
    description='Expression data retrieveal service from BAR eplant databse.',
    path='/efp_proxy',
)

# absolute path to the config/databases directory (where the sqlite mirrors live)
# centralized path keeps helper functions in sync about where mirrors live
ROOT_DIR = Path(__file__).resolve().parents[2]
DATABASE_DIR = ROOT_DIR / "config" / "databases"

# schema catalog for every database in config/databases
# spelling out the table + column names once means every db can share the same query code
# centralizing schema knowledge avoids per-database ORM duplication
DEFAULT_SAMPLE_SCHEMA = {
    "table": "sample_data",
    "gene_column": "data_probeset_id",
    "sample_column": "data_bot_id",
    "value_column": "data_signal",
}

# list of all mirrors that follow the default schema (sample_data/data_signal, etc.)
# adding new entries here is enough for the dynamic endpoint to pick them up
SAMPLE_DATA_DATABASES = [
    "arabidopsis_ecotypes",
    "arachis",
    "cannabis",
    "canola_nssnp",
    "dna_damage",
    "embryo",
    "eplant2",
    "eplant_poplar",
    "eplant_rice",
    "eplant_soybean",
    "eplant_tomato",
    "fastpheno",
    "germination",
    "homologs_db",
    "interactions_vincent_v2",
    "kalanchoe",
    "klepikova",
    "llama3",
    "phelipanche",
    "physcomitrella_db",
    "poplar_nssnp",
    "rice_interactions",
    "sample_data",
    "selaginella",
    "shoot_apex",
    "silique",
    "single_cell",
    "soybean_nssnp",
    "strawberry",
    "striga",
    "tomato_nssnp",
    "tomato_sequence",
    "triphysaria",
]

# databases that store microarray probeset identifiers in data_probeset_id.
# every other db expects a normal arabidopsis gene id (AT1G01010, etc.)
# this toggle informs the dynamic query whether it needs to translate AGIs to probesets
PROBESET_DATABASES = {"sample_data"}

# build the catalog once at import time so every request can look up its schema quickly
# precomputing avoids rebuilding dictionaries for every HTTP request
DYNAMIC_DATABASE_SCHEMAS: Dict[str, Dict[str, str]] = {}
for db_name in SAMPLE_DATA_DATABASES:
    schema = DEFAULT_SAMPLE_SCHEMA.copy()
    schema.update(
        {
            "filename": f"{db_name}.db",
            "identifier_type": "probeset" if db_name in PROBESET_DATABASES else "agi",
        }
    )
    DYNAMIC_DATABASE_SCHEMAS[db_name] = schema

# normalize optional samples provided via query params (supports repeated params,
# comma-delimited strings, or the legacy JSON array format)
# clients historically sent sample lists in several shapes; this keeps backward compatibility
def parse_samples_query_values(raw_values: Optional[List[str]]) -> Optional[List[str]]:
    if not raw_values:
        return None

    filtered = [value for value in raw_values if value]
    if not filtered:
        return None

    if len(filtered) > 1:
        return filtered

    candidate = filtered[0].strip()
    if not candidate:
        return None

    # interpret JSON array strings (legacy clients sent one JSON string value)
    if candidate.startswith("[") and candidate.endswith("]"):
        try:
            parsed = json.loads(candidate)
            if isinstance(parsed, list):
                return [str(item).strip() for item in parsed if isinstance(item, str) and item.strip()]
        except json.JSONDecodeError:
            pass

    if "," in candidate:
        # support comma-separated lists (?samples=A,B,C) by splitting manually
        split_values = [item.strip() for item in candidate.split(",") if item.strip()]
        if split_values:
            return split_values

    return [candidate]

# fetch gene expression data from the external bar eplant api
# either use the samples passed in or auto-fill the full list before calling the CGI
def fetch_efp_data(datasource, gene_id, samples=None):
    # set up the external bar api url and basic query parameters
    base_url = "https://bar.utoronto.ca//eplant/cgi-bin/plantefp.cgi"
    query_params = [
        ("datasource", datasource),
        ("id", gene_id),
        ("format", "json"),
    ]
    samples_applied = False  # tracks whether we hinted the CGI with explicit samples

    # handle optional sample filtering parameter
    # when provided, expect a list of sample ids collected from the query params
    if samples:
        cleaned_samples = [sample.strip() for sample in samples if isinstance(sample, str) and sample.strip()]
        if cleaned_samples:
            query_params.append(("samples", json.dumps(cleaned_samples)))
            samples_applied = True
    # no samples provided, so try to auto-load all samples for this datasource
    else:
        samples = get_all_samples_for_view(datasource)
        if samples:
            print(f"[info] auto-loaded {len(samples)} samples for datasource {datasource}")
            query_params.append(("samples", json.dumps(samples)))
            samples_applied = True
        else:
            # no metadata entry means we let the CGI decide which default samples to use
            print(f"[warn] no samples found for datasource {datasource}")

    # make exactly one http get request to the bar eplant cgi (packs every sample into this call)
    response = requests.get(base_url, params=query_params)
    url_called = response.url

    # check if the request failed with an http error code
    if not response.ok: 
        # propagate error status so clients see the same HTTP code the CGI returned
        return {"success": False, "error": f"bar returned {response.status_code} for url {url_called}"}, response.status_code
    
    # attempt to parse json response and extract data array
    try:
        data = response.json()
        if isinstance(data, dict) and "data" in data:
            data = data["data"]
    except Exception:
        # remote endpoint occasionally emits HTML error pages—treat them as no data
        data = []

    # if no results returned with samples, retry without sample filtering
    # if filtering wiped out the response, retry once without sample hints
    if (not data or data == []) and samples_applied:
        retry_params = [
            ("datasource", datasource),
            ("id", gene_id),
            ("format", "json"),
        ]
        retry_resp = requests.get(base_url, params=retry_params)
        # even if this second call fails, we still return an empty array to the caller
        retry_url = retry_resp.url

        try:
            retry_data = retry_resp.json()
            if isinstance(retry_data, dict) and "data" in retry_data:
                retry_data = retry_data["data"]
        except Exception:
            # treat malformed fallback responses as empty to keep behavior predictable
            retry_data = []

        return {
            "success": True,
            "url_called": url_called,
            "record_count": len(retry_data),
            "data": retry_data,
            "note": "no data returned with samples; fetched full view instead."
        }
    return {
        "success": True,
        "url_called": url_called,
        "record_count": len(data) if isinstance(data, list) else 0,
        "data": data  # payload mirrors what the real CGI would have returned
    }

# load all available samples for a datasource using our metadata json
# includes hardcoded fallbacks for specific views when the json is missing
def get_all_samples_for_view(datasource: str):
    # point at the metadata json that was scraped from the eFP site
    # during tests this file lives in the repo, so os.getcwd() resolves correctly
    path = os.path.join(os.getcwd(), "data/efp_info/efp_species_view_info.json")

    # check for specific datasources that need hardcoded samples
    if datasource == "root_Schaefer_lab":
        # this dataset is missing from the scraped metadata, so we pin a curated set
        print("[info] using hardcoded fallback samples for root_Schaefer_lab")
        return ["WTCHG_203594_01","WTCHG_203594_05","WTCHG_203839_04","WTCHG_203594_03","WTCHG_203594_07","WTCHG_203839_06","WTCHG_203839_01","WTCHG_203594_10","WTCHG_203839_08","WTCHG_129187_01","WTCHG_129189_01","WTCHG_129190_01","WTCHG_129187_03","WTCHG_129189_03","WTCHG_129190_03","WTCHG_129187_05","WTCHG_129189_05","WTCHG_129187_07","WTCHG_131167_01","WTCHG_125416_01","WTCHG_129190_05","WTCHG_131167_03","WTCHG_125416_03","WTCHG_129190_07","WTCHG_131167_05","WTCHG_125416_05","WTCHG_129189_07"]
    
    if datasource == "atgenexp_stress":
        # AtGenExp stress views still rely on the JSON metadata but we keep a minimal fallback
        print("[info] using fallback arabidopsis samples from json spec")
        return ["AtGen_6_0011", "AtGen_6_0012", "AtGen_6_0021", "AtGen_6_0022", 
                "AtGen_6_0711", "AtGen_6_0712", "AtGen_6_0721", "AtGen_6_0722"
        ]
    
    # check if metadata json file exists
    if not os.path.exists(path):
        # repo clones without fixtures can still run, just without auto-sample loading
        print(f"[warn] metadata json not found at {path}")
        return []

    # try to load and parse the json metadata file
    try:
        with open(path, "r") as f:
            metadata = json.load(f)
    except Exception as e:
        print(f"[error] unable to read json: {e}")
        return []
    
    # search through all species and views to find matching datasource
    # the metadata format is nested (species -> views -> groups -> treatments)
    for species, obj in metadata.items():
        views = obj.get("data", {}).get("views", {})
        for vname, vinfo in views.items():
            if vinfo.get("database") == datasource:
                # collect all unique samples from all treatment groups
                samples = []
                for group in vinfo.get("groups", {}).values():
                    # each group stores multiple treatment buckets; flatten all of them
                    for treatment_samples in group.get("treatments", {}).values():
                        samples.extend(treatment_samples)
                print(f"[info] found {len(samples)} samples in json for {datasource}")
                return sorted(set(samples))
    
    print(f"[warn] datasource {datasource} not found in json")
    return []

# convert arabidopsis agi gene id (like AT1G01010) to probeset id
# queries the lookup table to find the most recent mapping
def agi_to_probset(gene_id: str):
    try:
        # build query to find most recent probeset for this agi
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
        else:
            return None
    except Exception as e:
        print(f"[error] AGI to probeset conversion failed {e}")
        return None

# dynamically query any eFP database using the schema catalog above
# this replaces dozens of per-database ORM classes with one shared query path
def query_efp_database_dynamic(database: str, gene_id: str, sample_ids=None):
    try:
        database = str(database)
        gene_id = str(gene_id)

        # look up how this database stores genes/samples so the generic query knows which columns to use
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

        # decide which identifier should be used for the WHERE clause
        query_id = gene_id
        probset_display = None  # used to echo what identifier we ultimately queried with
        upper_id = gene_id.upper()
        is_agi_id = upper_id.startswith("AT") and "G" in upper_id

        if is_agi_id:
            # reject invalid AGI formatting up front before hitting the database
            if not BARUtils.is_arabidopsis_gene_valid(upper_id):
                return {
                    "success": False,
                    "error": "Invalid Arabidopsis gene ID format",
                    "error_code": 400,
                }

            if schema["identifier_type"] == "probeset":
                # older microarray mirrors store probeset-only identifiers
                # some microarray mirrors still store probeset ids, so translate AGIs on the fly
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
                probset_display = upper_id

        # build the full path to the requested database file (sqlite mirror on disk)
        # tests ship trimmed fixtures, but production deployments still point to MySQL binds
        db_path = DATABASE_DIR / schema["filename"]

        # try the real mysql bind first; if that fails, use the sqlite mirror
        engine_candidates = []
        # candidate order matters: we prefer live binds but degrade gracefully to sqlite
        if has_app_context():
            try:
                bound_engine = db.get_engine(bind=database)
                engine_candidates.append(("sqlalchemy_bind", bound_engine, False))
            except Exception as exc:
                print(f"[warn] Unable to load SQLAlchemy bind for {database}: {exc}")

        if db_path.exists():
            # mirrors are SQLite files generated via scripts/build_sqlite_mirrors.py
            sqlite_engine = create_engine(f"sqlite:///{db_path}")
            engine_candidates.append(("sqlite_mirror", sqlite_engine, True))

        if not engine_candidates:
            return {
                "success": False,
                "error": f"Database {database} is not available (no active bind or sqlite mirror).",
                "error_code": 404,
            }

        where_clauses = [f"{schema['gene_column']} = :gene_id"]
        # always parameterize values to avoid SQL injection and to cache query plans
        params = {"gene_id": query_id}

        if sample_ids:
            filtered = [s for s in sample_ids if s]
            if filtered:
                placeholders = []
                # build `IN (:sample_0, :sample_1, ...)` dynamically to keep it safe
                for idx, sample in enumerate(filtered):
                    key = f"sample_{idx}"
                    placeholders.append(f":{key}")
                    params[key] = sample
                where_clauses.append(
                    f"{schema['sample_column']} IN ({', '.join(placeholders)})"
                )

        # assemble one select statement that returns every sample/value for this gene
        query_sql = text(
            # select statements return a flat list of {sample, value} dicts for the caller
            f"SELECT {schema['sample_column']} AS sample, {schema['value_column']} AS value "
            f"FROM {schema['table']} "
            f"WHERE {' AND '.join(where_clauses)}"
        )

        results = None
        active_source = None
        last_error = None

        for source_label, engine, dispose_after in engine_candidates:
            try:
                with Session(engine) as session:
                    results = session.execute(query_sql, params).all()
                active_source = source_label  # track whether MySQL or SQLite satisfied the query
                break
            except SQLAlchemyError as exc:
                last_error = f"{source_label} failed: {exc}"
                print(f"[warn] {last_error}")
            except Exception as exc:
                last_error = f"{source_label} unexpected failure: {exc}"
                print(f"[warn] {last_error}")
            finally:
                if dispose_after:
                    # SQLite engines are cheap but keeping them open leaks file handles in tests
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

        if not results:
            # returning 404 keeps parity with the legacy API response for missing genes
            return {
                "success": False,
                "error": (
                    f"No expression data found for {gene_id} "
                    f"(query identifier: {query_id})"
                ),
                "error_code": 404,
            }

        # normalize the payload to match the eFP json structure the frontend expects
        expression_data = [{"name": row.sample, "value": str(row.value)} for row in results]
        # str() coercion keeps parity with the remote CGI which serializes numbers as strings

        return {
            "success": True,
            "gene_id": gene_id,
            "probset_id": probset_display or query_id,
            "database": database,
            "record_count": len(expression_data),
            "data": expression_data,
        }

    except Exception as e:
        error_trace = traceback.format_exc()
        # printing the trace means docker logs show full context without leaking to client
        print(f"[error] Database query exception: {error_trace}")
        return {
            "success": False,
            "error": f"Database query failed: {str(e)}",
            "error_code": 500
        }

# rest endpoint that proxies requests to the external bar eplant api
# supports urls like /efp_proxy/values/atgenexp_stress/AT1G01010
@efp_proxy_ns.route("/values/<string:database>/<string:gene_id>")
@efp_proxy_ns.doc(
    description="Proxies requests to BAR ePlant API: /efp_proxy/values/{database}/{gene_id}",
    params=OrderedDict([
        (
            "database",
            {
                "description": "Database/datasource for arabidopsis view (e.g., atgenexp_stress)",
                "in": "path",
                "default": "atgenexp_stress",
            },
        ),
        (
            "gene_id",
            {
                "description": "Gene ID to query (e.g., AT1G01010)",
                "in": "path",
                "default": "AT1G01010",
            },
        ),
        (
            "samples",
            {
                "description": "Optional list of sample IDs (repeat ?samples=SampleA&samples=SampleB); omit to fetch all samples. Legacy JSON arrays are still accepted.",
                "in": "query",
                "default": "",
            },
        ),
    ]),
)
class EFPValues(Resource):
    def get(self, database, gene_id):
        # sanitize path parameters to prevent injection attacks
        database = escape(database)
        gene_id = escape(gene_id)

        # parse ?samples= query args once so downstream logic gets a normalized list
        samples_arg = parse_samples_query_values(request.args.getlist("samples"))

        # delegate to fetch_efp_data which auto-loads samples when none provided
        return fetch_efp_data(database, gene_id, samples=samples_arg)
# rest endpoint that uses the static schema catalog to query local sqlite databases
# supports urls like /efp_proxy/expression/sample_data/261585_at
@efp_proxy_ns.route("/expression/<string:database>/<string:gene_id>")
@efp_proxy_ns.doc(
    description="Static eFP endpoint: /efp_proxy/expression/{database}/{gene_id}"
)
@efp_proxy_ns.param(
    "gene_id",
    "Gene ID (AGI format like AT1G01010 or probeset like 261585_at)",
    _in="path",
    default="AT1G01010",
)
@efp_proxy_ns.param(
    "database",
    "Database name (e.g., sample_data, klepikova, single_cell)",
    _in="path",
    default="klepikova",
)
class EFPExpression(Resource):
    def get(self, database, gene_id):
        # sanitize path parameters to prevent injection attacks
        database = escape(database)
        gene_id = escape(gene_id)

        # delegate to query_efp_database_dynamic for deterministic queries
        # optional sample filtering is not exposed here yet, hence sample_ids=None
        result = query_efp_database_dynamic(database, gene_id, sample_ids=None)

        # return result with appropriate http status code
        if result["success"]:
            return result
        else:
            return result, result.get("error_code", 500)

efp_proxy_ns.add_resource(EFPValues, '/values/<string:database>/<string:gene_id>')
efp_proxy_ns.add_resource(EFPExpression, '/expression/<string:database>/<string:gene_id>')
