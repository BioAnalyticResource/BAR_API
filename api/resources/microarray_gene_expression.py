from flask_restx import Namespace, Resource
from markupsafe import escape
from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.models.arabidopsis_ecotypes import SampleData as EcotypesSampleData
from api.utils.bar_utils import BARUtils
from api.utils.world_efp_utils import WorldeFPUtils


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
        subquery = db.select(AtAgiLookup.probeset).where(AtAgiLookup.agi == gene_id).order_by(AtAgiLookup.date.desc()).limit(1).subquery()

        sq_query = db.session.query(subquery)
        if sq_query.count() > 0:
            sq_result = sq_query[0][0]
        else:
            return BARUtils.error_exit("There are no data found for the given gene")

        rows = db.session.execute(
            db.select(EcotypesSampleData.data_probeset_id, EcotypesSampleData.data_signal, EcotypesSampleData.data_bot_id).where(EcotypesSampleData.data_probeset_id == sq_result)
        ).all()
        final_json = {}

        if len(rows) > 0:
            for row in rows:
                if row[2][5:8] not in final_json:
                    final_json[row[2][5:8]] = WorldeFPUtils.wrap_json(row[2][5:8], row[2], row[1], row[0])
                elif row[2][5:8] in final_json:
                    final_json[row[2][5:8]]['values'].update({row[2] : row[1]})
            return BARUtils.success_exit(final_json)
        else:
            return BARUtils.error_exit("There are no data found for the given gene")
