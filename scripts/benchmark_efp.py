#!/usr/bin/env python3
"""
Benchmark: flat-file model definition vs dynamic schema generation for EFP databases.

Measures (against the FULL Feb 2025 SQL dumps — not 1-5 row samples):
  1. Model class creation time: static flat definitions vs dynamic type() generation
  2. Schema catalog build time (unique to dynamic approach)
  3. RAM usage: peak RSS + tracemalloc for each approach
  4. HTTP query time: local API / ngrok tunnel / BAR production CGI
  5. Per-database query timing across all genes found in the dump

All plots are saved to scripts/results/.

Usage:
    python scripts/benchmark_efp.py
    python scripts/benchmark_efp.py --local-url http://localhost:5000
    python scripts/benchmark_efp.py --ngrok-url https://xxxx.ngrok-free.app
    python scripts/benchmark_efp.py --skip-bar   # skip remote BAR CGI requests
    python scripts/benchmark_efp.py --iterations 50 --query-genes 30
"""

from __future__ import annotations
import requests
import matplotlib.pyplot as plt

import argparse
import os
import random
import re
import resource
import sys
import time
import tracemalloc
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

import matplotlib
matplotlib.use("Agg")  # non-interactive — safe in CI and SSH sessions


# ---------------------------------------------------------------------------
# Repository layout
# ---------------------------------------------------------------------------
REPO_ROOT = Path(__file__).resolve().parents[1]
ARCHIVE_DIR = REPO_ROOT / "api" / "Archive"
RESULTS_DIR = Path(__file__).resolve().parent / "results"
RESULTS_DIR.mkdir(exist_ok=True)

sys.path.insert(0, str(REPO_ROOT))
os.chdir(str(REPO_ROOT))

# ---------------------------------------------------------------------------
# Dump files — full Vincent dumps from Feb 6 2025
# ---------------------------------------------------------------------------
DUMP_FILES: Dict[str, Path] = {
    "embryo": ARCHIVE_DIR / "embryo_efp_feb_6_2025_dump.sql",
    "klepikova": ARCHIVE_DIR / "klepikova_efp_feb_6_2025_dump.sql",
    "soybean": ARCHIVE_DIR / "soybean_efp_feb_6_2025_dump.sql",
}

# 0-indexed column positions inside each INSERT tuple after splitting on ','
COLUMN_MAP: Dict[str, Dict[str, int]] = {
    # embryo:    (proj_id, sample_id, data_probeset_id, data_signal, data_bot_id)
    "embryo": {"probeset": 2, "signal": 3, "bot": 4, "min_cols": 5},
    # klepikova: (proj_id, sample_id, data_probeset_id, data_signal, data_bot_id, NULL)
    "klepikova": {"probeset": 2, "signal": 3, "bot": 4, "min_cols": 5},
    # soybean:   (proj_id, proj_id2, filename, data_probeset_id, data_signal, data_call, data_p_val, data_bot_id)
    "soybean": {"probeset": 3, "signal": 4, "bot": 7, "min_cols": 8},
}

BAR_API_BASE = "https://bar.utoronto.ca/api"

# Databases that have a matching endpoint on the BAR production API:
#   GET /rnaseq_gene_expression/{species}/{database}/{gene_id}
# Soybean is not available via this endpoint on production.
BAR_RNASEQ_SUPPORTED: Dict[str, str] = {
    "embryo": "arabidopsis",
    "klepikova": "arabidopsis",
}

# Browser headers required — raw curl/requests UA returns 403
_BAR_HEADERS: Dict[str, str] = {
    "User-Agent": (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
    ),
    "Referer": "https://bar.utoronto.ca/eplant/",
    "Accept": "application/json, text/plain, */*",
}


# ===========================================================================
# Dump parsing helpers
# ===========================================================================

def _parse_tuple_fields(raw: str) -> List[str]:
    """Split a raw SQL tuple string on ',' and strip quotes from each field."""
    return [f.strip().strip("'\"") for f in raw.split(",")]


def extract_genes_from_dump(db_name: str, limit: Optional[int] = None) -> List[str]:
    """Return all unique probeset/gene IDs found in the dump's sample_data table.

    :param db_name: One of 'embryo', 'klepikova', 'soybean'.
    :param limit: If set, return at most this many gene IDs (random sample).
    :return: Sorted list of unique gene IDs.
    """
    dump_path = DUMP_FILES.get(db_name)
    if not dump_path or not dump_path.exists():
        print(f"  [WARN] Dump not found: {dump_path}")
        return []

    col = COLUMN_MAP[db_name]
    p_idx, min_cols = col["probeset"], col["min_cols"]
    genes: set[str] = set()

    with open(dump_path, "r", errors="replace") as fh:
        for line in fh:
            if "INSERT INTO `sample_data`" not in line:
                continue
            for m in re.finditer(r"\(([^)]+)\)", line):
                fields = _parse_tuple_fields(m.group(1))
                if len(fields) < min_cols:
                    continue
                gene = fields[p_idx]
                if gene:
                    genes.add(gene)

    result = sorted(genes)
    if limit and len(result) > limit:
        result = random.sample(result, limit)
        result.sort()
    return result


def count_dump_samples(db_name: str) -> int:
    """Count total sample rows in the dump's sample_data table."""
    dump_path = DUMP_FILES.get(db_name)
    if not dump_path or not dump_path.exists():
        return 0

    col = COLUMN_MAP[db_name]
    min_cols = col["min_cols"]
    total = 0

    with open(dump_path, "r", errors="replace") as fh:
        for line in fh:
            if "INSERT INTO `sample_data`" not in line:
                continue
            for m in re.finditer(r"\(([^)]+)\)", line):
                fields = _parse_tuple_fields(m.group(1))
                if len(fields) >= min_cols:
                    total += 1
    return total


