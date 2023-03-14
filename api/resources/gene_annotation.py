from flask_restx import Namespace, Resource, fields
from flask import request
from markupsafe import escape
from api.utils.bar_utils import BARUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from api import db
from sqlalchemy import text


gene_annotation = Namespace(
    "Gene Annotation", description="Gene annotation API", path="/gene_annotation"
)

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
            "tomato": "eplant_tomato",
            "poplar": "eplant_poplar",
            "rice": "eplant_rice",
            "soybean": "eplant_soybean",
            "arabidopsis": "eplant2",
        }

        query = escape(query)

        res = []
        for species, annot_db in annotation_db_list.items():
            if species == "arabidopsis":
                # Only Arabidopsis queries from multiple databases
                with db.engines[annot_db].connect() as conn:
                    # Query AGI Annotation table
                    agi_info = conn.execute(
                        text(
                            "select agi, annotation from agi_annotation where annotation REGEXP :annot"
                        ),
                        {"annot": query},
                    )

                    # Query TAIR10 table
                    tair10_curator_info = conn.execute(
                        text(
                            "select Model_name, Curator_summary from TAIR10_functional_descriptions where Curator_summary REGEXP :summary"
                        ),
                        {"summary": query},
                    )

                    # Query TAIR10 computation_info
                    tair10_computational_info = conn.execute(
                        text(
                            "select Model_name, Computational_description from TAIR10_functional_descriptions where Computational_description REGEXP :desc"
                        ),
                        {"desc": query},
                    )

                    # Query GeneRIFs
                    RIFs_info = conn.execute(
                        text("select gene, RIF from geneRIFs where RIF REGEXP :rif"),
                        {"rif": query},
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
                with db.engines[annot_db].connect() as conn:
                    rows = conn.execute(
                        text(
                            "select gene, annotation from gene_annotation where annotation REGEXP :annot"
                        ),
                        {"annot": query},
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

            database = "eplant_rice"
        else:
            return BARUtils.error_exit("Invalid species"), 400

        # Now query the database
        with db.engines[database].connect() as conn:
            results = conn.execute(
                text(
                    "select gene, annotation from gene_annotation where gene in :genes"
                ),
                {"genes": genes},
            )
            rows = results.fetchall()

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
