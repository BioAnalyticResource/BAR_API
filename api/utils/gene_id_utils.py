"""
Gene identifier utilities: species detection, validation, and probeset conversion.

Microarray (Affymetrix) probeset IDs end in '_at', e.g.:
  261585_at          (Arabidopsis ATH1 chip)
  Zm.16588.1.A1_at   (Maize Affymetrix chip)
  PtpAffx.224570.1.S1_at  (Poplar chip)
  Contig3267_at      (Barley chip)
  Mtr.45555.1.S1_at  (Medicago chip)
  OsAffx.1.1.S1_at   (Rice chip)

Conversion pipeline used by the gene expression endpoint:
  1. is_probeset_id(gene_id)         → skip conversion if already a probeset
  2. get_species_for_database(db)    → resolve which species the database belongs to
  3. validate_gene_id(gene_id, sp)   → check ID format via species-specific regex
  4. convert_gene_to_probeset(...)   → gene ID → Affymetrix probeset ID

Adding a new species lookup:
  - Add a model for the lookup table in api/models/annotations_lookup.py
  - Add the conversion branch in convert_gene_to_probeset() below
  - Add the database → species mapping in DATABASE_SPECIES
"""

from __future__ import annotations

import re
from typing import Optional

from api.utils.bar_utils import BARUtils

# ---------------------------------------------------------------------------
# Probeset ID detection
# ---------------------------------------------------------------------------

# Affymetrix probeset IDs end in _at (case-insensitive).
# This is the universal signal that an ID is already a probeset and
# does not need further conversion.
_PROBESET_RE = re.compile(r"^.+_at$", re.IGNORECASE)


def is_probeset_id(gene_id: str) -> bool:
    """Return True if *gene_id* is already an Affymetrix probeset (ends in _at).

    :param gene_id: Gene or probeset identifier
    :type gene_id: str
    :return: True if the identifier ends in ``_at``
    :rtype: bool

    Examples::

        is_probeset_id("261585_at")            # True  – Arabidopsis ATH1
        is_probeset_id("Zm.16588.1.A1_at")     # True  – Maize
        is_probeset_id("AT1G01010")             # False – Arabidopsis AGI
    """
    return bool(_PROBESET_RE.match(gene_id))


# ---------------------------------------------------------------------------
# DATABASE → species lookup table  (the "giant table")
#
# Maps every eFP database name to a canonical species key used by:
#   - validate_gene_id()         (picks the right regex validator)
#   - convert_gene_to_probeset() (picks the right lookup table)
#
# Canonical species keys are lowercase identifiers that match the
# validator dispatch table in validate_gene_id().
# ---------------------------------------------------------------------------

