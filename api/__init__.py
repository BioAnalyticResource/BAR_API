from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from flasgger import Swagger

swaggger_template = {
  "swagger": "2.0",
  "info": {
    "title": "BAR API",
    "description": "API for the Bio-Analytic Resource",
    "version": "0.0.1"
  },
  "schemes": [
    "http"
  ]
}

# Configuration
app = Flask(__name__)
swagger = Swagger(app, template=swaggger_template)
app.config['SQLALCHEMY_BINDS'] = {'annotations_lookup': 'mysql://USER:PASSWORD@localhost/annotations_lookup',
                                  'single_cell': 'mysql://USER:PASSWORD@localhost/single_cell'}

api = Api(app)
db = SQLAlchemy(app)

from api.resources.gene_alias import GeneAlias
from api.resources.rnaseq_gene_expression import RNASeqGeneExpression

# Gene Information
api.add_resource(GeneAlias, '/gene_alias/<string:species>/<string:gene_id>')

# Gene Expression
api.add_resource(RNASeqGeneExpression,
                 '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>/<string:sample_id>',
                 '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>')
