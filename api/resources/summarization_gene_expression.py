import requests
import os
import re
import datetime
import pandas
from api import db
from flask import request, abort, send_file
from werkzeug.utils import secure_filename
from api.utils.bar_utils import BARUtils
from flask_restx import Namespace, Resource
from sqlalchemy.exc import SQLAlchemyError


DATA_FOLDER = '/home/bpereira/dev/summarization-data'
SUMMARIZATION_FILES_PATH = '/home/bpereira/dev/gene-summarization-bar/summarization'
CROMWELL_URL = 'http://localhost:3020'


summarization_gene_expression = Namespace('Summarization Gene Expression',
                                          description='Gene Expression data from the BAR\'s summarization procedure',
                                          path='/summarization_gene_expression')


class SummarizationGeneExpressionUtils:
    @staticmethod
    def get_table_object(table_name):
        metadata = db.MetaData()
        table_object = db.Table(table_name, metadata, autoload=True, autoload_with=db.get_engine(bind="summarization"))
        return table_object

    @staticmethod
    def is_valid(string):
        """Checks if a given string only contains alphanumeric characters
        :param string: The string to be checked
        """
        if re.search("([^_0-9A-Za-z])+", string):
            return False
        else:
            return True

    @staticmethod
    def validate_api_key(key):
        """Checks if a given API key is in the Users database
        :param key: The API key to be checked
        """
        tbl = SummarizationGeneExpressionUtils.get_table_object("users")
        con = db.get_engine(bind='summarization')
        try:
            row = con.execute(db.select([tbl.c.uses_left]).where(tbl.c.api_key == key)).first()
        except SQLAlchemyError as e:
            error = str(e.__dict__['orig'])
            return error
        if(row is None):
            return False
        else:
            if row.uses_left > 0:
                return True
            else:
                return False

    @staticmethod
    def decrement_uses(key):
        """Subtracts 1 from the uses_left column of the user whose key matches the given string
        :param key: The user's API key
        """
        if(SummarizationGeneExpressionUtils.validate_api_key(key)):
            tbl = SummarizationGeneExpressionUtils.get_table_object("users")
            con = db.get_engine(bind='summarization')
            try:
                con.execute(db.update(tbl).where(tbl.c.api_key == key).values(uses_left=(tbl.c.uses_left - 1)))
                db.session.commit()
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return error
            return True
        else:
            return False