# ===========================================================================
# Part 1 — Model generation benchmark (flat vs dynamic)
# ===========================================================================

def _simulate_flat_class_creation(db_names: List[str]) -> float:
    """Time the overhead of defining flat-file model classes via type().

    In a real flat-file approach every class is written out in a .py file.
    Python's import system runs the body of each class definition exactly once.
    We replicate that cost by calling type() with the same attribute layout.

    :param db_names: List of database names (one class per DB).
    :return: Elapsed seconds.
    """
    t0 = time.perf_counter()
    for db_name in db_names:
        class_name = "".join(p.capitalize() for p in db_name.split("_")) + "SampleData"
        type(class_name, (), {
            "__bind_key__": db_name,
            "__tablename__": "sample_data",
            "data_probeset_id": None,
            "data_signal": None,
            "data_bot_id": None,
        })
    return time.perf_counter() - t0


def _simulate_dynamic_schema_build(db_names: List[str], specs_lookup: Dict[str, Any]) -> float:
    """Time the schema-dict construction + attribute-dict construction for every DB.

    This is the per-call overhead unique to the dynamic approach: building the
    schema catalog dict and mapping column specs to attribute dicts, before the
    type() call.

    :param db_names: List of database names.
    :param specs_lookup: Mapping of db_name -> spec dict (from SIMPLE_EFP_DATABASE_SCHEMAS).
    :return: Elapsed seconds.
    """
    t0 = time.perf_counter()
    for db_name in db_names:
        spec = specs_lookup[db_name]
        # schema dict construction
        attrs = {"__bind_key__": db_name, "__tablename__": spec["table_name"]}
        # attribute dict construction (column mapping loop)
        for col in spec["columns"]:
            col_type = col["type"]
            if col_type == "string":
                sqla_type = f"String({col['length']})"
            elif col_type == "float":
                sqla_type = "Float"
            else:
                sqla_type = "String(255)"
            attrs[col["name"]] = sqla_type
        # class creation (same cost as flat)
        class_name = "".join(p.capitalize() for p in db_name.split("_")) + "SampleData"
        type(class_name, (), attrs)
    return time.perf_counter() - t0


def benchmark_model_generation(iterations: int = 100) -> Dict[str, Any]:
    """Run flat vs dynamic class creation over many iterations.

    :param iterations: Number of times to repeat each approach.
    :return: Dict with avg/min/max ms for flat and dynamic, plus model_count.
    """
    from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS

    db_names = list(SIMPLE_EFP_DATABASE_SCHEMAS.keys())
    model_count = len(db_names)

    flat_times: List[float] = []
    dynamic_times: List[float] = []

    for _ in range(iterations):
        flat_times.append(_simulate_flat_class_creation(db_names))
        dynamic_times.append(_simulate_dynamic_schema_build(db_names, SIMPLE_EFP_DATABASE_SCHEMAS))

    def _stats(times: List[float]) -> Dict[str, float]:
        avg = sum(times) / len(times) * 1000
        return {
            "avg_ms": round(avg, 4),
            "min_ms": round(min(times) * 1000, 4),
            "max_ms": round(max(times) * 1000, 4),
            "all_ms": [round(t * 1000, 4) for t in times],
        }

    return {
        "model_count": model_count,
        "iterations": iterations,
        "flat": _stats(flat_times),
        "dynamic": _stats(dynamic_times),
    }


# ===========================================================================
# Part 2 — RAM benchmark
# ===========================================================================

def _rss_kb() -> float:
    """Return current peak RSS in KB (macOS returns bytes; Linux returns KB)."""
    usage = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    # On macOS ru_maxrss is in bytes; on Linux it's in kilobytes
    divisor = 1024 if sys.platform == "darwin" else 1
    return usage / divisor


def benchmark_memory() -> Dict[str, Any]:
    """Measure Python heap allocation for flat vs dynamic model approach.

    Uses tracemalloc to capture incremental allocation. Both approaches create
    the same number of class objects; the dynamic approach additionally builds
    the schema catalog dict.

    :return: Dict with tracemalloc deltas and peak RSS snapshots.
    """
    from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS

    db_names = list(SIMPLE_EFP_DATABASE_SCHEMAS.keys())

    tracemalloc.start()
    snap0 = tracemalloc.take_snapshot()
    rss0 = _rss_kb()

    # --- measure flat-file approach ---
    flat_models: Dict[str, Any] = {}
    for db_name in db_names:
        class_name = "".join(p.capitalize() for p in db_name.split("_")) + "FlatSD"
        flat_models[db_name] = type(class_name, (), {
            "__bind_key__": db_name,
            "__tablename__": "sample_data",
            "data_probeset_id": None,
            "data_signal": None,
            "data_bot_id": None,
        })

    snap1 = tracemalloc.take_snapshot()
    rss1 = _rss_kb()
    flat_kb = sum(s.size_diff for s in snap1.compare_to(snap0, "lineno")) / 1024

    # --- measure dynamic approach (schema dict + attr dict + type()) ---
    dynamic_models: Dict[str, Any] = {}
    schema_catalog: Dict[str, Any] = {}
    for db_name, spec in SIMPLE_EFP_DATABASE_SCHEMAS.items():
        schema_catalog[db_name] = {
            "table_name": spec["table_name"],
            "columns": spec["columns"],
            "charset": spec.get("charset", "latin1"),
            "metadata": spec.get("metadata", {}),
        }
        attrs = {"__bind_key__": db_name, "__tablename__": spec["table_name"]}
        for col in spec["columns"]:
            attrs[col["name"]] = col.get("type", "string")
        class_name = "".join(p.capitalize() for p in db_name.split("_")) + "DynSD"
        dynamic_models[db_name] = type(class_name, (), attrs)

    snap2 = tracemalloc.take_snapshot()
    rss2 = _rss_kb()
    dynamic_kb = sum(s.size_diff for s in snap2.compare_to(snap1, "lineno")) / 1024

    tracemalloc.stop()

    return {
        "model_count": len(db_names),
        "flat_heap_kb": round(flat_kb, 2),
        "flat_rss_kb": round(rss1 - rss0, 2),
        "dynamic_heap_kb": round(dynamic_kb, 2),
        "dynamic_rss_kb": round(rss2 - rss1, 2),
    }


