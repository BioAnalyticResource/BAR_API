import re
from sqlalchemy.exc import OperationalError
from flask_restx import Namespace, Resource
from flask import request
from api.models.annotations_lookup import AgiAlias
from api.utilities.bar_utilities import BARUtilities
from api import r
import json

gene_information = Namespace('Gene Information', description='Information about Genes', path='/')


@gene_information.route('/gene_alias/<string:species>/<string:gene_id>')
class GeneAlias(Resource):
    @gene_information.param('species', description='', _in='path', default='arabidopsis')
    @gene_information.param('gene_id', description='', _in='path', default='At3g24650')
    def get(self, species='', gene_id=''):
        """
        This end point provides gene alias given an gene ID
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
                try:
                    rows = AgiAlias.query.filter_by(agi=gene_id).all()
                except OperationalError:
                    gene_information.abort(500, 'An internal error has occurred')
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
