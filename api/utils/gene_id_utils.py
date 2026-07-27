"""
Reena Obmina | BCB330 Project 2025-2026 | University of Toronto

Gene identifier utilities: species detection, format validation, and probeset conversion.

Probeset IDs (Affymetrix chips) end in '_at', e.g.:
  261585_at               (Arabidopsis ATH1)
  AB004882_at             (Maize gdowns — GenBank accession probesets)
  PtpAffx.224570.1.S1_at  (Poplar)
  TU000001                (Tomato Rose Lab Atlas — Tomato Unigene chip, no _at suffix)

Note: not all non-_at IDs are gene IDs. Some databases (e.g. Tomato, Soybean) use gene-model
IDs as their primary key rather than Affymetrix probe IDs.

Only Arabidopsis AGI-to-probeset conversion is fully implemented.
All other species with pending lookup tables return an actionable error message.
"""

from __future__ import annotations

import re
from typing import Optional

from api.utils.bar_utils import BARUtils

# ---------------------------------------------------------------------------
# Probeset detection
# ---------------------------------------------------------------------------

# Most chips: ends in _at (e.g. 261585_at, PtpAffx.200227.1.S1_s_at)
# AROS chip:  A######_## format (e.g. A000011_01)
_PROBESET_RE = re.compile(r"^.+_at$", re.IGNORECASE)
_AROS_PROBESET_RE = re.compile(r"^A\d{6}_\d{2}$", re.IGNORECASE)


def is_probeset_id(gene_id: str) -> bool:
    """True if gene_id is already a probeset (ends in _at or is AROS format)."""
    return bool(_PROBESET_RE.match(gene_id) or _AROS_PROBESET_RE.match(gene_id))


# ---------------------------------------------------------------------------
# Database → species map
# ---------------------------------------------------------------------------

