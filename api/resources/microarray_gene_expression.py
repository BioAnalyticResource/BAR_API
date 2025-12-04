from flask_restx import Namespace, Resource
from markupsafe import escape
from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.models.efp_dynamic import SIMPLE_EFP_SAMPLE_MODELS
from api.utils.bar_utils import BARUtils
from api.utils.world_efp_utils import WorldeFPUtils
import json

# pull the dynamic model so this resource stays in sync with the schema catalog
EcotypesSampleData = SIMPLE_EFP_SAMPLE_MODELS["arabidopsis_ecotypes"]

microarray_gene_expression = Namespace(
    "Microarray Gene Expression",
    description="Microarray (probe-based) Gene Expression data from the BAR Databases",
    path="/microarray_gene_expression",
)


@microarray_gene_expression.route("/world_efp/<string:species>/<string:gene_id>")
class GetWorldeFPExpression(Resource):
    @microarray_gene_expression.param("species", _in="path", default="arabidopsis")
    @microarray_gene_expression.param("gene_id", _in="path", default="At1g01010")
    def get(self, species="", gene_id=""):
        """This end point returns World Efp gene expression data"""
        species = escape(species)
        gene_id = escape(gene_id)

        if species == "arabidopsis":
            if not BARUtils.is_arabidopsis_gene_valid(gene_id):
                return BARUtils.error_exit("Invalid gene id")
        else:
            return BARUtils.error_exit("Invalid species")
        subquery = (
            db.select(AtAgiLookup.probeset)
            .where(AtAgiLookup.agi == gene_id)
            .order_by(AtAgiLookup.date.desc())
            .limit(1)
            .subquery()
        )

        sq_query = db.session.query(subquery)
        if sq_query.count() > 0:
            sq_result = sq_query[0][0]
        else:
            return BARUtils.error_exit("There are no data found for the given gene")

        rows = db.session.execute(
            db.select(
                EcotypesSampleData.data_probeset_id, EcotypesSampleData.data_signal, EcotypesSampleData.data_bot_id
            ).where(EcotypesSampleData.data_probeset_id == sq_result)
        ).all()
        final_json = {}

        if len(rows) > 0:
            for row in rows:
                if row[2][5:8] not in final_json:
                    final_json[row[2][5:8]] = WorldeFPUtils.wrap_json(row[2][5:8], row[2], row[1], row[0])
                elif row[2][5:8] in final_json:
                    final_json[row[2][5:8]]["values"].update({row[2]: row[1]})
            return BARUtils.success_exit(final_json)
        else:
            return BARUtils.error_exit("There are no data found for the given gene")
    