# ===========================================================================
# Part 3 — HTTP query benchmarks
# ===========================================================================

_PLACEHOLDER_NGROK_URLS = {"https://xxxx.ngrok-free.app", "https://your-real-ngrok-url.ngrok-free.app"}

# ngrok's free tier shows an HTML interstitial for non-browser clients unless this header is set
_NGROK_HEADERS: Dict[str, str] = {"ngrok-skip-browser-warning": "true"}


def _validate_ngrok_url(url: Optional[str]) -> Optional[str]:
    """Return the URL if it looks real, None + a printed warning if it's a placeholder."""
    if not url:
        return None
    if url.rstrip("/") in _PLACEHOLDER_NGROK_URLS or "xxxx" in url or "your-real" in url:
        print(f"  [WARN] ngrok URL looks like a placeholder: {url}")
        print("  [WARN] Run `ngrok http 5000` and pass the real Forwarding URL.")
        return None
    return url


def _query_url(
    base_url: str,
    db_name: str,
    gene_id: str,
    timeout: int = 10,
    session: Optional[requests.Session] = None,
) -> Tuple[float, bool, int, str]:
    """GET /gene_expression/expression/{db_name}/{gene_id} and return (elapsed, success, records, error).

    :param session: Optional persistent session for HTTP keep-alive connection reuse.
        Pass the same session across calls to avoid paying TCP+TLS handshake cost per request.
    :return: (elapsed_seconds, success_bool, record_count, error_message)
    """
    url = f"{base_url}/gene_expression/expression/{db_name}/{gene_id}"
    # ngrok intercepts non-browser requests and returns HTML without this header
    headers = _NGROK_HEADERS if "ngrok" in base_url else {}
    requester = session if session is not None else requests
    t0 = time.perf_counter()
    try:
        resp = requester.get(url, timeout=timeout, headers=headers)
        elapsed = time.perf_counter() - t0
        data = resp.json()
        return (
            elapsed,
            bool(data.get("success", False)),
            int(data.get("record_count", 0)),
            data.get("error", "") if not data.get("success") else "",
        )
    except requests.exceptions.ConnectionError:
        return time.perf_counter() - t0, False, 0, "connection refused"
    except requests.exceptions.Timeout:
        return time.perf_counter() - t0, False, 0, "timeout"
    except Exception as exc:
        return time.perf_counter() - t0, False, 0, str(exc)


def benchmark_api(
    label: str,
    base_url: str,
    databases: List[str],
    genes_per_db: Dict[str, List[str]],
    iterations: int = 5,
    inter_request_delay: float = 0.0,
) -> Dict[str, Any]:
    """Benchmark HTTP query time for each database using a set of gene IDs.

    :param label: Human-readable label for this endpoint (e.g. 'local', 'ngrok').
    :param base_url: Root URL of the BAR API.
    :param databases: List of database names to test.
    :param genes_per_db: Dict mapping db_name -> list of gene IDs to query.
    :param iterations: Times to repeat each query (for averaging).
    :param inter_request_delay: Seconds to sleep between requests (use ~1.5 for ngrok free tier
        to stay under the 40 req/min rate limit).
    :return: Nested dict: {db_name: {avg_ms, min_ms, max_ms, genes_tested, success_rate, first_error}}.
    """
    import time as _time
    results: Dict[str, Any] = {}
    # A single persistent session reuses the TCP+TLS connection across all requests
    # (HTTP keep-alive). This is especially important for ngrok where each new
    # connection adds ~150-200 ms of handshake overhead.
    with requests.Session() as session:
        for db_name in databases:
            genes = genes_per_db.get(db_name, [])
            if not genes:
                continue

            times: List[float] = []
            successes = 0
            total_records = 0
            first_error: str = ""
            error_counts: Dict[str, int] = {}

            for gene in genes:
                for _ in range(iterations):
                    elapsed, ok, records, err = _query_url(base_url, db_name, gene, session=session)
                    if inter_request_delay > 0:
                        _time.sleep(inter_request_delay)
                    times.append(elapsed)
                    if ok:
                        successes += 1
                        total_records += records
                    elif err:
                        if not first_error:
                            first_error = f"{gene}: {err}"
                        error_counts[err] = error_counts.get(err, 0) + 1

            total_calls = len(genes) * iterations
            top_error = max(error_counts, key=lambda k: error_counts[k]) if error_counts else ""

            results[db_name] = {
                "label": label,
                "avg_ms": round(sum(times) / len(times) * 1000, 2) if times else 0,
                "min_ms": round(min(times) * 1000, 2) if times else 0,
                "max_ms": round(max(times) * 1000, 2) if times else 0,
                "all_ms": [round(t * 1000, 2) for t in times],
                "genes_tested": len(genes),
                "total_calls": total_calls,
                "success_rate": round(successes / max(total_calls, 1) * 100, 1),
                "avg_records": round(total_records / max(successes, 1), 1),
                "top_error": top_error,
                "first_error": first_error,
            }
    return results


