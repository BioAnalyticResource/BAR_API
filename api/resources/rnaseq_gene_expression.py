import re
from flask_restx import Namespace, Resource, fields
from flask import request
from sqlalchemy.exc import OperationalError
from api.models.single_cell import SingleCell
from api.utilities.bar_utilities import BARUtilities
from markupsafe import escape

rnaseq_gene_expression = Namespace('RNA-Seq Gene Expression',
                                   description='RNA-Seq Gene Expression data from the BAR Databases',
                                   path='/rnaseq_gene_expression')

# I think this is only needed for Swagger UI POST
resource_fields = rnaseq_gene_expression.model('GeneExpression', {
    'species': fields.String(required=True, example='arabidopsis'),
    'database': fields.String(required=True, example='single_cell'),
    'gene_id': fields.String(required=True, example='At1g01010'),
    'sample_ids': fields.List(example=['cluster0_WT1.ExprMean', 'cluster0_WT2.ExprMean', 'cluster0_WT3.ExprMean'],
                              cls_or_instance=fields.String)
})


class RNASeqUtils:
    @staticmethod
    def get_data(species, database, gene_id, sample_ids=None):
        if sample_ids is None:
            sample_ids = []
        data = {}

        # Set species and check gene ID format
        if species == 'arabidopsis':
            if not re.search(r"^At[12345CM]g\d{5}$", gene_id, re.I):
                return {'success': False, 'error': 'Invalid gene id', 'error_code': 400}
        else:
            return {'success': False, 'error': 'Invalid species', 'error_code': 400}

        # Set model
        if database == 'single_cell':
            database = SingleCell()
            # This needs to be more strict
            sample_regex = re.compile(r"^[\w+\._]{0,40}$", re.I)
        else:
            return {'success': False, 'error': 'Invalid database', 'error_code': 400}

        # Now query the database
        if len(sample_ids) == 0 or sample_ids is None:
            try:
                rows = database.query.filter_by(data_probeset_id=gene_id).all()
            except OperationalError:
                return {'success': False, 'error': 'An internal error has occurred', 'error_code': 500}

            if len(rows) > 0:
                for row in rows:
                    data[row.data_bot_id] = row.data_signal
        else:
            # Set sample
            for sample_id in sample_ids:
                if not sample_regex.search(sample_id):
                    return {'success': False, 'error': 'Invalid sample id', 'error_code': 400}

                try:
                    rows = database.query.filter_by(data_probeset_id=gene_id, data_bot_id=sample_id).all()
                except OperationalError:
                    return {'success': False, 'error': 'An internal error has occurred', 'error_code': 500}

                if len(rows) > 0:
                    for row in rows:
                        data[row.data_bot_id] = row.data_signal

        return {'success': True, 'data': data}


@rnaseq_gene_expression.route('/')
class PostRNASeqExpression(Resource):
    @rnaseq_gene_expression.expect(resource_fields)
    def post(self):
        json_data = request.get_json()
        species = json_data['species']
        database = json_data['database']
        gene_id = json_data['gene_id']
        sample_ids = json_data['sample_ids']

        results = RNASeqUtils.get_data(species, database, gene_id, sample_ids)

        if results['success']:
            # Return results if there are data
            if len(results['data']) > 0:
                return BARUtilities.success_exit(results['data'])
            else:
                return BARUtilities.error_exit('There is no data found for the given gene')
        else:
            return BARUtilities.error_exit(results['error']), results['error_code']


@rnaseq_gene_expression.route('/<string:species>/<string:database>/<string:gene_id>')
class GetRNASeqGeneExpression(Resource):
    @rnaseq_gene_expression.param('species', description='', _in='path', default='arabidopsis')
    @rnaseq_gene_expression.param('database', description='', _in='path', default='single_cell')
    @rnaseq_gene_expression.param('gene_id', description='', _in='path', default='At1g01010')
    def get(self, species='', database='', gene_id=''):
        """
        This end point returns RNA-Seq gene expression data

        """
        # Variables
        species = escape(species)
        database = escape(database)
        gene_id = escape(gene_id)

        results = RNASeqUtils.get_data(species, database, gene_id)

        if results['success']:
            # Return results if there are data
            if len(results['data']) > 0:
                return BARUtilities.success_exit(results['data'])
            else:
                return BARUtilities.error_exit('There is no data found for the given gene')
        else:
            return BARUtilities.error_exit(results['error']), results['error_code']


@rnaseq_gene_expression.route('/<string:species>/<string:database>/<string:gene_id>/<string:sample_id>')
class GetRNASeqGeneExpressionSample(Resource):
    @rnaseq_gene_expression.param('species', description='', _in='path', default='arabidopsis')
    @rnaseq_gene_expression.param('database', description='', _in='path', default='single_cell')
    @rnaseq_gene_expression.param('gene_id', description='', _in='path', default='At1g01010')
    @rnaseq_gene_expression.param('sample_id', description='', _in='path', default='cluster0_WT1.ExprMean')
    def get(self, species='', database='', gene_id='', sample_id=''):
        """
        This end point returns RNA-Seq gene expression data

        """
        # Variables
        species = escape(species)
        database = escape(database)
        gene_id = escape(gene_id)
        sample_id = escape(sample_id)

        results = RNASeqUtils.get_data(species, database, gene_id, [sample_id])

        if results['success']:
            # Return results if there are data
            if len(results['data']) > 0:
                return BARUtilities.success_exit(results['data'])
            else:
                return BARUtilities.error_exit('There is no data found for the given gene')
        else:
            return BARUtilities.error_exit(results['error']), results['error_code']
