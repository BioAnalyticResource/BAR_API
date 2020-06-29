from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from flasgger import Swagger
from os.path import expanduser
from os import environ
import redis

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

app = Flask(__name__)
redis_password = ''

# Load configuration
if environ.get('TRAVIS'):
    # Travis
    app.config.from_pyfile(environ.get('TRAVIS_BUILD_DIR') + '/config/BAR_API.cfg', silent=True)
elif environ.get('BAR'):
    # The BAR
    app.config.from_pyfile(environ.get('BAR_API_PATH'), silent=True)
    redis_password = environ.get('BAR_REDIS_PASSWORD')
else:
    # Change this line if you want to load your own configuration
    app.config.from_pyfile(expanduser('~') + '/Asher/BAR_API.cfg', silent=True)

# Initialize Swagger UI
swagger = Swagger(app, template=swaggger_template)

# Initial API and db
api = Api(app)
db = SQLAlchemy(app)

# Start Redis
r = redis.Redis(password=redis_password)
