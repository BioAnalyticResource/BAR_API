from flask_restx import Namespace, Resource, fields
from flask import request
from markupsafe import escape
from api.models.eplant_rice import GeneAnnotation as EplantRiceAnnotation
from api.models.eplant_poplar import GeneAnnotation as EplantPoplarAnnotation
from api.models.eplant_tomato import GeneAnnotation as EplantTomatoAnnotation
from api.models.eplant_soybean import GeneAnnotation as EplantSoybeanAnnotation
from api.models.eplant2 import AgiAnnotation, TAIR10FunctionalDescriptions, GeneRIFs
from api.utils.bar_utils import BARUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from api import db

gene_annotation = Namespace("Gene Annotation", description="Gene annotation API", path="/gene_annotation")

anntn_post_ex = gene_annotation.model(
    "AntnRiceGenes",
    {
        "species": fields.String(required=True, example="rice"),
        "genes": fields.List(
            required=True,
            example=["LOC_Os01g01010", "LOC_Os01g01050"],
            cls_or_instance=fields.String,
        ),
    },
)


class GeneIntrnsSchema(Schema):
    species = marshmallow_fields.String(required=True)
    genes = marshmallow_fields.List(cls_or_instance=marshmallow_fields.String)


@gene_annotation.route("/<string:query>")
class GeneAnnotation(Resource):
    @gene_annotation.param("query", _in="path", default="alpha-1 protein")
    def get(self, query=""):
        """
        Endpoint returns gene locus for given gene keywords
        """
        annotation_db_list = {
            "tomato": EplantTomatoAnnotation,
            "poplar": EplantPoplarAnnotation,
            "rice": EplantRiceAnnotation,
            "soybean": EplantSoybeanAnnotation,
            "arabidopsis": [AgiAnnotation, TAIR10FunctionalDescriptions, GeneRIFs],
        }

        query = escape(query)

        res = []
        for species, annot_db in annotation_db_list.items():
            if species == "arabidopsis":
                # Only Arabidopsis queries from multiple databases

                # Query AGI Annotation table
                agi_info = (
                    db.session.execute(db.select(AgiAnnotation).where(AgiAnnotation.annotation.regexp_match(query)))
                    .scalars()
                    .all()
                )

                # Query TAIR10 table
                tair10_curator_info = (
                    db.session.execute(
                        db.select(TAIR10FunctionalDescriptions).where(
                            TAIR10FunctionalDescriptions.Curator_summary.regexp_match(query)
                        )
                    )
                    .scalars()
                    .all()
                )

                # Query TAIR10 computation_info
                tair10_computational_info = (
                    db.session.execute(
                        db.select(TAIR10FunctionalDescriptions).where(
                            TAIR10FunctionalDescriptions.Computational_description.regexp_match(query)
                        )
                    )
                    .scalars()
                    .all()
                )

                # Query GeneRIFs
                RIFs_info = (
                    db.session.execute(db.select(GeneRIFs).where(GeneRIFs.RIF.regexp_match(query))).scalars().all()
                )

                res.extend(
                    [
                        {
                            "gene": i.agi,
                            "species": species,
                            "gene_annotation": i.annotation,
                        }
                        for i in agi_info
                    ]
                )

                res.extend(
                    [
                        {
                            "gene": i.Model_name,
                            "species": species,
                            "gene_annotation": i.Curator_summary,
                        }
                        for i in tair10_curator_info
                    ]
                )

                res.extend(
                    [
                        {
                            "gene": i.Model_name,
                            "species": species,
                            "gene_annotation": i.Computational_description,
                        }
                        for i in tair10_computational_info
                    ]
                )

                res.extend(
                    [
                        {
                            "gene": i.gene,
                            "species": species,
                            "gene_annotation": i.RIF,
                        }
                        for i in RIFs_info
                    ]
                )
            else:
                # For all other genes
                rows = (
                    db.session.execute(db.select(annot_db).where(annot_db.annotation.regexp_match(query)))
                    .scalars()
                    .all()
                )

                res.extend(
                    [
                        {
                            "gene": i.gene,
                            "species": species,
                            "gene_annotation": i.annotation,
                        }
                        for i in rows
                    ]
                )

        if len(res) == 0:
            return (
                BARUtils.error_exit("There are no data found for the given query"),
                400,
            )
        else:
            # return first 10 matches
            return {"status": "success", "query": query, "result": res[:10]}


@gene_annotation.route("/")
class GeneAnnotationPost(Resource):
    @gene_annotation.expect(anntn_post_ex)
    def post(self, query=""):
        """
        Returns gene annotation(s) give a set of gene(s) for a species
        Supported species: 'rice'
        """

        json_data = request.get_json()

        try:
            json_data = GeneIntrnsSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        species = json_data["species"].lower()
        genes = json_data["genes"]

        # First validate species and gene ids, and also select a database
        if species == "rice":
            for gene in genes:
                if not BARUtils.is_rice_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

            database = EplantRiceAnnotation
        else:
            return BARUtils.error_exit("Invalid species"), 400

        # Now query the database
        rows = db.session.execute(db.select(database).where(database.gene.in_(genes))).scalars().all()

        if len(rows) == 0:
            return (
                BARUtils.error_exit("No data for the given species/genes"),
                400,
            )
        else:
            res = [
                {
                    "gene": i.gene,
                    "annotation": i.annotation,
                }
                for i in rows
            ]
            return BARUtils.success_exit(res)
