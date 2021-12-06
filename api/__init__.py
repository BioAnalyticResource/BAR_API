from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api
from flask_cors import CORS
from flask_caching import Cache
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from sqlalchemy import MetaData
import os


def create_app():
    """Initialize the app factory based on the official Flask documentation"""
    bar_app = Flask(__name__)
    CORS(bar_app)

    # Load configuration
    if os.environ.get("CI"):
        # Travis
        print("We are now loading configuration.")
        bar_app.config.from_pyfile(os.getcwd() + "/config/BAR_API.cfg", silent=True)
        if bar_app.config.get("ADMIN_ENCRYPT_KEY"):
            os.environ["ADMIN_ENCRYPT_KEY"] = bar_app.config.get(
                "TEST_ADMIN_ENCRYPT_KEY"
            )
        if bar_app.config.get("ADMIN_PASSWORD_FILE"):
            os.environ["ADMIN_PASSWORD_FILE"] = bar_app.config.get(
                "TEST_ADMIN_PASSWORD_FILE"
            )
    elif os.environ.get("BAR"):
        # The BAR
        bar_app.config.from_pyfile(os.environ.get("BAR_API_PATH"), silent=True)
        if bar_app.config.get("ADMIN_ENCRYPT_KEY"):
            os.environ["ADMIN_ENCRYPT_KEY"] = bar_app.config.get("ADMIN_ENCRYPT_KEY")
        if bar_app.config.get("ADMIN_PASSWORD_FILE"):
            os.environ["ADMIN_PASSWORD_FILE"] = bar_app.config.get(
                "ADMIN_PASSWORD_FILE"
            )
        if bar_app.config.get("DRIVE_LIST_KEY"):
            os.environ["DRIVE_LIST_KEY"] = bar_app.config.get("DRIVE_LIST_KEY")
        if bar_app.config.get("DRIVE_LIST_FILE"):
            os.environ["DRIVE_LIST_FILE"] = bar_app.config.get("DRIVE_LIST_FILE")
    else:
        # The localhost
        bar_app.config.from_pyfile(
            os.path.expanduser("~") + "/.config/BAR_API.cfg", silent=True
        )

        # Load environment variables
        if bar_app.config.get("ADMIN_ENCRYPT_KEY"):
            os.environ["ADMIN_ENCRYPT_KEY"] = bar_app.config.get("ADMIN_ENCRYPT_KEY")
        if bar_app.config.get("ADMIN_PASSWORD_FILE"):
            os.environ["ADMIN_PASSWORD_FILE"] = bar_app.config.get(
                "ADMIN_PASSWORD_FILE"
            )
        if bar_app.config.get("DRIVE_LIST_KEY"):
            os.environ["DRIVE_LIST_KEY"] = bar_app.config.get("DRIVE_LIST_KEY")
        if bar_app.config.get("DRIVE_LIST_FILE"):
            os.environ["DRIVE_LIST_FILE"] = bar_app.config.get("DRIVE_LIST_FILE")
        if bar_app.config.get("PHENIX"):
            os.environ["PHENIX"] = bar_app.config.get("PHENIX")
        if bar_app.config.get("PHENIX_VERSION"):
            os.environ["PHENIX_VERSION"] = bar_app.config.get("PHENIX_VERSION")
        if bar_app.config.get("PATH"):
            os.environ["PATH"] = (
                bar_app.config.get("PATH") + ":/usr/local/phenix-1.18.2-3874/build/bin"
            )

    # Initialize the databases
    annotations_lookup_db.init_app(bar_app)
    eplant2_db.init_app(bar_app)
    eplant_poplar_db.init_app(bar_app)
    eplant_tomato_db.init_app(bar_app)
    poplar_nssnp_db.init_app(bar_app)
    tomato_nssnp_db.init_app(bar_app)
    tomato_seq_db.init_app(bar_app)
    single_cell_db.init_app(bar_app)
    summarization_db.init_app(bar_app)
    rice_interactions_db.init_app(bar_app)

    # Initialize the cache
    cache.init_app(bar_app)

    # Initialize rate limiter
    limiter.init_app(bar_app)

    # Configure the Swagger UI
    bar_api = Api(
        title="BAR API",
        version="0.0.1",
        description="API for the Bio-Analytic Resource",
    )

    # Now add routes
    from api.resources.gene_information import gene_information
    from api.resources.rnaseq_gene_expression import rnaseq_gene_expression
    from api.resources.summarization_gene_expression import (
        summarization_gene_expression,
    )
    from api.resources.api_manager import api_manager
    from api.resources.proxy import bar_proxy
    from api.resources.thalemine import thalemine
    from api.resources.snps import snps
    from api.resources.sequence import sequence
    from api.resources.gene_annotation import gene_annotation
    from api.resources.interactions import itrns
    from api.resources.gene_localizations import loc
    from api.resources.efp_image import efp_image

    bar_api.add_namespace(gene_information)
    bar_api.add_namespace(rnaseq_gene_expression)
    bar_api.add_namespace(summarization_gene_expression)
    bar_api.add_namespace(api_manager)
    bar_api.add_namespace(bar_proxy)
    bar_api.add_namespace(thalemine)
    bar_api.add_namespace(snps)
    bar_api.add_namespace(sequence)
    bar_api.add_namespace(gene_annotation)
    bar_api.add_namespace(itrns)
    bar_api.add_namespace(loc)
    bar_api.add_namespace(efp_image)
    bar_api.init_app(bar_app)
    return bar_app


# Initialize database system
# This is needed because multiple databases have the same database name
# Metadata cannot have multiple tables with the same name
annotations_lookup_db = SQLAlchemy(metadata=MetaData())
eplant2_db = SQLAlchemy(metadata=MetaData())
eplant_poplar_db = SQLAlchemy(metadata=MetaData())
eplant_tomato_db = SQLAlchemy(metadata=MetaData())
poplar_nssnp_db = SQLAlchemy(metadata=MetaData())
tomato_nssnp_db = SQLAlchemy(metadata=MetaData())
tomato_seq_db = SQLAlchemy(metadata=MetaData())
single_cell_db = SQLAlchemy(metadata=MetaData())
summarization_db = SQLAlchemy(metadata=MetaData())
rice_interactions_db = SQLAlchemy(metadata=MetaData())

# Initialize Redis
cache = Cache(
    config={
        "CACHE_TYPE": "flask_caching.backends.redis",
        "CACHE_KEY_PREFIX": "BAR_API_",
        "CACHE_REDIS_PASSWORD": os.environ.get("BAR_REDIS_PASSWORD"),
    }
)

# Initialize Limiter
limiter = Limiter(key_func=get_remote_address)

# Now create the bar_app
app = create_app()

if __name__ == "__main__":
    app.run()
