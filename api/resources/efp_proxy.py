import requests
import json
import os
from typing import List, Optional
from collections import OrderedDict
from flask_restx import Namespace, Resource
from flask import request, current_app
from markupsafe import escape
from sqlalchemy.engine.url import make_url
from sqlalchemy.exc import SQLAlchemyError

from api.models.efp_dynamic import SIMPLE_EFP_SAMPLE_MODELS
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS
from api.services.efp_bootstrap import bootstrap_simple_efp_databases
from api.services.efp_data import query_efp_database_dynamic

# efp proxy namespace provides two endpoints for gene expression data
# 1. /values talks to the live bar eplant cgi
# 2. /expression reads from our local or remote databases using one shared query
efp_proxy_ns = Namespace(
    'efp Proxy',
    description='Expression data retrieveal service from BAR eplant databse.',
    path='/efp_proxy',
)


# normalize optional samples from the query string so legacy formats still work
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

    # interpret json array strings because legacy clients sent one json string value
    if candidate.startswith("[") and candidate.endswith("]"):
        try:
            parsed = json.loads(candidate)
            if isinstance(parsed, list):
                return [str(item).strip() for item in parsed if isinstance(item, str) and item.strip()]
        except json.JSONDecodeError:
            pass

    if "," in candidate:
        # support comma-separated lists by splitting manually
        split_values = [item.strip() for item in candidate.split(",") if item.strip()]
        if split_values:
            return split_values

    return [candidate]


# fetch gene expression data from the external bar eplant api
# either use the samples provided or auto-fill the list before calling the cgi
def fetch_efp_data(datasource, gene_id, samples=None):
    # set up the external bar api url and basic query parameters
    base_url = "https://bar.utoronto.ca//eplant/cgi-bin/plantefp.cgi"
    query_params = [
        ("datasource", datasource),
        ("id", gene_id),
        ("format", "json"),
    ]
    samples_applied = False  # track whether we hinted the cgi with explicit samples

    # handle optional sample filtering and expect a normalized list of sample ids
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
            # no metadata entry means the cgi decides which default samples to use
            print(f"[warn] no samples found for datasource {datasource}")

    # make exactly one http get request to the bar eplant cgi with every sample packed in
    response = requests.get(base_url, params=query_params)
    url_called = response.url

    # check if the request failed with an http error code
    if not response.ok:
        # propagate error status so clients see the same http code the cgi returned
        return {"success": False, "error": f"bar returned {response.status_code} for url {url_called}"}, response.status_code

    # attempt to parse json response and extract the data array
    try:
        data = response.json()
        if isinstance(data, dict) and "data" in data:
            data = data["data"]
    except Exception:
        # remote endpoint occasionally emits html error pages so treat them as no data
        data = []

    # if no results returned with samples, retry once without sample filtering
    if (not data or data == []) and samples_applied:
        retry_params = [
            ("datasource", datasource),
            ("id", gene_id),
            ("format", "json"),
        ]
        retry_resp = requests.get(base_url, params=retry_params)
        # even if this second call fails, we still return an empty array to the caller

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
        "data": data  # payload mirrors what the real cgi would have returned
    }


