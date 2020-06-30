from os import environ
from os.path import expanduser
import redis
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api


class BARRedis(redis.Redis):
    def __init__(self):
        """
        This functions starts connection to the Redis Server
        :return: redis.Redis() instance
        """
        # Set the Redis password if we are on the BAR
        self.redis_password = ''
        if environ.get('BAR'):
            self.redis_password = environ.get('BAR_REDIS_PASSWORD')
        super().__init__(password=self.redis_password)


class BARApi:
    def __init__(self):
        """
        Initialize BAR API class
        """
        self.bar_app = Flask(__name__)

        # Load configuration
        if environ.get('TRAVIS'):
            # Travis
            self.bar_app.config.from_pyfile(environ.get('TRAVIS_BUILD_DIR') + '/config/BAR_API.cfg', silent=True)
        elif environ.get('BAR'):
            # The BAR
            self.bar_app.config.from_pyfile(environ.get('BAR_API_PATH'), silent=True)
        else:
            # Change this line if you want to load your own configuration
            self.bar_app.config.from_pyfile(expanduser('~') + '/Asher/BAR_API.cfg', silent=True)

        # Initialize the database
        db.init_app(self.bar_app)
        # Now add routes
        api = Api(
            title='BAR API',
            version='0.0.1',
            description='API for the Bio-Analytic Resource'
        )

        from api.resources.gene_information import gene_information
        from api.resources.rnaseq_gene_expression import rnaseq_gene_expression

        api.add_namespace(gene_information)
        api.add_namespace(rnaseq_gene_expression)
        api.init_app(self.bar_app)

    def create_app(self):
        """
        This function create the app
        :return: Flask app
        """
        # Set up variables
        return self.bar_app


############################################################################################################################

# Initialize database system
db = SQLAlchemy()

# Initialize Redis
r = BARRedis()

# Now create the app
app = BARApi().create_app()
