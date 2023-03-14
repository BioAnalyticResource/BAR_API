"""
Date: Apr 2021
Author: Vince L
Sequence endpoint that returns the amino acid sequence of a given protein, with additional options
for predicted sequences (Phyre2) that we host
"""
from flask_restx import Namespace, Resource
from api.utils.bar_utils import BARUtils
from markupsafe import escape
from api import db
from sqlalchemy import text

sequence = Namespace("Sequence", description="Sequence API", path="/sequence")


@sequence.route("/<string:species>/<string:gene_id>")
class Sequence(Resource):
    @sequence.param("species", _in="path", default="tomato")
    @sequence.param("gene_id", _in="path", default="Solyc00g005445.1.1")
    def get(self, species="", gene_id=""):
        """
        Endpoint returns sequence for a given gene of a particular species
        Response JSON designed to be like current PHP one:
        https://bar.utoronto.ca/webservices/bar_araport/get_protein_sequence_by_identifier.php?locus=AT1G01010.1
        Species Supported:
        - Tomato (ITAG3.2) - e.g. Solyc00g005445.1.1
        """

        species = escape(species.lower())
        gene_id = escape(gene_id.capitalize())

        if species == "tomato":
            if BARUtils.is_tomato_gene_valid(gene_id, True):
                with db.engines["tomato_sequence"].connect() as conn:
                    results = conn.execute(
                        text(
                            "select gene_id, full_seq from tomato_3_2_sequence_info where gene_id = :gene"
                        ),
                        {"gene": gene_id},
                    )
                    rows = results.fetchall()

                    if len(rows) == 0:
                        return (
                            BARUtils.error_exit(
                                "There are no data found for the given gene"
                            ),
                            400,
                        )
                    else:
                        return {
                            "status": "success",
                            "result": [
                                {
                                    "length": len(rows[0].full_seq) - 1,
                                    "gene_id": rows[0].gene_id,
                                    "sequence": rows[0].full_seq,
                                }
                            ],
                        }
            else:
                return BARUtils.error_exit("Invalid gene id"), 400
        else:
            return BARUtils.error_exit("Invalid species"), 400