# load all available samples for a datasource using the metadata json and fallbacks
def get_all_samples_for_view(datasource: str):
    # point at the scraped metadata json so tests resolve it from the repo
    path = os.path.join(os.getcwd(), "data/efp_info/efp_species_view_info.json")

    # check for datasources that need hardcoded samples
    if datasource == "root_Schaefer_lab":
        # this dataset is missing from the scraped metadata so we pin a curated set
        print("[info] using hardcoded fallback samples for root_Schaefer_lab")
        return ["WTCHG_203594_01", "WTCHG_203594_05", "WTCHG_203839_04", "WTCHG_203594_03", "WTCHG_203594_07", "WTCHG_203839_06", "WTCHG_203839_01", "WTCHG_203594_10", "WTCHG_203839_08", "WTCHG_129187_01", "WTCHG_129189_01", "WTCHG_129190_01", "WTCHG_129187_03", "WTCHG_129189_03", "WTCHG_129190_03", "WTCHG_129187_05", "WTCHG_129189_05", "WTCHG_129187_07", "WTCHG_131167_01", "WTCHG_125416_01", "WTCHG_129190_05", "WTCHG_131167_03", "WTCHG_125416_03", "WTCHG_129190_07", "WTCHG_131167_05", "WTCHG_125416_05", "WTCHG_129189_07"]

    if datasource == "atgenexp_stress":
        # atgenexp stress views still rely on the json metadata so we keep a minimal fallback
        print("[info] using fallback arabidopsis samples from json spec")
        return ["AtGen_6_0011", "AtGen_6_0012", "AtGen_6_0021", "AtGen_6_0022",
                "AtGen_6_0711", "AtGen_6_0712", "AtGen_6_0721", "AtGen_6_0722"]

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

    # search through all species and views to find a matching datasource
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


def _infer_default_db_credentials():
    """Derive MySQL connection info for the simple eFP datasets from the configured binds."""
    binds = current_app.config.get("SQLALCHEMY_BINDS") or {}
    for db_name in SIMPLE_EFP_DATABASE_SCHEMAS.keys():
        uri = binds.get(db_name)
        if not uri:
            continue
        url = make_url(uri)
        return {
            "host": url.host or "localhost",
            "port": url.port or 3306,
            "user": url.username or "root",
            "password": url.password or "",
        }
    raise ValueError("No SQLAlchemy bind configured for the simple eFP databases.")


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


@efp_proxy_ns.route("/bootstrap/simple")
@efp_proxy_ns.doc(
    description="Create or update the simple eFP MySQL databases using the in-memory schema definitions.",
    params={
        "host": "Optional MySQL hostname override. Defaults to the host defined in SQLALCHEMY_BINDS.",
        "port": "Optional MySQL port override. Defaults to the port defined in SQLALCHEMY_BINDS.",
        "user": "Optional MySQL username override. Defaults to the username defined in SQLALCHEMY_BINDS.",
        "password": "Optional MySQL password override. Defaults to the password defined in SQLALCHEMY_BINDS.",
        "databases": "Optional list of database names to bootstrap. Defaults to every simple database.",
    },
)
class EFPSimpleBootstrap(Resource):
    def post(self):
        payload = request.get_json(silent=True) or {}
        try:
            defaults = _infer_default_db_credentials()
        except ValueError as exc:
            return {"success": False, "error": str(exc)}, 500

        host = payload.get("host") or defaults["host"]
        try:
            port_value = payload.get("port")
            port = int(port_value) if port_value is not None else int(defaults["port"])
        except (TypeError, ValueError):
            return {"success": False, "error": "port must be an integer"}, 400
        user = payload.get("user") or defaults["user"]
        password = payload.get("password") or defaults["password"]

        databases = payload.get("databases")
        if databases is not None:
            if not isinstance(databases, list) or not all(isinstance(item, str) for item in databases):
                return {"success": False, "error": "databases must be a list of names."}, 400

        try:
            results = bootstrap_simple_efp_databases(
                host=host,
                port=port,
                user=user,
                password=password,
                databases=databases,
            )
        except ValueError as exc:
            return {"success": False, "error": str(exc)}, 400
        except SQLAlchemyError as exc:
            return {"success": False, "error": str(exc)}, 500

        model_info = [
            {"database": name, "model": model.__name__}
            for name, model in SIMPLE_EFP_SAMPLE_MODELS.items()
            if databases is None or name in databases
        ]

        return {
            "success": True,
            "databases": results,
            "models": model_info,
            "note": "Simple eFP databases are materialized in MySQL while SQLAlchemy models remain dynamic.",
        }, 200


efp_proxy_ns.add_resource(EFPValues, '/values/<string:database>/<string:gene_id>')
efp_proxy_ns.add_resource(EFPExpression, '/expression/<string:database>/<string:gene_id>')
efp_proxy_ns.add_resource(EFPSimpleBootstrap, '/bootstrap/simple')
