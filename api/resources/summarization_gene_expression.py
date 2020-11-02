import requests
import os
import re
import uuid
import pandas
from api.models.summarization_gene_expression import SummarizationGeneExpression
from api import db
from flask import request, jsonify, abort
from werkzeug.utils import secure_filename
from api.utils.bar_utils import BARUtils
from flask_restx import Namespace, Resource


UPLOAD_FOLDER = '/windir/c/Users/Bruno/Documents'
SUMMARIZATION_FILES_PATH = '../gene-summarization-bar/summarization'
CROMWELL_URL = "http://127.0.0.1:8000"


summarization_gene_expression = Namespace('Summarization Gene Expression',
                                          description='Gene Expression data from the BAR\'s summarization procedure',
                                          path='/summarization_gene_expression')


class SummarizationGeneExpressionUtils:
    @staticmethod
    def get_table_object(uid):
        metadata = db.MetaData()
        table_object = db.Table(uid, metadata,
                                db.Column('Gene', primary_key=True),
                                db.Column('Sample', primary_key=True),
                                db.Column('Value', primary_key=True)
                                )
        db.clear_mappers()
        db.mapper(SummarizationGeneExpression, table_object)
        return table_object

    @staticmethod
    def is_valid(string):
        if re.search("([^_0-9A-Za-z])+", string):
            return False
        else:
            return True


@summarization_gene_expression.route('/summarize', methods=["POST"])
class SummarizationGeneExpressionSummarize(Resource):
    def post(self):
        if request.remote_addr != '127.0.0.1':
            abort(403)
        if(request.method == "POST"):
            json = request.get_json()
            uid = uuid.uuid4().hex
            inputs = """
                    {
                    "geneSummarization.gtf": "./data/Araport11_GFF3_genes_transposons.201606.gtf",
                    "geneSummarization.summarizeGenesScript": "./summarize_genes.R",
                    "geneSummarization.downloadFilesScript": "./downloadDriveFiles.py",
                    "geneSummarization.insertDataScript": "./insertData.py",
                    "geneSummarization.credentials": "./data/credentials.json",
                    "geneSummarization.token": "./data/token.pickle",
                    "geneSummarization.aliases": "./data/aliases.txt",
                    "geneSummarization.folderId": """ + json["folderId"] + """,
                    "geneSummarization.id": """ + str(uid) + """
                    }
                    """
            # Create DB
            # Send request to Cromwell
            files = {'workflowSource': ('rpkm.wdl', open(SUMMARIZATION_FILES_PATH + '/rpkm.wdl', 'rb')), 'workflowInputs': ('rpkm_inputs.json', inputs)}
            requests.post(CROMWELL_URL + '/api/workflows/v1', files=files)
            # Return ID for future accessing
            return uid


@summarization_gene_expression.route('/csv_upload', methods=["POST"])
class SummarizationGeneExpressionCsvUpload(Resource):
    def post(self):
        if request.remote_addr != '127.0.0.1':
            abort(403)
        if(request.method == "POST"):
            if('file' not in request.files):
                print("Error")
            file = request.files['file']
            if file:
                filename = secure_filename(file.filename)
                file.save(os.path.join(UPLOAD_FOLDER, filename))
                uid = uuid.uuid4().hex
                inputs = """
                        {
                        "csvUpload.insertDataScript": "./insertData.py",
                        "csvUpload.id": """ + str(uid) + """,
                        "csvUpload.csv": """ + os.path.join(UPLOAD_FOLDER, filename) + """,
                        }
                        """
                files = {'workflowSource': ('csvUpload.wdl', open(SUMMARIZATION_FILES_PATH + '/csvUpload.wdl', 'rb')), 'workflowInputs': ('rpkm_inputs.json', inputs)}
                requests.post(CROMWELL_URL + '/api/workflows/v1', files=files)
                return uid


@summarization_gene_expression.route('/insert', methods=["POST"])
class SummarizationGeneExpressionInsert(Resource):
    def post(self):
        if request.remote_addr != '127.0.0.1':
            abort(403)
        if(request.method == "POST"):
            csv = request.get_json().get("csv")
            db_id = request.get_json().get("uid")
            print(csv)
            print(db_id)
            df = pandas.read_csv(csv)
            db_id = db_id.split(".")[0]
            df = df.melt(id_vars=["Gene"], var_name="Sample", value_name="Value")
            db_id = db_id.split("/")[len(db_id.split("/"))-1]
            con = db.get_engine(bind='summarization')
            df.to_sql(db_id, con, if_exists='append', index=True)


@summarization_gene_expression.route('/value', methods=["GET"])
class SummarizationGeneExpressionValue(Resource):
    def get(self):
        gene = request.args.get('gene')
        if not BARUtils.is_arabidopsis_gene_valid(gene):
            return {'success': False, 'error': 'Invalid gene id', 'error_code': 400}
        else:
            sample = request.args.get('sample') if request.args.get('sample') else ''
            uid = request.args.get('id')
            con = db.get_engine(bind='summarization')
            tbl = SummarizationGeneExpressionUtils.get_table_object(uid)
            if(sample == ''):
                values = {}
                rows = con.execute(tbl.select(tbl.c.Value).where(tbl.c.Gene == gene))
                for row in rows:
                    values.update({row.Sample: row.Value})
            else:
                values = []
                rows = con.execute(tbl.select(tbl.c.Value).where(tbl.c.Sample == sample).where(tbl.c.Gene == gene))
                [values.append((row.Value)) for row in rows]
            return jsonify(values)


@summarization_gene_expression.route('/samples', methods=["GET"])
class SummarizationGeneExpressionSamples(Resource):
    def get(self):
        uid = request.args.get('id')
        con = db.get_engine(bind='summarization')
        tbl = SummarizationGeneExpressionUtils.get_table_object(uid)
        values = []
        rows = con.execute(db.select([tbl.c.Sample]).distinct())
        [values.append((row.Sample)) for row in rows]
        return jsonify(values)


@summarization_gene_expression.route('/genes', methods=["GET"])
class SummarizationGeneExpressionGenes(Resource):
    def get(self):
        uid = request.args.get('id')
        con = db.get_engine(bind='summarization')
        tbl = SummarizationGeneExpressionUtils.get_table_object(uid)
        values = []
        rows = con.execute(db.select([tbl.c.Gene]).distinct())
        [values.append((row.Sample)) for row in rows]
        return jsonify(values)


@summarization_gene_expression.route('/find_gene', methods=["GET"])
class SummarizationGeneExpressionFindGene(Resource):
    def get(self):
        uid = request.args.get('id')
        string = request.args.get('string')
        con = db.get_engine(bind='summarization')
        tbl = SummarizationGeneExpressionUtils.get_table_object(uid) 
        values = []
        rows = con.execute(db.select([tbl.c.Gene]).where(tbl.c.Gene.contains(string)))
        [values.append((row.Gene)) for row in rows]
        return jsonify(values)


@summarization_gene_expression.route('/table_exists', methods=["GET"])
class SummarizationGeneExpressionDbExists(Resource):
    def get(self):
        uid = request.args.get('id')
        con = db.get_engine(bind='summarization')
        return jsonify(con.dialect.has_table(con, uid))


@summarization_gene_expression.route('/drop_table', methods=["GET"])
class SummarizationGeneExpressionDbExists(Resource):
    def get(self):
        if request.remote_addr != '127.0.0.1':
            abort(403)
        uid = request.args.get('id')
        con = db.get_engine(bind='summarization')
        tbl = SummarizationGeneExpressionUtils.get_table_object(uid) 
        tbl.drop()
