"""
Date: Aug 2024
Author: Vincent Lau
LLaMA endpoiint for plant connectome GPT results
"""

from flask_restx import Namespace, Resource
from markupsafe import escape
from api.utils.bar_utils import BARUtils
from api import db
from api.models.llama3 import Summaries


llama3 = Namespace("LLaMA", description="Endpoint for retreiving LLaMA3 results", path="/LLaMA")


@llama3.route("/<string:gene_id>")
class Llama(Resource):
    @llama3.param("gene_id", _in="path", default="AT3G18850")
    def get(self, gene_id=""):
        """
        Endpoint returns Llama3 summary of plant connectome for a given gene
        - Arabidopsis - e.g. AT3G18850
        """

        gene_id = escape(gene_id.upper())

        if BARUtils.is_arabidopsis_gene_valid(gene_id):
            rows = (
                db.session.execute(db.select(Summaries).where(Summaries.gene_id == gene_id))
                .first()
            )

            if len(rows) == 0:
                return (
                    BARUtils.error_exit("There are no data found for the given gene"),
                    400,
                )
            else:
                res = {
                            "summary": rows[0].summary,
                            "gene_id": rows[0].gene_id,
                            "bert_score": rows[0].bert_score,
                    }
                return BARUtils.success_exit(res)
        else:
            return BARUtils.error_exit("Invalid gene id"), 400
