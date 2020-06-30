import re
from flask_restx import Namespace, Resource
from sqlalchemy.exc import OperationalError
from api.models.single_cell import SingleCell
from api.utilities.bar_utilities import BARUtilities

rnaseq_gene_expression = Namespace('RNA-Seq Gene Expression',
                                   description='RNA-Seq Gene Expression data from the BAR Databases',
                                   path='/rnaseq_gene_expression')


@rnaseq_gene_expression.route('/<string:species>/<string:database>/<string:gene_id>')
@rnaseq_gene_expression.route('/<string:species>/<string:database>/<string:gene_id>/<string:sample_id>')
class RNASeqGeneExpression(Resource):
    @rnaseq_gene_expression.param('species', description='', _in='path', default='arabidopsis')
    @rnaseq_gene_expression.param('database', description='', _in='path', default='single_cell')
    @rnaseq_gene_expression.param('gene_id', description='', _in='path', default='At1g01010')
    @rnaseq_gene_expression.param('sample_id', description='', _in='path', default='cluster0_WT1.ExprMean')
    def get(self, species='', database='', gene_id='', sample_id=''):
        """
        This end point returns RNA-Seq gene expression data

        """
        # Variables
        rows = []
        sample_regex = ''

        # Set species and check gene ID format
        if species == 'arabidopsis':
            if not re.search(r"^At[12345CM]g\d{5}$", gene_id, re.I):
                return BARUtilities.error_exit('Invalid gene id')
        else:
            return BARUtilities.error_exit('Invalid species')

        # Set model
        if database == 'single_cell':
            database = SingleCell()
            # This needs to be more strict
            sample_regex = re.compile(r"^[\w+\._]{0,40}$", re.I)
        else:
            return BARUtilities.error_exit('Invalid database')

        # Set sample
        if not sample_regex.search(sample_id):
            return BARUtilities.error_exit('Invalid sample id')

        # Now query the database
        if sample_id == '' or sample_id is None:
            try:
                rows = database.query.filter_by(data_probeset_id=gene_id).all()
            except OperationalError:
                rnaseq_gene_expression.abort(500, 'An internal error has occurred')
        else:
            try:
                rows = database.query.filter_by(data_probeset_id=gene_id, data_bot_id=sample_id).all()
            except OperationalError:
                rnaseq_gene_expression.abort(500, 'An internal error has occurred')

        data = {}
        for row in rows:
            data[row.data_bot_id] = row.data_signal

        # Return results if there are data
        if len(data) > 0:
            return BARUtilities.success_exit(data)
        else:
            return BARUtilities.error_exit('There is no data found for the given gene')
