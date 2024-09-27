from flask_restx import Namespace, Resource, fields
from flask import request
from markupsafe import escape
from api.models.annotations_lookup import AgiAlias
from api.models.eplant2 import Isoforms as EPlant2Isoforms
from api.models.eplant2 import Publications as EPlant2Publications
from api.models.eplant2 import TAIR10GFF3 as EPlant2TAIR10GFF3
from api.models.eplant2 import AgiAlias as EPlant2AgiAlias
from api.models.eplant2 import AgiAnnotation as EPlant2AgiAnnotation
from api.models.eplant_poplar import Isoforms as EPlantPoplarIsoforms
from api.models.eplant_tomato import Isoforms as EPlantTomatoIsoforms
from api.models.eplant_soybean import Isoforms as EPlantSoybeanIsoforms
from api.utils.bar_utils import BARUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from api import db


gene_information = Namespace("Gene Information", description="Information about Genes", path="/gene_information")

parser = gene_information.parser()
parser.add_argument(
    "terms",
    type=list,
    action="append",
    required=True,
    help="Gene IDs, format example: AT1G01010",
    default=["AT1G01020", "AT1G01030"],
)

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

query_genes_request_fields = gene_information.model(
    "GeneInformation",
    {
        "species": fields.String(required=True, example="arabidopsis"),
        "terms": fields.List(
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


@gene_information.route("/gene_aliases")
class GeneAliases(Resource):
    @gene_information.expect(gene_information_request_fields)
    def post(self):
        """This end point retrieves gene aliases for a large dataset"""
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


@gene_information.route("/gene_publications/<string:species>/<string:gene_id>")
class GenePublications(Resource):
    @gene_information.param("species", _in="path", default="arabidopsis")
    @gene_information.param("gene_id", _in="path", default="AT1G01010")
    def get(self, species="", gene_id=""):
        """This end point provides publications given a gene ID."""
        publications = []

        # Escape input
        species = escape(species)
        gene_id = escape(gene_id)

        # Set the database and check if genes are valid
        if species == "arabidopsis":
            database = EPlant2Publications

            # Remove Arabidopsis isoforms
            gene_id = gene_id.split(".")[0]

            if not BARUtils.is_arabidopsis_gene_valid(gene_id):
                return BARUtils.error_exit("Invalid gene id"), 400
        else:
            return BARUtils.error_exit("No data for the given species")

        # Get data
        rows = db.session.execute(db.select(database).where(database.gene == gene_id)).scalars().all()
        for row in rows:
            publications.append(
                {
                    "gene_id": row.gene,
                    "author": row.author,
                    "year": row.year,
                    "journal": row.journal,
                    "title": row.title,
                    "pubmed": row.pubmed,
                }
            )

        # Return results if there are data
        if len(publications) > 0:
            return BARUtils.success_exit(publications)
        else:
            return BARUtils.error_exit("There are no data found for the given gene")


@gene_information.route(
    "/genes_by_position/<string:species>/<string:chromosome>/<string:start_param>/<string:end_param>"
)
class GeneTair10Gff3(Resource):
    @gene_information.param("species", _in="path", default="arabidopsis")
    @gene_information.param("chromosome", _in="path", default="1")
    @gene_information.param("start_param", _in="path", default=3000)
    @gene_information.param("end_param", _in="path", default=6000)
    def get(self, species="", chromosome="", start_param="", end_param=""):
        """This end point provides genes given position."""

        # Check if all parameters are provided
        if not chromosome or not start_param or not end_param:
            return BARUtils.error_exit("Missing parameters"), 400

        # Check if the start param is smaller than end param
        if start_param >= end_param:
            return BARUtils.error_exit("Start location should be smaller than the end location"), 400

        # Check if both parameters are valid figures
        if not BARUtils.is_integer(start_param) or not BARUtils.is_integer(end_param):
            return BARUtils.error_exit("At lease one parameter is not valid")

        # Escape input
        species = escape(species)
        chromosome = escape(chromosome)
        start_param = escape(start_param)
        end_param = escape(end_param)

        # Set database
        if species == "arabidopsis":
            gff3_database = EPlant2TAIR10GFF3
            alias_database = EPlant2AgiAlias
            annotation_database = EPlant2AgiAnnotation

            if chromosome not in ["1", "2", "3", "4", "5", "C", "M"]:
                return BARUtils.error_exit("Invalid chromosome"), 400

            # Arabidopsis Gene format
            gene_id = "AT" + str(chromosome) + "G"
        else:
            return BARUtils.error_exit("No data for the given species"), 400

        # Construct the query

        query1 = db.select(gff3_database.geneId, gff3_database.Start, gff3_database.End, gff3_database.Strand).where(
            gff3_database.Type == "gene",
            gff3_database.geneId.startswith(gene_id),
            (
                gff3_database.Start.between(start_param, end_param)
                | gff3_database.End.between(start_param, end_param)
                | ((gff3_database.Start < start_param) & (gff3_database.End > end_param))
            ),
        )
        result1 = db.session.execute(query1).all()
        gene_ids = [row[0] for row in result1]

        # Get aliases
        query2 = db.select(alias_database.agi, alias_database.alias).where(alias_database.agi.in_(gene_ids))
        result2 = db.session.execute(query2).all()
        all_aliases = {}
        for row in result2:
            if row[0] not in all_aliases:
                all_aliases[row[0]] = []
            all_aliases[row[0]].append(row[1])

        # Get annotation
        query3 = db.select(annotation_database.agi, annotation_database.annotation).where(
            annotation_database.agi.in_(gene_ids)
        )
        result3 = db.session.execute(query3).all()
        all_annotations = {}
        for row in result3:
            temp = row[1].split("__")
            if len(temp) > 1:
                all_annotations[row[0].upper()] = temp[1]
            else:
                all_annotations[row[0].upper()] = temp[0]

        genes = []
        for row in result1:
            gene = {
                "id": row[0],
                "start": row[1],
                "end": row[2],
                "strand": row[3],
                "aliases": all_aliases.get(row[0], []),
                "annotation": all_annotations.get(row[0], None),
            }

            genes.append(gene)

        return BARUtils.success_exit(genes)


@gene_information.route("/gene_query")
class GeneQueryGene(Resource):
    @gene_information.expect(query_genes_request_fields)
    def post(self):
        """This end point provides gene information for multiple genes given multiple terms."""

        # Escape input
        data = request.get_json()
        species = data["species"]
        terms = data["terms"]
        for one_term in terms:
            one_term.upper()

        # Species check
        if species == "arabidopsis":
            # Term check
            for one_term in terms:
                if not BARUtils.is_arabidopsis_gene_valid(one_term):
                    return BARUtils.error_exit("Input list contains invalid term"), 400

            alias_database = EPlant2AgiAlias
            gff3_database = EPlant2TAIR10GFF3
            annotation_database = EPlant2AgiAnnotation
        else:
            return BARUtils.error_exit("No data for the given species"), 400

        gene_ids = []
        gene_fail = []
        for one_term in terms:
            query = db.select(alias_database.agi).where(alias_database.agi.contains(one_term)).limit(1)
            result = db.session.execute(query).fetchone()
            if result is not None:
                gene_ids.append(result[0])
            else:
                gene_fail.append(one_term)

        # For terms that do not have results
        for fail_term in gene_fail:
            query = (
                db.select(gff3_database.geneId)
                .where(
                    ((gff3_database.Type == "gene") | (gff3_database.Type == "transposable_element_gene")),
                    gff3_database.geneId.contains(fail_term),
                )
                .limit(1)
            )
            result = db.session.execute(query).fetchone()
            if result:
                gene_ids.append(result[0])

        # Find information for each term
        query = db.select(gff3_database.geneId, gff3_database.Start, gff3_database.End, gff3_database.Strand).where(
            ((gff3_database.Type == "gene") | (gff3_database.Type == "transposable_element_gene")),
            gff3_database.Source == "TAIR10",
            gff3_database.geneId.in_(gene_ids),
        )
        result = db.session.execute(query).all()
        genes_info = {}
        for row in result:
            if row[0] not in genes_info:
                gene = {
                    "id": row[0],
                    "chromosome": "Chr" + row[0][2:3],
                    "start": row[1],
                    "end": row[2],
                    "strand": row[3],
                    "aliases": [],
                    "annotation": None,
                }
                genes_info[row[0]] = gene

        # Get aliases
        query = db.select(alias_database.agi, alias_database.alias).where(alias_database.agi.in_(gene_ids))
        result = db.session.execute(query).all()
        for row in result:
            if row[0] in genes_info:
                genes_info[row[0]]["aliases"].append(row[1])

        # Get annotations
        query = db.select(annotation_database.agi, annotation_database.annotation).where(
            annotation_database.agi.in_(gene_ids)
        )
        result = db.session.execute(query)
        for row in result:
            if row[0].upper() in genes_info:
                temp = row[1].split("__")
                if len(temp) > 1:
                    genes_info[row[0].upper()]["annotation"] = temp[1]
                else:
                    genes_info[row[0].upper()]["annotation"] = temp[0]

        return BARUtils.success_exit(genes_info)


@gene_information.route("/single_gene_query/<string:species>/<string:term>")
class SingleGeneQueryGene(Resource):
    @gene_information.param("species", _in="path", default="arabidopsis")
    @gene_information.param("term", _in="path", default="AT1G01010")
    def get(self, species="", term=""):
        """This end point provides gene information for a single gene given one term."""

        # Escape input
        species = escape(species)
        term = escape(term).upper()

        # Species check
        if species == "arabidopsis":
            alias_database = EPlant2AgiAlias
            gff3_database = EPlant2TAIR10GFF3
            annotation_database = EPlant2AgiAnnotation

            # Term check
            if not BARUtils.is_arabidopsis_gene_valid(term):
                return BARUtils.error_exit("Input term invalid"), 400
        else:
            return BARUtils.error_exit("No data for the given species"), 400

        query = db.select(alias_database.agi).where(alias_database.agi == term).limit(1)
        result = db.session.execute(query).fetchone()

        if not result:
            query = (
                db.select(gff3_database.geneId)
                .where(
                    ((gff3_database.Type == "gene") | (gff3_database.Type == "transposable_element_gene")),
                    gff3_database.geneId == term,
                )
                .limit(1)
            )
            result = db.session.execute(query).fetchone()

        genes_info = {}
        if result:
            # Find information for the term
            query = db.select(gff3_database.geneId, gff3_database.Start, gff3_database.End, gff3_database.Strand).where(
                ((gff3_database.Type == "gene") | (gff3_database.Type == "transposable_element_gene")),
                gff3_database.Source == "TAIR10",
                gff3_database.geneId == term,
            )
            result = db.session.execute(query).fetchone()

            # This Arabidopsis specific.
            gene = {
                "id": result[0],
                "chromosome": "Chr" + result[0][2:3],
                "start": result[1],
                "end": result[2],
                "strand": result[3],
                "aliases": [],
                "annotation": None,
            }

            genes_info[result[0]] = gene

            # Get aliases
            query = db.select(alias_database.agi, alias_database.alias).where(alias_database.agi == term)
            result = db.session.execute(query).all()
            for row in result:
                if row[1] not in gene["aliases"]:
                    gene["aliases"].append(row[1])

            # Get annotations
            query = db.select(annotation_database.agi, annotation_database.annotation).where(
                annotation_database.agi == term
            )
            result = db.session.execute(query).all()
            for row in result:
                temp = row[1].split("__")
                if len(temp) > 1:
                    gene["annotation"] = temp[1]
                else:
                    gene["annotation"] = temp[0]

        return BARUtils.success_exit(genes_info)


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
