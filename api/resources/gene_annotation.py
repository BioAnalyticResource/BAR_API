from flask_restx import Namespace, Resource, fields
from flask import request
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.eplant_rice import GeneAnnotation as EplantRiceAnnotation
from api.models.eplant_poplar import GeneAnnotation as EplantPoplarAnnotation
from api.models.eplant_tomato import GeneAnnotation as EplantTomatoAnnotation
from api.models.eplant_soybean import GeneAnnotation as EplantSoybeanAnnotation
from api.models.eplant2 import AgiAnnotation, TAIR10, GeneRIFs
from api.utils.bar_utils import BARUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields


gene_annotation = Namespace(
    "Gene Annotation", description="Gene annotation API", path="/gene_annotation"
)


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
            "arabidopsis": [AgiAnnotation, TAIR10, GeneRIFs],
        }

        query = escape(query)

        res = []
        for species, db in annotation_db_list.items():
            if species == "arabidopsis":
                try:
                    agi_info = AgiAnnotation.query.filter(
                        AgiAnnotation.annotation.op("regexp")(query)
                    ).all()

                    tair10_curator_info = TAIR10.query.filter(
                        TAIR10.Curator_summary.op("regexp")(query)
                    ).all()

                    tair10_computational_info = TAIR10.query.filter(
                        TAIR10.Computational_description.op("regexp")(query)
                    ).all()

                    RIFs_info = GeneRIFs.query.filter(
                        GeneRIFs.RIF.op("regexp")(query)
                    ).all()

                except OperationalError:
                    return BARUtils.error_exit("An internal error has occurred"), 500

                res += [
                    {
                        "gene": i.agi,
                        "species": species,
                        "gene_annotation": i.annotation,
                    }
                    for i in agi_info
                ]

                res += [
                    {
                        "gene": i.Model_name,
                        "species": species,
                        "gene_annotation": i.Curator_summary,
                    }
                    for i in tair10_curator_info
                ]

                res += [
                    {
                        "gene": i.Model_name,
                        "species": species,
                        "gene_annotation": i.Computational_description,
                    }
                    for i in tair10_computational_info
                ]

                res += [
                    {"gene": i.gene, "species": species, "gene_annotation": i.RIF}
                    for i in RIFs_info
                ]

            else:
                try:
                    rows = db.query.filter(db.annotation.op("regexp")(query)).all()
                except OperationalError:
                    return BARUtils.error_exit("An internal error has occurred"), 500

                res += [
                    {
                        "gene": i.gene,
                        "species": species,
                        "gene_annotation": i.annotation,
                    }
                    for i in rows
                ]

        if len(res) == 0:
            return (
                BARUtils.error_exit("There are no data found for the given query"),
                400,
            )
        else:
            # return first 10 matches
            return {"status": "success", "query": query, "result": res[:10]}


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

        if species == "rice":
            for gene in genes:
                if not BARUtils.is_rice_gene_valid(gene):
                    return BARUtils.error_exit("Invalid gene id"), 400

            try:
                rows = EplantRiceAnnotation.query.filter(
                    EplantRiceAnnotation.gene.in_(genes)
                ).all()
                if len(rows) == 0:
                    return (
                        BARUtils.error_exit("No data for the given species/genes"),
                        400,
                    )
                else:
                    print(rows)
                    res = [
                        {
                            "gene": i.gene,
                            "annotation": i.annotation,
                        }
                        for i in rows
                    ]
                    return BARUtils.success_exit(res)
            except OperationalError:
                return BARUtils.error_exit("An internal error has occurred."), 500

        else:
            return BARUtils.error_exit("Invalid species"), 400