# endpoint made by reena
# return view and database mappings for a given species
@microarray_gene_expression.route("/<string:species>/databases")
class GetDatabases(Resource):
    @microarray_gene_expression.param("species", _in="path", default="arabidopsis")
    def get(self, species=""):
        """This endpoint returns available database and view mappings for a given species"""
        species = escape(species)

        species_databases = {
            "actinidia": {
                "Bud_Development": "actinidia_bud_development",
                "Flower_Fruit_Development": "actinidia_flower_fruit_development",
                "Postharvest": "actinidia_postharvest",
                "Vegetative_Growth": "actinidia_vegetative_growth"
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
                "Tissue_Specific": "atgenexp_plus"
            },
            "arabidopsis seedcoat": {
                "Seed_Coat": "seedcoat"
            },
            "arachis": {
                "Arachis_Atlas": "arachis"
            },
            "barley": {
                "barley_mas": "barley_mas",
                "barley_rma": "barley_rma"
            },
            "brachypodium": {
                "Brachypodium_Atlas": "brachypodium",
                "Brachypodium_Grains": "brachypodium_grains",
                "Brachypodium_Spikes": "brachypodium_Bd21",
                "Photo_Thermocycle": "brachypodium_photo_thermocycle"
            },
            "brassica rapa": {
                "Embryogenesis": "brassica_rapa"
            },
            "cacao ccn": {
                "Developmental_Atlas": "cacao_developmental_atlas",
                "Drought_Diurnal_Atlas": "cacao_drought_diurnal_atlas"
            },
            "cacao sca": {
                "Developmental_Atlas": "cacao_developmental_atlas_sca",
                "Drought_Diurnal_Atlas": "cacao_drought_diurnal_atlas_sca",
                "Meristem_Atlas": "cacao_meristem_atlas_sca",
                "Seed_Atlas": "cacao_seed_atlas_sca"
            },
            "cacao tc": {
                "Cacao_Infection": "cacao_infection",
                "Cacao_Leaf": "cacao_leaf"
            },
            "camelina": {
                "Developmental_Atlas_FPKM": "camelina",
                "Developmental_Atlas_TPM": "camelina_tpm"
            },
            "cannabis": {
                "Cannabis_Atlas": "cannabis"
            },
            "canola": {
                "Canola_Seed": "canola_seed"
            },
            "eutrema": {
                "Eutrema": "thellungiella_db"
            },
            "grape": {
                "grape_developmental": "grape_developmental"
            },
            "kalanchoe": {
                "Light_Response": "kalanchoe"
            },
            "little millet": {
                "Life_Cycle": "little_millet"
            },
            "lupin": {
                "LCM_Leaf": "lupin_lcm_leaf",
                "LCM_Pod": "lupin_lcm_pod",
                "LCM_Stem": "lupin_lcm_stem",
                "Whole_Plant": "lupin_whole_plant"
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
                "maize_rice_comparison": "maize_rice_comparison"
            },
            "mangosteen": {
                "Aril_vs_Rind": "mangosteen_aril_vs_rind",
                "Callus": "mangosteen_callus",
                "Diseased_vs_Normal": "mangosteen_diseased_vs_normal",
                "Fruit_Ripening": "mangosteen_fruit_ripening",
                "Seed_Development": "mangosteen_seed_development",
                "Seed_Germination": "mangosteen_seed_germination"
            },
            "medicago": {
                "medicago_mas": "medicago_mas",
                "medicago_rma": "medicago_rma",
                "medicago_seed": "medicago_seed"
            },
            "poplar": {
                "Poplar": "poplar",
                "PoplarTreatment": "poplar"
            },
            "potato": {
                "Potato_Developmental": "potato_dev",
                "Potato_Stress": "potato_stress"
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
                "ricestress_rma": "rice_rma"
            },
            "soybean": {
                "soybean": "soybean",
                "soybean_embryonic_development": "soybean_embryonic_development",
                "soybean_heart_cotyledon_globular": "soybean_heart_cotyledon_globular",
                "soybean_senescence": "soybean_senescence",
                "soybean_severin": "soybean_severin"
            },
            "strawberry": {
                "Developmental_Map_Strawberry_Flower_and_Fruit": "strawberry",
                "Strawberry_Green_vs_White_Stage": "strawberry"
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
                "Tomato_Meristem": "tomato_meristem"
            },
            "triticale": {
                "triticale": "triticale",
                "triticale_mas": "triticale_mas"
            },
            "wheat": {
                "Developmental_Atlas": "wheat",
                "Wheat_Abiotic_Stress": "wheat_abiotic_stress",
                "Wheat_Embryogenesis": "wheat_embryogenesis",
                "Wheat_Meiosis": "wheat_meiosis"
            }
        }

        if species not in species_databases:
            return BARUtils.error_exit("Invalid species")

        return BARUtils.success_exit({
            "species": species,
            "databases": species_databases[species]
        })


# endpoint made by reena
# return control and sample mappings for a given species
@microarray_gene_expression.route("/<string:species>/<string:view>/samples")
class GetSamples1(Resource):
    """This endpoint returns control and sample group mappings for a given species and view (or all views)"""

    @microarray_gene_expression.param("species", _in="path", default="arabidopsis")
    @microarray_gene_expression.param("view", _in="path", default="Abiotic_Stress")
    def get(self, species="", view=""):
        """This endpoint returns control and sample group mappings for a given species and view (or all views)"""
        species = escape(species.lower())
        view = escape(view)

        try:
            with open("data/efp_info/efp_species_view_info.json") as f:
                all_species_data = json.load(f)
        except Exception as e:
            return BARUtils.error_exit(f"Data file missing or invalid: {e}")

        if species not in all_species_data:
            return BARUtils.error_exit("Invalid species")

        species_data = all_species_data[species]["data"]

        # if user requests all views
        if view.lower() == "all":
            return BARUtils.success_exit({
                "species": species,
                "views": species_data["views"]
            })

        # otherwise check single view
        if view not in species_data["views"]:
            return BARUtils.error_exit("Invalid view for this species")

        return BARUtils.success_exit({
            "species": species,
            "view": view,
            "groups": species_data["views"][view]["groups"]
        })
