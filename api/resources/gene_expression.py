import re

from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy import func

from api import db
from api.models.annotations_lookup import AtAgiLookup
from api.models.efp_dynamic import SAMPLE_DATA_MODELS
from api.utils.bar_utils import BARUtils, load_combined_master

gene_expression = Namespace(
    "Gene Expression",
    description="Gene expression data from BAR eFP databases",
    path="/gene_expression",
)

_AGI_RE = re.compile(r"^AT[12345CM]G\d{5}(\.\d+)?$", re.I)


@gene_expression.route("/expression/<string:database>/<path:gene_id>")
@gene_expression.param("database", "Database name (e.g. klepikova, atgenexp, embryo)", _in="path", default="klepikova")
@gene_expression.param(
    "gene_id", "Gene ID (e.g. AT1G01010 for Arabidopsis, or a probeset like 261585_at)", _in="path", default="AT1G01010"
)
class GeneExpression(Resource):
    def get(self, database, gene_id):
        """Returns expression values for a gene from a given eFP database."""
        database = str(escape(database))
        gene_id = str(escape(gene_id))
        upper_id = gene_id.upper()

        master = load_combined_master()
        db_info = master["databases"].get(database)
        model = SAMPLE_DATA_MODELS.get(database)
        if not db_info or not model:
            return BARUtils.error_exit("Invalid species or gene ID"), 400

        pattern = master["gene_id_patterns"].get(db_info.get("gene_id_pattern") or db_info["species"])
        if not BARUtils.is_valid_gene_id(pattern, upper_id):
            return BARUtils.error_exit("Invalid species or gene ID"), 400

        query_id = upper_id
        if db_info["identifier_type"] == "probeset" and _AGI_RE.fullmatch(upper_id):
            rows = db.session.execute(
                db.select(AtAgiLookup.probeset)
                .where(AtAgiLookup.agi == upper_id)
                .order_by(AtAgiLookup.date.desc())
                .limit(1)
            ).all()

            if len(rows) == 0:
                return BARUtils.error_exit("Invalid species or gene ID"), 400

            query_id = rows[0][0]

        rows = db.session.execute(
            db.select(model.data_bot_id, model.data_signal).where(func.upper(model.data_probeset_id) == query_id.upper())
        ).all()

        if len(rows) == 0:
            return BARUtils.error_exit("There are no data found for the given gene"), 400

        res = {
            "gene_id": gene_id,
            "probset_id": query_id,
            "database": database,
            "record_count": len(rows),
            "data": [{"name": name, "value": str(value)} for name, value in rows],
        }

        return BARUtils.success_exit(res)
