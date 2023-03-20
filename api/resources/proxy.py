from flask_restx import Namespace, Resource
from api.utils.bar_utils import BARUtils
from markupsafe import escape
import requests

bar_proxy = Namespace("Proxy", description="Proxy to other APIs", path="/proxy")

# Request header of almost all Proxies
request_headers = {"user-agent": "BAR API", "accept": "application/json"}


@bar_proxy.route("/atted_api4/<string:gene_id>/<int:top_n>")
class ATTEDApi4(Resource):
    @bar_proxy.param("gene_id", _in="path", default="At1g01010")
    @bar_proxy.param("top_n", _in="path", default=5)
    def get(self, gene_id="", top_n=""):
        """This end point is a proxy for ATTED-II api version 4.
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
        resp = requests.get("https://atted.jp/cgi-bin/api4.cgi", params=payload, headers=request_headers)

        # I think the remote API always returns status 200, so skip status checking
        return resp.json()
