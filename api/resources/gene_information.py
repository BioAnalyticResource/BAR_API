from flask_restx import Namespace, Resource, fields
from flask import request
from markupsafe import escape
from api.models.annotations_lookup import AgiAlias
from api.models.eplant2 import Isoforms as EPlant2Isoforms
from api.models.eplant_poplar import Isoforms as EPlantPoplarIsoforms
from api.models.eplant_tomato import Isoforms as EPlantTomatoIsoforms
from api.models.eplant_soybean import Isoforms as EPlantSoybeanIsoforms
from api.utils.bar_utils import BARUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from api import cache, db


gene_information = Namespace("Gene Information", description="Information about Genes", path="/gene_information")

# I think this is only needed for Swagger UI POST
gene_information_request_fields = gene_information.model(
    "GeneInformation",
    {
        "species": fields.String(required=True, example="arabidopsis"),
        "genes": fields.List(
            required=True,
            example=["AT1G01010", "AT1G01020"],
            cls_or_instance=fields.String,
        ),
    },
)


# Validation is done in a different way to keep things simple
class GeneInformationSchema(Schema):
    species = marshmallow_fields.String(required=True)
    genes = marshmallow_fields.List(cls_or_instance=marshmallow_fields.String)


@gene_information.route("/gene_alias/<string:species>/<string:gene_id>")
class GeneAliases(Resource):
    @gene_information.param("species", _in="path", default="arabidopsis")
    @gene_information.param("gene_id", _in="path", default="At3g24650")
    @cache.cached()
    def get(self, species="", gene_id=""):
        """This end point provides gene alias given a gene ID."""
        aliases = []

        # Escape input
        species = escape(species)
        gene_id = escape(gene_id)

        if species == "arabidopsis":
            if BARUtils.is_arabidopsis_gene_valid(gene_id):
                rows = db.session.execute(db.select(AgiAlias).where(AgiAlias.agi == gene_id)).scalars().all()
                [aliases.append(row.alias) for row in rows]
            else:
                return BARUtils.error_exit("Invalid gene id"), 400
        else:
            return BARUtils.error_exit("No data for the given species")

        # Return results if there are data
        if len(aliases) > 0:
            return BARUtils.success_exit(aliases)
        else:
            return BARUtils.error_exit("There are no data found for the given gene")


@gene_information.route("/gene_alias")
class PostGeneAliases(Resource):
    @gene_information.expect(gene_information_request_fields)
    def post(self):
        """This end point retrived gene aliases for a large dataset"""
        json_data = request.get_json()
        data = {}

        # Validate json
        try:
            json_data = GeneInformationSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        genes = json_data["genes"]
        species = json_data["species"]

        # Set species and check gene ID format
        if species == "arabidopsis":
            database = AgiAlias

            # Check if gene is valid
            for gene in genes:
                if not BARUtils.is_arabidopsis_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

        else:
            return BARUtils.error_exit("Invalid species"), 400

        # Query must be run individually for each species
        rows = db.session.execute(db.select(database).where(database.agi.in_(genes))).scalars().all()

        # If there are any isoforms found, return data
        data = []
        data_items = {}

        if len(rows) > 0:
            for row in rows:
                if row.agi in data_items.keys():
                    data_items[row.agi].append(row.agi)
                else:
                    data_items[row.agi] = []
                    data_items[row.agi].append(row.alias)

            for gene in data_items.keys():
                data.append({"gene": gene, "aliases": data_items[gene]})

            return BARUtils.success_exit(data)

        else:
            return BARUtils.error_exit("No data for the given species/genes"), 400


@gene_information.route("/gene_isoforms/<string:species>/<string:gene_id>")
class GeneIsoforms(Resource):
    @gene_information.param("species", _in="path", default="arabidopsis")
    @gene_information.param("gene_id", _in="path", default="AT1G01020")
    def get(self, species="", gene_id=""):
        """This end point provides gene isoforms given a gene ID.
        Only genes/isoforms with pdb structures are returned"""
        gene_isoforms = []

        # Escape input
        species = escape(species)
        gene_id = escape(gene_id)

        # Set the database and check if genes are valid
        if species == "arabidopsis":
            database = EPlant2Isoforms

            if not BARUtils.is_arabidopsis_gene_valid(gene_id):
                return BARUtils.error_exit("Invalid gene id"), 400

        elif species == "poplar":
            database = EPlantPoplarIsoforms

            if not BARUtils.is_poplar_gene_valid(gene_id):
                return BARUtils.error_exit("Invalid gene id"), 400

            # Format the gene first
            gene_id = BARUtils.format_poplar(gene_id)

        elif species == "tomato":
            database = EPlantTomatoIsoforms

            if not BARUtils.is_tomato_gene_valid(gene_id, False):
                return BARUtils.error_exit("Invalid gene id"), 400

        elif species == "soybean":
            database = EPlantSoybeanIsoforms

            if not BARUtils.is_soybean_gene_valid(gene_id):
                return BARUtils.error_exit("Invalid gene id"), 400
        else:
            return BARUtils.error_exit("No data for the given species")

        # Now get the data
        rows = db.session.execute(db.select(database).where(database.gene == gene_id)).scalars().all()
        [gene_isoforms.append(row.isoform) for row in rows]

        # Found isoforms
        if len(gene_isoforms) > 0:
            return BARUtils.success_exit(gene_isoforms)
        else:
            return BARUtils.error_exit("There are no data found for the given gene")


@gene_information.route("/gene_isoforms/")
class PostGeneIsoforms(Resource):
    @gene_information.expect(gene_information_request_fields)
    def post(self):
        """This end point returns gene isoforms data for a multiple genes for a species.
        Only genes/isoforms with pdb structures are returned"""

        json_data = request.get_json()
        data = {}

        # Validate json
        try:
            json_data = GeneInformationSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        genes = json_data["genes"]
        species = json_data["species"]

        # Set species and check gene ID format
        if species == "arabidopsis":
            database = EPlant2Isoforms

            # Check if gene is valid
            for gene in genes:
                if not BARUtils.is_arabidopsis_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

        elif species == "poplar":
            database = EPlantPoplarIsoforms

            for gene in genes:
                # Check if gene is valid
                if not BARUtils.is_poplar_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

        elif species == "tomato":
            database = EPlantTomatoIsoforms

            for gene in genes:
                # Check if gene is valid
                if not BARUtils.is_tomato_gene_valid(gene, False):
                    return BARUtils.error_exit("Invalid gene id"), 400

        elif species == "soybean":
            database = EPlantSoybeanIsoforms

            for gene in genes:
                # Check if gene is valid
                if not BARUtils.is_soybean_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

        else:
            return BARUtils.error_exit("Invalid species"), 400

        # Query must be run individually for each species
        rows = db.session.execute(db.select(database).where(database.gene.in_(genes))).scalars().all()

        # If there are any isoforms found, return data
        if len(rows) > 0:
            for row in rows:
                if row.gene in data:
                    data[row.gene].append(row.isoform)
                else:
                    data[row.gene] = []
                    data[row.gene].append(row.isoform)

            return BARUtils.success_exit(data)

        else:
            return BARUtils.error_exit("No data for the given species/genes"), 400
