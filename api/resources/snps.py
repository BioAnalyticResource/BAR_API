from flask_restx import Namespace, Resource
from flask import redirect  # , send_file
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.poplar_nssnp import ProteinAlias, SnpsProteinJoin, SnpsTbl
from api.utils.bar_utils import BARUtils
from api import cache, db
import re
import subprocess
import requests

snps = Namespace('SNPs', description='Information about SNPs', path='/snps')


@snps.route('/phenix/<fixed_pdb>/<moving_pdb>')
class Phenix(Resource):
    @snps.param('fixed_pdb', _in='path', default='Potri.016G107900')
    @snps.param('moving_pdb', _in='path', default='AT5G01040.1')
    def get(self, fixed_pdb='', moving_pdb=''):
        """This end point returns the superimposition of the moving PDB onto moving PDB in PDB format"""

        arabidopsis_pdb_path = '/var/www/html/eplant_legacy/java/Phyre2-Models/Phyre2_'
        poplar_pdb_path = '/var/www/html/eplant_poplar/pdb/'
        phenix_pdb_link = 'http://bar.utoronto.ca/phenix-pdbs/'
        phenix_pdb_path = '/var/www/html/phenix-pdbs/'

        if BARUtils.is_arabidopsis_gene_valid(fixed_pdb):
            fixed_pdb_path = arabidopsis_pdb_path + fixed_pdb.upper() + '.pdb'
        elif BARUtils.is_poplar_gene_valid(fixed_pdb):
            fixed_pdb_path = poplar_pdb_path + BARUtils.format_poplar(fixed_pdb) + '.pdb'
        else:
            return {'success': False, 'error': 'Invalid fixed pdb gene id', 'error_code': 400}, 400

        if BARUtils.is_arabidopsis_gene_valid(moving_pdb):
            moving_pdb_path = arabidopsis_pdb_path + moving_pdb.upper() + '.pdb'
        elif BARUtils.is_poplar_gene_valid(moving_pdb):
            moving_pdb_path = poplar_pdb_path + BARUtils.format_poplar(moving_pdb) + '.pdb'
        else:
            return {'success': False, 'error': 'Invalid fixed pdb gene id', 'error_code': 400}, 400

        phenix_file_name = fixed_pdb.upper() + "-" + moving_pdb.upper() + "-phenix.pdb"
        response = requests.get(phenix_pdb_link + phenix_file_name)

        if response.status_code != 200:
            subprocess.run(['phenix.superpose_pdbs',
                            'file_name=' + phenix_pdb_path + phenix_file_name,
                            fixed_pdb_path,
                            moving_pdb_path])

        return redirect(phenix_pdb_link + phenix_file_name)  # TODO: same url as above
        # return send_file('/Users/vin/Desktop/Poplar-project/Phenix/fitted_PDBs/test.pdb')


@snps.route('/gene_alias/<string:gene_id>')
class GeneNameAlias(Resource):
    @snps.param('gene_id', _in='path', default='Potri.019G123900.1')
    @cache.cached()
    def get(self, gene_id=''):
        """ Endpoint returns annotated SNP poplar data in order of (to match A th API format):
            AA pos (zero-indexed), sample id, 'missense_variant','MODERATE', 'MISSENSE', codon/DNA base change,
            AA change (DH), pro length, gene ID, 'protein_coding', 'CODING', transcript id, biotype
            values with single quotes are fixed """
        results_json = []

        # Escape input
        gene_id = escape(gene_id)

        try:
            rows = db.session.query(ProteinAlias, SnpsProteinJoin, SnpsTbl). \
                select_from(ProteinAlias). \
                join(SnpsProteinJoin). \
                join(SnpsTbl). \
                filter(ProteinAlias.gene_identifier == gene_id).all()
            # BAR A Th API format is chr, AA pos (zero-indexed), sample id, 'missense_variant',
            # 'MODERATE', 'MISSENSE', codon/DNA base change, AA change (DH),
            # pro length, gene ID, 'protein_coding', 'CODING', transcript id, biotype
            for protein, snpsjoin, snpstbl in rows:
                itm_lst = [
                    snpstbl.chromosome,
                    # snpstbl.chromosomal_loci,
                    snpsjoin.aa_pos - 1,  # zero index-ed
                    snpstbl.sample_id,
                    'missense_variant',
                    'MODERATE',
                    'MISSENSE',
                    str(snpsjoin.transcript_pos) + snpsjoin.ref_DNA + '>' + snpsjoin.alt_DNA,
                    snpsjoin.ref_aa + snpsjoin.alt_aa,
                    None,
                    re.sub(r'.\d$', '', protein.gene_identifier),
                    'protein_coding',
                    'CODING',
                    protein.gene_identifier,
                    None,
                ]
                results_json.append(itm_lst)
                print(protein.gene_identifier, snpsjoin.alt_aa, snpstbl.sample_id)
        except OperationalError as e:
            print(e)
            return BARUtils.error_exit('An internal error has occurred'), 500
        # [results_json.append(row.gene_identifier) for row in rows]

        # Return results if there are data
        if len(results_json) > 0:
            return BARUtils.success_exit(results_json)
        else:
            return BARUtils.error_exit('There are no data found for the given gene')
