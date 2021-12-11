import base64
import re
import requests
import random
import redis.connection
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
        # This are the only species available so far
        # If this is updated, update get request and test as well
        species = ["efp_arabidopsis"]
        return BARUtils.success_exit(species)


@efp_image.route("/<string:efp>/<string:view>/<string:mode>/<string:gene_1>")
@efp_image.route(
    "/<string:efp>/<string:view>/<string:mode>/<string:gene_1>/<string:gene_2>",
    doc=False,
)
class eFPImage(Resource):
    @staticmethod
    def is_efp_mode(efp_mode):
        """This function checks if the eFP mode is valid
        :param efp_mode: string eFP Mode
        :return: True or False
        """
        # This are case sensitive
        valid_modes = ["Absolute", "Relative", "Compare"]
        if efp_mode in valid_modes:
            return True
        else:
            return False

    @efp_image.param("efp", _in="path", default="efp_arabidopsis")
    @efp_image.param("view", _in="path", default="Developmental_Map")
    @efp_image.param("mode", _in="path", default="Absolute")
    @efp_image.param("gene_1", _in="path", default="At1g01010")
    @efp_image.param("gene_2", _in="path", default="At3g27340")
    def get(self, efp="", view="", mode="", gene_1="", gene_2=""):
        """This end point returns eFP images."""
        # list of allowed eFPs
        # See endpoint able
        species = ["efp_arabidopsis"]

        # Escape input data
        efp = escape(efp)
        view = escape(view)
        mode = escape(mode)
        gene_1 = escape(gene_1)
        gene_2 = escape(gene_2)

        # Validate values
        if efp not in species:
            return BARUtils.error_exit("Invalid eFP."), 400

        # Validate view
        if not BARUtils.is_efp_view_name(view):
            return BARUtils.error_exit("Invalid eFP View name."), 400

        # Validate mode
        if not self.is_efp_mode(mode):
            return BARUtils.error_exit("Invalid eFP mode."), 400

        # Validate gene ids
        if not BARUtils.is_arabidopsis_gene_valid(gene_1):
            return BARUtils.error_exit("Gene 1 is invalid."), 400

        if mode == "Compare":
            if not BARUtils.is_arabidopsis_gene_valid(gene_2):
                return BARUtils.error_exit("Gene 2 is invalid."), 400

        # Check if request is cached
        try:
            r = BARUtils.connect_redis()
            key = "BAR_API_efp_image_" + "_".join([efp, view, mode, gene_1, gene_2])
            efp_image_base64 = r.get(key)
        except redis.connection.ConnectionError:
            # Failed redis connection
            r = None
            key = None
            efp_image_base64 = None

        if efp_image_base64 is None:
            # Request is not cached
            # Run eFP. Note, this is currently running from home directory!
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

            # File is not found
            if match is None:
                return (
                    BARUtils.error_exit(
                        "Failed to retrieve image. Data for the given gene may not exist."
                    ),
                    500,
                )

            # Save this path for later use
            path = match[1]
            efp_file_link = (
                "https://bar.utoronto.ca/~asher/python3/" + efp + "/output/" + path
            )

            # Download and serve that image
            img_data = requests.get(efp_file_link).content
            with open("output/" + path, "wb") as file:
                file.write(img_data)

            # Cache the request if redis is alive
            if r:
                efp_image_base64 = base64.b64encode(img_data)
                r.set(key, efp_image_base64)
                r.close()

        else:
            # Request is cached
            img_data = base64.b64decode(efp_image_base64)
            path = key + str(random.randrange(0, 1000000)) + ".png"
            with open("output/" + path, "wb") as file:
                file.write(img_data)
            r.close()

        return send_from_directory(
            directory="../output/", path=path, mimetype="image/png"
        )