# fmt: off
DATABASE_SPECIES: dict[str, str] = {
    # Arabidopsis
    "affydb":                               "arabidopsis",
    "arabidopsis_ecotypes":                 "arabidopsis",
    "atgenexp":                             "arabidopsis",
    "atgenexp_hormone":                     "arabidopsis",
    "atgenexp_pathogen":                    "arabidopsis",
    "atgenexp_plus":                        "arabidopsis",
    "atgenexp_stress":                      "arabidopsis",
    "circadian_mutants":                    "arabidopsis",
    "dna_damage":                           "arabidopsis",
    "embryo":                               "arabidopsis",
    "gc_drought":                           "arabidopsis",
    "germination":                          "arabidopsis",
    "guard_cell":                           "arabidopsis",
    "gynoecium":                            "arabidopsis",
    "hnahal":                               "arabidopsis",
    "klepikova":                            "arabidopsis",
    "lateral_root_initiation":              "arabidopsis",
    "light_series":                         "arabidopsis",
    "lipid_map":                            "arabidopsis",
    "meristem_db":                          "arabidopsis",
    "meristem_db_new":                      "arabidopsis",
    "rohan":                                "arabidopsis",
    "root":                                 "arabidopsis",
    "root_Schaefer_lab":                    "arabidopsis",
    "rpatel":                               "arabidopsis",
    "seed_db":                              "arabidopsis",
    "seedcoat":                             "arabidopsis",   # AROS chip; A######_## probesets
    "shoot_apex":                           "arabidopsis",
    "silique":                              "arabidopsis",
    "single_cell":                          "arabidopsis",

    # Actinidia (kiwifruit)
    "actinidia_bud_development":            "actinidia",
    "actinidia_flower_fruit_development":   "actinidia",
    "actinidia_postharvest":                "actinidia",
    "actinidia_vegetative_growth":          "actinidia",
    # Apple
    "apple":                                "apple",
    # Arachis (peanut)
    "arachis":                              "arachis",
    # Barley
    "barley_mas":                           "barley",
    "barley_rma":                           "barley",
    "barley_seed":                          "barley",
    "barley_spike_meristem":                "barley",
    "barley_spike_meristem_v3":             "barley",
    # Brachypodium
    "brachypodium":                         "brachypodium",
    "brachypodium_Bd21":                    "brachypodium",
    "brachypodium_embryogenesis":           "brachypodium",
    "brachypodium_grains":                  "brachypodium",
    "brachypodium_metabolites_map":         "brachypodium",
    "brachypodium_photo_thermocycle":       "brachypodium",
    # Brassica rapa
    "brassica_rapa":                        "brassica",
    # Cacao
    "cacao_developmental_atlas":            "cacao",
    "cacao_developmental_atlas_sca":        "cacao",
    "cacao_drought_diurnal_atlas":          "cacao",
    "cacao_drought_diurnal_atlas_sca":      "cacao",
    "cacao_infection":                      "cacao",
    "cacao_leaf":                           "cacao",
    "cacao_meristem_atlas_sca":             "cacao",
    "cacao_seed_atlas_sca":                 "cacao",
    # Camelina
    "camelina":                             "camelina",
    "camelina_tpm":                         "camelina",
    # Cannabis
    "cannabis":                             "cannabis",
    # Canola (Brassica napus)
    "canola":                               "canola",
    "canola_original":                      "canola",
    "canola_original_v2":                   "canola",
    "canola_seed":                          "canola",
    # Cassava
    "cassava_atlas":                        "cassava",
    "cassava_cbb":                          "cassava",
    "cassava_eacmv":                        "cassava",
    # Cuscuta
    "cuscuta":                              "cuscuta",
    "cuscuta_early_haustoriogenesis":       "cuscuta",
    "cuscuta_lmd":                          "cuscuta",
    # Wheat / Durum
    "durum_wheat_abiotic_stress":           "wheat",
    "durum_wheat_biotic_stress":            "wheat",
    "durum_wheat_development":              "wheat",
    # Eucalyptus
    "eucalyptus":                           "eucalyptus",
    # Euphorbia
    "euphorbia":                            "euphorbia",
    # Grape
    "grape_developmental":                  "grape",
    # Heterodera (nematode)
    "heterodera_schachtii":                 "heterodera",
    # Human
    "human_body_map_2":                     "human",
    "human_developmental":                  "human",
    "human_developmental_SpongeLab":        "human",
    "human_diseased":                       "human",
    # Kalanchoe
    "kalanchoe":                            "kalanchoe",
    "kalanchoe_time_course_analysis":       "kalanchoe",
    # Little millet
    "little_millet":                        "little_millet",
    # Lupin
    "lupin_lcm_leaf":                       "lupin",
    "lupin_lcm_pod":                        "lupin",
    "lupin_lcm_stem":                       "lupin",
    "lupin_pod_seed":                       "lupin",
    "lupin_whole_plant":                    "lupin",
    # Maize
    "maize_RMA_linear":                     "maize",
    "maize_RMA_log":                        "maize",
    "maize_atlas":                          "maize",
    "maize_atlas_v5":                       "maize",
    "maize_buell_lab":                      "maize",
    "maize_early_seed":                     "maize",
    "maize_ears":                           "maize",
    "maize_embryonic_leaf_development":     "maize",
    "maize_enzyme":                         "maize",
    "maize_gdowns":                         "maize",         # Affymetrix chip; GRMZM* → AB*_at (GenBank accession probesets)
    "maize_iplant":                         "maize",
    "maize_kernel_v5":                      "maize",
    "maize_leaf_gradient":                  "maize",
    "maize_lipid_map":                      "maize",
    "maize_metabolite":                     "maize",
    "maize_nitrogen_use_efficiency":        "maize",
    "maize_rice_comparison":                "maize",
    "maize_root":                           "maize",
    "maize_stress_v5":                      "maize",
    # Mangosteen
    "mangosteen_aril_vs_rind":              "mangosteen",
    "mangosteen_callus":                    "mangosteen",
    "mangosteen_diseased_vs_normal":        "mangosteen",
    "mangosteen_fruit_ripening":            "mangosteen",
    "mangosteen_seed_development":          "mangosteen",
    "mangosteen_seed_development_germination": "mangosteen",
    "mangosteen_seed_germination":          "mangosteen",
    # Marchantia
    "marchantia_organ_stress":              "marchantia",
    # Medicago
    "medicago_mas":                         "medicago",      # Affymetrix chip; Medtr* → Mtr.*_at
    "medicago_rma":                         "medicago",
    "medicago_root":                        "medicago",
    "medicago_root_v5":                     "medicago",
    "medicago_seed":                        "medicago",
    # Mouse
    "mouse_db":                             "mouse",
    # Oat
    "oat":                                  "oat",
    # Phelipanche
    "phelipanche":                          "phelipanche",
    # Physcomitrella
    "physcomitrella_db":                    "physcomitrella",
    # Poplar
    "poplar":                               "poplar",        # Affymetrix chip; grail3.* → PtpAffx.*_at
    "poplar_hormone":                       "poplar",
    "poplar_leaf":                          "poplar",
    "poplar_xylem":                         "poplar",
    # Potato
    "potato_dev":                           "potato",
    "potato_stress":                        "potato",
    "potato_wounding":                      "potato",
    # Rice
    "rice_abiotic_stress_sc_pseudobulk":    "rice",
    "rice_drought_heat_stress":             "rice",
    "rice_leaf_gradient":                   "rice",
    "rice_maize_comparison":                "rice",
    "rice_mas":                             "rice",          # Affymetrix chip; LOC_Os* → Os.*_at
    "rice_metabolite":                      "rice",
    "rice_rma":                             "rice",
    "rice_root":                            "rice",
    # Selaginella
    "selaginella":                          "selaginella",
    # Sorghum
    "sorghum_atlas_w_BS_cells":             "sorghum",
    "sorghum_comparative_transcriptomics":  "sorghum",
    "sorghum_developmental":                "sorghum",
    "sorghum_developmental_2":              "sorghum",
    "sorghum_flowering_activation":         "sorghum",
    "sorghum_low_phosphorus":               "sorghum",
    "sorghum_nitrogen_stress":              "sorghum",
    "sorghum_nitrogen_use_efficiency":      "sorghum",
    "sorghum_phosphate_stress":             "sorghum",
    "sorghum_plasma":                       "sorghum",
    "sorghum_saline_alkali_stress":         "sorghum",
    "sorghum_stress":                       "sorghum",
    "sorghum_strigolactone_variation":      "sorghum",
    "sorghum_sulfur_stress":                "sorghum",
    "sorghum_temperature_stress":           "sorghum",
    "sorghum_vascularization_and_internode": "sorghum",
    # Soybean
    "soybean":                              "soybean",
    "soybean_embryonic_development":        "soybean",
    "soybean_heart_cotyledon_globular":     "soybean",
    "soybean_senescence":                   "soybean",
    "soybean_severin":                      "soybean",
    # Spruce
    "spruce":                               "spruce",
    # Strawberry
    "strawberry":                           "strawberry",
    # Striga
    "striga":                               "striga",
    # Sugarcane
    "sugarcane_culms":                      "sugarcane",
    "sugarcane_leaf":                       "sugarcane",
    # Sunflower
    "sunflower":                            "sunflower",
    # Thellungiella (Eutrema)
    "thellungiella_db":                     "thellungiella",
    # Tomato
    "tomato":                               "tomato",
    "tomato_ils":                           "tomato",
    "tomato_ils2":                          "tomato",
    "tomato_ils3":                          "tomato",
    "tomato_meristem":                      "tomato",
    "tomato_renormalized":                  "tomato",
    "tomato_root":                          "tomato",
    "tomato_root_field_pot":                "tomato",
    "tomato_s_pennellii":                   "tomato",
    "tomato_seed":                          "tomato",
    "tomato_shade_mutants":                 "tomato",
    "tomato_shade_timecourse":              "tomato",
    "tomato_trait":                         "tomato",
    # Triphysaria
    "triphysaria":                          "triphysaria",
    # Triticale
    "triticale":                            "triticale",     # Affymetrix chip; EU* → Ta.*_at
    "triticale_mas":                        "triticale",
    # Tung tree
    "tung_tree":                            "tung_tree",
    # Wheat
    "wheat":                                "wheat",
    "wheat_abiotic_stress":                 "wheat",
    "wheat_embryogenesis":                  "wheat",
    "wheat_meiosis":                        "wheat",
    "wheat_root":                           "wheat",
    # Willow
    "willow":                               "willow",
    # Test
    "sample_data":                          "arabidopsis",
    'arabidopsis_NIE_pseudobulk':           "arabidopsis",
    "arabidopsis_stem_lee_pseudobulk":      "arabidopsis",
    "arabidopsis_flower_lee_pseudobulk":    "arabidopsis",
    "arabidopsis_silique_lee_pseudobulk":   "arabidopsis",
    "arabidopsis_root_rs_pseudobulk":       "arabidopsis",
    "arabidopsis_seed_martin_pseudobulk":   "arabidopsis",
    "rice_OW_pseudobulk":                   "rice",
    "rice_OW_umap":                         "rice",
    "arabidopsis_NIE_umap":                 "arabidopsis",
    "arabidopsis_root_shahan_umap":         "arabidopsis",
    "arabidopsis_seed_martin_umap":         "arabidopsis",
    "arabidopsis_flower_lee_umap":          "arabidopsis",
    "arabidopsis_silique_lee_umap":         "arabidopsis",
    "arabidopsis_stem_lee_umap":            "arabidopsis",
}
# fmt: on