# fmt: off
DATABASE_SPECIES: dict[str, str] = {
    # ── Arabidopsis (ATH1 microarray + RNA-seq) ──────────────────────────────
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
    "gc_drought":                           "arabidopsis",   # guard-cell drought
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
    "seedcoat":                             "arabidopsis",   # seed coat; may have own probeset – see TODO below
    "shoot_apex":                           "arabidopsis",
    "silique":                              "arabidopsis",
    "single_cell":                          "arabidopsis",
    # ── Actinidia (kiwifruit) ────────────────────────────────────────────────
    "actinidia_bud_development":            "actinidia",
    "actinidia_flower_fruit_development":   "actinidia",
    "actinidia_postharvest":                "actinidia",
    "actinidia_vegetative_growth":          "actinidia",
    # ── Apple ────────────────────────────────────────────────────────────────
    "apple":                                "apple",
    # ── Arachis (peanut) ─────────────────────────────────────────────────────
    "arachis":                              "arachis",
    # ── Barley ───────────────────────────────────────────────────────────────
    "barley_mas":                           "barley",        # Affymetrix Barley1 chip
    "barley_rma":                           "barley",        # Affymetrix Barley1 chip
    "barley_seed":                          "barley",
    "barley_spike_meristem":                "barley",
    "barley_spike_meristem_v3":             "barley",
    # ── Brachypodium ─────────────────────────────────────────────────────────
    "brachypodium":                         "brachypodium",
    "brachypodium_Bd21":                    "brachypodium",
    "brachypodium_embryogenesis":           "brachypodium",
    "brachypodium_grains":                  "brachypodium",
    "brachypodium_metabolites_map":         "brachypodium",
    "brachypodium_photo_thermocycle":       "brachypodium",
    # ── Brassica rapa ────────────────────────────────────────────────────────
    "brassica_rapa":                        "brassica",
    # ── Cacao ────────────────────────────────────────────────────────────────
    "cacao_developmental_atlas":            "cacao",
    "cacao_developmental_atlas_sca":        "cacao",
    "cacao_drought_diurnal_atlas":          "cacao",
    "cacao_drought_diurnal_atlas_sca":      "cacao",
    "cacao_infection":                      "cacao",
    "cacao_leaf":                           "cacao",
    "cacao_meristem_atlas_sca":             "cacao",
    "cacao_seed_atlas_sca":                 "cacao",
    # ── Camelina ─────────────────────────────────────────────────────────────
    "camelina":                             "camelina",
    "camelina_tpm":                         "camelina",
    # ── Cannabis ─────────────────────────────────────────────────────────────
    "cannabis":                             "cannabis",
    # ── Canola (Brassica napus) ───────────────────────────────────────────────
    "canola":                               "canola",
    "canola_original":                      "canola",
    "canola_original_v2":                   "canola",
    "canola_seed":                          "canola",
    # ── Cassava ──────────────────────────────────────────────────────────────
    "cassava_atlas":                        "cassava",
    "cassava_cbb":                          "cassava",
    "cassava_eacmv":                        "cassava",
    # ── Cuscuta ──────────────────────────────────────────────────────────────
    "cuscuta":                              "cuscuta",
    "cuscuta_early_haustoriogenesis":       "cuscuta",
    "cuscuta_lmd":                          "cuscuta",
    # ── Wheat / Durum ────────────────────────────────────────────────────────
    "durum_wheat_abiotic_stress":           "wheat",
    "durum_wheat_biotic_stress":            "wheat",
    "durum_wheat_development":              "wheat",
    # ── Eucalyptus ───────────────────────────────────────────────────────────
    "eucalyptus":                           "eucalyptus",
    # ── Euphorbia ────────────────────────────────────────────────────────────
    "euphorbia":                            "euphorbia",
    # ── Grape ────────────────────────────────────────────────────────────────
    "grape_developmental":                  "grape",
    # ── Heterodera (nematode) ────────────────────────────────────────────────
    "heterodera_schachtii":                 "heterodera",
    # ── Human ────────────────────────────────────────────────────────────────
    "human_body_map_2":                     "human",
    "human_developmental":                  "human",         # Affymetrix Human chip
    "human_developmental_SpongeLab":        "human",         # Affymetrix Human chip
    "human_diseased":                       "human",         # Affymetrix Human chip
    # ── Kalanchoe ────────────────────────────────────────────────────────────
    "kalanchoe":                            "kalanchoe",
    "kalanchoe_time_course_analysis":       "kalanchoe",
    # ── Little millet ────────────────────────────────────────────────────────
    "little_millet":                        "little_millet",
    # ── Lupin ────────────────────────────────────────────────────────────────
    "lupin_lcm_leaf":                       "lupin",
    "lupin_lcm_pod":                        "lupin",
    "lupin_lcm_stem":                       "lupin",
    "lupin_pod_seed":                       "lupin",
    "lupin_whole_plant":                    "lupin",
    # ── Maize ────────────────────────────────────────────────────────────────
    "maize_RMA_linear":                     "maize",
    "maize_RMA_log":                        "maize",
    "maize_atlas":                          "maize",
    "maize_atlas_v5":                       "maize",
    "maize_buell_lab":                      "maize",
    "maize_early_seed":                     "maize",
    "maize_ears":                           "maize",
    "maize_embryonic_leaf_development":     "maize",
    "maize_enzyme":                         "maize",
    "maize_gdowns":                         "maize",         # Affymetrix Maize chip (Zm._ probeset IDs)
    "maize_iplant":                         "maize",
    "maize_kernel_v5":                      "maize",
    "maize_leaf_gradient":                  "maize",
    "maize_lipid_map":                      "maize",
    "maize_metabolite":                     "maize",
    "maize_nitrogen_use_efficiency":        "maize",
    "maize_rice_comparison":                "maize",
    "maize_root":                           "maize",
    "maize_stress_v5":                      "maize",
    # ── Mangosteen ───────────────────────────────────────────────────────────
    "mangosteen_aril_vs_rind":              "mangosteen",
    "mangosteen_callus":                    "mangosteen",
    "mangosteen_diseased_vs_normal":        "mangosteen",
    "mangosteen_fruit_ripening":            "mangosteen",
    "mangosteen_seed_development":          "mangosteen",
    "mangosteen_seed_development_germination": "mangosteen",
    "mangosteen_seed_germination":          "mangosteen",
    # ── Marchantia ───────────────────────────────────────────────────────────
    "marchantia_organ_stress":              "marchantia",
    # ── Medicago ─────────────────────────────────────────────────────────────
    "medicago_mas":                         "medicago",      # Affymetrix Medicago chip
    "medicago_rma":                         "medicago",      # Affymetrix Medicago chip
    "medicago_root":                        "medicago",
    "medicago_root_v5":                     "medicago",
    "medicago_seed":                        "medicago",
    # ── Mouse ────────────────────────────────────────────────────────────────
    "mouse_db":                             "mouse",
    # ── Oat ──────────────────────────────────────────────────────────────────
    "oat":                                  "oat",
    # ── Phelipanche ──────────────────────────────────────────────────────────
    "phelipanche":                          "phelipanche",
    # ── Physcomitrella ───────────────────────────────────────────────────────
    "physcomitrella_db":                    "physcomitrella",
    # ── Poplar ───────────────────────────────────────────────────────────────
    "poplar":                               "poplar",        # Affymetrix Poplar chip (PtpAffx._ probeset IDs)
    "poplar_hormone":                       "poplar",
    "poplar_leaf":                          "poplar",
    "poplar_xylem":                         "poplar",
    # ── Potato ───────────────────────────────────────────────────────────────
    "potato_dev":                           "potato",
    "potato_stress":                        "potato",
    "potato_wounding":                      "potato",
    # ── Rice ─────────────────────────────────────────────────────────────────
    "rice_abiotic_stress_sc_pseudobulk":    "rice",
    "rice_drought_heat_stress":             "rice",
    "rice_leaf_gradient":                   "rice",
    "rice_maize_comparison":                "rice",
    "rice_mas":                             "rice",          # Affymetrix Rice chip (OsAffx._ probeset IDs)
    "rice_metabolite":                      "rice",
    "rice_rma":                             "rice",          # Affymetrix Rice chip
    "rice_root":                            "rice",
    # ── Selaginella ──────────────────────────────────────────────────────────
    "selaginella":                          "selaginella",
    # ── Sorghum ──────────────────────────────────────────────────────────────
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
    # ── Soybean ──────────────────────────────────────────────────────────────
    "soybean":                              "soybean",
    "soybean_embryonic_development":        "soybean",
    "soybean_heart_cotyledon_globular":     "soybean",
    "soybean_senescence":                   "soybean",
    "soybean_severin":                      "soybean",
    # ── Spruce ───────────────────────────────────────────────────────────────
    "spruce":                               "spruce",
    # ── Strawberry ───────────────────────────────────────────────────────────
    "strawberry":                           "strawberry",
    # ── Striga ───────────────────────────────────────────────────────────────
    "striga":                               "striga",
    # ── Sugarcane ────────────────────────────────────────────────────────────
    "sugarcane_culms":                      "sugarcane",
    "sugarcane_leaf":                       "sugarcane",
    # ── Sunflower ────────────────────────────────────────────────────────────
    "sunflower":                            "sunflower",
    # ── Thellungiella (Eutrema) ───────────────────────────────────────────────
    "thellungiella_db":                     "thellungiella",
    # ── Tomato ───────────────────────────────────────────────────────────────
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
    # ── Triphysaria ──────────────────────────────────────────────────────────
    "triphysaria":                          "triphysaria",
    # ── Triticale ────────────────────────────────────────────────────────────
    "triticale":                            "triticale",     # Affymetrix Wheat/Triticale chip
    "triticale_mas":                        "triticale",     # Affymetrix Wheat/Triticale chip
    # ── Tung tree ────────────────────────────────────────────────────────────
    "tung_tree":                            "tung_tree",
    # ── Wheat ────────────────────────────────────────────────────────────────
    "wheat":                                "wheat",
    "wheat_abiotic_stress":                 "wheat",
    "wheat_embryogenesis":                  "wheat",
    "wheat_meiosis":                        "wheat",
    "wheat_root":                           "wheat",
    # ── Willow ───────────────────────────────────────────────────────────────
    "willow":                               "willow",
    # ── Test / manual databases ───────────────────────────────────────────────
    "sample_data":                          "arabidopsis",   # Arabidopsis ATH1 test set
}
# fmt: on

