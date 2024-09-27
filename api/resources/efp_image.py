import base64
import re
import requests
import random
import os
import time
import redis.exceptions
from flask_restx import Namespace, Resource
from markupsafe import escape
from flask import send_from_directory
from api.utils.bar_utils import BARUtils
from api.utils.efp_utils import eFPUtils

efp_image = Namespace("eFP Image", description="eFP Image generation service", path="/efp_image")


@efp_image.route("/")
class eFPImageList(Resource):
    def get(self):
        """This end point returns the list of species available"""
        # This are the only species available so far
        # If this is updated, update efp_utils.py and unit tests as well
        species = [
            "efp_arabidopsis",
            "efp_arachis",
            "efp_cannabis",
            "efp_maize",
            "efp_rice",
            "efp_sorghum",
            "efp_soybean",
        ]
        return BARUtils.success_exit(species)


@efp_image.route("/<string:efp>/<string:view>/<string:mode>/<string:gene_1>")
@efp_image.route("/<string:efp>/<string:view>/<string:mode>/<string:gene_1>/<string:gene_2>")
class eFPImage(Resource):
    @efp_image.param("efp", _in="path", default="efp_arabidopsis")
    @efp_image.param("view", _in="path", default="Developmental_Map")
    @efp_image.param("mode", _in="path", default="Absolute")
    @efp_image.param("gene_1", _in="path", default="At1g01010")
    @efp_image.param("gene_2", _in="path", default="At3g27340")
    def get(self, efp="", view="", mode="", gene_1="", gene_2=""):
        """This end point returns eFP images."""
        # Escape input data
        efp = escape(efp)
        view = escape(view)
        mode = escape(mode)
        gene_1 = escape(gene_1)
        gene_2 = escape(gene_2)

        validation = eFPUtils.is_efp_input_valid(efp, view, mode, gene_1, gene_2)
        if validation[0] is False:
            return BARUtils.error_exit(validation[1]), 400

        # Data are valid. Clear directory before running
        for file in os.listdir("output"):
            # Full file name is required at this point
            file = os.path.join("output", file)

            # Check if it is a png file and is greater than 5 minutes old
            if (
                os.path.isfile(file)
                and (os.path.splitext(file)[1] == ".png")
                and (os.stat(file).st_mtime < (time.time() - 5 * 60))
            ):
                os.remove(file)

        # Check if request is cached
        try:
            r = BARUtils.connect_redis()
            key = "BAR_API_efp_image_" + "_".join([efp, view, mode, gene_1, gene_2])
            efp_image_base64 = r.get(key)
        except redis.exceptions.ConnectionError:
            # Failed redis connection
            r = None
            key = None
            efp_image_base64 = None

        if efp_image_base64 is None:
            # Request is not cached
            # Run eFP. Note, this is currently running from home directory!
            efp_url = (
                "https://bar.utoronto.ca/"
                + efp
                + "/cgi-bin/efpWeb.cgi?dataSource="
                + view
                + "&mode="
                + mode
                + "&primaryGene="
                + gene_1
                + "&secondaryGene="
                + gene_2
                + "&grey_low=None&grey_stddev=None&navbar=0"
            )
            # This is important to fix the eFP Url which as &amp; instead of &
            efp_url = re.sub(r"amp;", "", efp_url)
            efp_html = requests.get(efp_url)

            # Now search for something like <img src=\"../output/efp-2nBNhe.png\"
            # This is the eFP output image
            match = re.search(r'"\.\./output/(efp-.{1,10}\.png)', efp_html.text)

            # File is not found
            if match is None:
                return (
                    BARUtils.error_exit("Failed to retrieve image. Data for the given gene may not exist."),
                    500,
                )

            # Save this path for later use
            path = match[1]
            efp_file_link = "https://bar.utoronto.ca/" + efp + "/output/" + path

            # Download and serve that image
            response = requests.get(efp_file_link)
            img_data = response.content
            img_length = int(response.headers.get("Content-Length"))

            with open("output/" + path, "wb") as file:
                file.write(img_data)

            # Cache the request if redis is alive and content is > 500
            if r and (img_length > 500):
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

        return send_from_directory(directory="../output/", path=path, mimetype="image/png")


