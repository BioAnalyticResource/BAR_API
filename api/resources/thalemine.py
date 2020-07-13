from flask_restx import Namespace, Resource
from api.utils.bar_utils import BARUtils
from markupsafe import escape
from api import r
from flask import request
import requests
import json

thalemine = Namespace('ThaleMine', description='ThaleMine API client', path='/thalemine')

# Request header of almost all ThaleMine Requests
request_headers = {'user-agent': 'BAR API', 'content-type': 'application/x-www-form-urlencoded; charset=UTF-8'}


@thalemine.route('/gene_rifs/<string:gene_id>')
class ThaleMineGeneRIFs(Resource):
    @thalemine.param('gene_id', _in='path', default='At1g01020')
    def get(self, gene_id=''):
        """This end point retrieves Gene RIFs from ThaleMine given an AGI ID"""
        gene_id = escape(gene_id)
        redis_key = request.url

        # Is data valid
        if not BARUtils.is_arabidopsis_gene_valid(gene_id):
            return BARUtils.error_exit('Invalid gene id'), 400

        # Check if redis is running and results are cached
        if BARUtils.is_redis_available():
            redis_value = r.get(redis_key)
            # If the request is stored then return value
            if redis_value:
                redis_value = json.loads(redis_value)
                return redis_value

        query = '<query name="" model="genomic" view="Gene.geneRifs.annotation Gene.geneRifs.timeStamp ' \
                'Gene.geneRifs.publication.pubMedId" longDescription="" sortOrder="Gene.geneRifs.annotation ' \
                'asc"><constraint path="Gene.primaryIdentifier" op="=" value="{}"/></query> '
        query = query.format(gene_id)

        # Now query the web service
        payload = {'format': 'json', 'query': query}
        resp = requests.post('https://bar.utoronto.ca/thalemine/service/query/results', data=payload,
                             headers=request_headers)
        result = resp.json()

        # Set up cache if it does not exist
        if BARUtils.is_redis_available() and r.get(redis_key) is None:
            r.set(redis_key, json.dumps(result))

        return result