# ---------------------------------------------------------------------------
# Probeset databases
#
# Databases where expression data is stored against Affymetrix probeset IDs
# rather than canonical gene identifiers.  Providing a gene ID (e.g., AGI)
# to one of these databases requires a gene→probeset conversion step.
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
        "maize_gdowns",  # Affymetrix Maize GeneChip (gene → Zm.XXXXX probeset IDs)
        "medicago_mas",  # Affymetrix Medicago GeneChip (Medtr* → Mtr.*_at)
        "medicago_rma",  # Affymetrix Medicago GeneChip
        "poplar",  # Affymetrix Poplar GeneChip (grail3.* → PtpAffx.*_at)
        "rice_mas",  # Affymetrix Rice GeneChip (LOC_Os* → Os.*_at)
        "rice_rma",  # Affymetrix Rice GeneChip
        "triticale",  # Affymetrix Wheat/Triticale GeneChip (EU* → Ta.*_at)
        "triticale_mas",  # Affymetrix Wheat/Triticale GeneChip
        # ── Non-Affymetrix species with gene ID ≠ probeset ID ────────────────────
        # Confirmed from eFP browser: input gene ID differs from the stored probeset.
        # Lookup tables pending for all of these.
        "grape_developmental",  # VIT_00s0120g00060 → CHRUN_JGVV120_4_T01
        "potato_dev",  # PGSC0003DMP400000011 → PGSC0003DMG400000005
        "potato_stress",  # same DMP → DMG gene model conversion
        "potato_wounding",  # same DMP → DMG gene model conversion
        "soybean",  # Glyma.06g316600 (new) → Glyma06g47400 (old format)
        "soybean_embryonic_development",
        "soybean_heart_cotyledon_globular",
        "soybean_senescence",
        "soybean_severin",
        # ── Cross-species: input is an Arabidopsis AGI, stored as species gene ID ─
        # See CROSS_SPECIES_DATABASES below for the input validation override.
        "phelipanche",  # AT1G07890 → OrAeBC5_10.1
        "striga",  # AT3G11400 → StHeBC3_1.1
        "thellungiella_db",  # AT2G21470 → Thhalv10000089m.g
        "triphysaria",  # AT1G11260 → TrVeBC3_1.1
        # TODO: seedcoat (oat) – has species-specific probeset IDs; add once format confirmed
        # TODO: strawberry – gene10171 → FvH4_1g00010; lookup table needed
        # TODO: physcomitrella – Phypa_166136 → Pp1s103_79V6.1; lookup table needed
    }
)