# Mapping from our internal DB name -> (cgi_base_url, dataSource view name).
# View names come from the XML files at <browser>/data/<View>.xml
# (filename without .xml; db name is the "db" attribute inside the file).
# Each species may have its own eFP browser instance at a different base URL.
BAR_LEGACY_CGI_VIEWS: Dict[str, tuple] = {
    "embryo": ("https://bar.utoronto.ca/efp/cgi-bin/efpWeb.cgi", "Embryo"),
    "klepikova": ("https://bar.utoronto.ca/efp/cgi-bin/efpWeb.cgi", "Klepikova_Atlas"),
    "soybean": ("https://bar.utoronto.ca/efpsoybean/cgi-bin/efpWeb.cgi", "Developmental"),
}


def benchmark_legacy_efp_cgi(
    databases: List[str],
    genes_per_db: Dict[str, List[str]],
    iterations: int = 3,
) -> Dict[str, Any]:
    """Benchmark the legacy BAR eFP Browser CGI endpoint.

    Sends a GET request to the eFP Browser CGI for each gene and measures the
    full HTML page response time. This is the correct legacy comparison target —
    the CGI renders a full expression image page and typically takes 500–2000 ms.

    Only databases with a known CGI view name in BAR_LEGACY_CGI_VIEWS are tested.

    :param databases: List of database names.
    :param genes_per_db: Dict mapping db_name -> list of gene IDs.
    :param iterations: Times to repeat each query.
    :return: Nested dict: {db_name: {avg_ms, min_ms, max_ms, success_rate, top_error}}.
    """
    results: Dict[str, Any] = {}
    with requests.Session() as session:
        for db_name in databases:
            mapping = BAR_LEGACY_CGI_VIEWS.get(db_name)
            if not mapping:
                print(f"  {db_name:15s}  skipped — no CGI view mapping defined")
                continue
            cgi_base, view = mapping

            genes = genes_per_db.get(db_name, [])
            if not genes:
                continue

            times: List[float] = []
            successes = 0
            error_counts: Dict[str, int] = {}

            for gene in genes:
                params = {
                    "primaryGene": gene,
                    "dataSource": view,
                    "modeInput": "Absolute",
                    "colourBy": "Tissue",
                }
                for _ in range(iterations):
                    t0 = time.perf_counter()
                    try:
                        resp = session.get(
                            cgi_base,
                            params=params,
                            headers=_BAR_HEADERS,
                            timeout=30,
                        )
                        elapsed = time.perf_counter() - t0
                        ok = resp.status_code == 200 and len(resp.content) > 500
                        if not ok:
                            error_counts[f"HTTP {resp.status_code}"] = (
                                error_counts.get(f"HTTP {resp.status_code}", 0) + 1
                            )
                    except Exception as exc:
                        elapsed = time.perf_counter() - t0
                        ok = False
                        error_counts[str(exc)] = error_counts.get(str(exc), 0) + 1
                    times.append(elapsed)
                    if ok:
                        successes += 1

            total_calls = len(genes) * iterations
            top_error = max(error_counts, key=lambda k: error_counts[k]) if error_counts else ""

            results[db_name] = {
                "label": "legacy CGI",
                "avg_ms": round(sum(times) / len(times) * 1000, 2) if times else 0,
                "min_ms": round(min(times) * 1000, 2) if times else 0,
                "max_ms": round(max(times) * 1000, 2) if times else 0,
                "all_ms": [round(t * 1000, 2) for t in times],
                "genes_tested": len(genes),
                "total_calls": total_calls,
                "success_rate": round(successes / max(total_calls, 1) * 100, 1),
                "top_error": top_error,
            }
    return results


def benchmark_bar_rnaseq(
    databases: List[str],
    genes_per_db: Dict[str, List[str]],
    iterations: int = 3,
) -> Dict[str, Any]:
    """Benchmark the BAR production rnaseq_gene_expression REST endpoint.

    Uses GET /api/rnaseq_gene_expression/{species}/{database}/{gene_id}.
    Only databases listed in BAR_RNASEQ_SUPPORTED are tested; others are
    skipped with a printed notice.

    :param databases: List of database names.
    :param genes_per_db: Dict mapping db_name -> list of gene IDs.
    :param iterations: Times to repeat each query.
    :return: Nested dict: {db_name: {avg_ms, min_ms, max_ms, success_rate, avg_records, top_error}}.
    """
    results: Dict[str, Any] = {}
    for db_name in databases:
        species = BAR_RNASEQ_SUPPORTED.get(db_name)
        if not species:
            print(f"  {db_name:15s}  skipped — not available on BAR production rnaseq endpoint")
            continue

        genes = genes_per_db.get(db_name, [])
        if not genes:
            continue

        times: List[float] = []
        successes = 0
        total_records = 0
        error_counts: Dict[str, int] = {}

        for gene in genes:
            url = f"{BAR_API_BASE}/rnaseq_gene_expression/{species}/{db_name}/{gene}"
            for _ in range(iterations):
                t0 = time.perf_counter()
                try:
                    resp = requests.get(url, headers=_BAR_HEADERS, timeout=15)
                    elapsed = time.perf_counter() - t0
                    data_obj = resp.json()
                    ok = bool(data_obj.get("wasSuccessful", False)) and len(data_obj.get("data", {})) > 0
                    records = len(data_obj.get("data", {})) if ok else 0
                    if not ok:
                        err = data_obj.get("error", f"empty (HTTP {resp.status_code})")
                        error_counts[err] = error_counts.get(err, 0) + 1
                except Exception as exc:
                    elapsed = time.perf_counter() - t0
                    ok = False
                    records = 0
                    err = str(exc)
                    error_counts[err] = error_counts.get(err, 0) + 1
                times.append(elapsed)
                if ok:
                    successes += 1
                    total_records += records

        total_calls = len(genes) * iterations
        top_error = max(error_counts, key=lambda k: error_counts[k]) if error_counts else ""

        results[db_name] = {
            "label": "BAR website",
            "avg_ms": round(sum(times) / len(times) * 1000, 2) if times else 0,
            "min_ms": round(min(times) * 1000, 2) if times else 0,
            "max_ms": round(max(times) * 1000, 2) if times else 0,
            "all_ms": [round(t * 1000, 2) for t in times],
            "genes_tested": len(genes),
            "total_calls": total_calls,
            "success_rate": round(successes / max(total_calls, 1) * 100, 1),
            "avg_records": round(total_records / max(successes, 1), 1),
            "top_error": top_error,
        }
    return results


