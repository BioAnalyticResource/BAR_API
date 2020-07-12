import json
from flask import request
from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api import r
from api.models.annotations_lookup import AgiAlias
from api.utils.bar_utils import BARUtils

gene_information = Namespace('Gene Information', description='Information about Genes', path='/gene_information')


@gene_information.route('/gene_alias')
class GeneAliasList(Resource):
    def get(self):
        """This end point returns the list of species available"""
        species = ['arabidopsis']  # This are the only species available so far
        return BARUtils.success_exit(species)


@gene_information.route('/gene_alias/<string:species>/<string:gene_id>')
class GeneAlias(Resource):
    @gene_information.param('species', _in='path', default='arabidopsis')
    @gene_information.param('gene_id', _in='path', default='At3g24650')
    def get(self, species='', gene_id=''):
        """This end point provides gene alias given a gene ID"""
        aliases = []
        redis_key = request.url

        # Escape input
        species = escape(species)
        gene_id = escape(gene_id)

        # Check if redis is running and results are cached
        if BARUtils.is_redis_available():
            redis_value = r.get(redis_key)
            # If the request is stored then return value
            if redis_value:
                redis_value = json.loads(redis_value)
                return BARUtils.success_exit(redis_value)

        if species == 'arabidopsis':
            if BARUtils.is_arabidopsis_gene_valid(gene_id):
                try:
                    rows = AgiAlias.query.filter_by(agi=gene_id).all()
                except OperationalError:
                    return BARUtils.error_exit('An internal error has occurred'), 500
                [aliases.append(row.alias) for row in rows]
            else:
                return BARUtils.error_exit('Invalid gene id'), 400
        else:
            return BARUtils.error_exit('No data for the given species')

        # Return results if there are data
        if len(aliases) > 0:
            # Set up cache if it does not exist
            if BARUtils.is_redis_available() and r.get(redis_key) is None:
                r.set(redis_key, json.dumps(aliases))
            return BARUtils.success_exit(aliases)
        else:
            return BARUtils.error_exit('There are no data found for the given gene')
