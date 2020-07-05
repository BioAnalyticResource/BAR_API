from os import environ
from os.path import expanduser
import redis
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api


def create_app():
    """
    Initialize the app factory based on the official Flask documentation
    """
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

    # Configure the Swagger UI
    bar_app.api = Api(
        title='BAR API',
        version='0.0.1',
        description='API for the Bio-Analytic Resource'
    )

    # Now add routes
    from api.resources.gene_information import gene_information
    from api.resources.rnaseq_gene_expression import rnaseq_gene_expression

    bar_app.api.add_namespace(gene_information)
    bar_app.api.add_namespace(rnaseq_gene_expression)
    bar_app.api.init_app(bar_app)
    return bar_app


# Initialize database system
db = SQLAlchemy()

# Initialize Redis
r = redis.Redis(environ.get('BAR'))

# Now create the bar_app
app = create_app()
