from flask_restx import Namespace, Resource, fields
from flask import request
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.annotations_lookup import AgiAlias
from api.models.eplant2 import isoforms
from api.utils.bar_utils import BARUtils
from marshmallow import Schema, ValidationError, fields as marshmallow_fields
from api import cache

gene_information = Namespace('Gene Information', description='Information about Genes', path='/gene_information')

# I think this is only needed for Swagger UI POST
gene_isoforms_request_fields = gene_information.model('GeneIsoforms', {
    'species': fields.String(required=True, example='arabidopsis'),
    'genes': fields.List(required=True, example=['AT1G01010', 'AT1G01020'], cls_or_instance=fields.String)
})


# Validation is done in a different way to keep things simple
class GeneIsoformsSchema(Schema):
    species = marshmallow_fields.String(required=True)
    genes = marshmallow_fields.List(cls_or_instance=marshmallow_fields.String)


@gene_information.route('/gene_alias')
class GeneAliasList(Resource):
    def get(self):
        """This end point returns the list of species available"""
        species = ['arabidopsis']  # This are the only species available so far
        return BARUtils.success_exit(species)


@gene_information.route('/gene_alias/<string:species>/<string:gene_id>')
class GeneAlias(Resource):
    @gene_information.param('species', _in='path', default='arabidopsis')
    @gene_information.param('gene_id', _in='path', default='At3g24650')
    @cache.cached()
    def get(self, species='', gene_id=''):
        """This end point provides gene alias given a gene ID"""
        aliases = []

        # Escape input
        species = escape(species)
        gene_id = escape(gene_id)

        if species == 'arabidopsis':
            if BARUtils.is_arabidopsis_gene_valid(gene_id):
                try:
                    rows = AgiAlias.query.filter_by(agi=gene_id).all()
                except OperationalError:
                    return BARUtils.error_exit('An internal error has occurred'), 500
                [aliases.append(row.alias) for row in rows]
            else:
                return BARUtils.error_exit('Invalid gene id'), 400
        else:
            return BARUtils.error_exit('No data for the given species')

        # Return results if there are data
        if len(aliases) > 0:
            return BARUtils.success_exit(aliases)
        else:
            return BARUtils.error_exit('There are no data found for the given gene')


@gene_information.route('/gene_isoforms/<string:species>/<string:gene_id>')
class GeneIsoforms(Resource):
    @gene_information.param('species', _in='path', default='arabidopsis')
    @gene_information.param('gene_id', _in='path', default='AT1G01020')
    def get(self, species='', gene_id=''):
        """This end point provides gene isoforms given a gene ID"""
        gene_isoforms = []

        # Escape input
        species = escape(species)
        gene_id = escape(gene_id)

        if species == 'arabidopsis':
            if BARUtils.is_arabidopsis_gene_valid(gene_id):
                try:
                    rows = isoforms.query.filter_by(gene=gene_id).all()
                except OperationalError:
                    return BARUtils.error_exit('An internal error has occurred'), 500
                [gene_isoforms.append(row.isoform) for row in rows]
            else:
                return BARUtils.error_exit('Invalid gene id'), 400
        else:
            return BARUtils.error_exit('No data for the given species')

        # Return results if there are data
        if len(gene_isoforms) > 0:
            return BARUtils.success_exit(gene_isoforms)
        else:
            return BARUtils.error_exit('There are no data found for the given gene')


@gene_information.route('/gene_isoforms/')
class PostGeneIsoforms(Resource):
    @gene_information.expect(gene_isoforms_request_fields)
    def post(self):
        """This end point returns gene expression data for a single gene and multiple samples."""

        json_data = request.get_json()
        data = {}

        # Validate json
        try:
            json_data = GeneIsoformsSchema().load(json_data)
        except ValidationError as err:
            return BARUtils.error_exit(err.messages), 400

        genes = json_data['genes']
        species = json_data['species']

        # Set species and check gene ID format
        if species == 'arabidopsis':
            for gene in genes:
                if not BARUtils.is_arabidopsis_gene_valid(gene):
                    return BARUtils.error_exit('Invalid gene id'), 400
        else:
            return BARUtils.error_exit('Invalid species'), 400

        # Query the database
        database = isoforms()
        try:
            rows = database.query.filter(isoforms.gene.in_(genes)).all()
        except OperationalError:
            return BARUtils.error_exit('An internal error has occurred.'), 500

        if len(rows) > 0:
            for row in rows:
                if row.gene in data:
                    data[row.gene].append(row.isoform)
                else:
                    data[row.gene] = []
                    data[row.gene].append(row.isoform)
        else:
            return BARUtils.error_exit('No data for the given species/genes'), 400

        return BARUtils.success_exit(data)
