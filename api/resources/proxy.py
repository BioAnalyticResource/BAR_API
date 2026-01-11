from flask_restx import Namespace, Resource
from api.utils.bar_utils import BARUtils
from markupsafe import escape
import requests

bar_proxy = Namespace("Proxy", description="Proxy to other APIs", path="/proxy")

# Request header of almost all Proxies
request_headers = {"user-agent": "BAR API", "accept": "application/json"}


@bar_proxy.route("/atted_api5/<string:gene_id>/<int:top_n>")
class ATTEDApi5(Resource):
    @bar_proxy.param("gene_id", _in="path", default="At1g01010")
    @bar_proxy.param("top_n", _in="path", default=5)
    def get(self, gene_id="", top_n=""):
        """This end point is a proxy for ATTED-II api version 5.
        This is used by ThaleMine.
        This end point is currently not cached.
        """
        gene_id = escape(gene_id)
        top_n = escape(top_n)

        # Is data valid
        if not BARUtils.is_arabidopsis_gene_valid(gene_id):
            return BARUtils.error_exit("Invalid gene id"), 400

        if not BARUtils.is_integer(top_n):
            return BARUtils.error_exit("Invalid count"), 400

        # Now query the web service
        payload = {"gene": gene_id, "topN": top_n}
        resp = requests.get("https://atted.jp/api5/", params=payload, headers=request_headers)

        # Handle HTTP errors and invalid JSON responses
        if resp.status_code != 200:
            return BARUtils.error_exit(f"External API returned HTTP {resp.status_code}"), 502

        try:
            return resp.json()
        except requests.exceptions.JSONDecodeError:
            return BARUtils.error_exit("External API returned invalid response"), 502
