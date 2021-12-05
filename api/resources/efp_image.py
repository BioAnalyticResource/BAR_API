from flask_restx import Namespace, Resource
# from markupsafe import escape
from api.utils.bar_utils import BARUtils

efp_image = Namespace(
    "eFP Image", description="eFP Image generation service", path="/efp_image"
)


@efp_image.route("/")
class GeneAliasList(Resource):
    def get(self):
        """This end point returns the list of species available"""
        species = ["efp_arabidopsis"]  # This are the only species available so far
        return BARUtils.success_exit(species)