# ---------------------------------------------------------------------------
# Probeset databases
# Databases where the stored key is a probeset ID, not the canonical gene ID.
# A gene → probeset lookup is required before querying these.
# ---------------------------------------------------------------------------

PROBESET_DATABASES: frozenset[str] = frozenset(
    {
        # ── Arabidopsis ATH1 GeneChip ────────────────────────────────────────────
        "affydb",
        "arabidopsis_ecotypes",
        "atgenexp",
        "atgenexp_hormone",
        "atgenexp_pathogen",
        "atgenexp_plus",
        "atgenexp_stress",
        "guard_cell",
        "hnahal",
        "lateral_root_initiation",
        "light_series",
        "meristem_db",
        "meristem_db_new",
        "root",
        "rohan",
        "rpatel",
        "seed_db",
        # ── Other species Affymetrix chips ───────────────────────────────────────
        # Lookup tables for these are pending; supply probeset directly (e.g. Contig3267_at)
        "barley_mas",  # Affymetrix Barley1 GeneChip  (AK364622 → Contig3045_at)
        "barley_rma",  # Affymetrix Barley1 GeneChip
        "human_developmental",  # CCR5 → 206991_s_at
        "human_developmental_SpongeLab",
        "human_diseased",
        "maize_gdowns",    # Affymetrix Maize GeneChip (GRMZM* → AB*_at, GenBank accession probesets)
        "maize_RMA_linear",  # contig-based probesets (GRMZM* → AC*_FGT* format)
        "maize_RMA_log",   # same chip as maize_RMA_linear
        "medicago_mas",    # Affymetrix Medicago GeneChip (Medtr* → Mtr.*_at)
        "medicago_rma",    # Affymetrix Medicago GeneChip
        "medicago_seed",   # old genome model (Medtr8g* → Medtr_v1_*); confirmed from sample data
        "poplar",          # Affymetrix Poplar GeneChip (Potri.* → grail3.* → PtpAffx.*_at)
        "rice_mas",        # Affymetrix Rice GeneChip (LOC_Os* → Os.*_at)
        "rice_rma",        # Affymetrix Rice GeneChip
        "tomato",          # Affymetrix Tomato GeneChip (Solyc* → TU* probesets); confirmed from sample data
        "triticale",       # Affymetrix Wheat/Triticale GeneChip (EU* → Ta.*_at)
        "triticale_mas",   # Affymetrix Wheat/Triticale GeneChip
        # ── Non-Affymetrix species with gene ID ≠ stored key ─────────────────────
        # Confirmed from eFP browser: input gene ID differs from the stored key.
        # Lookup tables pending for all of these.
        "grape_developmental",  # VIT_00s0120g00060 → CHRUN_JGVV120_4_T01
        "soybean",              # Glyma.XxG* (new Wm82.a4) → GlymaXxg*/GlymaXxs* (old format)
        "soybean_embryonic_development",
        "soybean_heart_cotyledon_globular",
        "soybean_senescence",
        "soybean_severin",
        # ── Cross-species: input is an Arabidopsis AGI, stored as species gene ID ─
        # See CROSS_SPECIES_DATABASES below for the input validation override.
        "phelipanche",     # AT1G07890 → OrAeBC5_10.1
        "striga",          # AT3G11400 → StHeBC3_1.1
        "thellungiella_db",  # AT2G21470 → Thhalv10000089m.g
        "triphysaria",     # AT1G11260 → TrVeBC3_1.1
        # TODO: seedcoat – AROS chip; A######_## probesets; add once format confirmed
        # TODO: strawberry – gene10171 → FvH4_1g00010; lookup table needed
        # TODO: physcomitrella – Phypa_166136 → Pp1s103_79V6.1; lookup table needed
        # TODO: willow – SapurV1A.* → comp*_c*_seq* (Trinity); assembly mapping needed
        # TODO: sunflower – HanXRQChr12g* → Ha1_*; genome version mapping needed
        # TODO: camelina – Csa01g* (v6) → Csa*s*.* (old assembly); version mapping needed
    }
)