@summarization_gene_expression.route('/summarize', methods=["POST"])
class SummarizationGeneExpressionSummarize(Resource):
    def post(self):
        """Takes a Google Drive folder ID (containing BAM files) and submits them to the Cromwell server for summarization
        """
        if(request.method == "POST"):
            json = request.get_json()
            key = request.headers.get("X-Api-Key")
            if(SummarizationGeneExpressionUtils.decrement_uses(key)):
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
                        "geneSummarization.id": """ + key + """
                        }
                        """
                # Create DB
                # Send request to Cromwell
                path = os.path.join(SUMMARIZATION_FILES_PATH, "rpkm.wdl")
                files = {'workflowSource': ('rpkm.wdl', open(path, 'rb')), 'workflowInputs': ('rpkm_inputs.json', inputs)}
                requests.post(CROMWELL_URL + '/api/workflows/v1', files=files)
                # Return ID for future accessing
            return BARUtils.success_exit(key), 200


@summarization_gene_expression.route('/csv_upload', methods=["POST"])
class SummarizationGeneExpressionCsvUpload(Resource):
    def post(self):
        """Takes a CSV file containing expression data and inserts the data into the database
        """
        if(request.method == "POST"):
            if('file' not in request.files):
                return BARUtils.error_exit("No file attached"), 400
            file = request.files['file']
            if file:
                filename = secure_filename(file.filename)
                key = request.headers.get("X-Api-Key")
                file.save(os.path.join(DATA_FOLDER + "/" + key + "/", filename))
                if(SummarizationGeneExpressionUtils.decrement_uses(key)):
                    inputs = """
                            {
                            "csvUpload.insertDataScript": "./insertData.py",
                            "csvUpload.id": """ + key + """,
                            "csvUpload.csv": """ + os.path.join(DATA_FOLDER, key, filename) + """,
                            }
                            """
                    path = os.path.join(SUMMARIZATION_FILES_PATH, "csvUpload.wdl")
                    files = {'workflowSource': ('csvUpload.wdl',
                                                open(path, 'rb')),
                             'workflowInputs': ('rpkm_inputs.json', inputs)}
                    requests.post(CROMWELL_URL + '/api/workflows/v1', files=files)
                return BARUtils.success_exit(key)


@summarization_gene_expression.route('/insert', methods=["POST"])
class SummarizationGeneExpressionInsert(Resource):
    def post(self):
        """This function adds a CSV's data to the database. This is only called by the Cromwell server after receiving the user's file.
        """
        if request.remote_addr != '127.0.0.1':
            return BARUtils.error_exit("Forbidden"), 403
        if(request.method == "POST"):
            key = request.headers.get("X-Api-Key")
            if(SummarizationGeneExpressionUtils.decrement_uses(key)):
                csv = request.get_json()["csv"]
                db_id = request.get_json()["uid"]
                df = pandas.read_csv(csv)
                db_id = db_id.split(".")[0]
                df = df.melt(id_vars=["Gene"], var_name="Sample", value_name="Value")
                db_id = db_id.split("/")[len(db_id.split("/")) - 1]
                con = db.get_engine(bind='summarization')
                df.to_sql(db_id, con, if_exists='append', index=True)


@summarization_gene_expression.route('/value/<string:table_id>/<string:gene>', defaults={'sample': ''})
@summarization_gene_expression.route('/value/<string:table_id>/<string:gene>/<string:sample>', methods=["GET"])
class SummarizationGeneExpressionValue(Resource):
    @summarization_gene_expression.param('table_id', _in='path', default='test')
    @summarization_gene_expression.param('sample', _in='path', default='')
    @summarization_gene_expression.param('gene', _in='path', default='At1g01010')
    def get(self, table_id, sample, gene):
        """Returns the value for a given gene and sample. If no sample is given returns all values for that gene
        """
        if not BARUtils.is_arabidopsis_gene_valid(gene):
            return BARUtils.success_exit("Invalid gene ID"), 400
        else:
            key = request.headers.get("X-Api-Key")
            if(SummarizationGeneExpressionUtils.decrement_uses(key)):
                con = db.get_engine(bind='summarization')
                tbl = SummarizationGeneExpressionUtils.get_table_object(table_id)
                if(sample == ''):
                    values = {}
                    try:
                        rows = con.execute(tbl.select(tbl.c.Value).where(tbl.c.Gene == gene))
                    except SQLAlchemyError as e:
                        error = str(e.__dict__['orig'])
                        return BARUtils.error_exit("Internal server error"), 500
                    for row in rows:
                        values.update({row.Sample: row.Value})
                else:
                    values = []
                    try:
                        rows = con.execute(tbl.select(tbl.c.Value).where(tbl.c.Sample == sample).where(tbl.c.Gene == gene))
                    except SQLAlchemyError as e:
                        error = str(e.__dict__['orig'])
                        return BARUtils.error_exit("Internal server error"), 500
                    [values.append((row.Value)) for row in rows]
                return BARUtils.success_exit(values)


@summarization_gene_expression.route('/samples/<string:table_id>')
class SummarizationGeneExpressionSamples(Resource):
    @summarization_gene_expression.param('table_id', _in='path', default='test')
    def get(self, table_id=''):
        """Returns the list of samples in the table with the given ID
        """
        con = db.get_engine(bind='summarization')
        tbl = SummarizationGeneExpressionUtils.get_table_object(table_id)
        values = []
        try:
            rows = con.execute(db.select([tbl.c.Sample]).distinct())
        except SQLAlchemyError:
            return BARUtils.error_exit("Internal server error"), 500
        [values.append((row.Sample)) for row in rows]
        return BARUtils.success_exit(values)


@summarization_gene_expression.route('/genes/<string:table_id>')
class SummarizationGeneExpressionGenes(Resource):
    @summarization_gene_expression.param('table_id', _in='path', default='test')
    def get(self, table_id=''):
        """Returns the list of genes in the table with the given ID
        """
        key = request.headers.get("x-api-key")
        if(SummarizationGeneExpressionUtils.decrement_uses(key)):
            con = db.get_engine(bind='summarization')
            tbl = SummarizationGeneExpressionUtils.get_table_object(table_id)
            values = []
            try:
                rows = con.execute(db.select([tbl.c.Gene]).distinct())
            except SQLAlchemyError as e:
                error = str(e.__dict__['orig'])
                return BARUtils.error_exit("Internal server error"), 500
            [values.append((row.Gene)) for row in rows]
            return BARUtils.success_exit(values)


@summarization_gene_expression.route('/find_gene/<string:table_id>/<string:user_string>')
class SummarizationGeneExpressionFindGene(Resource):
    @summarization_gene_expression.param('table_id', _in='path', default='test')
    @summarization_gene_expression.param('user_string', _in='path', default='AT1G')
    def get(self, table_id='', user_string=''):
        """Returns all genes that contain a given string as part of their name
        """
        con = db.get_engine(bind='summarization')
        tbl = SummarizationGeneExpressionUtils.get_table_object(table_id)
        values = []
        try:
            rows = con.execute(db.select([tbl.c.Gene]).where(tbl.c.Gene.contains(user_string)).distinct())
        except SQLAlchemyError:
            return BARUtils.error_exit("Internal server error"), 500
        [values.append((row.Gene)) for row in rows]
        return BARUtils.success_exit(values)


@summarization_gene_expression.route('/table_exists/<string:table_id>')
class SummarizationGeneExpressionTableExists(Resource):
    @summarization_gene_expression.param('table_id', _in='path', default='test')
    def get(self, table_id=''):
        """Checks if a given table exists
        """
        con = db.get_engine(bind='summarization')
        if(con.dialect.has_table(con, table_id)):
            return BARUtils.success_exit(True)
        else:
            return BARUtils.success_exit(False)


@summarization_gene_expression.route('/drop_table/<string:table_id>')
class SummarizationGeneExpressionDropTable(Resource):
    @summarization_gene_expression.param('table_id', _in='path', default='test')
    def get(self, table_id=''):
        """Drops the table with the given ID
        """
        if request.remote_addr != '127.0.0.1':
            return BARUtils.error_exit("Forbidden"), 403
        tbl = SummarizationGeneExpressionUtils.get_table_object(table_id)
        tbl.drop()


@summarization_gene_expression.route('/save', methods=["POST"])
class SummarizationGeneExpressionSave(Resource):
    def save(self):
        if (request.method == "POST"):
            api_key = request.headers.get('x-api-key')
            if(api_key is None):
                return BARUtils.error_exit("Invalid API key"), 403
            now = datetime.now()
            dt_string = now.strftime("%d-%m-%Y_%H-%M-%S")
            if 'file' in request.files:
                file = request.files['file']
                extension = ""
                if(file.content_type == "text/xml"):
                    extension = ".xml"
                elif(file.content_type == "image/svg+xml"):
                    extension = ".svg"
                else:
                    return BARUtils.error_exit("Invalid file type"), 400
                filename = os.path.join(DATA_FOLDER, api_key, dt_string + extension)
                file.save(filename)
                return BARUtils.success_exit(True)
            else:
                return BARUtils.error_exit("No file attached"), 400


@summarization_gene_expression.route('/get_file_list', methods=["POST"])
class SummarizationGeneExpressionGetFileList(Resource):
    def get_file_list(self):
        if (request.method == "POST"):
            api_key = request.headers.get('x-api-key')
            files = []
            for file in os.walk(DATA_FOLDER + api_key):
                files.append(file[2])
            return BARUtils.success_exit(files)


@summarization_gene_expression.route('/get_file/<string:folder_id>')
class SummarizationGeneExpressionGetFile(Resource):
    @summarization_gene_expression.param('folder_id', _in='path', default='test')
    def get_file(self, folder_id):
        """Returns a file stored in the user's folder
        """
        if (request.method == "GET"):
            api_key = request.headers.get('x-api-key')
            filename = os.path.join(DATA_FOLDER, api_key, folder_id)
            if(os.path.isfile(filename)):
                return send_file(filename)
            else:
                return BARUtils.error_exit("File not found"), 404
