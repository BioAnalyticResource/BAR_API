"""
Date: Nov 2021
Author: Vincent Lau
Interactions (Protein-Protein, Protein-DNA, etc.) endpoint
"""

from flask_restx import Namespace, Resource
from api.models.rice_interactions import Interactions as rice_interactions
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from sqlalchemy import or_
from api.utils.bar_utils import BARUtils

itrns = Namespace(
    "Interactions",
    description="Interactions (protein-protein, protein-DNA, etc) endpoint",
    path="/interactions",
)


@itrns.route("/<species>/<query_gene>")
class Interactions(Resource):
    @itrns.param("species", _in="path", default="rice")
    @itrns.param("query_gene", _in="path", default="LOC_Os01g52560")
    def get(self, species="", query_gene=""):
        """
        Returns the protein-protein interactions for a particular query gene
        Supported species: 'rice'
        """

        species = escape(species.lower())
        query_gene = escape(query_gene)
        if species == "rice" and BARUtils.is_rice_gene_valid(query_gene):
            try:
                rows = rice_interactions.query.filter(
                    or_(
                        rice_interactions.Protein1 == query_gene,
                        rice_interactions.Protein2 == query_gene,
                    )
                ).all()
                if len(rows) == 0:
                    return (
                        BARUtils.error_exit(
                            "There are no data found for the given gene"
                        ),
                        400,
                    )
                else:
                    print(rows)
                    # res = []
                    res = [
                        {
                            "protein_1": i.Protein1,
                            "protein_2": i.Protein2,
                            "total_hits": i.Total_hits,
                            "Num_species": i.Num_species,
                            "Quality": i.Quality,
                            "pcc": i.Pcc,
                        }
                        for i in rows
                    ]
                    return {
                        "wasSuccessful": True,
                        "data": res
                    }
            except OperationalError:
                return BARUtils.error_exit("An internal error has occurred"), 500
        else:
            return BARUtils.error_exit("Invalid species or gene ID"), 400
