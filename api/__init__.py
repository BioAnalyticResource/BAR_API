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


class BARApi(Flask):
    def __init__(self):
        """
        Initialize BAR API class
        """
        super().__init__(__name__)

        # Load configuration
        if environ.get('TRAVIS'):
            # Travis
            self.config.from_pyfile(environ.get('TRAVIS_BUILD_DIR') + '/config/BAR_API.cfg', silent=True)
        elif environ.get('BAR'):
            # The BAR
            self.config.from_pyfile(environ.get('BAR_API_PATH'), silent=True)
        else:
            # Change this line if you want to load your own configuration
            self.config.from_pyfile(expanduser('~') + '/Asher/BAR_API.cfg', silent=True)

        # Initialize the database
        db.init_app(self)

        # Now add routes
        self.api = Api(
            title='BAR API',
            version='0.0.1',
            description='API for the Bio-Analytic Resource'
        )

        from api.resources.gene_information import gene_information
        from api.resources.rnaseq_gene_expression import rnaseq_gene_expression

        self.api.add_namespace(gene_information)
        self.api.add_namespace(rnaseq_gene_expression)
        self.api.init_app(self)


############################################################################################################################

# Initialize database system
db = SQLAlchemy()

# Initialize Redis
r = BARRedis()

# Now create the app
app = BARApi()
