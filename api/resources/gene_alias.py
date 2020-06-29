import re
from flask_restful import Resource, request
from api.models.annotations_lookup import AgiAlias
from api.utilities.bar_utilities import BARUtilities
from api import r
import json


class GeneAlias(Resource):
    def get(self, species='', gene_id=''):
        """
        This end point gets gene alias information
        ---
        parameters:
          - name: species
            in: path
            type: string
            required: true
            default: arabidopsis
          - name: gene_id
            in: path
            type: string
            required: true
            default: At3g24650
        tags:
          - "Gene Information"
        summary: "Returns gene alias given a species and gene id"
        produces:
          - application/json
        responses:
          "200":
            description: "Successful operation"
        """

        aliases = []
        redis_key = request.url

        # Check if redis is running and results are cached
        if BARUtilities.is_redis_available():
            redis_value = r.get(redis_key)
            # If the request is stored then return value
            if redis_value:
                redis_value = json.loads(redis_value)
                return BARUtilities.success_exit(redis_value)

        if species == 'arabidopsis':
            if re.search(r"^At[12345CM]g\d{5}$", gene_id, re.I):
                rows = AgiAlias.query.filter_by(agi=gene_id).all()
                [aliases.append(row.alias) for row in rows]
            else:
                return BARUtilities.error_exit('Invalid gene id')
        else:
            return BARUtilities.error_exit('No data for the given species')

        # Return results if there are data
        if len(aliases) > 0:
            # Set up cache if it does not exist
            if BARUtilities.is_redis_available() and r.get(redis_key) is None:
                r.set(redis_key, json.dumps(aliases))

            return BARUtilities.success_exit(aliases)
        else:
            return BARUtilities.error_exit('There is no data found for the given gene')
