from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from flasgger import Swagger

# Start the app
app = Flask(__name__)

# Load configuration
app.config.from_pyfile('/home/asher/Asher/BAR_API.cfg', silent=True)

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
