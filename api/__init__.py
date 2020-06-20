from api.base import api
from api.resources.gene_alias import GeneAlias
from api.resources.rnaseq_gene_expression import RNASeqGeneExpression

# Gene Information
api.add_resource(GeneAlias, '/gene_alias/<string:species>/<string:gene_id>')

# Gene Expression
api.add_resource(RNASeqGeneExpression,
                 '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>/<string:sample_id>',
                 '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>')
