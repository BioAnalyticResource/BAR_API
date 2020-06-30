from os import environ
from os.path import expanduser

import redis
from flasgger import Swagger
from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy


def start_redis():
    """
    This functions starts connection to the Redis Server
    :return: redis.Redis() instance
    """
    redis_password = ''
    if environ.get('BAR'):
        redis_password = environ.get('BAR_REDIS_PASSWORD')

    bar_redis = redis.Redis(password=redis_password)
    return bar_redis


def create_app():
    """
    This function create the app
    :return: Flask app
    """
    # Set up variables
    swaggger_template = {
        "swagger": "2.0",
        "info": {
            "title": "BAR API",
            "description": "API for the Bio-Analytic Resource",
            "version": "0.0.1"
        },
        "schemes": [
            "http",
            "https"
        ]
    }

    # Set host name on BAR
    if environ.get('BAR'):
        swaggger_template["host"] = "bar.utoronto.ca"
        swaggger_template["basePath"] = "/api"

    bar_app = Flask(__name__)

    # Load configuration
    if environ.get('TRAVIS'):
        # Travis
        bar_app.config.from_pyfile(environ.get('TRAVIS_BUILD_DIR') + '/config/BAR_API.cfg', silent=True)
    elif environ.get('BAR'):
        # The BAR
        bar_app.config.from_pyfile(environ.get('BAR_API_PATH'), silent=True)
    else:
        # Change this line if you want to load your own configuration
        bar_app.config.from_pyfile(expanduser('~') + '/Asher/BAR_API.cfg', silent=True)

    # Initialize the database
    db.init_app(bar_app)
    # No add routes
    add_routes(bar_app)

    # Initialize Swagger UI
    Swagger(bar_app, template=swaggger_template)

    return bar_app


def add_routes(bar_app):
    """
    A helper function to list all the routes
    :param bar_app:
    :return:
    """
    from api.resources.gene_alias import GeneAlias
    from api.resources.rnaseq_gene_expression import RNASeqGeneExpression

    bar_api = Api(bar_app)

    # Gene Information
    bar_api.add_resource(GeneAlias, '/gene_alias/<string:species>/<string:gene_id>')

    # Gene Expression
    bar_api.add_resource(RNASeqGeneExpression,
                         '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>/<string:sample_id>',
                         '/rnaseq_gene_expression/<string:species>/<string:database>/<string:gene_id>')


############################################################################################################################

# Initialize database system
db = SQLAlchemy()

# Initialize Redis
r = start_redis()

# Now create the app
app = create_app()
