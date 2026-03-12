from flask_restx import Namespace, Resource
from markupsafe import escape

from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.services.efp_data import query_efp_database_dynamic, DYNAMIC_DATABASE_SCHEMAS

gene_expression = Namespace(
    'Gene Expression',
    description='Gene expression data from BAR eFP databases',
    path='/gene_expression',
)


@gene_expression.route("/expression/<string:database>/<string:gene_id>")
@gene_expression.doc(
    description="Retrieve gene expression values from a specified eFP database."
)
@gene_expression.param(
    "gene_id",
    "Gene ID (AGI format like AT1G01010 or probeset like 261585_at)",
    _in="path",
    default="AT1G01010",
)
@gene_expression.param(
    "database",
    "Database name (e.g., sample_data, klepikova, single_cell)",
    _in="path",
    default="klepikova",
)
class GeneExpression(Resource):
    def get(self, database, gene_id):

        database = escape(database)
        gene_id = escape(gene_id)

        upper_id = gene_id.upper()
        is_agi = upper_id.startswith("AT") and "G" in upper_id

        # for databases that store probeset IDs, convert AGI to probeset via at_agi_lookup
        schema = DYNAMIC_DATABASE_SCHEMAS.get(str(database))
        if schema and is_agi and schema.get("identifier_type") == "probeset":
            subquery = (
                db.select(AtAgiLookup.probeset)
                .where(AtAgiLookup.agi == upper_id)
                .order_by(AtAgiLookup.date.desc())
                .limit(1)
                .subquery()
            )
            sq_query = db.session.query(subquery)
            if sq_query.count() > 0:
                gene_id = sq_query[0][0]
            else:
                return {"success": False, "error": f"No probeset found for {gene_id}", "error_code": 404}, 404

        result = query_efp_database_dynamic(database, gene_id, sample_ids=None)

        if result["success"]:
            return result
        else:
            return result, result.get("error_code", 500)


gene_expression.add_resource(GeneExpression, '/expression/<string:database>/<string:gene_id>')