def verify_values_vs_bar(
    base_url: str,
    genes_per_db: Dict[str, List[str]],
    n_genes: int = 3,
) -> None:
    """Spot-check local API values vs BAR production for a sample of genes.

    Compares sample-level expression values between the local efp_proxy endpoint
    and BAR production rnaseq_gene_expression endpoint within ±1e-4 tolerance.

    :param base_url: Root URL of the local BAR API.
    :param genes_per_db: Dict mapping db_name -> list of gene IDs.
    :param n_genes: How many genes to spot-check per database.
    """
    tol = 1e-4
    print(f"\n[VERIFY] Spot-checking local API vs BAR production (tolerance ±{tol})")
    for db_name, species in BAR_RNASEQ_SUPPORTED.items():
        genes = genes_per_db.get(db_name, [])[:n_genes]
        if not genes:
            continue
        print(f"\n  {db_name}")
        for gene in genes:
            bar_url = f"{BAR_API_BASE}/rnaseq_gene_expression/{species}/{db_name}/{gene}"
            try:
                bar_resp = requests.get(bar_url, headers=_BAR_HEADERS, timeout=15)
                bar_obj = bar_resp.json()
                if not bar_obj.get("wasSuccessful"):
                    print(f"    {gene}: BAR error — {bar_obj.get('error')}")
                    continue
                bar_vals: Dict[str, float] = {k: float(v) for k, v in bar_obj.get("data", {}).items()}
            except Exception as exc:
                print(f"    {gene}: BAR request failed — {exc}")
                continue

            try:
                local_resp = requests.get(
                    f"{base_url}/gene_expression/expression/{db_name}/{gene}", timeout=10
                )
                local_obj = local_resp.json()
                if not local_obj.get("success"):
                    print(f"    {gene}: local error — {local_obj.get('error')}")
                    continue
                local_vals: Dict[str, float] = {
                    row["name"]: float(row["value"]) for row in local_obj.get("data", [])
                }
            except Exception as exc:
                print(f"    {gene}: local request failed — {exc}")
                continue

            mismatches = sum(
                1 for s, bv in bar_vals.items()
                if s in local_vals and abs(bv - local_vals[s]) > tol
            )
            missing_in_local = sum(1 for s in bar_vals if s not in local_vals)
            extra_in_local = sum(1 for s in local_vals if s not in bar_vals)

            if mismatches == 0 and missing_in_local == 0 and extra_in_local == 0:
                status = "OK"
            elif mismatches > 0:
                status = f"VALUE MISMATCH ({mismatches})"
            else:
                status = f"COUNT DIFF (missing={missing_in_local} extra={extra_in_local})"

            print(f"    {gene}: BAR={len(bar_vals)} samples  local={len(local_vals)} samples  "
                  f"mismatches={mismatches}  [{status}]")


# ===========================================================================
# Part 4 — Visualizations
# ===========================================================================

COLORS = {
    "flat": "#4C72B0",
    "dynamic": "#DD8452",
    "local": "#55A868",
    "ngrok": "#C44E52",
    "legacy_cgi": "#E67E22",
    "bar_rest": "#8172B2",
}


def _save(fig: plt.Figure, name: str) -> Path:
    path = RESULTS_DIR / name
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print(f"  Saved: {path}")
    return path


def plot_model_generation(results: Dict[str, Any]) -> None:
    """Bar chart: flat vs dynamic model class creation time (avg ± range).

    :param results: Output of benchmark_model_generation().
    """
    fig, ax = plt.subplots(figsize=(7, 4))

    labels = ["Flat-file\n(static class defs)", "Dynamic\n(schema dict + type())"]
    avgs = [results["flat"]["avg_ms"], results["dynamic"]["avg_ms"]]
    mins = [results["flat"]["min_ms"], results["dynamic"]["min_ms"]]
    maxs = [results["flat"]["max_ms"], results["dynamic"]["max_ms"]]
    colors = [COLORS["flat"], COLORS["dynamic"]]

    x = range(len(labels))
    bars = ax.bar(x, avgs, color=colors, width=0.5, zorder=3)

    # error bars show min/max range
    lower = [avgs[i] - mins[i] for i in range(len(avgs))]
    upper = [maxs[i] - avgs[i] for i in range(len(avgs))]
    ax.errorbar(x, avgs, yerr=[lower, upper], fmt="none", color="black",
                capsize=6, linewidth=1.5, zorder=4)

    for bar, val in zip(bars, avgs):
        ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.005,
                f"{val:.3f} ms", ha="center", va="bottom", fontsize=9)

    ax.set_xticks(list(x))
    ax.set_xticklabels(labels, fontsize=10)
    ax.set_ylabel("Time (ms per full iteration)", fontsize=10)
    ax.set_title(
        f"Model Creation Time — {results['model_count']} databases, "
        f"{results['iterations']} iterations",
        fontsize=11,
    )
    ax.yaxis.grid(True, linestyle="--", alpha=0.6)
    ax.set_axisbelow(True)
    fig.tight_layout()
    _save(fig, "benchmark_model_generation.png")


