#!/usr/bin/env python3
"""
Proofread EFP expression values — two modes:

  Mode A (dump): Compare every sample/value in the SQL dump against the local API.
    Covers: embryo, klepikova, soybean (full Feb 6 2025 dumps)
    Checks: exact signal values match between dump and API (tolerance ±1e-4)

  Mode B (XML):  Use the BAR eFP Browser XML file for a view to get the canonical
    list of sample IDs, then verify the local API returns non-null values for each.
    URL pattern: https://bar.utoronto.ca/efp/data/<View_Name>.xml
    Covers: every view in the Arabidopsis (and other species) eFP Browser
    Checks: all expected sample IDs exist in the API response for a given gene

Note: No SQLite used. All local queries go through the BAR API HTTP endpoint.

Usage — Mode A (dump-based):
    python scripts/proofread_efp_values.py
    python scripts/proofread_efp_values.py --databases embryo,klepikova
    python scripts/proofread_efp_values.py --genes AT1G01010,AT1G01020
    python scripts/proofread_efp_values.py --all-genes --skip-cgi

Usage — Mode B (XML-based):
    python scripts/proofread_efp_values.py --view Embryo --gene AT1G01010
    python scripts/proofread_efp_values.py --view Guard_Cell --gene AT1G01010
    python scripts/proofread_efp_values.py --view Klepikova_Atlas --gene AT1G01010
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any, Dict, List, Optional

import requests

# ---------------------------------------------------------------------------
# Repository layout
# ---------------------------------------------------------------------------
REPO_ROOT = Path(__file__).resolve().parents[1]
ARCHIVE_DIR = REPO_ROOT / "api" / "Archive"

# ---------------------------------------------------------------------------
# Dump files — full Vincent dumps from Feb 6 2025
# ---------------------------------------------------------------------------
DUMP_FILES: Dict[str, Path] = {
    "embryo": ARCHIVE_DIR / "embryo_efp_feb_6_2025_dump.sql",
    "klepikova": ARCHIVE_DIR / "klepikova_efp_feb_6_2025_dump.sql",
    "soybean": ARCHIVE_DIR / "soybean_efp_feb_6_2025_dump.sql",
}

# 0-indexed column positions inside each INSERT tuple after splitting on ','
#
#  embryo:    ('proj_id', sample_id, 'data_probeset_id', data_signal, 'data_bot_id')
#  klepikova: ('proj_id', sample_id, 'data_probeset_id', data_signal, 'data_bot_id', NULL)
#  soybean:   (proj_id, 'proj_id2', 'filename', 'data_probeset_id', data_signal,
#              'data_call', data_p_val, 'data_bot_id')
COLUMN_MAP: Dict[str, Dict[str, int]] = {
    "embryo": {"probeset": 2, "signal": 3, "bot": 4, "min_cols": 5},
    "klepikova": {"probeset": 2, "signal": 3, "bot": 4, "min_cols": 5},
    "soybean": {"probeset": 3, "signal": 4, "bot": 7, "min_cols": 8},
}

BAR_CGI_URL = "https://bar.utoronto.ca/eplant/cgi-bin/plantefp.cgi"
BAR_EFP_DATA = "https://bar.utoronto.ca/efp/data"  # XML directory

# ---------------------------------------------------------------------------
# View → database name mapping
# Structure: {species_label: {xml_view_name: db_name}}
# Source: BAR eFP Browser <view db="..."> attributes, Feb 2025
# Note: some view names repeat across species (e.g. Developmental_Atlas in
#       cacao_ccn vs cacao_sca) — always qualify with species when ambiguous.
# ---------------------------------------------------------------------------
VIEW_DB_BY_SPECIES: Dict[str, Dict[str, str]] = {
    "actinidia": {
        "Bud_Development": "actinidia_bud_development",
        "Flower_Fruit_Development": "actinidia_flower_fruit_development",
        "Postharvest": "actinidia_postharvest",
        "Vegetative_Growth": "actinidia_vegetative_growth",
    },
    "arabidopsis": {
        "Abiotic_Stress": "atgenexp_stress",
        "Abiotic_Stress_II": "atgenexp_stress",
        "Biotic_Stress": "atgenexp_pathogen",
        "Biotic_Stress_II": "atgenexp_pathogen",
        "Chemical": "atgenexp_hormone",
        "DNA_Damage": "dna_damage",
        "Development_RMA": "atgenexp",
        "Developmental_Map": "atgenexp_plus",
        "Developmental_Mutants": "atgenexp_plus",
        "Embryo": "embryo",
        "Germination": "germination",
        "Guard_Cell": "guard_cell",
        "Gynoecium": "gynoecium",
        "Hormone": "atgenexp_hormone",
        "Klepikova_Atlas": "klepikova",
        "Lateral_Root_Initiation": "lateral_root_initiation",
        "Light_Series": "light_series",
        "Natural_Variation": "arabidopsis_ecotypes",
        "Regeneration": "meristem_db",
        "Root": "root",
        "Root_II": "root",
        "Seed": "seed_db",
        "Shoot_Apex": "shoot_apex",
        "Silique": "silique",
        "Single_Cell": "single_cell",
        "Tissue_Specific": "atgenexp_plus",
    },
    "arabidopsis seedcoat": {
        "Seed_Coat": "seedcoat",
    },
    "arachis": {
        "Arachis_Atlas": "arachis",
    },
    "barley": {
        "barley_mas": "barley_mas",
        "barley_rma": "barley_rma",
    },
    "brachypodium": {
        "Brachypodium_Atlas": "brachypodium",
        "Brachypodium_Grains": "brachypodium_grains",
        "Brachypodium_Spikes": "brachypodium_Bd21",
        "Photo_Thermocycle": "brachypodium_photo_thermocycle",
    },
    "brassica rapa": {
        "Embryogenesis": "brassica_rapa",
    },
    "cacao ccn": {
        "Developmental_Atlas": "cacao_developmental_atlas",
        "Drought_Diurnal_Atlas": "cacao_drought_diurnal_atlas",
    },
    "cacao sca": {
        "Developmental_Atlas": "cacao_developmental_atlas_sca",
        "Drought_Diurnal_Atlas": "cacao_drought_diurnal_atlas_sca",
        "Meristem_Atlas": "cacao_meristem_atlas_sca",
        "Seed_Atlas": "cacao_seed_atlas_sca",
    },
    "cacao tc": {
        "Cacao_Infection": "cacao_infection",
        "Cacao_Leaf": "cacao_leaf",
    },
    "camelina": {
        "Developmental_Atlas_FPKM": "camelina",
        "Developmental_Atlas_TPM": "camelina_tpm",
    },
    "cannabis": {
        "Cannabis_Atlas": "cannabis",
    },
    "canola": {
        "Canola_Seed": "canola_seed",
    },
    "eutrema": {
        "Eutrema": "thellungiella_db",
    },
    "grape": {
        "grape_developmental": "grape_developmental",
    },
    "kalanchoe": {
        "Light_Response": "kalanchoe",
    },
    "little millet": {
        "Life_Cycle": "little_millet",
    },
    "lupin": {
        "LCM_Leaf": "lupin_lcm_leaf",
        "LCM_Pod": "lupin_lcm_pod",
        "LCM_Stem": "lupin_lcm_stem",
        "Whole_Plant": "lupin_whole_plant",
    },
    "maize": {
        "Downs_et_al_Atlas": "maize_gdowns",
        "Early_Seed": "maize_early_seed",
        "Embryonic_Leaf_Development": "maize_embryonic_leaf_development",
        "Hoopes_et_al_Atlas": "maize_buell_lab",
        "Hoopes_et_al_Stress": "maize_buell_lab",
        "Maize_Kernel": "maize_early_seed",
        "Maize_Root": "maize_root",
        "Sekhon_et_al_Atlas": "maize_RMA_linear",
        "Tassel_and_Ear_Primordia": "maize_ears",
        "maize_iplant": "maize_iplant",
        "maize_leaf_gradient": "maize_leaf_gradient",
        "maize_rice_comparison": "maize_rice_comparison",
    },
    "mangosteen": {
        "Aril_vs_Rind": "mangosteen_aril_vs_rind",
        "Callus": "mangosteen_callus",
        "Diseased_vs_Normal": "mangosteen_diseased_vs_normal",
        "Fruit_Ripening": "mangosteen_fruit_ripening",
        "Seed_Development": "mangosteen_seed_development",
        "Seed_Germination": "mangosteen_seed_germination",
    },
    "medicago": {
        "medicago_mas": "medicago_mas",
        "medicago_rma": "medicago_rma",
        "medicago_seed": "medicago_seed",
    },
    "poplar": {
        "Poplar": "poplar",
        "PoplarTreatment": "poplar",
    },
    "potato": {
        "Potato_Developmental": "potato_dev",
        "Potato_Stress": "potato_stress",
    },
    "rice": {
        "rice_drought_heat_stress": "rice_drought_heat_stress",
        "rice_leaf_gradient": "rice_leaf_gradient",
        "rice_maize_comparison": "rice_maize_comparison",
        "rice_mas": "rice_mas",
        "rice_rma": "rice_rma",
        "riceanoxia_mas": "rice_mas",
        "riceanoxia_rma": "rice_rma",
        "ricestigma_mas": "rice_mas",
        "ricestigma_rma": "rice_rma",
        "ricestress_mas": "rice_mas",
        "ricestress_rma": "rice_rma",
    },
    "soybean": {
        "soybean": "soybean",
        "soybean_embryonic_development": "soybean_embryonic_development",
        "soybean_heart_cotyledon_globular": "soybean_heart_cotyledon_globular",
        "soybean_senescence": "soybean_senescence",
        "soybean_severin": "soybean_severin",
    },
    "strawberry": {
        "Developmental_Map_Strawberry_Flower_and_Fruit": "strawberry",
        "Strawberry_Green_vs_White_Stage": "strawberry",
    },
    "tomato": {
        "ILs_Leaf_Chitwood_et_al": "tomato_ils",
        "ILs_Root_Tip_Brady_Lab": "tomato_ils2",
        "M82_S_pennellii_Atlases_Koenig_et_al": "tomato_s_pennellii",
        "Rose_Lab_Atlas": "tomato",
        "Rose_Lab_Atlas_Renormalized": "tomato_renormalized",
        "SEED_Lab_Angers": "tomato_seed",
        "Shade_Mutants": "tomato_shade_mutants",
        "Shade_Timecourse_WT": "tomato_shade_timecourse",
        "Tomato_Meristem": "tomato_meristem",
    },
    "triticale": {
        "triticale": "triticale",
        "triticale_mas": "triticale_mas",
    },
    "wheat": {
        "Developmental_Atlas": "wheat",
        "Wheat_Abiotic_Stress": "wheat_abiotic_stress",
        "Wheat_Embryogenesis": "wheat_embryogenesis",
        "Wheat_Meiosis": "wheat_meiosis",
    },
}

# Flat lookup: view_name → db_name (first match wins; ambiguous names are noted below)
# Ambiguous view names (appear in multiple species with different dbs):
#   "Developmental_Atlas" → cacao_developmental_atlas OR cacao_developmental_atlas_sca OR wheat
#   "Drought_Diurnal_Atlas" → cacao_drought_diurnal_atlas OR cacao_drought_diurnal_atlas_sca
# For these, always use --species to disambiguate.
VIEW_TO_DB: Dict[str, str] = {}
_AMBIGUOUS_VIEWS: Dict[str, List[str]] = {}
for _, _views in VIEW_DB_BY_SPECIES.items():
    for _vname, _dbname in _views.items():
        if _vname in VIEW_TO_DB and VIEW_TO_DB[_vname] != _dbname:
            _AMBIGUOUS_VIEWS.setdefault(_vname, [VIEW_TO_DB[_vname]]).append(_dbname)
        else:
            VIEW_TO_DB[_vname] = _dbname

# Default genes per database (Mode A)
DEFAULT_GENES: Dict[str, List[str]] = {
    "embryo": ["AT1G01010", "AT1G01020", "AT1G01030", "AT1G01040", "AT1G01050"],
    "klepikova": ["AT1G01010", "AT1G01020", "AT1G01030", "AT1G01040", "AT1G01050"],
    "soybean": ["Glyma0021s00200", "Glyma0021s00420", "Glyma0021s00460"],
}


# ===========================================================================
# Shared helpers
# ===========================================================================


def _parse_fields(raw: str) -> List[str]:
    """Split a raw SQL tuple on ',' and strip surrounding quotes from each field."""
    return [f.strip().strip("'\"") for f in raw.split(",")]


def query_local_api(base_url: str, db_name: str, gene_id: str) -> Dict[str, Any]:
    """GET /gene_expression/expression/{db_name}/{gene_id} from the local BAR API.

    :param base_url: Root URL of the running BAR API.
    :param db_name: EFP database name.
    :param gene_id: Gene / probeset identifier.
    :return: Parsed JSON response, or error dict on failure.
    """
    url = f"{base_url}/gene_expression/expression/{db_name}/{gene_id}"
    try:
        resp = requests.get(url, timeout=15)
        return resp.json()
    except Exception as exc:
        return {"success": False, "error": str(exc), "data": []}


def query_bar_cgi(db_name: str, gene_id: str, samples: List[str]) -> List[Dict[str, Any]]:
    """Check sample existence on the BAR production plantefp.cgi for up to 50 samples.

    :param db_name: EFP database name.
    :param gene_id: Gene identifier.
    :param samples: Sample IDs (data_bot_id values) to check.
    :return: List of {name, value} dicts from the CGI.
    """
    if not samples:
        return []
    params = {
        "datasource": db_name,
        "id": gene_id,
        "format": "json",
        "samples": json.dumps(samples[:50]),
    }
    try:
        resp = requests.get(BAR_CGI_URL, params=params, timeout=20)
        data = resp.json()
        return data if isinstance(data, list) else []
    except Exception:
        return []


# ===========================================================================
# Mode A — SQL dump parsing
# ===========================================================================


def extract_all_genes(db_name: str) -> List[str]:
    """Return all unique gene/probeset IDs found in the dump's sample_data table.

    :param db_name: One of 'embryo', 'klepikova', 'soybean'.
    :return: Sorted list of unique gene IDs.
    """
    dump_path = DUMP_FILES.get(db_name)
    if not dump_path or not dump_path.exists():
        return []

    col = COLUMN_MAP[db_name]
    p_idx, min_cols = col["probeset"], col["min_cols"]
    genes: set[str] = set()

    with open(dump_path, "r", errors="replace") as fh:
        for line in fh:
            if "INSERT INTO `sample_data`" not in line:
                continue
            for m in re.finditer(r"\(([^)]+)\)", line):
                fields = _parse_fields(m.group(1))
                if len(fields) >= min_cols:
                    gene = fields[p_idx]
                    if gene:
                        genes.add(gene)

    return sorted(genes)


def parse_dump_for_gene(db_name: str, gene_id: str) -> Dict[str, float]:
    """Extract all {sample_id: signal_value} pairs for one gene from the dump.

    Reads the entire dump file but only retains rows where the probeset column
    matches ``gene_id`` exactly (case-sensitive, as stored in the dump).

    :param db_name: Database name (must be in COLUMN_MAP).
    :param gene_id: Exact gene / probeset identifier as it appears in the dump.
    :return: Dict mapping sample_id -> float(signal_value).
    """
    dump_path = DUMP_FILES.get(db_name)
    if not dump_path or not dump_path.exists():
        return {}

    col = COLUMN_MAP[db_name]
    p_idx = col["probeset"]
    s_idx = col["signal"]
    b_idx = col["bot"]
    min_c = col["min_cols"]
    values: Dict[str, float] = {}

    with open(dump_path, "r", errors="replace") as fh:
        for line in fh:
            if "INSERT INTO `sample_data`" not in line:
                continue
            if gene_id not in line:  # fast pre-filter
                continue
            for m in re.finditer(r"\(([^)]+)\)", line):
                fields = _parse_fields(m.group(1))
                if len(fields) < min_c:
                    continue
                if fields[p_idx] != gene_id:
                    continue
                try:
                    signal = float(fields[s_idx])
                except ValueError:
                    continue
                bot_id = fields[b_idx]
                if bot_id:
                    values[bot_id] = signal

    return values


def compare_dump_vs_api(
    dump_values: Dict[str, float],
    api_data: List[Dict[str, str]],
    tolerance: float = 1e-4,
) -> Dict[str, Any]:
    """Compare dump signal values against API response values, sample by sample.

    :param dump_values: {sample_id: float(signal)} from the SQL dump.
    :param api_data: List of {"name": sample_id, "value": str(signal)} from the API.
    :param tolerance: Absolute tolerance for floating-point comparison.
    :return: Comparison summary dict.
    """
    api_lookup: Dict[str, float] = {}
    for entry in api_data:
        try:
            api_lookup[entry["name"]] = float(entry["value"])
        except (KeyError, ValueError, TypeError):
            continue

    matches: int = 0
    mismatches: List[Dict[str, Any]] = []
    missing_in_api: List[str] = []
    extra_in_api: List[str] = []

    for sample in sorted(dump_values):
        dump_val = dump_values[sample]
        if sample in api_lookup:
            api_val = api_lookup[sample]
            if abs(dump_val - api_val) <= tolerance:
                matches += 1
            else:
                mismatches.append(
                    {
                        "sample": sample,
                        "dump": dump_val,
                        "api": api_val,
                        "abs_diff": round(abs(dump_val - api_val), 8),
                        "rel_diff_%": round(abs(dump_val - api_val) / max(abs(dump_val), 1e-12) * 100, 4),
                    }
                )
        else:
            missing_in_api.append(sample)

    for sample in sorted(api_lookup):
        if sample not in dump_values:
            extra_in_api.append(sample)

    status = "OK" if not mismatches and not missing_in_api else "MISMATCH" if mismatches else "MISSING"
    return {
        "dump_sample_count": len(dump_values),
        "api_sample_count": len(api_lookup),
        "matches": matches,
        "mismatches": mismatches,
        "missing_in_api": missing_in_api,
        "extra_in_api": extra_in_api,
        "status": status,
    }


def proofread_gene_dump(
    base_url: str,
    db_name: str,
    gene_id: str,
    check_cgi: bool = True,
    verbose: bool = True,
) -> Dict[str, Any]:
    """Proofread one gene: dump → API value comparison.

    :param base_url: Root URL of the local BAR API.
    :param db_name: EFP database name.
    :param gene_id: Gene / probeset identifier.
    :param check_cgi: If True, cross-check sample existence with BAR CGI.
    :param verbose: If True, print detailed per-sample output.
    :return: Summary dict.
    """
    if verbose:
        print(f"\n  Gene: {gene_id}")
        print(f"  {'─' * 52}")

    dump_values = parse_dump_for_gene(db_name, gene_id)
    if not dump_values:
        if verbose:
            print(f"    [SKIP] No rows in dump for {gene_id}")
        return {"gene_id": gene_id, "status": "SKIP", "reason": "no dump data"}

    if verbose:
        print(f"    Dump records: {len(dump_values)}")
        for sample, val in sorted(dump_values.items())[:5]:
            print(f"      dump: {sample:<34s} = {val}")
        if len(dump_values) > 5:
            print(f"      ... and {len(dump_values) - 5} more")

    api_result = query_local_api(base_url, db_name, gene_id)
    if not api_result.get("success"):
        err = api_result.get("error", "unknown error")
        if verbose:
            print(f"    [API FAIL] {err}")
        return {"gene_id": gene_id, "status": "API_FAIL", "error": err, "dump_samples": len(dump_values)}

    api_data = api_result.get("data", [])
    if verbose:
        print(f"    API records:  {len(api_data)}")
        for entry in api_data[:5]:
            print(f"      api:  {entry['name']:<34s} = {entry['value']}")
        if len(api_data) > 5:
            print(f"      ... and {len(api_data) - 5} more")

    cmp = compare_dump_vs_api(dump_values, api_data)

    if verbose:
        if cmp["status"] == "OK":
            print(f"\n    [OK] {cmp['matches']}/{cmp['dump_sample_count']} samples match " f"(±1e-4)")
        elif cmp["mismatches"]:
            print(f"\n    [MISMATCH] {len(cmp['mismatches'])} differences (showing ≤10):")
            for m in cmp["mismatches"][:10]:
                print(
                    f"      {m['sample']:<34s}  dump={m['dump']:<14}  "
                    f"api={m['api']:<14}  diff={m['abs_diff']}  "
                    f"({m['rel_diff_%']}%)"
                )
        if cmp["missing_in_api"]:
            print(f"    [MISSING] {len(cmp['missing_in_api'])} dump samples absent from API:")
            for s in cmp["missing_in_api"][:5]:
                print(f"      {s}")
            if len(cmp["missing_in_api"]) > 5:
                print(f"      ... and {len(cmp['missing_in_api']) - 5} more")
        if cmp["extra_in_api"]:
            print(f"    [EXTRA] {len(cmp['extra_in_api'])} API samples not in dump")

    cgi_summary: Optional[Dict[str, Any]] = None
    if check_cgi:
        samples_to_check = sorted(dump_values.keys())[:50]
        cgi_data = query_bar_cgi(db_name, gene_id, samples_to_check)
        if cgi_data:
            confirmed = [d["name"] for d in cgi_data if d.get("value") is not None]
            not_found = [d["name"] for d in cgi_data if d.get("value") is None]
            cgi_summary = {
                "checked": len(cgi_data),
                "confirmed": len(confirmed),
                "not_found": len(not_found),
                "not_found_samples": not_found[:10],
            }
            if verbose:
                print(f"    BAR CGI: {len(confirmed)}/{len(cgi_data)} samples confirmed")
                if not_found:
                    print(f"      Not on BAR: {not_found[:5]}")
        else:
            cgi_summary = {"checked": 0, "confirmed": 0, "not_found": 0}
            if verbose:
                print("    BAR CGI: no response")

    return {
        "gene_id": gene_id,
        "status": cmp["status"],
        "dump_samples": cmp["dump_sample_count"],
        "api_samples": cmp["api_sample_count"],
        "matches": cmp["matches"],
        "mismatch_count": len(cmp["mismatches"]),
        "mismatches": cmp["mismatches"][:20],
        "missing_in_api": cmp["missing_in_api"][:20],
        "extra_in_api": cmp["extra_in_api"][:20],
        "cgi": cgi_summary,
    }


def run_mode_a(
    base_url: str,
    databases: List[str],
    genes_override: Optional[List[str]],
    all_genes: bool,
    max_genes: int,
    check_cgi: bool,
    verbose: bool,
) -> Dict[str, List[Dict[str, Any]]]:
    """Mode A: proofread using SQL dump files as ground truth.

    :return: Dict mapping db_name -> list of per-gene result dicts.
    """
    all_results: Dict[str, List[Dict[str, Any]]] = {}

    for db_name in databases:
        if db_name not in DUMP_FILES:
            print(f"\n[SKIP] No dump configured for '{db_name}'")
            continue

        if genes_override:
            genes = genes_override
        elif all_genes:
            genes = extract_all_genes(db_name)
            print(f"\n  {db_name}: found {len(genes)} unique genes in dump")
        else:
            genes = DEFAULT_GENES.get(db_name, ["AT1G01010"])[:max_genes]

        dump_path = DUMP_FILES[db_name]
        print(f"\n{'=' * 66}")
        print(f"  DATABASE : {db_name}")
        print(f"  Dump     : {dump_path}")
        print(f"  Genes    : {len(genes)}")
        print(f"{'=' * 66}")

        if not dump_path.exists():
            print("  [ERROR] Dump file not found.")
            continue

        gene_results: List[Dict[str, Any]] = []
        for gene_id in genes:
            result = proofread_gene_dump(base_url, db_name, gene_id, check_cgi=check_cgi, verbose=verbose)
            gene_results.append(result)

        statuses = [r["status"] for r in gene_results]
        print(f"\n  ── {db_name} summary ──")
        print(
            f"     OK={statuses.count('OK')}  MISMATCH={statuses.count('MISMATCH')}  "
            f"MISSING={statuses.count('MISSING')}  "
            f"API_FAIL={statuses.count('API_FAIL')}  SKIP={statuses.count('SKIP')}"
        )
        all_results[db_name] = gene_results

    return all_results


# ===========================================================================
# Mode B — XML-based sample verification
# ===========================================================================


def fetch_efp_xml(view_name: str) -> Optional[str]:
    """Download the eFP Browser XML file for a given view name.

    Naming convention: spaces → underscores, append ".xml".
    URL: https://bar.utoronto.ca/efp/data/<View_Name>.xml

    :param view_name: eFP Browser view name (e.g., "Embryo", "Guard_Cell").
    :return: XML content as a string, or None if download fails.
    """
    # normalise: replace spaces with underscores
    xml_name = view_name.replace(" ", "_") + ".xml"
    url = f"{BAR_EFP_DATA}/{xml_name}"
    try:
        resp = requests.get(
            url,
            timeout=20,
            headers={"User-Agent": "Mozilla/5.0"},
        )
        if resp.status_code == 200:
            return resp.text
        print(f"  [WARN] HTTP {resp.status_code} fetching {url}")
        return None
    except Exception as exc:
        print(f"  [WARN] Could not fetch {url}: {exc}")
        return None


def parse_efp_xml(xml_content: str) -> Dict[str, Any]:
    """Parse a BAR eFP Browser XML file and extract the DB name and tissue→sample map.

    XML structure (key elements):
      <view db="embryo">
        <group name="Med_CTRL">
          <control sample="Med_CTRL"/>
          <tissue name="Bent cotyledon">
            <sample name="bc_1"/>
            <sample name="bc_2"/>
          </tissue>
        </group>
      </view>

    :param xml_content: Raw XML string.
    :return: Dict with keys:
        - 'db'       : str  — database name (e.g., "embryo")
        - 'tissues'  : list of {name, samples, controls} dicts
        - 'all_samples' : sorted list of all unique sample IDs
        - 'controls' : sorted list of all unique control sample IDs
    """
    try:
        root = ET.fromstring(xml_content)
    except ET.ParseError as exc:
        print(f"  [ERROR] XML parse error: {exc}")
        return {}

    # Find the first <view> element — it holds the db attribute
    view_elem = root.find(".//view")
    if view_elem is None:
        print("  [ERROR] No <view> element found in XML")
        return {}

    db_name = view_elem.get("db", "")
    if not db_name:
        print("  [ERROR] <view> element has no 'db' attribute")
        return {}

    tissues: List[Dict[str, Any]] = []
    all_samples: set[str] = set()
    all_controls: set[str] = set()

    for group_elem in view_elem.findall(".//group"):
        # collect controls in this group
        group_controls = [ctrl.get("sample", "") for ctrl in group_elem.findall("control") if ctrl.get("sample")]
        all_controls.update(group_controls)

        for tissue_elem in group_elem.findall("tissue"):
            tissue_name = tissue_elem.get("name", "")
            tissue_samples = [s.get("name", "") for s in tissue_elem.findall("sample") if s.get("name")]
            all_samples.update(tissue_samples)
            tissues.append(
                {
                    "name": tissue_name,
                    "samples": tissue_samples,
                    "controls": group_controls,
                }
            )

    return {
        "db": db_name,
        "tissues": tissues,
        "all_samples": sorted(all_samples),
        "controls": sorted(all_controls),
    }


def resolve_db_for_view(view_name: str, species: Optional[str] = None) -> Optional[str]:
    """Resolve the database name for a given view, using the mapping.

    :param view_name: eFP Browser view name (e.g. "Embryo", "Guard_Cell").
    :param species: Species label (e.g. "arabidopsis") to disambiguate if needed.
    :return: Database name, or None if not found.
    """
    if species:
        sp_views = VIEW_DB_BY_SPECIES.get(species.lower(), {})
        db = sp_views.get(view_name)
        if db:
            return db

    # flat lookup (warns if ambiguous)
    db = VIEW_TO_DB.get(view_name)
    if db:
        if view_name in _AMBIGUOUS_VIEWS:
            print(
                f"  [WARN] '{view_name}' maps to multiple DBs: "
                f"{_AMBIGUOUS_VIEWS[view_name] + [db]}. "
                f"Using first match '{db}'. Pass --species to disambiguate."
            )
        return db

    return None


def proofread_from_xml(
    base_url: str,
    view_name: str,
    gene_id: str,
    species: Optional[str] = None,
    check_cgi: bool = True,
    verbose: bool = True,
) -> Dict[str, Any]:
    """Mode B: verify that a gene has expression values for every sample in the XML.

    Checks *completeness* — every tissue sample listed in the view XML
    should be present in the API response for the given gene, with a numeric value.

    The database name is resolved from VIEW_DB_BY_SPECIES first (offline, fast),
    falling back to the ``db`` attribute in the fetched XML.

    :param base_url: Root URL of the local BAR API.
    :param view_name: eFP Browser view name (e.g. "Embryo", "Guard_Cell").
    :param gene_id: Gene / probeset identifier to query.
    :param species: Species label for disambiguation (e.g. "arabidopsis").
    :param check_cgi: If True, cross-check with BAR production CGI.
    :param verbose: If True, print detailed output.
    :return: Summary dict.
    """
    print(f"\n{'=' * 66}")
    print(f"  VIEW     : {view_name}")
    print(f"  Gene     : {gene_id}")
    print(f"{'=' * 66}")

    # Step 1 — resolve db name (offline lookup first, then XML attribute)
    db_name_from_map = resolve_db_for_view(view_name, species)

    xml_content = fetch_efp_xml(view_name)
    if not xml_content:
        if not db_name_from_map:
            return {"status": "XML_FAIL", "view": view_name, "gene_id": gene_id}
        # we have a db name from the map but no XML — can't get sample IDs
        print(
            f"  [WARN] Could not fetch XML; db='{db_name_from_map}' from mapping "
            f"but sample list unavailable. Skipping."
        )
        return {"status": "XML_FAIL", "view": view_name, "gene_id": gene_id, "db": db_name_from_map}

    xml_data = parse_efp_xml(xml_content)
    if not xml_data:
        return {"status": "XML_PARSE_FAIL", "view": view_name, "gene_id": gene_id}

    # prefer mapping (already verified), fall back to XML attribute
    db_name = db_name_from_map or xml_data.get("db", "")
    if not db_name:
        print(f"  [ERROR] Could not determine db name for view '{view_name}'")
        return {"status": "NO_DB", "view": view_name, "gene_id": gene_id}

    if db_name_from_map and xml_data.get("db") and db_name_from_map != xml_data["db"]:
        print(
            f"  [WARN] Mapping says db='{db_name_from_map}' but XML says "
            f"db='{xml_data['db']}'. Using mapping value."
        )

    expected_sids = xml_data["all_samples"]  # data_bot_id values from XML
    tissues = xml_data["tissues"]

    print(f"  DB (from XML): {db_name}")
    print(f"  Tissues      : {len(tissues)}")
    print(f"  Expected samples in DB: {len(expected_sids)}")
    if verbose and expected_sids:
        preview = expected_sids[:8]
        print(f"  Sample IDs (first {len(preview)}): {preview}")
        if len(expected_sids) > len(preview):
            print(f"    ... and {len(expected_sids) - len(preview)} more")

    # Step 2 — query local API
    api_result = query_local_api(base_url, db_name, gene_id)
    if not api_result.get("success"):
        err = api_result.get("error", "unknown error")
        if verbose:
            print(f"\n  [API FAIL] {err}")
        return {
            "status": "API_FAIL",
            "view": view_name,
            "db": db_name,
            "gene_id": gene_id,
            "error": err,
            "expected_samples": len(expected_sids),
        }

    api_data = api_result.get("data", [])
    api_lookup: Dict[str, Optional[float]] = {}
    for entry in api_data:
        try:
            api_lookup[entry["name"]] = float(entry["value"])
        except (KeyError, ValueError, TypeError):
            api_lookup[entry.get("name", "")] = None

    if verbose:
        print(f"  API records : {len(api_data)}")

    # Step 3 — compare expected samples vs API response
    present: List[str] = []
    missing: List[str] = []
    null_val: List[str] = []

    for sid in expected_sids:
        if sid in api_lookup:
            if api_lookup[sid] is not None:
                present.append(sid)
            else:
                null_val.append(sid)
        else:
            missing.append(sid)

    extra_in_api = [s for s in sorted(api_lookup) if s not in set(expected_sids)]

    # Per-tissue breakdown
    tissue_rows: List[Dict[str, Any]] = []
    for tissue in tissues:
        t_present = [s for s in tissue["samples"] if s in api_lookup and api_lookup[s] is not None]
        t_missing = [s for s in tissue["samples"] if s not in api_lookup]
        t_null = [s for s in tissue["samples"] if s in api_lookup and api_lookup[s] is None]
        tissue_rows.append(
            {
                "tissue": tissue["name"],
                "total": len(tissue["samples"]),
                "present": len(t_present),
                "missing": len(t_missing),
                "null": len(t_null),
                "ok": len(t_missing) == 0 and len(t_null) == 0,
                "samples_missing": t_missing,
            }
        )

    status = "OK" if not missing and not null_val else "MISSING" if missing else "NULL_VALUES"

    if verbose:
        print(f"\n  Results: {len(present)}/{len(expected_sids)} expected samples present " f"with valid values")
        if missing:
            print(f"  [MISSING] {len(missing)} expected sample IDs not in API response:")
            for s in missing[:10]:
                print(f"    {s}")
            if len(missing) > 10:
                print(f"    ... and {len(missing) - 10} more")
        if null_val:
            print(f"  [NULL] {len(null_val)} samples returned null/non-numeric value:")
            for s in null_val[:5]:
                print(f"    {s}")
        if extra_in_api:
            print(f"  [EXTRA] {len(extra_in_api)} API samples not in XML " f"(may be from other views / older data)")
        print(f"\n  Status: {status}")

        # Per-tissue table
        if tissues:
            print("\n  Per-tissue breakdown:")
            w = max(len(t["tissue"]) for t in tissue_rows)
            print(f"    {'Tissue':<{w}}  Total  Present  Missing  Null  OK?")
            print(f"    {'─' * w}  ─────  ───────  ───────  ────  ───")
            for row in tissue_rows:
                flag = "✓" if row["ok"] else "✗"
                print(
                    f"    {row['tissue']:<{w}}  {row['total']:5d}  "
                    f"{row['present']:7d}  {row['missing']:7d}  "
                    f"{row['null']:4d}  {flag}"
                )

    # Step 4 — BAR CGI cross-check on expected samples
    cgi_summary: Optional[Dict[str, Any]] = None
    if check_cgi and expected_sids:
        cgi_data = query_bar_cgi(db_name, gene_id, expected_sids[:50])
        if cgi_data:
            confirmed = [d["name"] for d in cgi_data if d.get("value") is not None]
            not_found = [d["name"] for d in cgi_data if d.get("value") is None]
            cgi_summary = {
                "checked": len(cgi_data),
                "confirmed": len(confirmed),
                "not_found": len(not_found),
                "not_found_samples": not_found[:10],
            }
            if verbose:
                print(f"\n  BAR CGI: {len(confirmed)}/{len(cgi_data)} samples confirmed on production")
                if not_found:
                    print(f"    Not found on BAR: {not_found[:5]}")
        else:
            cgi_summary = {"checked": 0, "confirmed": 0, "not_found": 0}
            if verbose:
                print("  BAR CGI: no response")

    return {
        "status": status,
        "view": view_name,
        "db": db_name,
        "gene_id": gene_id,
        "expected_samples": len(expected_sids),
        "present": len(present),
        "missing": len(missing),
        "null_values": len(null_val),
        "extra_in_api": len(extra_in_api),
        "tissue_rows": tissue_rows,
        "cgi": cgi_summary,
    }


# ===========================================================================
# Main
# ===========================================================================


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Proofread EFP expression values (dump or XML mode, no SQLite)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument(
        "--local-url",
        default="http://localhost:5000",
        help="Base URL of the local BAR API (default: http://localhost:5000)",
    )

    # Mode B (XML) arguments
    xml_grp = parser.add_argument_group("Mode B — XML-based (BAR eFP Browser view)")
    xml_grp.add_argument(
        "--view",
        default=None,
        help="eFP Browser view name (e.g. 'Embryo', 'Guard_Cell'). " "Activates XML mode for a single view.",
    )
    xml_grp.add_argument(
        "--all-views",
        action="store_true",
        help="Run XML mode for every view in VIEW_DB_BY_SPECIES " "(use with --species to restrict to one species).",
    )
    xml_grp.add_argument(
        "--species",
        default=None,
        help="Species label to disambiguate view names or restrict " "--all-views (e.g. 'arabidopsis', 'maize').",
    )
    xml_grp.add_argument("--gene", default="AT1G01010", help="Gene ID for XML mode (default: AT1G01010)")

    # Mode A (dump) arguments
    dump_grp = parser.add_argument_group("Mode A — dump-based (SQL dump files)")
    dump_grp.add_argument(
        "--databases", default=None, help="Comma-separated databases to check " "(default: embryo, klepikova, soybean)"
    )
    dump_grp.add_argument("--genes", default=None, help="Comma-separated gene IDs (overrides --max-genes)")
    dump_grp.add_argument("--all-genes", action="store_true", help="Check every gene found in each dump (can be slow)")
    dump_grp.add_argument("--max-genes", type=int, default=5, help="Max genes per database in dump mode (default: 5)")

    # Shared arguments
    parser.add_argument("--skip-cgi", action="store_true", help="Skip BAR production CGI cross-check")
    parser.add_argument("--quiet", action="store_true", help="Print summaries only, not per-sample detail")
    args = parser.parse_args()

    verbose = not args.quiet

    # -----------------------------------------------------------------------
    # Mode B: XML view proofreading
    # -----------------------------------------------------------------------
    if args.view or args.all_views:
        print("=" * 66)
        print("EFP PROOFREADER — Mode B (XML-based)")
        print(f"  Local API : {args.local_url}")
        print(f"  BAR CGI   : {BAR_CGI_URL}")
        print(f"  XML data  : {BAR_EFP_DATA}/")
        if args.species:
            print(f"  Species   : {args.species}")
        print("=" * 66)

        # Build the list of (view_name, species) pairs to check
        if args.all_views:
            if args.species:
                sp = args.species.lower()
                views_to_check = [
                    (v, sp)
                    for sp_key, vmap in VIEW_DB_BY_SPECIES.items()
                    if sp_key.lower() == sp or sp_key.lower().startswith(sp)
                    for v in vmap
                ]
                if not views_to_check:
                    print(f"  [ERROR] No views found for species '{args.species}'.")
                    print(f"  Available: {', '.join(VIEW_DB_BY_SPECIES.keys())}")
                    sys.exit(1)
            else:
                views_to_check = [(v, sp) for sp, vmap in VIEW_DB_BY_SPECIES.items() for v in vmap]
        else:
            views_to_check = [(args.view, args.species)]

        xml_results: List[Dict[str, Any]] = []
        for view_name, sp in views_to_check:
            r = proofread_from_xml(
                base_url=args.local_url,
                view_name=view_name,
                gene_id=args.gene,
                species=sp,
                check_cgi=not args.skip_cgi,
                verbose=verbose,
            )
            xml_results.append(r)

        print("\n" + "=" * 66)
        print("MODE B SUMMARY")
        print("=" * 66)
        all_pass = True
        print(f"  {'View':<48s}  {'DB':<36s}  Status")
        print(f"  {'─' * 48}  {'─' * 36}  ──────")
        for r in xml_results:
            status = r.get("status", "?")
            verdict = "PASS" if status == "OK" else "FAIL"
            if verdict != "PASS":
                all_pass = False
            present = r.get("present", "?")
            expected = r.get("expected_samples", "?")
            print(f"  {r.get('view', ''):<48s}  {r.get('db', ''):<36s}  " f"{verdict}  ({present}/{expected})")

        print(f"\n  Gene tested : {args.gene}")
        overall = "ALL PASS" if all_pass else "FAILURES FOUND"
        print(f"  Result      : {overall}")
        print("=" * 66)
        sys.exit(0 if all_pass else 1)

    # -----------------------------------------------------------------------
    # Mode A: dump-based proofreading
    # -----------------------------------------------------------------------
    if args.databases:
        databases = [d.strip() for d in args.databases.split(",")]
    else:
        databases = list(DUMP_FILES.keys())

    genes_override = [g.strip() for g in args.genes.split(",")] if args.genes else None

    print("=" * 66)
    print("EFP PROOFREADER — Mode A (SQL dump-based)")
    print(f"  Local API : {args.local_url}")
    print(f"  BAR CGI   : {BAR_CGI_URL}")
    print(f"  Databases : {', '.join(databases)}")
    print("=" * 66)

    all_results = run_mode_a(
        base_url=args.local_url,
        databases=databases,
        genes_override=genes_override,
        all_genes=args.all_genes,
        max_genes=args.max_genes,
        check_cgi=not args.skip_cgi,
        verbose=verbose,
    )

    # Final cross-database summary
    print("\n" + "=" * 66)
    print("FINAL SUMMARY")
    print("=" * 66)

    total_ok = total_mismatch = total_missing = total_fail = 0
    for db_name, results in all_results.items():
        ok = sum(1 for r in results if r["status"] == "OK")
        mis = sum(1 for r in results if r["status"] == "MISMATCH")
        miss = sum(1 for r in results if r["status"] == "MISSING")
        fail = sum(1 for r in results if r["status"] == "API_FAIL")
        total_ok += ok
        total_mismatch += mis
        total_missing += miss
        total_fail += fail

        verdict = "PASS" if mis == 0 and miss == 0 and fail == 0 else "FAIL"
        print(f"  {db_name:<15s}  {verdict}  " f"ok={ok}  mismatch={mis}  missing={miss}  api_fail={fail}")
        mismatch_genes = [r["gene_id"] for r in results if r["status"] == "MISMATCH"]
        if mismatch_genes:
            print(f"    Mismatched genes: {', '.join(mismatch_genes)}")

    print(f"\n  Totals  ok={total_ok}  mismatch={total_mismatch}  " f"missing={total_missing}  api_fail={total_fail}")
    overall = "ALL PASS" if (total_mismatch + total_missing + total_fail) == 0 else "FAILURES FOUND"
    print(f"\n  Result: {overall}")
    print("=" * 66)
    sys.exit(0 if overall == "ALL PASS" else 1)


if __name__ == "__main__":
    main()
