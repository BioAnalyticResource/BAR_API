"""
Compact schema definitions for eFP databases exposing a sample_data table.

Each database only needs 3 columns: data_probeset_id, data_signal, data_bot_id.
Schemas are defined as compact tuples and expanded into full spec dicts at import time.
"""

from __future__ import annotations

from typing import Any, Dict, List

ColumnSpec = Dict[str, Any]
DatabaseSpec = Dict[str, Any]


def _schema(pl: int, bl: int, species: str, charset: str = "latin1") -> DatabaseSpec:
    """Build a 3-column schema from compact parameters.

    :param pl: data_probeset_id length. Positive int → VARCHAR(N), 0 → TEXT.
    :param bl: data_bot_id length. Positive int → VARCHAR(N), 0 → TEXT.
    :param species: Species name for metadata.
    :param charset: MySQL character set ('latin1' or 'utf8mb4').
    :return: Full database schema specification.
    """
    p: ColumnSpec = (
        {"name": "data_probeset_id", "type": "string", "length": pl, "nullable": True, "primary_key": True}
        if pl else {"name": "data_probeset_id", "type": "text", "nullable": True}
    )
    s: ColumnSpec = {"name": "data_signal", "type": "float", "nullable": True, "primary_key": True}
    b: ColumnSpec = (
        {"name": "data_bot_id", "type": "string", "length": bl, "nullable": True, "primary_key": True}
        if bl else {"name": "data_bot_id", "type": "text", "nullable": True}
    )
    idx = []
    if pl:
        idx.append("data_probeset_id")
    if bl:
        idx.append("data_bot_id")
    idx.append("data_signal")
    return {
        "table_name": "sample_data",
        "charset": charset,
        "columns": [p, s, b],
        "index": idx,
        "identifier_type": "agi",
        "metadata": {"species": species, "sample_regex": r".*"},
    }


