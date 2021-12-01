"""
Date: Nov 2021
Author: Vincent Lau
Localizations (for various species and their respective genes) endpoint
"""

from flask_restx import Namespace, Resource, fields
from flask import request
from api.models.rice_interactions import Rice_mPLoc as rice_loc_db
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.utils.bar_utils import BARUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields

loc = Namespace("Localizations", description="Sub-cellular gene localzation endpoint", path="/loc")


# Validation is done in a different way to keep things simple
class GeneLocationsSchema(Schema):
    species = marshmallow_fields.String(required=True)
    genes = marshmallow_fields.List(cls_or_instance=marshmallow_fields.String)


@loc.route("/<species>/<query_gene>")
class Localizations(Resource):
    @loc.param("species", _in="path", default="rice")
    @loc.param("query_gene", _in="path", default="LOC_Os01g52560.1")
    def get(self, species="", query_gene=""):
        """
        Returns the protein-protein interactions for a particular query gene
        Supported species: 'rice'
        """

        species = escape(species.lower())
        query_gene = escape(query_gene)
        if species == "rice" and BARUtils.is_rice_gene_valid(query_gene, True):
            try:
                rows = rice_loc_db.query.filter_by(gene_id=query_gene).all()
                if len(rows) == 0:
                    return (
                        BARUtils.error_exit(
                            "There are no data found for the given gene"
                        ),
                        400,
                    )
                else:
                    print(rows)
                    return {
                        "wasSuccessful": True,
                        "data": {
                            "gene": rows[0].gene_id,
                            "predicted_location": rows[0].pred_mPLoc,
                        }
                    }
            except OperationalError:
                return BARUtils.error_exit("An internal error has occurred"), 500
        else:
            return BARUtils.error_exit("Invalid species or gene ID"), 400


loc_post_ex = loc.model(
    "GeneIsoforms",
    {
        "species": fields.String(required=True, example="rice"),
        "genes": fields.List(
            required=True,
            example=["LOC_Os01g01080.1", "LOC_Os01g52560.1"],
            cls_or_instance=fields.String,
        ),
    },
)


@loc.route("/")
class LocalizationsPost(Resource):
    @loc.expect(loc_post_ex)
    def post(self):
        """
        Returns the protein-protein interactions for a particular multiple genes
        Supported species: 'rice'
        """

        json_data = request.get_json()
        data = {}

        # Validate json
        try:
            json_data = GeneLocationsSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        genes = json_data["genes"]
        species = json_data["species"].lower()

        if species == "rice":
            for gene in genes:
                if not BARUtils.is_rice_gene_valid(gene, True):
                    return BARUtils.error_exit("Invalid gene id"), 400

            try:
                rows = rice_loc_db.query.filter(rice_loc_db.gene_id.in_(genes)).all()
            except OperationalError:
                return BARUtils.error_exit("An internal error has occurred."), 500
        else:
            return BARUtils.error_exit("Invalid species"), 400

        if len(rows) > 0:
            for row in rows:
                if row.gene_id in data:
                    data[row.gene_id].append(row.pred_mPLoc)
                else:
                    data[row.gene_id] = []
                    data[row.gene_id].append(row.pred_mPLoc)

            return BARUtils.success_exit(data)

        else:
            return BARUtils.error_exit("No data for the given species/genes"), 400
