from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from flasgger import Swagger
from socket import gethostname
from os.path import expanduser
from os import environ

# Start the app
app = Flask(__name__)

# Load configuration
if environ.get('TRAVIS'):
    # Travis
    pass
elif gethostname() == 'bar':
    # The BAR
    app.config.from_pyfile(environ.get('BAR_API_PATH'), silent=True)
else:
    # Change this line if you want to load your own configuration
    app.config.from_pyfile(expanduser('~') + '/Asher/BAR_API.cfg', silent=True)

swaggger_template = {
    "swagger": "2.0",
    "info": {
        "title": "BAR API",
        "description": "API for the Bio-Analytic Resource",
        "version": "0.0.1"
    },
    "host": "bar.utoronto.ca",
    "basePath": "/api",
    "schemes": [
        "http",
        "https"
    ]
}

# Initialize Swagger UI
swagger = Swagger(app, template=swaggger_template)

# Initial API and db
api = Api(app)
db = SQLAlchemy(app)
