import re
from flask_restx import Namespace, Resource, fields
from flask import request
from api.utils.bar_utils import BARUtils
from api.services.efp_data import query_efp_database_dynamic
from api.models.efp_schemas import SIMPLE_EFP_DATABASE_SCHEMAS
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from markupsafe import escape

rnaseq_gene_expression = Namespace(
    "RNA-Seq Gene Expression",
    description="RNA-Seq Gene Expression data from the BAR Databases",
    path="/rnaseq_gene_expression",
)

# validators stay here so schema metadata can reference them
SPECIES_VALIDATORS = {
    "arabidopsis": BARUtils.is_arabidopsis_gene_valid,
    "arachis": BARUtils.is_arachis_gene_valid,
    "cannabis": BARUtils.is_cannabis_gene_valid,
    "kalanchoe": BARUtils.is_kalanchoe_gene_valid,
    "selaginella": BARUtils.is_selaginella_gene_valid,
    "strawberry": BARUtils.is_strawberry_gene_valid,
    "striga": BARUtils.is_striga_gene_valid,
    "triphysaria": BARUtils.is_triphysaria_gene_valid,
    "phelipanche": BARUtils.is_phelipanche_gene_valid,
    "physcomitrella": BARUtils.is_physcomitrella_gene_valid,
}

# metadata mirrors the schema catalog so validation stays in sync
DATABASE_METADATA = {name: spec.get("metadata") or {} for name, spec in SIMPLE_EFP_DATABASE_SCHEMAS.items()}

# this is only needed for swagger ui post examples
gene_expression_request_fields = rnaseq_gene_expression.model(
    "GeneExpression",
    {
        "species": fields.String(required=True, example="arabidopsis"),
        "database": fields.String(required=True, example="single_cell"),
        "gene_id": fields.String(required=True, example="At1g01010"),
        "sample_ids": fields.List(
            example=[
                "cluster0_WT1.ExprMean",
                "cluster0_WT2.ExprMean",
                "cluster0_WT3.ExprMean",
            ],
            cls_or_instance=fields.String,
        ),
    },
)


# validation is done manually to keep things simple
class RNASeqSchema(Schema):
    species = marshmallow_fields.String(required=True)
    database = marshmallow_fields.String(required=True)
    gene_id = marshmallow_fields.String(required=True)
    sample_ids = marshmallow_fields.List(cls_or_instance=marshmallow_fields.String)


class RNASeqUtils:
    @staticmethod
    def get_data(species, database, gene_id, sample_ids=None):
        """query the database for gene expression values"""
        if sample_ids is None:
            sample_ids = []
        data: dict = {}

        # validate species selection and gene id format
        species = species.lower()
        gene_validator = SPECIES_VALIDATORS.get(species)
        if not gene_validator:
            return {"success": False, "error": "Invalid species", "error_code": 400}

        database = database.lower()
        db_metadata = DATABASE_METADATA.get(database, {})
        db_species = db_metadata.get("species")
        if db_species and db_species != species:
            return {"success": False, "error": "Invalid species", "error_code": 400}

        if not gene_validator(gene_id):
            return {"success": False, "error": "Invalid gene id", "error_code": 400}

        if database not in DATABASE_METADATA:
            return {"success": False, "error": "Invalid database", "error_code": 400}

        # sample validation is driven by metadata so regex updates live in one place
        sample_pattern = db_metadata.get("sample_regex")
        if not sample_pattern:
            return {
                "success": False,
                "error": f"Sample validation metadata missing for database {database}",
                "error_code": 500,
            }

        regex_flags = re.I if db_metadata.get("sample_regex_case_insensitive", True) else 0
        sample_regex = re.compile(sample_pattern, regex_flags)

        # validate samples if the caller provided any
        if sample_ids:
            for sample_id in sample_ids:
                if not sample_regex.search(sample_id):
                    return {
                        "success": False,
                        "error": "Invalid sample id",
                        "error_code": 400,
                    }

        query_result = query_efp_database_dynamic(
            database,
            gene_id,
            sample_ids=sample_ids or None,
            allow_empty_results=True,
            sample_case_insensitive=db_metadata.get("sample_case_insensitive_query", True),
        )

        if not query_result["success"]:
            return {
                "success": False,
                "error": query_result.get("error", "Database query failed"),
                "error_code": query_result.get("error_code", 500),
            }

        for entry in query_result.get("data", []):
            sample_name = entry.get("name")
            value = entry.get("value")
            if sample_name is None:
                continue
            try:
                data[sample_name] = float(value)
            except (TypeError, ValueError):
                data[sample_name] = value

        return {"success": True, "data": data}


@rnaseq_gene_expression.route("/")
class PostRNASeqExpression(Resource):
    @rnaseq_gene_expression.expect(gene_expression_request_fields)
    def post(self):
        """return gene expression data for a single gene and a list of samples"""
        json_data = request.get_json()

        # validate json payload
        try:
            json_data = RNASeqSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        species = json_data["species"]
        database = json_data["database"]
        gene_id = json_data["gene_id"]
        sample_ids = json_data["sample_ids"]

        results = RNASeqUtils.get_data(species, database, gene_id, sample_ids)

        if results["success"]:
            # return results when rows exist
            if len(results["data"]) > 0:
                return BARUtils.success_exit(results["data"])
            else:
                return BARUtils.error_exit("There are no data found for the given gene")
        else:
            return BARUtils.error_exit(results["error"]), results["error_code"]


@rnaseq_gene_expression.route("/<string:species>/<string:database>/<string:gene_id>")
class GetRNASeqGeneExpression(Resource):
    @rnaseq_gene_expression.param("species", _in="path", default="arabidopsis")
    @rnaseq_gene_expression.param("database", _in="path", default="single_cell")
    @rnaseq_gene_expression.param("gene_id", _in="path", default="At1g01010")
    def get(self, species="", database="", gene_id=""):
        """return rna-seq gene expression data"""
        # sanitize path inputs
        species = escape(species)
        database = escape(database)
        gene_id = escape(gene_id)

        results = RNASeqUtils.get_data(species, database, gene_id)

        if results["success"]:
            # return results when rows exist
            if len(results["data"]) > 0:
                return BARUtils.success_exit(results["data"])
            else:
                return BARUtils.error_exit("There are no data found for the given gene")
        else:
            return BARUtils.error_exit(results["error"]), results["error_code"]


@rnaseq_gene_expression.route("/<string:species>/<string:database>/<string:gene_id>/<string:sample_id>")
class GetRNASeqGeneExpressionSample(Resource):
    @rnaseq_gene_expression.param("species", _in="path", default="arabidopsis")
    @rnaseq_gene_expression.param("database", _in="path", default="single_cell")
    @rnaseq_gene_expression.param("gene_id", _in="path", default="At1g01010")
    @rnaseq_gene_expression.param("sample_id", _in="path", default="cluster0_WT1.ExprMean")
    def get(self, species="", database="", gene_id="", sample_id=""):
        """return rna-seq gene expression for a specific sample"""
        # sanitize path inputs
        species = escape(species)
        database = escape(database)
        gene_id = escape(gene_id)
        sample_id = escape(sample_id)

        results = RNASeqUtils.get_data(species, database, gene_id, [sample_id])

        if results["success"]:
            # return results when rows exist
            if len(results["data"]) > 0:
                return BARUtils.success_exit(results["data"])
            else:
                return BARUtils.error_exit("There are no data found for the given gene")
        else:
            return BARUtils.error_exit(results["error"]), results["error_code"]