# ---------------------------------------------------------------------------
# Cross-species databases
# These accept an Arabidopsis AGI as input and convert it to a species probeset.
# Used to override input validation (validate against arabidopsis, not native species).
# ---------------------------------------------------------------------------

CROSS_SPECIES_DATABASES: dict[str, str] = {
    # database            → species of the expected INPUT gene ID
    "phelipanche": "arabidopsis",  # AT* AGI → OrAeBC5_* probeset
    "striga": "arabidopsis",  # AT* AGI → StHeBC3_* probeset
    "thellungiella_db": "arabidopsis",  # AT* AGI → Thhalv* probeset
    "triphysaria": "arabidopsis",  # AT* AGI → TrVeBC3_* probeset
}


# ---------------------------------------------------------------------------
# Species detection
# ---------------------------------------------------------------------------


def detect_gene_species(gene_id: str) -> Optional[str]:
    """Infer species from gene_id format. Returns canonical species key or None."""
    upper = gene_id.upper()
    if BARUtils.is_arabidopsis_gene_valid(upper):
        return "arabidopsis"
    if BARUtils.is_maize_gene_valid(upper):
        return "maize"
    if BARUtils.is_rice_gene_valid(upper):
        return "rice"
    if BARUtils.is_soybean_gene_valid(upper):
        return "soybean"
    if BARUtils.is_poplar_gene_valid(upper):
        return "poplar"
    if BARUtils.is_tomato_gene_valid(upper):
        return "tomato"
    if BARUtils.is_sorghum_gene_valid(upper):
        return "sorghum"
    if BARUtils.is_cannabis_gene_valid(upper):
        return "cannabis"
    if BARUtils.is_grape_gene_valid(upper):
        return "grape"
    if BARUtils.is_kalanchoe_gene_valid(upper):
        return "kalanchoe"
    if BARUtils.is_strawberry_gene_valid(upper):
        return "strawberry"
    if BARUtils.is_selaginella_gene_valid(upper):
        return "selaginella"
    if BARUtils.is_phelipanche_gene_valid(upper):
        return "phelipanche"
    if BARUtils.is_physcomitrella_gene_valid(upper):
        return "physcomitrella"
    if BARUtils.is_striga_gene_valid(upper):
        return "striga"
    if BARUtils.is_triphysaria_gene_valid(upper):
        return "triphysaria"
    if BARUtils.is_canola_gene_valid(upper):
        return "canola"
    if BARUtils.is_brassica_rapa_gene_valid(upper):
        return "brassica"
    if BARUtils.is_arachis_gene_valid(upper):
        return "arachis"
    return None


