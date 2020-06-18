import re
import json
from flask_restful import Resource
from api import db


class AgiAlias(db.Model):
    # This is the data model for agi_alias table
    __tablename__ = 'agi_alias'
    agi = db.Column(db.VARCHAR(30), primary_key=True)
    alias = db.Column(db.VARCHAR(30), primary_key=True)
    date = db.Column(db.DATE, primary_key=True)


class GetAlias(Resource):
    def get(self, gene_id):
        """
        This function returns a Gene Aliases given an AGI ID.

        :param gene_id: AGI ID
        :return: Gene alias object
        """

        result = {}
        aliases = []

        # Validate data
        if re.search(r"^At[12345CM]g\d{5}$", gene_id, re.I):
            rows = AgiAlias.query.filter_by(agi=gene_id).all()

            [aliases.append(row.alias) for row in rows]

            result['status'] = 'success'
            result['alias'] = aliases
        else:
            result['status'] = 'fail'
            result['error'] = 'Invalid gene id'

        return result