# fmt: off
# (name, probeset_len, bot_len, species) — 0 means TEXT (tinytext in MySQL)
_SPECS: List[tuple] = [
    ("actinidia_bud_development", 12, 8, "actinidia"),
    ("actinidia_flower_fruit_development", 12, 16, "actinidia"),
    ("actinidia_postharvest", 12, 24, "actinidia"),
    ("actinidia_vegetative_growth", 12, 16, "actinidia"),
    ("affydb", 30, 0, "arabidopsis"),
    ("apple", 18, 12, "apple"),
    ("arabidopsis_ecotypes", 30, 16, "arabidopsis"),
    ("arachis", 30, 65, "arachis"),
    ("atgenexp", 30, 50, "arabidopsis"),
    ("atgenexp_hormone", 30, 50, "arabidopsis"),
    ("atgenexp_pathogen", 30, 50, "arabidopsis"),
    ("atgenexp_plus", 30, 50, "arabidopsis"),
    ("atgenexp_stress", 30, 40, "arabidopsis"),
    ("barley_mas", 30, 24, "barley"),
    ("barley_rma", 30, 24, "barley"),
    ("barley_seed", 32, 12, "barley"),
    ("barley_spike_meristem", 24, 24, "barley"),
    ("barley_spike_meristem_v3", 32, 24, "barley"),
    ("brachypodium", 18, 50, "brachypodium"),
    ("brachypodium_Bd21", 18, 32, "brachypodium"),
    ("brachypodium_embryogenesis", 18, 50, "brachypodium"),
    ("brachypodium_grains", 18, 32, "brachypodium"),
    ("brachypodium_metabolites_map", 64, 45, "brachypodium"),
    ("brachypodium_photo_thermocycle", 18, 12, "brachypodium"),
    ("brassica_rapa", 16, 10, "brassica"),
    ("cacao_developmental_atlas", 24, 16, "cacao"),
    ("cacao_developmental_atlas_sca", 24, 16, "cacao"),
    ("cacao_drought_diurnal_atlas", 24, 16, "cacao"),
    ("cacao_drought_diurnal_atlas_sca", 24, 16, "cacao"),
    ("cacao_infection", 18, 24, "cacao"),
    ("cacao_leaf", 18, 12, "cacao"),
    ("cacao_meristem_atlas_sca", 24, 24, "cacao"),
    ("cacao_seed_atlas_sca", 24, 24, "cacao"),
    ("camelina", 20, 40, "camelina"),
    ("camelina_tpm", 20, 40, "camelina"),
    ("cannabis", 24, 8, "cannabis"),
    ("canola", 0, 0, "canola"),
    ("canola_original", 0, 0, "canola"),
    ("canola_original_v2", 0, 0, "canola"),
    ("canola_seed", 16, 12, "canola"),
    ("cassava_atlas", 24, 24, "cassava"),
    ("cassava_cbb", 24, 24, "cassava"),
    ("cassava_eacmv", 24, 24, "cassava"),
    ("circadian_mutants", 12, 18, "circadian mutants"),
    ("cuscuta", 16, 12, "cuscuta"),
    ("cuscuta_early_haustoriogenesis", 12, 8, "cuscuta"),
    ("cuscuta_lmd", 12, 8, "cuscuta"),
    ("dna_damage", 10, 32, "arabidopsis"),
    ("durum_wheat_abiotic_stress", 32, 32, "wheat"),
    ("durum_wheat_biotic_stress", 32, 42, "wheat"),
    ("durum_wheat_development", 32, 24, "wheat"),
    ("embryo", 16, 8, "arabidopsis"),
    ("eucalyptus", 16, 42, "eucalyptus"),
    ("euphorbia", 18, 24, "euphorbia"),
    ("gc_drought", 12, 12, "gc drought"),
    ("germination", 30, 16, "arabidopsis"),
    ("grape_developmental", 40, 50, "grape"),
    ("guard_cell", 30, 24, "guard cell"),
    ("gynoecium", 12, 16, "gynoecium"),
    ("heterodera_schachtii", 12, 16, "heterodera"),
    ("hnahal", 0, 0, "hnahal"),
    ("human_body_map_2", 28, 20, "human"),
    ("human_developmental", 32, 24, "human"),
    ("human_developmental_SpongeLab", 0, 0, "human"),
    ("human_diseased", 0, 0, "human"),
    ("kalanchoe", 24, 16, "kalanchoe"),
    ("kalanchoe_time_course_analysis", 18, 16, "kalanchoe"),
    ("klepikova", 30, 16, "arabidopsis"),
    ("lateral_root_initiation", 40, 64, "arabidopsis"),
    ("light_series", 30, 30, "light series"),
    ("lipid_map", 64, 16, "lipid map"),
    ("little_millet", 32, 12, "little_millet"),
    ("lupin_lcm_leaf", 32, 32, "lupin"),
    ("lupin_lcm_pod", 32, 32, "lupin"),
    ("lupin_lcm_stem", 32, 32, "lupin"),
    ("lupin_pod_seed", 32, 32, "lupin"),
    ("lupin_whole_plant", 32, 32, "lupin"),
    ("maize_RMA_linear", 20, 30, "maize"),
    ("maize_RMA_log", 20, 30, "maize"),
    ("maize_atlas", 25, 40, "maize"),
    ("maize_atlas_v5", 25, 40, "maize"),
    ("maize_buell_lab", 24, 50, "maize"),
    ("maize_early_seed", 24, 50, "maize"),
    ("maize_ears", 20, 16, "maize"),
    ("maize_embryonic_leaf_development", 18, 24, "maize"),
    ("maize_enzyme", 40, 8, "maize"),
    ("maize_gdowns", 40, 40, "maize"),
    ("maize_iplant", 20, 16, "maize"),
    ("maize_kernel_v5", 25, 8, "maize"),
    ("maize_leaf_gradient", 20, 12, "maize"),
    ("maize_lipid_map", 24, 12, "maize"),
    ("maize_metabolite", 64, 5, "maize"),
    ("maize_nitrogen_use_efficiency", 24, 24, "maize"),
    ("maize_rice_comparison", 16, 12, "maize"),
    ("maize_root", 30, 255, "maize"),
    ("maize_stress_v5", 25, 20, "maize"),
    ("mangosteen_aril_vs_rind", 8, 8, "mangosteen"),
    ("mangosteen_callus", 8, 8, "mangosteen"),
    ("mangosteen_diseased_vs_normal", 8, 12, "mangosteen"),
    ("mangosteen_fruit_ripening", 8, 8, "mangosteen"),
    ("mangosteen_seed_development", 8, 12, "mangosteen"),
    ("mangosteen_seed_development_germination", 8, 8, "mangosteen"),
    ("mangosteen_seed_germination", 8, 12, "mangosteen"),
    ("marchantia_organ_stress", 32, 32, "marchantia"),
    ("medicago_mas", 28, 22, "medicago"),
    ("medicago_rma", 28, 22, "medicago"),
    ("medicago_root", 18, 16, "medicago"),
    ("medicago_root_v5", 64, 16, "medicago"),
    ("medicago_seed", 18, 15, "medicago"),
    ("meristem_db", 30, 18, "meristem db"),
    ("meristem_db_new", 0, 0, "meristem db new"),
    ("mouse_db", 15, 18, "mouse"),
    ("oat", 36, 24, "oat"),
    ("phelipanche", 16, 32, "phelipanche"),
    ("physcomitrella_db", 40, 40, "physcomitrella"),
    ("poplar", 70, 40, "poplar"),
    ("poplar_hormone", 18, 12, "poplar"),
    ("poplar_leaf", 70, 40, "poplar"),
    ("poplar_xylem", 70, 40, "poplar"),
    ("potato_dev", 40, 15, "potato"),
    ("potato_stress", 40, 12, "potato"),
    ("potato_wounding", 40, 12, "potato"),
    ("rice_abiotic_stress_sc_pseudobulk", 16, 64, "rice"),
    ("rice_drought_heat_stress", 24, 12, "rice"),
    ("rice_leaf_gradient", 18, 12, "rice"),
    ("rice_maize_comparison", 18, 12, "maize"),
    ("rice_mas", 28, 26, "rice"),
    ("rice_metabolite", 25, 6, "rice"),
    ("rice_rma", 28, 26, "rice"),
    ("rice_root", 16, 8, "rice"),
    ("rohan", 0, 0, "rohan"),
    ("root", 30, 24, "root"),
    ("root_Schaefer_lab", 16, 20, "root Schaefer lab"),
    ("rpatel", 0, 0, "rpatel"),
    ("seed_db", 30, 64, "seed db"),
    ("seedcoat", 22, 12, "oat"),
    ("selaginella", 18, 36, "selaginella"),
    ("shoot_apex", 12, 8, "arabidopsis"),
    ("silique", 12, 64, "arabidopsis"),
    ("single_cell", 24, 32, "arabidopsis"),
    ("sorghum_atlas_w_BS_cells", 24, 24, "sorghum"),
    ("sorghum_comparative_transcriptomics", 18, 40, "sorghum"),
    ("sorghum_developmental", 16, 12, "sorghum"),
    ("sorghum_developmental_2", 16, 32, "sorghum"),
    ("sorghum_flowering_activation", 16, 32, "sorghum"),
    ("sorghum_low_phosphorus", 24, 16, "sorghum"),
    ("sorghum_nitrogen_stress", 16, 32, "sorghum"),
    ("sorghum_nitrogen_use_efficiency", 24, 12, "sorghum"),
    ("sorghum_phosphate_stress", 24, 32, "sorghum"),
    ("sorghum_plasma", 24, 16, "sorghum"),
    ("sorghum_saline_alkali_stress", 16, 32, "sorghum"),
    ("sorghum_stress", 16, 12, "sorghum"),
    ("sorghum_strigolactone_variation", 16, 32, "sorghum"),
    ("sorghum_sulfur_stress", 24, 32, "sorghum"),
    ("sorghum_temperature_stress", 16, 32, "sorghum"),
    ("sorghum_vascularization_and_internode", 24, 32, "sorghum"),
    ("soybean", 36, 22, "soybean"),
    ("soybean_embryonic_development", 24, 42, "soybean"),
    ("soybean_heart_cotyledon_globular", 24, 42, "soybean"),
    ("soybean_senescence", 24, 8, "soybean"),
    ("soybean_severin", 18, 18, "soybean"),
    ("spruce", 16, 24, "spruce"),
    ("strawberry", 16, 24, "strawberry"),
    ("striga", 24, 42, "striga"),
    ("sugarcane_culms", 32, 16, "sugarcane"),
    ("sugarcane_leaf", 32, 32, "sugarcane"),
    ("sunflower", 16, 16, "sunflower"),
    ("thellungiella_db", 40, 40, "thellungiella"),
    ("tomato", 18, 18, "tomato"),
    ("tomato_ils", 20, 12, "tomato"),
    ("tomato_ils2", 20, 12, "tomato"),
    ("tomato_ils3", 20, 16, "tomato"),
    ("tomato_meristem", 18, 24, "tomato"),
    ("tomato_renormalized", 18, 18, "tomato"),
    ("tomato_root", 18, 12, "tomato"),
    ("tomato_root_field_pot", 18, 12, "tomato"),
    ("tomato_s_pennellii", 20, 24, "tomato"),
    ("tomato_seed", 24, 16, "tomato"),
    ("tomato_shade_mutants", 16, 20, "tomato"),
    ("tomato_shade_timecourse", 16, 16, "tomato"),
    ("tomato_trait", 100, 0, "tomato"),
    ("triphysaria", 16, 32, "triphysaria"),
    ("triticale", 30, 18, "triticale"),
    ("triticale_mas", 30, 30, "triticale"),
    ("tung_tree", 16, 16, "tung_tree"),
    ("wheat", 32, 16, "wheat"),
    ("wheat_abiotic_stress", 32, 16, "wheat"),
    ("wheat_embryogenesis", 32, 50, "wheat"),
    ("wheat_meiosis", 32, 24, "wheat"),
    ("wheat_root", 32, 16, "wheat"),
    ("willow", 32, 16, "willow"),
]