# ---------------------------------------------------------------------------
# Gene ID validation
# ---------------------------------------------------------------------------

# Species without a validator entry pass through (unknown format = not rejected).
# Note: strawberry and physcomitrella validators match the probeset format
# (FvH4_*, Pp1s*V6.*), not the user-input gene format (gene####, Phypa_*).
# Lookup tables for those are still pending.
_VALIDATORS: dict = {
    "arabidopsis": BARUtils.is_arabidopsis_gene_valid,
    "arachis": BARUtils.is_arachis_gene_valid,
    "brassica": BARUtils.is_brassica_rapa_gene_valid,
    "cannabis": BARUtils.is_cannabis_gene_valid,
    "canola": BARUtils.is_canola_gene_valid,
    "grape": BARUtils.is_grape_gene_valid,
    "kalanchoe": BARUtils.is_kalanchoe_gene_valid,
    "maize": BARUtils.is_maize_gene_valid,
    "phelipanche": BARUtils.is_phelipanche_gene_valid,
    "physcomitrella": BARUtils.is_physcomitrella_gene_valid,
    "poplar": BARUtils.is_poplar_gene_valid,
    "rice": BARUtils.is_rice_gene_valid,
    "selaginella": BARUtils.is_selaginella_gene_valid,
    "sorghum": BARUtils.is_sorghum_gene_valid,
    "soybean": BARUtils.is_soybean_gene_valid,
    "strawberry": BARUtils.is_strawberry_gene_valid,
    "striga": BARUtils.is_striga_gene_valid,
    "tomato": BARUtils.is_tomato_gene_valid,
    "triphysaria": BARUtils.is_triphysaria_gene_valid,
}


