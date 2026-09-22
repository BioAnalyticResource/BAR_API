from flask_restx import Namespace, Resource
from markupsafe import escape
from api import db
from api.models.umap_dynamic import UMAP_COORDS_MODELS, UMAP_DATABASES, UMAP_EXPRESSION_MODELS
from api.utils.bar_utils import BARUtils, load_combined_master

umap_gene_expression = Namespace(
    "UMAP Gene Expression",
    description="UMAP coordinates and single cell gene expression data from the BAR Databases",
    path="/umap_gene_expression",
)


class UMAPUtils:
    @staticmethod
    def get_tables(database):
        """This function sets the tables and species for a UMAP database
        :param database: name of BAR database
        :return: dict with the coordinates table, expression table and species
        """
        # Set database
        database = str(database)
        if database not in UMAP_DATABASES:
            return {"success": False, "error": "Invalid database", "error_code": 400}

        coords_table = UMAP_COORDS_MODELS[database]
        expression_table = UMAP_EXPRESSION_MODELS[database]
        species = UMAP_DATABASES[database]

        return {"success": True, "coords_table": coords_table, "expression_table": expression_table, "species": species}


@umap_gene_expression.route("/<string:database>")
class GetUMAPCoordinates(Resource):
    @umap_gene_expression.param("database", _in="path", default="arabidopsis_NIE_umap")
    def get(self, database=""):
        """This end point returns the UMAP coordinates of every cell"""
        database = escape(database)

        tables = UMAPUtils.get_tables(database)
        if not tables["success"]:
            return BARUtils.error_exit(tables["error"]), tables["error_code"]

        table = tables["coords_table"]
        rows = db.session.execute(db.select(table.cell_id, table.umap_1, table.umap_2, table.cell_type)).all()

        data = {}
        for row in rows:
            data[row[0]] = {"umap_1": row[1], "umap_2": row[2], "cell_type": row[3]}

        return BARUtils.success_exit(data)


@umap_gene_expression.route("/<string:database>/<string:gene_id>")
class GetUMAPGeneExpression(Resource):
    @umap_gene_expression.param("database", _in="path", default="arabidopsis_NIE_umap")
    @umap_gene_expression.param("gene_id", _in="path", default="At1g01010")
    def get(self, database="", gene_id=""):
        """This end point returns the sparse UMAP gene expression data, keyed by cell id"""
        database = escape(database)
        gene_id = escape(gene_id)

        tables = UMAPUtils.get_tables(database)
        if not tables["success"]:
            return BARUtils.error_exit(tables["error"]), tables["error_code"]

        pattern = load_combined_master()["gene_id_patterns"][tables["species"]]
        if not BARUtils.is_valid_gene_id(pattern, gene_id):
            return BARUtils.error_exit("Invalid gene id"), 400

        table = tables["expression_table"]
        rows = db.session.execute(db.select(table.expression).where(table.gene_id == gene_id)).scalars().all()

        if len(rows) == 0:
            return BARUtils.error_exit("There are no data found for the given gene"), 400

        return BARUtils.success_exit(rows[0])