def plot_memory(mem: Dict[str, Any]) -> None:
    """Grouped bar chart: heap and RSS delta for flat vs dynamic.

    :param mem: Output of benchmark_memory().
    """
    fig, ax = plt.subplots(figsize=(7, 4))

    categories = ["Heap (tracemalloc)", "RSS delta"]
    flat_vals = [mem["flat_heap_kb"], mem["flat_rss_kb"]]
    dynamic_vals = [mem["dynamic_heap_kb"], mem["dynamic_rss_kb"]]

    x = range(len(categories))
    width = 0.35
    b1 = ax.bar([xi - width / 2 for xi in x], flat_vals, width, label="Flat-file", color=COLORS["flat"], zorder=3)
    b2 = ax.bar([xi + width / 2 for xi in x], dynamic_vals, width, label="Dynamic", color=COLORS["dynamic"], zorder=3)

    for bar in list(b1) + list(b2):
        h = bar.get_height()
        ax.text(bar.get_x() + bar.get_width() / 2, h + 0.5,
                f"{h:.1f}", ha="center", va="bottom", fontsize=8)

    ax.set_xticks(list(x))
    ax.set_xticklabels(categories, fontsize=10)
    ax.set_ylabel("Memory (KB)", fontsize=10)
    ax.set_title(f"RAM Usage — {mem['model_count']} models", fontsize=11)
    ax.legend(fontsize=9)
    ax.yaxis.grid(True, linestyle="--", alpha=0.6)
    ax.set_axisbelow(True)
    fig.tight_layout()
    _save(fig, "benchmark_memory.png")


def plot_query_times(
    local_results: Dict[str, Any],
    ngrok_results: Dict[str, Any],
    legacy_cgi_results: Dict[str, Any],
    databases: List[str],
) -> None:
    """Grouped bar chart: avg query time per database, per endpoint.

    :param local_results:      Output of benchmark_api() for the local URL.
    :param ngrok_results:      Output of benchmark_api() for the ngrok URL (may be empty).
    :param legacy_cgi_results: Output of benchmark_legacy_efp_cgi().
    :param databases:          Ordered list of database names to include.
    """
    def _get_avg(result_dict: Dict[str, Any], db: str) -> float:
        return result_dict.get(db, {}).get("avg_ms", 0.0)

    have_ngrok = any(db in ngrok_results for db in databases)
    have_cgi = any(db in legacy_cgi_results for db in databases)

    sources = [("Local API", local_results, COLORS["local"])]
    if have_ngrok:
        sources.append(("ngrok (internet)", ngrok_results, COLORS["ngrok"]))
    if have_cgi:
        sources.append(("Legacy CGI", legacy_cgi_results, COLORS["legacy_cgi"]))

    n_groups = len(sources)
    width = 0.8 / n_groups
    offsets = [width * (i - (n_groups - 1) / 2) for i in range(n_groups)]

    fig, ax = plt.subplots(figsize=(max(7, len(databases) * 2.5), 5))
    x = range(len(databases))

    for (label, result_dict, color), offset in zip(sources, offsets):
        avgs = [_get_avg(result_dict, db) for db in databases]
        positions = [xi + offset for xi in x]
        bars = ax.bar(positions, avgs, width=width * 0.95, label=label, color=color, zorder=3)
        for bar, val in zip(bars, avgs):
            if val > 0:
                ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 2,
                        f"{val:.0f}", ha="center", va="bottom", fontsize=7, rotation=90)

    ax.set_xticks(list(x))
    ax.set_xticklabels(databases, fontsize=9, rotation=20, ha="right")
    ax.set_ylabel("Avg query time (ms)", fontsize=10)
    ax.set_title("Query Time: Local API vs Legacy CGI vs New BAR REST API", fontsize=11)
    ax.legend(fontsize=9)
    ax.yaxis.grid(True, linestyle="--", alpha=0.6)
    ax.set_axisbelow(True)
    fig.tight_layout()
    _save(fig, "benchmark_query_times.png")