def validate_gene_id(gene_id: str, species: str) -> bool:
    """True if gene_id passes the species validator, or species has no validator."""
    validator = _VALIDATORS.get(species)
    return validator(gene_id) if validator is not None else True


def get_species_for_database(database: str) -> Optional[str]:
    """Return canonical species key for database, or None if unknown."""
    return DATABASE_SPECIES.get(database)


# ---------------------------------------------------------------------------
# Gene ID normalisation
# ---------------------------------------------------------------------------

# Maize transcript IDs (e.g. GRMZM2G083841_T01) must be stripped to gene level
# before querying eFP databases.
_MAIZE_TRANSCRIPT_RE = re.compile(r"_T\d{1,3}$", re.IGNORECASE)

# Barley V3 IDs from ePlant use a .V3 suffix (e.g. HORVU.MOREX.r3.1HG0000030.V3)
# but databases store a .1 suffix (e.g. HORVU.MOREX.r3.1HG0000030.1).
# Strip any trailing version suffix (.[Vv]\d+ or .\d+) and reattach .1.
_BARLEY_V3_RE = re.compile(r"\.[Vv]\d+$")


def normalize_gene_id(gene_id: str, species: str) -> str:
    """Return the gene ID in the form stored in eFP databases.

    :param gene_id: Raw gene identifier supplied by the user.
    :type gene_id: str
    :param species: Canonical species key (e.g. ``'maize'``, ``'barley'``).
    :type species: str
    :returns: Normalised gene ID ready for database lookup.
    :rtype: str

    Maize: strips ``_T##`` transcript suffix (``GRMZM2G083841_T01`` → ``GRMZM2G083841``).

    Barley V3: replaces ``.V3`` version suffix with ``.1`` to match the stored format
    (``HORVU.MOREX.r3.1HG0000030.V3`` → ``HORVU.MOREX.r3.1HG0000030.1``).
    """
    if species == "maize":
        return _MAIZE_TRANSCRIPT_RE.sub("", gene_id)
    if species == "barley" and _BARLEY_V3_RE.search(gene_id):
        return _BARLEY_V3_RE.sub(".1", gene_id)
    return gene_id


