from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.annotations_lookup import AgiAlias
from api.utils.bar_utils import BARUtils
from api import cache

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
    @cache.cached()
    def get(self, species='', gene_id=''):
        """This end point provides gene alias given a gene ID"""
        aliases = []

        # Escape input
        species = escape(species)
        gene_id = escape(gene_id)

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
            return BARUtils.success_exit(aliases)
        else:
            return BARUtils.error_exit('There are no data found for the given gene')