def plot_query_distributions(
    local_results: Dict[str, Any],
    ngrok_results: Dict[str, Any],
    legacy_cgi_results: Dict[str, Any],
    databases: List[str],
) -> None:
    """Box plots of query time distribution per database across all genes/iterations.

    :param local_results:      Output of benchmark_api() for the local URL.
    :param ngrok_results:      Output of benchmark_api() for the ngrok URL (may be empty).
    :param legacy_cgi_results: Output of benchmark_legacy_efp_cgi().
    :param databases:          Ordered list of database names.
    """
    ncols = len(databases)
    fig, axes = plt.subplots(1, ncols, figsize=(max(8, ncols * 3), 4), sharey=False)

    if ncols == 1:
        axes = [axes]

    for ax, db in zip(axes, databases):
        data_sets = []
        labels_bp = []
        colors_bp = []

        local_ms = local_results.get(db, {}).get("all_ms", [])
        if local_ms:
            data_sets.append(local_ms)
            labels_bp.append("Local")
            colors_bp.append(COLORS["local"])

        ngrok_ms = ngrok_results.get(db, {}).get("all_ms", [])
        if ngrok_ms:
            data_sets.append(ngrok_ms)
            labels_bp.append("ngrok")
            colors_bp.append(COLORS["ngrok"])

        cgi_ms = legacy_cgi_results.get(db, {}).get("all_ms", [])
        if cgi_ms:
            data_sets.append(cgi_ms)
            labels_bp.append("Legacy CGI")
            colors_bp.append(COLORS["legacy_cgi"])

        if not data_sets:
            ax.set_visible(False)
            continue

        bp = ax.boxplot(data_sets, patch_artist=True, notch=False,
                        medianprops={"color": "black", "linewidth": 1.5})
        for patch, color in zip(bp["boxes"], colors_bp):
            patch.set_facecolor(color)
            patch.set_alpha(0.75)

        ax.set_xticklabels(labels_bp, fontsize=8)
        ax.set_title(db, fontsize=9)
        ax.set_ylabel("ms" if ax == axes[0] else "", fontsize=8)
        ax.yaxis.grid(True, linestyle="--", alpha=0.5)

    fig.suptitle("Query Time Distributions", fontsize=11, y=1.01)
    fig.tight_layout()
    _save(fig, "benchmark_query_distributions.png")


# ===========================================================================
# Main
# ===========================================================================

