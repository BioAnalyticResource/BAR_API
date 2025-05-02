"""
Date: Nov 2021
Author: Vincent Lau
Interactions (Protein-Protein, Protein-DNA, etc.) endpoint
"""

from flask_restx import Namespace, Resource, fields
from flask import request, jsonify
from markupsafe import escape
from api.utils.bar_utils import BARUtils
from api.utils.mfinder_utils import MfinderUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from api import db
from api.models.rice_interactions import Interactions as RiceInteractions
from sqlalchemy import or_

itrns = Namespace(
    "Interactions",
    description="Interactions (protein-protein, protein-DNA, etc) endpoint",
    path="/interactions",
)

itrns_post_ex = itrns.model(
    "ItrnsRiceGenes",
    {
        "species": fields.String(required=True, example="rice"),
        "genes": fields.List(
            required=True,
            example=["LOC_Os01g01080", "LOC_Os01g73310"],
            cls_or_instance=fields.String,
        ),
    },
)

post_int_data = itrns.model(
    "MFinderData",
    {
        "data": fields.List(
            required=True,
            example=[["AT5G67420", "AT1G12110"], ["AT5G67420", "AT1G08090"]],
            cls_or_instance=fields.List(fields.String),
        ),
    },
)


class GeneIntrnsSchema(Schema):
    species = marshmallow_fields.String(required=True)
    genes = marshmallow_fields.List(cls_or_instance=marshmallow_fields.String)


class MFinderDataSchema(Schema):
    data = marshmallow_fields.List(marshmallow_fields.List(marshmallow_fields.String()))


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
            rows = (
                db.session.execute(
                    db.select(RiceInteractions).where(
                        or_(
                            RiceInteractions.Protein1 == query_gene,
                            RiceInteractions.Protein2 == query_gene,
                        ),
                    )
                )
                .scalars()
                .all()
            )

            if len(rows) == 0:
                return (
                    BARUtils.error_exit("There are no data found for the given gene"),
                    400,
                )
            else:
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
                return BARUtils.success_exit(res)
        else:
            return BARUtils.error_exit("Invalid species or gene ID"), 400


@itrns.route("/")
class InteractionsPost(Resource):
    @itrns.expect(itrns_post_ex)
    def post(self):
        """
        Returns the protein-protein interactions for a particular query genes
        Supported species: 'rice'
        """

        json_data = request.get_json()

        try:
            json_data = GeneIntrnsSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        species = json_data["species"].lower()
        genes = json_data["genes"]

        if species == "rice":
            for gene in genes:
                if not BARUtils.is_rice_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

            rows = (
                db.session.execute(
                    db.select(RiceInteractions).where(
                        or_(
                            RiceInteractions.Protein1.in_(genes),
                            RiceInteractions.Protein2.in_(genes),
                        ),
                    )
                )
                .scalars()
                .all()
            )

        else:
            return BARUtils.error_exit("Invalid species"), 400

        if len(rows) > 0:
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
            return BARUtils.success_exit(res)
        else:
            return BARUtils.error_exit("No data for the given species/genes"), 400


@itrns.route("/mfinder")
class MFinder(Resource):
    @itrns.expect(post_int_data)
    def post(self):
        """This endpoint was originally written by Vincent Lau to return mFinder
        results to AGENT in his express node.JS app. However Tianhui Zhao refactored
        to the BAR_API
        """
        data = request.get_json()
        # Validate json
        try:
            data = MFinderDataSchema().load(data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        filtered_valid_arr = MfinderUtils.input_validation(data["data"])
        if isinstance(filtered_valid_arr, str):
            return BARUtils.error_exit(filtered_valid_arr), 400
        settings = MfinderUtils.settings_validation(data.get("options", {}))
        ret_json = MfinderUtils.create_files_and_mfinder(filtered_valid_arr, settings)
        return jsonify(MfinderUtils.beautify_results(ret_json))
