from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api
from flask_cors import CORS
from flask_caching import Cache
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import os


def create_app():
    """Initialize the app factory based on the official Flask documentation"""
    bar_app = Flask(__name__)
    CORS(bar_app)

    # Load configuration
    if os.environ.get('CI'):
        # Travis
        print('We are now loading configuration.')
        bar_app.config.from_pyfile(os.getcwd() + '/config/BAR_API.cfg', silent=True)
    elif os.environ.get('BAR'):
        # The BAR
        bar_app.config.from_pyfile(os.environ.get('BAR_API_PATH'), silent=True)
    else:
        # The localhost
        bar_app.config.from_pyfile(os.path.expanduser('~') + '/.config/BAR_API.cfg', silent=True)

        # Load environment variables
        if bar_app.config.get('API_MANAGER_KEY'):
            os.environ['API_MANAGER_KEY'] = bar_app.config.get('API_MANAGER_KEY')
        if bar_app.config.get('PHENIX'):
            os.environ['PHENIX'] = bar_app.config.get('PHENIX')
        if bar_app.config.get('PHENIX_VERSION'):
            os.environ['PHENIX_VERSION'] = bar_app.config.get('PHENIX_VERSION')
        if bar_app.config.get('PATH'):
            os.environ['PATH'] = bar_app.config.get('PATH') + ':/usr/local/phenix-1.18.2-3874/build/bin'

    # Initialize the database
    db.init_app(bar_app)

    # Initialize the cache
    cache.init_app(bar_app)

    # Initialize rate limiter
    limiter.init_app(bar_app)

    # Configure the Swagger UI
    bar_api = Api(
        title='BAR API',
        version='0.0.1',
        description='API for the Bio-Analytic Resource'
    )

    # Now add routes
    from api.resources.gene_information import gene_information
    from api.resources.rnaseq_gene_expression import rnaseq_gene_expression
    from api.resources.summarization_gene_expression import summarization_gene_expression
    from api.resources.api_manager import api_manager
    from api.resources.proxy import bar_proxy
    from api.resources.thalemine import thalemine
    from api.resources.snps import snps

    bar_api.add_namespace(gene_information)
    bar_api.add_namespace(rnaseq_gene_expression)
    bar_api.add_namespace(summarization_gene_expression)
    bar_api.add_namespace(api_manager)
    bar_api.add_namespace(bar_proxy)
    bar_api.add_namespace(thalemine)
    bar_api.add_namespace(snps)
    bar_api.init_app(bar_app)
    return bar_app


# Initialize database system
db = SQLAlchemy()

# Initialize Redis
cache = Cache(config={
    'CACHE_TYPE': 'redis',
    'CACHE_KEY_PREFIX': 'BAR_API_',
    'CACHE_REDIS_PASSWORD': os.environ.get('BAR_REDIS_PASSWORD')
})

# Initialize Limiter
limiter = Limiter(key_func=get_remote_address)

# Now create the bar_app
app = create_app()

if __name__ == '__main__':
    app.run()