# ---------------------------------------------------------------------------
# Gene ID → probeset conversion
# ---------------------------------------------------------------------------


def convert_gene_to_probeset(
    gene_id: str,
    species: str,
    database: str,
) -> tuple[Optional[str], Optional[str]]:
    """Convert gene_id to its probeset ID. Returns (probeset, None) or (None, error)."""

    # ── Implemented ──────────────────────────────────────────────────────────

    if species == "arabidopsis":
        from api.services.efp_data import EFPDataService  # noqa: PLC0415
        probeset = EFPDataService.agi_to_probset(gene_id.upper())
        if probeset:
            return probeset, None
        return None, f"No ATH1 probeset found for '{gene_id}'."

    # ── Affymetrix chips (lookup tables pending) ──────────────────────────────

    if species == "barley":
        # TODO: AK364622 → Contig3045_at
        pass

    if species == "maize":
        # TODO: maize_gdowns — GRMZM* → AB*_at (GenBank accession probesets; confirmed from sample data)
        # TODO: maize_RMA_linear — GRMZM* → AC*_FGT* (contig-based probesets; confirmed from sample data)
        # Other maize databases (maize_buell_lab etc.) store Zm00001d* directly — use normalize_gene_id.
        pass

    if species == "medicago":
        # TODO: medicago_mas / medicago_rma — Medtr* → Mtr.*_at (Affymetrix chip)
        # TODO: medicago_seed — Medtr8g* → Medtr_v1_* (old genome model; confirmed from sample data)
        pass

    if species == "poplar":
        # TODO: grail3.* → PtpAffx.*_at
        pass

    if species == "rice":
        # TODO: LOC_Os* → Os.*_at
        pass

    if species == "triticale":
        # TODO: EU* → Ta.*_at
        pass

    if species == "human":
        # TODO: gene symbol → numeric_s_at (e.g. CCR5 → 206991_s_at)
        pass

    # ── Non-Affymetrix species with differing ID formats (lookup tables pending) ──

    if species == "tomato" and database == "tomato":
        # TODO: Solyc* → TU* (Tomato Unigene probesets on Affymetrix Tomato GeneChip)
        # Confirmed from sample data: tomato (Rose Lab Atlas) stores TU000001 format.
        # tomato_ils / tomato_ils2 store Solyc* directly — no conversion needed for those.
        pass

    if species == "grape":
        # TODO: VIT_* → CHRUN_*
        pass

    if species == "soybean":
        # TODO: Glyma.XxG* (new Wm82.a4 format) → GlymaXxg*/GlymaXxs* (old format)
        # Confirmed from sample data: soybean/soybean_severin store old format (e.g. Glyma0021s00410).
        # This is a gene model version reconciliation, not just string formatting.
        pass

    # ── Cross-species: Arabidopsis AGI input → species probeset (lookup tables pending) ──

    if species == "phelipanche":
        # TODO: AT* → OrAeBC5_*
        pass

    if species == "striga":
        # TODO: AT* → StHeBC3_*
        pass

    if species == "thellungiella":
        # TODO: AT* → Thhalv*
        pass

    if species == "triphysaria":
        # TODO: AT* → TrVeBC3_*
        pass

    return None, (
        f"Probeset lookup not yet available for species '{species}' "
        f"(database: '{database}'). "
        "Supply the probeset ID directly (e.g. Contig3267_at)."
    )
