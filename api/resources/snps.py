from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.retrieve_snp import ProteinAlias, SnpsProteinJoin, SnpsTbl
from api.utils.bar_utils import BARUtils
from api import cache, db
import re

snps = Namespace('SNPs', description='Information about SNPs', path='/snps')


@snps.route('/protein_name')
class ProteinName(Resource):
    def get(self):
        """ Define later TODO """
        id = ['asdasddsa']
        return BARUtils.success_exit(id)


@snps.route('/gene_alias/<string:gene_id>')
class GeneNameAlias(Resource):
    @snps.param('gene_id', _in='path', default='1')
    @cache.cached()
    def get(self, gene_id=''):
        """ TODO define endpoint """
        resultsJSON = []

        # Escape input
        gene_id = escape(gene_id)

        try:
            rows = db.session.query(ProteinAlias, SnpsProteinJoin, SnpsTbl).\
                select_from(ProteinAlias).\
                join(SnpsProteinJoin).\
                join(SnpsTbl).\
                filter(ProteinAlias.gene_identifier == gene_id).all()
            print(rows)
            for protein, snpsjoin, snpstbl in rows:
                itmLst = [
                    snpstbl.chromosome,
                    snpstbl.chromosomal_loci,
                    snpstbl.sample_id,
                    "missense_variant",
                    "MODERATE",
                    "MISSENSE",
                    None,
                    "p." + snpsjoin.ref_aa + str(snpsjoin.aa_pos) + snpsjoin.alt_aa + 
                    "/c." + str(snpsjoin.transcript_pos) + snpsjoin.ref_DNA + ">" + snpsjoin.alt_DNA,
                    None,
                    re.sub('.\d$', "", protein.gene_identifier),
                    None,
                    None,
                    protein.gene_identifier
                ]
                resultsJSON.append(itmLst)
                print(protein.gene_identifier, snpsjoin.alt_aa, snpstbl.sample_id)
        except OperationalError as e:
            print(e)
            return BARUtils.error_exit('An internal error has occurred'), 500
        # [resultsJSON.append(row.gene_identifier) for row in rows]

        # Return results if there are data
        if len(resultsJSON) > 0:
            print('yay!')
            return BARUtils.success_exit(resultsJSON)
        else:
            return BARUtils.error_exit('There are no data found for the given gene')

