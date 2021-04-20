"""
Date: Apr 2021
Author: Vince L
Sequence endpoint that returns the amino acid sequence of a given protein, with additional options
for predicted sequences (Phyre2) that we host
"""
from flask_restx import Namespace, Resource
from api.utils.bar_utils import BARUtils
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.tomato_seq import Sequence as tom_seq

sequence = Namespace("Sequence", description="Sequence API", path="/sequence")


@sequence.route("/<string:species>/<string:gene_id>")
class Sequence(Resource):
    @sequence.param("species", _in="path", default="tomato")
    @sequence.param("gene_id", _in="path", default="Solyc00g005445.1.1")
    def get(self, species="", gene_id=""):
        """
        Endpoint returns sequence for a given gene of a particular species
        Species Supported:
        - Tomato (ITAG3.2) - e.g. Solyc00g005445.1.1
        """

        species = escape(species.lower())
        gene_id = escape(gene_id.capitalize())

        if species == "tomato":
            if BARUtils.is_tomato_gene_valid(gene_id, True):
                try:
                    rows = tom_seq.query.filter_by(gene_id=gene_id).all()
                    if len(rows) == 0:
                        return BARUtils.error_exit("There are no data found for the given gene"), 400
                    else:
                        return {
                            "gene_id" : rows[0].gene_id,
                            "sequence": rows[0].full_seq,
                            "length": rows[0].full_seq_len,
                            "phyre_2_seq": rows[0].phyre_2_seq,
                            "phyre2_seq_start": rows[0].phyre2_seq_start,
                            "phyre2_seq_end": rows[0].phyre2_seq_end
                        }
                except OperationalError:
                    return BARUtils.error_exit("An internal error has occurred"), 500
            else:
                return BARUtils.error_exit("Invalid gene id"), 400
        else:
            return BARUtils.error_exit("Invalid species"), 400
