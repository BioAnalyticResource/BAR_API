from flask import Flask
from flask_restful import Api
from flask_sqlalchemy import SQLAlchemy

# Configuration
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = "mysql://<user>:<password>@localhost/annotations_lookup"

api = Api(app)
db = SQLAlchemy(app)

from api.resources.arabidopsis.get_alias import GetAlias

# Arabidopis endpoints
api.add_resource(GetAlias, '/arabidopsis/get_alias/', '/arabidopsis/get_alias/<string:gene_id>')