# ---------------------------------------------------------------------------
# Cross-species input databases
#
# These databases belong to non-Arabidopsis species but accept an Arabidopsis
# AGI as the query gene ID.  The API converts the AGI to the species-specific
# probeset via a lookup table (pending for all four).
#
# The endpoint uses this map to validate the *input* gene ID against the
# Arabidopsis regex rather than the database's native species regex.
# ---------------------------------------------------------------------------

CROSS_SPECIES_DATABASES: dict[str, str] = {
    # database            → species of the expected INPUT gene ID
    "phelipanche": "arabidopsis",  # AT* AGI → OrAeBC5_* probeset
    "striga": "arabidopsis",  # AT* AGI → StHeBC3_* probeset
    "thellungiella_db": "arabidopsis",  # AT* AGI → Thhalv* probeset
    "triphysaria": "arabidopsis",  # AT* AGI → TrVeBC3_* probeset
}


# ---------------------------------------------------------------------------
# Species detection from gene ID format
# ---------------------------------------------------------------------------


def detect_gene_species(gene_id: str) -> Optional[str]:
    """Infer the species of *gene_id* from its format using regex validators.

    Checks are ordered from most-specific to least-specific to avoid false
    matches.  Returns the first matching canonical species key, or None.

    :param gene_id: Gene identifier to classify.
    :type gene_id: str
    :return: Canonical species key (e.g. ``'arabidopsis'``) or ``None``.
    :rtype: Optional[str]

    Examples::

        detect_gene_species("AT1G01010")      # 'arabidopsis'
        detect_gene_species("Zm00001d046170") # 'maize'
        detect_gene_species("261585_at")      # None  – already a probeset
    """
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

# Dispatch table: canonical species key → BARUtils validator
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
    """Return True if *gene_id* is valid for the given *species*.

    Species without a registered validator always return True so that
    databases without a known gene-ID format are not incorrectly rejected.

    :param gene_id: Gene identifier to validate.
    :type gene_id: str
    :param species: Canonical species key from :data:`DATABASE_SPECIES`.
    :type species: str
    :return: True if valid (or species unknown).
    :rtype: bool
    """
    validator = _VALIDATORS.get(species)
    return validator(gene_id) if validator is not None else True


def get_species_for_database(database: str) -> Optional[str]:
    """Return the canonical species key for *database*, or None if unknown.

    :param database: eFP database name (e.g. ``'klepikova'``).
    :type database: str
    :return: Canonical species key or ``None``.
    :rtype: Optional[str]
    """
    return DATABASE_SPECIES.get(database)