@efp_image.route("/get_efp_data_source/<species>")
class eFPDataSource(Resource):
    @efp_image.param("species", _in="path", default="sorghum")
    def get(self, species=""):
        """
        Returns Data sources using eFP Directory
        Supported species: Sorghum
        """

        species = escape(species)
        species = species.lower()
        results = []

        # This will only work on the BAR
        if os.environ.get("BAR"):
            if species in ["arabidopsis", "arachis", "cannabis", "maize", "sorghum", "soybean"]:
                efp_base_path = "/var/www/html/efp_" + species + "/data"
            else:
                return BARUtils.error_exit("Invalid species.")

            data_files = os.listdir(efp_base_path)

            for file in data_files:
                if file.endswith(".xml") and file != "efp_info.xml":
                    results.append(file.replace(".xml", ""))

            return BARUtils.success_exit(results)
        else:
            return BARUtils.error_exit("Only available on the BAR.")


@efp_image.route("/get_efp_dir/<species>")
class eFPXMLSVGList(Resource):
    @efp_image.param("species", _in="path", default="arabidopsis")
    def get(self, species=""):
        """
        Return the SVG and XML links for a given eplant species
        Supported species: Arabidopsis, Poplar
        """

        species = escape(species)
        species = species.lower()

        if species == "arabidopsis":
            # efp_base_path = "/usr/src/efp_example_files"
            efp_base_path = "/var/www/html/eplant/efp/data/"
            XML_name = "Arabidopsis_thaliana.xml"
            SVG_name = "Arabidopsis_thaliana.svg"
            base_url = "//bar.utoronto.ca/eplant/data/"
        elif species == "poplar":
            # efp_base_path = "/usr/src/efp_example_files_poplar"
            efp_base_path = "/var/www/html/eplant_poplar/data"
            XML_name = "Populus_trichocarpa.xml"
            SVG_name = "Populus_trichocarpa.svg"
            base_url = "//bar.utoronto.ca/eplant_poplar/data/"
        else:
            return BARUtils.error_exit("Invalid species.")

        efp_folders = os.listdir(efp_base_path)

        return_obj = {}

        for folder in efp_folders:
            abs_path_inner_dir = efp_base_path + "/" + folder
            if folder in ["cell", "plant"]:
                if (
                    XML_name in next(os.walk(abs_path_inner_dir))[2]
                ):  # check if XML/SVG valid for this ePlant species; as A th XML can be in Poplar dirs
                    return_obj[folder] = {
                        "XML-link": base_url + folder + "/" + XML_name,
                        "SVG_link": base_url + folder + "/" + SVG_name,
                        "name": folder,
                    }
            if folder == "experiment" or (
                folder == "plant" and "plant" not in return_obj
            ):  # experiment and plant can have multiple folders
                return_obj[folder] = {}
                efp_path = abs_path_inner_dir + "/efps" if folder == "experiment" else abs_path_inner_dir
                efp_url = "/efps/" if folder == "experiment" else "/"
                for exp_folder in next(os.walk(efp_path))[1]:  # next(os.walk)[1] returns dirnames only, no files
                    if (
                        XML_name in next(os.walk(efp_path + "/" + exp_folder))[2]
                    ):  # check if XML/SVG valid for this ePlant species
                        return_obj[folder][exp_folder] = {
                            "XML-link": base_url + folder + efp_url + exp_folder + "/" + XML_name,
                            "SVG_link": base_url + folder + efp_url + exp_folder + "/" + SVG_name,
                            "name": exp_folder,
                        }

        return BARUtils.success_exit(return_obj)
