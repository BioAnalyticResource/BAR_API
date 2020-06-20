from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy
from flasgger import Swagger

# Start the app
app = Flask(__name__)

# Configuration
app.config['SWAGGER'] = {
    'title': 'My API',
    'uiversion': 3,
    'hide_top_bar': True
}

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

# Initialize Databases
app.config['SQLALCHEMY_BINDS'] = {'annotations_lookup': 'mysql://USER:PASSWORD@localhost/annotations_lookup',
                                  'single_cell': 'mysql://USER:PASSWORD@localhost/single_cell'}

# Initial API and db
api = Api(app)
db = SQLAlchemy(app)
