from api.resources.gene_alias import GeneAlias
from api.resources.rnaseq_gene_expression import RNASeqGeneExpression
from flask_restful import Api


def add_routes(bar_app):
    """
    A helper function to list all the routes
    :param bar_app:
    :return:
    """

    bar_api = Api(bar_app)

    # Gene Information
    bar_api.add_resource(GeneAlias, '/gene_alias/<string:species>/<string:gene_id>')

    # Gene Expression
    bar_api.add_resource(RNASeqGeneExpression,
                         '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>',
                         '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>/<string:sample_id>'
                         )
