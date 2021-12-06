import re
import requests
from flask_restx import Namespace, Resource
from markupsafe import escape
from flask import send_from_directory
from api.utils.bar_utils import BARUtils

efp_image = Namespace(
    "eFP Image", description="eFP Image generation service", path="/efp_image"
)


@efp_image.route("/")
class eFPImageList(Resource):
    def get(self):
        """This end point returns the list of species available"""
        species = ["efp_arabidopsis"]  # This are the only species available so far
        return BARUtils.success_exit(species)


@efp_image.route("/<string:efp>/<string:view>/<string:mode>/<string:gene_1>")
@efp_image.route(
    "/<string:efp>/<string:view>/<string:mode>/<string:gene_1>/<string:gene_2>",
    doc=False,
)
class eFPImage(Resource):
    @efp_image.param("efp", _in="path", default="efp_arabidopsis")
    @efp_image.param("view", _in="path", default="Developmental_Map")
    @efp_image.param("mode", _in="path", default="Absolute")
    @efp_image.param("gene_1", _in="path", default="At1g01010")
    @efp_image.param("gene_2", _in="path", default="At3g27340")
    def get(self, efp="", view="", mode="", gene_1="", gene_2=""):
        """This end point returns eFP images."""
        # list of allowed eFPs
        # See endpoint able
        efp_list = ["efp_arabidopsis"]

        # Escape input data
        efp = escape(efp)
        view = escape(view)
        mode = escape(mode)
        gene_1 = escape(gene_1)
        gene_2 = escape(gene_2)

        # Validate values
        if efp not in efp_list:
            return BARUtils.error_exit("Invalid eFP"), 400

        # Add rate limiter
        # Validate view
        # Validate mode
        # Validate gene ids
        # Check if request is cached
        # If request is not cached, run the search

        # Run eFP
        efp_url = (
            "https://bar.utoronto.ca/~asher/python3/"
            + efp
            + "/cgi-bin/efpWeb.cgi?dataSource="
            + view
            + "&mode="
            + mode
            + "&primaryGene="
            + gene_1
            + "&secondaryGene="
            + gene_2
            + "&grey_low=None&grey_stddev=None"
        )
        efp_html = requests.get(efp_url)

        # Now search for something like <img src=\"../output/efp-2nBNhe.png\"
        # This is the eFP output image
        match = re.search(r'"\.\./output/(efp-.{1,10}\.png)', efp_html.text)
        efp_file_link = (
            "https://bar.utoronto.ca/~asher/python3/" + efp + "/output/" + match[1]
        )

        # Download and serve that image
        img_data = requests.get(efp_file_link).content
        with open("output/" + match[1], "wb") as file:
            file.write(img_data)

        return send_from_directory(
            directory="../output/", path=match[1], mimetype="image/png"
        )
