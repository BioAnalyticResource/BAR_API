import requests
import os
import uuid
from api.models.summarization_gene_expression import SummarizationGeneExpression 
from flask import request, jsonify
from werkzeug.utils import secure_filename
from sqlalchemy.orm import scoped_session, sessionmaker, clear_mappers, mapper
from sqlalchemy import create_engine
from api.utils.bar_utils import BARUtils
from sqlalchemy.ext.declarative import declarative_base
from flask_restx import Namespace, Resource
from sqlalchemy import MetaData, Table, Column

Base = declarative_base()

DB_PATH = "/windir/c/Users/Bruno/Documents/GitHub/gene-summarization-bar/db/"
ALLOWED_EXTENSIONS = {'csv'}
UPLOAD_FOLDER = '/windir/c/Users/Bruno/Documents/'
SUMMARIZATION_FILES_PATH = '../gene-summarization-bar/summarization/'


summarization_gene_expression = Namespace('Summarization Gene Expression',
                                          description='Gene Expression data from the BAR\'s summarization procedure',
                                          path='/summarization_gene_expression')


class SummarizationGeneExpressionUtils:
    @staticmethod
    def get_table_object(uid):
        metadata = MetaData()
        table_object = Table(uid, metadata,
                             Column('Gene', primary_key=True),
                             Column('Sample', primary_key=True),
                             Column('Value', primary_key=True)
                             )
        clear_mappers()
        mapper(SummarizationGeneExpression, table_object)
        return SummarizationGeneExpression

    @staticmethod
    def get_session(uid):
        sqlite_url = 'sqlite:///%s%s.db' % (DB_PATH, uid)
        engine = create_engine(sqlite_url, connect_args={'check_same_thread': False})
        Base.metadata.create_all(engine)
        session_factory = sessionmaker(bind=engine)
        Session = scoped_session(session_factory)
        session = Session()
        return session


@summarization_gene_expression.route('/summarize', methods=["POST"])
class SummarizationGeneExpressionSummarize(Resource):
    def post(self):
        if(request.method == "POST"):
            print(file)
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
            requests.post('http://localhost:8000/api/workflows/v1', files=files)

            # Return ID for future accessing
            return uid


@summarization_gene_expression.route('/csv_upload', methods=["POST"])
class SummarizationGeneExpressionCsvUpload(Resource):
    def post(self):
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
                requests.post('http://localhost:8000/api/workflows/v1', files=files)
                return uid


@summarization_gene_expression.route('/value', methods=["GET"])
class SummarizationGeneExpressionValue(Resource):
    def get(self):
        gene = request.args.get('gene')
        sample = request.args.get('sample') if request.args.get('sample') else ''
        uid = request.args.get('id')
        session = SummarizationGeneExpressionUtils.get_session(uid)
        if(sample == ''):
            values = {}
            rows = session.query(SummarizationGeneExpressionUtils.get_table_object(uid)).filter_by(Gene=gene).all()
            for row in rows:
                values.update({row.Sample: row.Value})
        else:
            values = []
            rows = session.query(SummarizationGeneExpressionUtils.get_table_object(uid)).filter_by(Gene=gene, Sample=sample).all()
            [values.append((row.Value)) for row in rows]
        session.close()
        return jsonify(values)


@summarization_gene_expression.route('/samples', methods=["GET"])
class SummarizationGeneExpressionSamples(Resource):
    def get(self):
        uid = request.args.get('id')
        session = SummarizationGeneExpressionUtils.get_session(uid)
        rows = session.query(SummarizationGeneExpressionUtils.get_table_object(uid).Sample).distinct().all()
        session.close()
        return jsonify(rows)


@summarization_gene_expression.route('/genes', methods=["GET"])
class SummarizationGeneExpressionGenes(Resource):
    def get(self):
        uid = request.args.get('id')
        session = SummarizationGeneExpressionUtils.get_session(uid)
        rows = session.query(SummarizationGeneExpressionUtils.get_table_object(uid).Gene).distinct().all()
        session.close()
        return jsonify(rows)


@summarization_gene_expression.route('/find_gene', methods=["GET"])
class SummarizationGeneExpressionFindGene(Resource):
    def get(self):
        uid = request.args.get('id')
        string = request.args.get('string')
        session = SummarizationGeneExpressionUtils.get_session(uid)
        tbl = SummarizationGeneExpressionUtils.get_table_object(uid)
        rows = session.query(tbl.Gene).filter(tbl.Gene.like('%%%s%%' % string)).distinct().all()
        session.close()
        return jsonify(rows)


@summarization_gene_expression.route('/database_exists', methods=["GET"])
class SummarizationGeneExpressionDbExists(Resource):
    def get(self):
        uid = request.args.get('id')
        file_path = DB_PATH + "%s.db" % uid
        if(os.path.isfile(file_path)):
            return jsonify(True)
        else:
            return jsonify(False)
