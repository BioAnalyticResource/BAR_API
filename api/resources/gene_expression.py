from flask_restx import Namespace, Resource
from markupsafe import escape

from api.services.efp_data import query_efp_database_dynamic
from api.utils.bar_utils import BARUtils
from api.utils.gene_id_utils import (
    DATABASE_SPECIES,
    GeneIdUtils,
)

gene_expression = Namespace(
    "Gene Expression",
    description="Gene expression data from BAR eFP databases",
    path="/gene_expression",
)


@gene_expression.route("/expression/<string:database>/<string:gene_id>")
@gene_expression.doc(description="Retrieve gene expression values from a specified eFP database.")
@gene_expression.param(
    "gene_id",
    "Gene ID (e.g. AT1G01010 for Arabidopsis, or a probeset like 261585_at)",
    _in="path",
    default="AT1G01010",
)
@gene_expression.param(
    "database",
    "Database name (e.g. klepikova, atgenexp, sample_data)",
    _in="path",
    default="klepikova",
)
class GeneExpression(Resource):
    def get(self, database, gene_id):
        """Retrieve expression values for a gene from a given eFP database."""
        database = str(escape(database))
        gene_id = str(escape(gene_id))

        species = DATABASE_SPECIES.get(database)
        if species is None:
            return BARUtils.error_exit(f"Unknown database '{database}'"), 400

        if GeneIdUtils.is_probeset_id(gene_id):
            query_id = gene_id
        else:
            if not GeneIdUtils.validate_gene_id(gene_id, species):
                return BARUtils.error_exit(f"Invalid {species} gene ID: '{gene_id}'"), 400
            query_id = GeneIdUtils.normalize_gene_id(gene_id, species)

        result = query_efp_database_dynamic(database, query_id)

        if result["success"]:
            return BARUtils.success_exit(result)

        error_code = result.get("error_code", 500)
        if error_code == 404:
            return BARUtils.error_exit("No data found for the given gene"), 404
        if error_code == 503:
            return BARUtils.error_exit("Database not available"), 503
        return BARUtils.error_exit("An error occurred"), 500


gene_expression.add_resource(GeneExpression, "/expression/<string:database>/<string:gene_id>")