# databases that use utf8mb4 charset (all others default to latin1)
_UTF8MB4 = {
    "actinidia_bud_development", "actinidia_flower_fruit_development",
    "actinidia_postharvest", "actinidia_vegetative_growth", "apple",
    "barley_seed", "barley_spike_meristem_v3",
    "brachypodium_Bd21", "brachypodium_grains", "brachypodium_metabolites_map",
    "brassica_rapa",
    "cacao_developmental_atlas", "cacao_developmental_atlas_sca",
    "cacao_drought_diurnal_atlas", "cacao_drought_diurnal_atlas_sca",
    "cacao_infection", "cacao_leaf", "cacao_meristem_atlas_sca", "cacao_seed_atlas_sca",
    "canola_seed",
    "cassava_atlas", "cassava_cbb", "cassava_eacmv",
    "circadian_mutants", "cuscuta", "cuscuta_early_haustoriogenesis", "cuscuta_lmd",
    "dna_damage",
    "durum_wheat_abiotic_stress", "durum_wheat_biotic_stress", "durum_wheat_development",
    "eucalyptus", "euphorbia",
    "gc_drought", "gynoecium", "heterodera_schachtii",
    "kalanchoe_time_course_analysis",
    "lateral_root_initiation", "lipid_map", "little_millet",
    "lupin_lcm_leaf", "lupin_lcm_pod", "lupin_lcm_stem", "lupin_pod_seed", "lupin_whole_plant",
    "maize_atlas_v5", "maize_embryonic_leaf_development", "maize_kernel_v5",
    "maize_lipid_map", "maize_nitrogen_use_efficiency", "maize_stress_v5",
    "mangosteen_aril_vs_rind", "mangosteen_callus", "mangosteen_diseased_vs_normal",
    "mangosteen_fruit_ripening", "mangosteen_seed_development",
    "mangosteen_seed_development_germination", "mangosteen_seed_germination",
    "marchantia_organ_stress",
    "medicago_root", "medicago_root_v5",
    "oat", "phelipanche", "poplar_hormone", "potato_wounding",
    "rice_abiotic_stress_sc_pseudobulk", "rice_drought_heat_stress", "rice_root",
    "silique",
    "sorghum_atlas_w_BS_cells", "sorghum_comparative_transcriptomics",
    "sorghum_developmental", "sorghum_developmental_2", "sorghum_flowering_activation",
    "sorghum_low_phosphorus", "sorghum_nitrogen_stress", "sorghum_nitrogen_use_efficiency",
    "sorghum_phosphate_stress", "sorghum_plasma", "sorghum_saline_alkali_stress",
    "sorghum_stress", "sorghum_strigolactone_variation", "sorghum_sulfur_stress",
    "sorghum_temperature_stress", "sorghum_vascularization_and_internode",
    "soybean_embryonic_development", "soybean_heart_cotyledon_globular", "soybean_senescence",
    "spruce", "strawberry",
    "sugarcane_culms", "sugarcane_leaf",
    "tomato_root", "tomato_root_field_pot", "tomato_seed",
    "tomato_shade_mutants", "tomato_shade_timecourse",
    "triphysaria",
    "wheat_abiotic_stress", "wheat_meiosis", "wheat_root",
}
# fmt: on

SIMPLE_EFP_DATABASE_SCHEMAS: Dict[str, DatabaseSpec] = {
    n: _schema(p, b, s, "utf8mb4" if n in _UTF8MB4 else "latin1")
    for n, p, b, s in _SPECS
}

__all__: List[str] = ["SIMPLE_EFP_DATABASE_SCHEMAS", "ColumnSpec", "DatabaseSpec"]
