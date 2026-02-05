from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api
from flask_cors import CORS
from flask_caching import Cache
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import os
from pathlib import Path
import tempfile


def create_app():
    """Initialize the app factory based on the official Flask documentation"""
    bar_app = Flask(__name__)
    CORS(bar_app)

    # Load configuration
    if os.environ.get("CI"):
        # Travis
        print("We are now loading configuration.")
        bar_app.config.from_pyfile(os.getcwd() + "/config/BAR_API.cfg", silent=True)

    elif os.environ.get("BAR"):
        # The BAR
        bar_app.config.from_pyfile(os.environ.get("BAR_API_PATH"), silent=True)

        # Load environment variables on the BAR
        if bar_app.config.get("PHENIX"):
            os.environ["PHENIX"] = bar_app.config.get("PHENIX")
        if bar_app.config.get("PHENIX_VERSION"):
            os.environ["PHENIX_VERSION"] = bar_app.config.get("PHENIX_VERSION")
        if bar_app.config.get("PATH"):
            os.environ["PATH"] = bar_app.config.get("PATH") + ":/usr/local/phenix-1.18.2-3874/build/bin"
    else:
        # The localhost
        bar_app.config.from_pyfile(os.path.expanduser("~") + "/.config/BAR_API.cfg", silent=True)

    repo_root = Path(__file__).resolve().parents[1]
    db_dir = repo_root / "config" / "databases"
    if db_dir.exists():
        is_test_run = (
            bar_app.config.get("TESTING")
            or "pytest" in os.sys.modules
            or os.environ.get("BAR_API_AUTO_SQLITE_MIRRORS") == "1"
        )

        # For tests/local dev, build sqlite mirrors in a temp directory (no repo db files needed).
        if is_test_run and not os.environ.get("BAR"):
            from api.utils.sqlite_mirror_utils import build_sqlite_db

            tmp_root = Path(tempfile.gettempdir()) / "bar_api_sqlite"
            tmp_root.mkdir(parents=True, exist_ok=True)

            bind_names = set()
            if bar_app.config.get("SQLALCHEMY_BINDS"):
                bind_names.update(bar_app.config["SQLALCHEMY_BINDS"].keys())
            else:
                bind_names.update(p.stem for p in db_dir.glob("*.sql") if p.stem)

            sqlite_binds = {}
            for name in sorted(bind_names):
                sql_path = db_dir / f"{name}.sql"
                if not sql_path.exists():
                    continue
                db_path = tmp_root / f"{name}.db"
                if (
                    os.environ.get("BAR_API_AUTO_SQLITE_MIRRORS") == "1"
                    or not db_path.exists()
                    or db_path.stat().st_size == 0
                ):
                    build_sqlite_db(sql_path, db_path)
                sqlite_binds[name] = f"sqlite:///{db_path}"

            bar_app.config["SQLALCHEMY_BINDS"] = sqlite_binds

        # If no binds were configured and we're not in test mode, fall back to local sqlite mirrors.
        if not bar_app.config.get("SQLALCHEMY_BINDS"):
            binds = {}
            for db_path in db_dir.glob("*.db"):
                if not db_path.stem:
                    continue
                binds[db_path.stem] = f"sqlite:///{db_path}"
            bar_app.config["SQLALCHEMY_BINDS"] = binds

    # Initialize the databases
    db.init_app(bar_app)

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
    from api.resources.microarray_gene_expression import microarray_gene_expression
    from api.resources.proxy import bar_proxy
    from api.resources.thalemine import thalemine
    from api.resources.snps import snps
    from api.resources.sequence import sequence
    from api.resources.gene_annotation import gene_annotation
    from api.resources.interactions import itrns
    from api.resources.gene_localizations import loc
    from api.resources.efp_image import efp_image
    from api.resources.fastpheno import fastpheno
    from api.resources.llama3 import llama3
    from api.resources.efp_proxy import efp_proxy_ns

    bar_api.add_namespace(gene_information)
    bar_api.add_namespace(rnaseq_gene_expression)
    bar_api.add_namespace(microarray_gene_expression)
    bar_api.add_namespace(bar_proxy)
    bar_api.add_namespace(thalemine)
    bar_api.add_namespace(snps)
    bar_api.add_namespace(sequence)
    bar_api.add_namespace(gene_annotation)
    bar_api.add_namespace(itrns)
    bar_api.add_namespace(loc)
    bar_api.add_namespace(efp_image)
    bar_api.add_namespace(fastpheno)
    bar_api.add_namespace(llama3)
    bar_api.add_namespace(efp_proxy_ns)
    bar_api.init_app(bar_app)
    return bar_app


# Initialize database system
db = SQLAlchemy()

# Initialize Redis
if os.environ.get("BAR"):
    cache = Cache(
        config={
            "CACHE_TYPE": "RedisCache",
            "CACHE_KEY_PREFIX": "BAR_API_",
            "CACHE_REDIS_HOST": os.environ.get("BAR_REDIS_HOST"),
            "CACHE_REDIS_PASSWORD": os.environ.get("BAR_REDIS_PASSWORD"),
        }
    )
else:
    cache = Cache(
        config={
            "CACHE_TYPE": "RedisCache",
            "CACHE_KEY_PREFIX": "BAR_API_",
            "CACHE_REDIS_HOST": "localhost",
        }
    )

# Initialize Limiter
limiter = Limiter(key_func=get_remote_address)

# Now create the bar_app
app = create_app()

if __name__ == "__main__":
    app.run()