# ---------------------------------------------------------------------------
# Gene ID normalisation
# ---------------------------------------------------------------------------

# Maize transcript IDs carry a _T## suffix (e.g. GRMZM2G083841_T01).
# eFP databases index by the gene-level ID (GRMZM2G083841), so the suffix
# must be stripped before querying.
_MAIZE_TRANSCRIPT_RE = re.compile(r"_T\d{1,3}$", re.IGNORECASE)


def normalize_gene_id(gene_id: str, species: str) -> str:
    """Return the canonical form of *gene_id* as stored in eFP databases.

    Currently handles
    ~~~~~~~~~~~~~~~~~
    * **maize** — strips ``_T##`` transcript suffix from GRMZM IDs.
      e.g. ``GRMZM2G083841_T01`` → ``GRMZM2G083841``

    :param gene_id: Raw gene identifier supplied by the caller.
    :type gene_id: str
    :param species: Canonical species key from :data:`DATABASE_SPECIES`.
    :type species: str
    :return: Normalised gene identifier.
    :rtype: str
    """
    if species == "maize":
        return _MAIZE_TRANSCRIPT_RE.sub("", gene_id)
    return gene_id


# ---------------------------------------------------------------------------
# Gene ID → probeset conversion
# ---------------------------------------------------------------------------


def convert_gene_to_probeset(
    gene_id: str,
    species: str,
    database: str,
) -> tuple[Optional[str], Optional[str]]:
    """Convert a gene identifier to its Affymetrix probeset ID.

    Returns ``(probeset_id, None)`` on success or ``(None, error_message)``
    on failure.

    Currently implemented
    ~~~~~~~~~~~~~~~~~~~~~
    * **arabidopsis** — looks up ``at_agi_lookup`` via :class:`AtAgiLookup`.

    Planned — Affymetrix chips (lookup tables pending)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    * barley     — AK364622 → Contig3045_at
    * maize      — gene → Zm.XXXXX_at  (maize_gdowns only; other maize DBs use normalize_gene_id)
    * medicago   — Medtr* → Mtr.*_at
    * poplar     — grail3.* → PtpAffx.*_at
    * rice       — LOC_Os* → Os.*_at
    * triticale  — EU* → Ta.*_at
    * human      — gene symbol → numeric_s_at

    Planned — non-Affymetrix species with differing ID formats
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    * grape     — VIT_* → CHRUN_*
    * potato    — PGSC0003DMP* → PGSC0003DMG*
    * soybean   — Glyma.* (new) → Glyma* (old)

    Planned — cross-species (Arabidopsis AGI input → species probeset)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    * phelipanche    — AT* → OrAeBC5_*
    * striga         — AT* → StHeBC3_*
    * thellungiella  — AT* → Thhalv*
    * triphysaria    — AT* → TrVeBC3_*

    :param gene_id: Gene identifier (e.g. AGI ``AT1G01010``).
    :type gene_id: str
    :param species: Canonical species key.
    :type species: str
    :param database: Target eFP database name (used in error messages).
    :type database: str
    :return: Tuple of ``(probeset_id, error_message)``.
    :rtype: tuple[Optional[str], Optional[str]]

    Examples::

        probeset, err = convert_gene_to_probeset("AT1G01010", "arabidopsis", "atgenexp")
        # probeset = "261585_at", err = None

        probeset, err = convert_gene_to_probeset("Zm00001d046170", "maize", "maize_gdowns")
        # probeset = None, err = "Probeset lookup not yet available for species 'maize' ..."
    """
    if species == "arabidopsis":
        # Lazy import avoids circular dependencies at module load time
        from api.services.efp_data import EFPDataService  # noqa: PLC0415

        probeset = EFPDataService.agi_to_probst(gene_id.upper())
        if probeset:
            return probeset, None
        return None, (
            f"No Affymetrix ATH1 probeset found for Arabidopsis gene '{gene_id}'. "
            "Verify the AGI is present in the at_agi_lookup table."
        )

    # ── Placeholder branches for future lookup tables ─────────────────────
    # Uncomment and implement each block when the lookup table is available.
    #
    # if species == "maize":
    #     from api.models.annotations_lookup import MaizeAgiLookup
    #     ...
    #
    # if species in ("barley", "medicago", "poplar", "rice", "triticale"):
    #     from api.models.annotations_lookup import <SpeciesLookup>
    #     ...

    return None, (
        f"Probeset lookup is not yet available for species '{species}' "
        f"(database: '{database}'). "
        "Please supply the Affymetrix probeset ID directly (e.g., Contig3267_at)."
    )
