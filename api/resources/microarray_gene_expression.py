from flask_restx import Namespace, Resource
from markupsafe import escape
from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.models.efp_dynamic import SAMPLE_DATA_MODELS
from api.utils.bar_utils import BARUtils, load_combined_master
from api.utils.world_efp_utils import WorldeFPUtils
from sqlalchemy import func

EcotypesSampleData = SAMPLE_DATA_MODELS["arabidopsis_ecotypes"]

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
            pattern = load_combined_master()["gene_id_patterns"].get(species)  # 1:1 lookup of this species' regex
            if not BARUtils.is_valid_gene_id(pattern, gene_id):
                return BARUtils.error_exit("Invalid gene id")
        else:
            return BARUtils.error_exit("Invalid species")
        subquery = (
            db.select(AtAgiLookup.probeset)
            .where(func.lower(AtAgiLookup.agi) == gene_id.lower())
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


@microarray_gene_expression.route("/<string:species>/databases")
class GetDatabases(Resource):
    @microarray_gene_expression.param("species", _in="path", default="arabidopsis")
    def get(self, species=""):
        """Returns the databases and views available for a given species, sourced live from combined_master.json."""
        species = str(escape(species)).lower()

        master = load_combined_master()
        if species not in master["species"]:
            return BARUtils.error_exit("Invalid species")

        databases = {
            db_name: db_info
            for db_name, db_info in master["databases"].items()
            if db_info["species"] == species
        }

        # collapse each database's views (efp/eplant may name them differently) into one view_name -> database_name mapping
        views = {}
        for db_name, db_info in databases.items():
            for used_by in db_info["used_by"]:
                view_key = used_by["view"].replace(" ", "_")
                views[view_key] = db_name

        return BARUtils.success_exit({
            "species": species,
            "num_databases": len(databases),
            "num_views": len(views),
            "databases": views,
        })


@microarray_gene_expression.route("/<string:species>/<string:view>/samples")
class GetSamples1(Resource):
    @microarray_gene_expression.param("species", _in="path", default="arabidopsis")
    @microarray_gene_expression.param("view", _in="path", default="Abiotic_Stress")
    def get(self, species="", view=""):
        """This endpoint returns control and sample group mappings for a given species and view (or all views)"""
        species = str(escape(species)).lower()
        view = str(escape(view))

        master = load_combined_master()
        if species not in master["species"]:
            return BARUtils.error_exit("Invalid species")

        species_databases = {
            db_name: db_info
            for db_name, db_info in master["databases"].items()
            if db_info["species"] == species
        }

        # same view_name -> {database, platform, groups} collapsing as /databases
        all_views = {}
        for db_name, db_info in species_databases.items():
            for view_info in db_info["views"].values():
                view_key = view_info["display_name"].replace(" ", "_")
                all_views[view_key] = {
                    "database": db_name,
                    "platform": db_info["platform"],
                    "groups": view_info["sample_groups"],
                }

        if view.lower() == "all":
            return BARUtils.success_exit({"species": species, "views": all_views})

        if view not in all_views:
            return BARUtils.error_exit("Invalid view for this species")

        view_data = all_views[view]
        return BARUtils.success_exit({
            "species": species,
            "view": view,
            "database": view_data["database"],
            "platform": view_data["platform"],
            "groups": view_data["groups"],
        })
