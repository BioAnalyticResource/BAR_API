from flask_restx import Namespace, Resource
from api.utils.bar_utils import BARUtils
from markupsafe import escape
from api import cache
import requests

thalemine = Namespace(
    "ThaleMine", description="ThaleMine API client", path="/thalemine"
)

# Request header of almost all ThaleMine Requests
request_headers = {
    "user-agent": "BAR API",
    "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
}


@thalemine.route("/gene_rifs/<string:gene_id>")
class ThaleMineGeneRIFs(Resource):
    @thalemine.param("gene_id", _in="path", default="At1g01020")
    @cache.cached()
    def get(self, gene_id=""):
        """This end point retrieves Gene RIFs from ThaleMine given an AGI ID"""
        gene_id = escape(gene_id)

        # Is data valid
        if not BARUtils.is_arabidopsis_gene_valid(gene_id):
            return BARUtils.error_exit("Invalid gene id"), 400

        query = (
            '<query name="" model="genomic" view="Gene.geneRifs.annotation Gene.geneRifs.timeStamp '
            'Gene.geneRifs.publication.pubMedId" longDescription="" sortOrder="Gene.geneRifs.annotation '
            'asc"><constraint path="Gene.primaryIdentifier" op="=" value="{}"/></query>'
        )
        query = query.format(gene_id)

        # Now query the web service
        payload = {"format": "json", "query": query}
        resp = requests.post(
            "https://bar.utoronto.ca/thalemine/service/query/results",
            data=payload,
            headers=request_headers,
        )

        return resp.json()


@thalemine.route("/publications/<string:gene_id>")
class ThaleMinePublications(Resource):
    @thalemine.param("gene_id", _in="path", default="At1g01020")
    @cache.cached()
    def get(self, gene_id=""):
        """This end point retrieves publications from ThaleMine given an AGI ID"""
        gene_id = escape(gene_id)

        # Is data valid
        if not BARUtils.is_arabidopsis_gene_valid(gene_id):
            return BARUtils.error_exit("Invalid gene id"), 400

        query = (
            '<query name="" model="genomic" view="Gene.publications.firstAuthor Gene.publications.issue '
            "Gene.publications.journal Gene.publications.pages Gene.publications.pubMedId Gene.publications.title "
            'Gene.publications.volume Gene.publications.year" longDescription="" '
            'sortOrder="Gene.publications.firstAuthor asc"><constraint path="Gene.primaryIdentifier" op="=" value="{'
            '}"/></query> '
        )
        query = query.format(gene_id)

        # Now query the web service
        payload = {"format": "json", "query": query}
        resp = requests.post(
            "https://bar.utoronto.ca/thalemine/service/query/results",
            data=payload,
            headers=request_headers,
        )

        return resp.json()
