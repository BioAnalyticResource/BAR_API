import re
from flask_restful import Resource
from api.models.annotations_lookup import AgiAlias
from api.utilities.bar_utilites import BARUtilities


class GeneAlias(Resource):
    def get(self, species='', gene_id=''):
        """
        This function returns a Gene Aliases given an AGI ID.

        :param species: Common name of species
        :param gene_id: AGI ID
        :return: Gene alias object
        """

        result = {}
        aliases = []

        # Get data
        if species == 'species' or species is None or species == '':
            return BARUtilities.success_exit(['arabidopsis'])

        if species == 'arabidopsis':
            if re.search(r"^At[12345CM]g\d{5}$", gene_id, re.I):
                rows = AgiAlias.query.filter_by(agi=gene_id).all()
                [aliases.append(row.alias) for row in rows]
            else:
                return BARUtilities.error_exit('Invalid gene id')
        else:
            return BARUtilities.error_exit('No data for the given species')

        # Return results if there are data
        if len(aliases) > 0:
            result['status'] = 'success'
            result['alias'] = aliases
        else:
            return BARUtilities.error_exit('There is no data found for the given gene')

        return result