def main() -> None:
    parser = argparse.ArgumentParser(description="Benchmark EFP flat vs dynamic models")
    parser.add_argument("--local-url", default="http://localhost:5000",
                        help="Base URL of your local BAR API server")
    parser.add_argument("--ngrok-url", default=None,
                        help="ngrok tunnel URL (e.g. https://xxxx.ngrok-free.app) "
                             "for internet-latency-aware benchmarking")
    parser.add_argument("--iterations", type=int, default=50,
                        help="Iterations for model-generation microbenchmark (default 50)")
    parser.add_argument("--query-genes", type=int, default=20,
                        help="Number of gene IDs per DB to sample for query benchmarks (default 20)")
    parser.add_argument("--query-iters", type=int, default=3,
                        help="Repeat each gene query this many times (default 3)")
    parser.add_argument("--skip-bar", action="store_true",
                        help="Skip remote BAR CGI requests")
    parser.add_argument("--seed", type=int, default=42,
                        help="Random seed for gene sampling (default 42)")
    args = parser.parse_args()

    random.seed(args.seed)

    print("=" * 70)
    print("EFP BENCHMARK — flat-file models vs dynamic schema generation")
    print("=" * 70)

    # ------------------------------------------------------------------
    # 0. Dump inventory
    # ------------------------------------------------------------------
    print("\n[0] Dump file inventory")
    databases = [db for db, p in DUMP_FILES.items() if p.exists()]
    genes_per_db: Dict[str, List[str]] = {}

    for db_name in databases:
        all_genes = extract_genes_from_dump(db_name)
        sample_count = count_dump_samples(db_name)
        genes_per_db[db_name] = (
            random.sample(all_genes, min(args.query_genes, len(all_genes)))
            if all_genes else []
        )
        genes_per_db[db_name].sort()
        print(f"  {db_name:15s}  genes={len(all_genes):6d}  total_rows={sample_count:8d}  "
              f"query_sample={len(genes_per_db[db_name])}")

    if not databases:
        print("  [ERROR] No dump files found in api/Archive/. Exiting.")
        sys.exit(1)

    # ------------------------------------------------------------------
    # 1. Model generation benchmark
    # ------------------------------------------------------------------
    print(f"\n[1] Model generation — {args.iterations} iterations")
    gen_results = benchmark_model_generation(args.iterations)
    flat_d = gen_results["flat"]
    dynamic_d = gen_results["dynamic"]
    print(f"  Flat-file  avg={flat_d['avg_ms']:.3f} ms  "
          f"min={flat_d['min_ms']:.3f}  max={flat_d['max_ms']:.3f}")
    print(f"  Dynamic    avg={dynamic_d['avg_ms']:.3f} ms  "
          f"min={dynamic_d['min_ms']:.3f}  max={dynamic_d['max_ms']:.3f}")
    print(f"  Models: {gen_results['model_count']}")
    ratio = dynamic_d["avg_ms"] / max(flat_d["avg_ms"], 1e-9)
    winner = "flat-file" if flat_d["avg_ms"] < dynamic_d["avg_ms"] else "dynamic"
    print(f"  -> {winner} is faster  (ratio {ratio:.2f}x)")

    # ------------------------------------------------------------------
    # 2. Memory benchmark
    # ------------------------------------------------------------------
    print("\n[2] Memory usage")
    mem_results = benchmark_memory()
    print(f"  Flat-file  heap={mem_results['flat_heap_kb']:.1f} KB  "
          f"RSS delta={mem_results['flat_rss_kb']:.1f} KB")
    print(f"  Dynamic    heap={mem_results['dynamic_heap_kb']:.1f} KB  "
          f"RSS delta={mem_results['dynamic_rss_kb']:.1f} KB")

    # ------------------------------------------------------------------
    # 3. Local API query benchmark
    # ------------------------------------------------------------------
    print(f"\n[3] Local API query benchmark  ({args.local_url})")
    local_results = benchmark_api(
        "local", args.local_url, databases, genes_per_db,
        iterations=args.query_iters,
    )
    for db_name, stats in local_results.items():
        rate = stats["success_rate"]
        line = (f"  {db_name:15s}  avg={stats['avg_ms']:>8.2f} ms  "
                f"genes={stats['genes_tested']}  success={rate}%  "
                f"avg_records={stats['avg_records']}")
        print(line)
        if rate < 100 and stats.get("top_error"):
            print(f"    -> most common error: {stats['top_error']}")
        if rate == 0 and stats.get("first_error"):
            print(f"    -> first failure:     {stats['first_error']}")

    # ------------------------------------------------------------------
    # 4. ngrok tunnel benchmark (optional)
    # ------------------------------------------------------------------
    ngrok_results: Dict[str, Any] = {}
    real_ngrok_url = _validate_ngrok_url(args.ngrok_url)
    if real_ngrok_url:
        # ngrok free tier: ~40 req/min limit. With 20 genes × 3 iters = 60 req/db,
        # a 1.5 s inter-request delay keeps us under the limit and avoids
        # "connection refused" errors that appear on the 2nd/3rd database.
        print(f"\n[4] ngrok tunnel query benchmark  ({real_ngrok_url})")
        print("    (throttling to 1 req/1.5 s to stay under ngrok free-tier rate limit)")
        ngrok_results = benchmark_api(
            "ngrok", real_ngrok_url, databases, genes_per_db,
            iterations=args.query_iters,
            inter_request_delay=1.5,
        )
        for db_name, stats in ngrok_results.items():
            rate = stats["success_rate"]
            print(f"  {db_name:15s}  avg={stats['avg_ms']:>8.2f} ms  success={rate}%")
            if rate < 100 and stats.get("top_error"):
                print(f"    -> most common error: {stats['top_error']}")
    elif args.ngrok_url:
        print("\n[4] ngrok benchmark skipped  (placeholder URL — start ngrok and use the real URL)")
    else:
        print("\n[4] ngrok benchmark skipped  (pass --ngrok-url to enable)")

    # ------------------------------------------------------------------
    # 5a. Legacy BAR eFP Browser CGI benchmark (the correct legacy comparison)
    # ------------------------------------------------------------------
    legacy_cgi_results: Dict[str, Any] = {}
    if not args.skip_bar:
        print("\n[5a] Legacy BAR eFP Browser CGI  (per-database URLs in BAR_LEGACY_CGI_VIEWS)")
        print("     (full HTML page render — this is what gave 1000-2000 ms originally)")
        legacy_cgi_results = benchmark_legacy_efp_cgi(
            databases, genes_per_db, iterations=args.query_iters
        )
        for db_name, stats in legacy_cgi_results.items():
            rate = stats["success_rate"]
            print(f"  {db_name:15s}  avg={stats['avg_ms']:>8.2f} ms  success={rate}%")
            if rate < 100 and stats.get("top_error"):
                print(f"    -> most common error: {stats['top_error']}")
    else:
        print("\n[5a] Legacy CGI benchmark skipped  (--skip-bar)")

    # ------------------------------------------------------------------
    # 3b. Verify local values vs BAR production
    # ------------------------------------------------------------------
    verify_values_vs_bar(args.local_url, genes_per_db, n_genes=3)

    # ------------------------------------------------------------------
    # 6. Plots
    # ------------------------------------------------------------------
    print("\n[6] Generating plots ...")
    plot_model_generation(gen_results)
    plot_memory(mem_results)
    plot_query_times(local_results, ngrok_results, legacy_cgi_results, databases)
    plot_query_distributions(local_results, ngrok_results, legacy_cgi_results, databases)

    # ------------------------------------------------------------------
    # 7. Summary
    # ------------------------------------------------------------------
    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print(f"  Model count       : {gen_results['model_count']}")
    print(f"  Flat-file avg     : {flat_d['avg_ms']:.3f} ms / full iteration")
    print(f"  Dynamic avg       : {dynamic_d['avg_ms']:.3f} ms / full iteration")
    print(f"  Flat heap         : {mem_results['flat_heap_kb']:.1f} KB")
    print(f"  Dynamic heap      : {mem_results['dynamic_heap_kb']:.1f} KB")
    print()
    for db_name in databases:
        local_stats = local_results.get(db_name, {})
        local_ms = local_stats.get("avg_ms", 0)
        local_rate = local_stats.get("success_rate", 0)
        ngrok_ms = ngrok_results.get(db_name, {}).get("avg_ms", 0)
        ngrok_rate = ngrok_results.get(db_name, {}).get("success_rate", 0)
        cgi_ms = legacy_cgi_results.get(db_name, {}).get("avg_ms", 0)
        cgi_rate = legacy_cgi_results.get(db_name, {}).get("success_rate", 0)
        print(f"  {db_name}:")
        print(f"    Local API       : {local_ms:>8.2f} ms  (success={local_rate}%)")
        if ngrok_ms:
            print(f"    ngrok (internet): {ngrok_ms:>8.2f} ms  (success={ngrok_rate}%  "
                  f"+{ngrok_ms - local_ms:.2f} ms latency overhead)")
        if cgi_ms:
            speedup = cgi_ms / max(local_ms, 0.01)
            print(f"    Legacy CGI      : {cgi_ms:>8.2f} ms  (success={cgi_rate}%  "
                  f"local is {speedup:.1f}x faster)")
    print()
    print(f"  Plots saved to: {RESULTS_DIR}/")


if __name__ == "__main__":
    main()
