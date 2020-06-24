import re
from flask_restful import Resource
from api.models.single_cell import SingleCell
from api.utilities.bar_utilities import BARUtilities


class RNASeqGeneExpression(Resource):
    def get(self, species='', database='', gene_id='', sample_id=''):
        """
        This end point returns RNA-Seq gene expression data
        ---
        parameters:
          - name: species
            in: path
            type: string
            required: true
            default: arabidopsis
          - name: database
            in: path
            type: string
            required: true
            default: single_cell
          - name: gene_id
            in: path
            type: string
            required: true
            default: At1g01010
          - name: sample_id
            in: path
            type: string
            required: false
            default: cluster0_WT1.ExprMean
        tags:
          - "RNA-Seq Gene Expression Data"
        summary: "Returns gene alias given a species and gene id"
        produces:
          - application/json
        responses:
          "200":
            description: "Successful operation"
        """
        # Set species and check gene ID format
        if species == 'arabidopsis':
            if not re.search(r"^At[12345CM]g\d{5}$", gene_id, re.I):
                return BARUtilities.error_exit('Invalid gene id')
        else:
            return BARUtilities.error_exit('Invalid species')

        # Set model
        if database == 'single_cell':
            database = SingleCell()
        else:
            return BARUtilities.error_exit('Invalid database')

        # Set sample
        if not re.search(r"^[\w+\._]{0,40}$", sample_id, re.I):
            return BARUtilities.error_exit('Invalid sample id')

        # Now query the database
        if sample_id == '' or sample_id is None:
            rows = database.query.filter_by(data_probeset_id=gene_id).all()
        else:
            rows = database.query.filter_by(data_probeset_id=gene_id, data_bot_id=sample_id).all()

        data = {}
        for row in rows:
            data[row.data_bot_id] = row.data_signal

        # Return results if there are data
        if len(data) > 0:
            return BARUtilities.success_exit(data)
        else:
            return BARUtilities.error_exit('There is no data found for the given gene')
