from flask_restx import Namespace, Resource
from markupsafe import escape

from api.services.efp_data import query_efp_database_dynamic

efp_proxy_ns = Namespace(
    'efp Proxy',
    description='Gene expression data from BAR eFP databases',
    path='/efp_proxy',
)


@efp_proxy_ns.route("/expression/<string:database>/<string:gene_id>")
@efp_proxy_ns.doc(
    description="Retrieve gene expression values from a specified eFP database."
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


efp_proxy_ns.add_resource(EFPExpression, '/expression/<string:database>/<string:gene_id>')
