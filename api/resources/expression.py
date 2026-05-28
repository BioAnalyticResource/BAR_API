"""
Reena Obmina | UTEA Project 2026 | University of Toronto

Unified Arabidopsis ePlant expression endpoint.

Replaces ~40 separate XML + CGI round-trips per gene load with a single
request that returns all views in one JSON response.

Route: GET /expression/ePlant_expression?gene=AT1G01010&species=Arabidopsis
"""
from flask import request
from flask_restx import Namespace, Resource
from markupsafe import escape

from api.eplant_arabidopsis_expression import get_expression
from api.utils.bar_utils import BARUtils

expression = Namespace(
    "Expression",
    description="Unified ePlant expression endpoint for Arabidopsis thaliana",
    path="/expression",
)


@expression.route("/ePlant_expression")
class EPlantArabidopsisExpression(Resource):
    @expression.param("gene", description="Gene ID (e.g. AT1G01010)", required=True)
    @expression.param("species", description="Species name", default="Arabidopsis")
    def get(self):
        """Returns unified ePlant expression data for all Arabidopsis views."""
        gene = str(escape(request.args.get("gene", ""))).strip().upper()
        species = str(escape(request.args.get("species", "Arabidopsis"))).strip()

        if not gene:
            return BARUtils.error_exit("Missing required parameter: gene"), 400

        if species.lower() not in ("arabidopsis", "arabidopsis thaliana"):
            return BARUtils.error_exit(f"Unsupported species: {species}"), 400

        if not BARUtils.is_arabidopsis_gene_valid(gene):
            return BARUtils.error_exit(f"Invalid gene id: {gene}"), 400

        result = get_expression(gene)
        return BARUtils.success_exit(result)
