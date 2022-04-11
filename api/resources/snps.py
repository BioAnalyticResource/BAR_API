from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy.exc import OperationalError
from api.models.poplar_nssnp import (
    ProteinReference as PoplarProteinReference,
    SnpsToProtein as PoplarSnpsToProtein,
    SnpsReference as PoplarSnpsReference,
)
from api.models.tomato_nssnp import (
    ProteinReference as TomatoProteinReference,
    SnpsToProtein as TomatoSnpsToProtein,
    SnpsReference as TomatoSnpsReference,
    LinesLookup as TomatoLinesLookup,
)
from api.models.soybean_nssnp import (
    ProteinReference as SoybeanProteinReference,
    SnpsToProtein as SoybeanSnpsToProtein,
    SnpsReference as SoybeanSnpsReference,
    SamplesLookup as SoybeanSampleNames,
)
from api.utils.bar_utils import BARUtils
from api import cache, poplar_nssnp_db, tomato_nssnp_db, soybean_nssnp_db
import re
import subprocess
import requests

snps = Namespace("SNPs", description="Information about SNPs", path="/snps")


@snps.route("/phenix/<fixed_pdb>/<moving_pdb>")
class Phenix(Resource):
    @snps.param("fixed_pdb", _in="path", default="Potri.016G107900.1")
    @snps.param("moving_pdb", _in="path", default="AT5G01040.1")
    def get(self, fixed_pdb="", moving_pdb=""):
        """
        This end point returns the superimposition of the moving PDB onto the fixed PDB (returns a URL to fetch PDB)
        Enter valid species identifier for proteins of interest
        """

        fixed_pdb = escape(fixed_pdb)
        moving_pdb = escape(moving_pdb)

        arabidopsis_pdb_path = "/var/www/html/eplant_legacy/java/Phyre2-Models/Phyre2_"
        poplar_pdb_path = "/var/www/html/eplant_poplar/pdb/"
        tomato_pdb_path = "/var/www/html/eplant_tomato/pdb/"
        phenix_pdb_link = "//bar.utoronto.ca/phenix-pdbs/"
        phenix_pdb_path = "/var/www/html/phenix-pdbs/"

        # Check if genes ids are valid
        if BARUtils.is_arabidopsis_gene_valid(fixed_pdb):
            fixed_pdb_path = arabidopsis_pdb_path + fixed_pdb.upper() + ".pdb"
        elif BARUtils.is_poplar_gene_valid(fixed_pdb):
            fixed_pdb_path = (
                poplar_pdb_path + BARUtils.format_poplar(fixed_pdb) + ".pdb"
            )
        elif BARUtils.is_tomato_gene_valid(fixed_pdb, True):
            fixed_pdb_path = tomato_pdb_path + fixed_pdb.capitalize() + ".pdb"
        else:
            return BARUtils.error_exit("Invalid fixed pdb gene id"), 400

        if BARUtils.is_arabidopsis_gene_valid(moving_pdb):
            moving_pdb_path = arabidopsis_pdb_path + moving_pdb.upper() + ".pdb"
        elif BARUtils.is_poplar_gene_valid(moving_pdb):
            moving_pdb_path = (
                poplar_pdb_path + BARUtils.format_poplar(moving_pdb) + ".pdb"
            )
        elif BARUtils.is_tomato_gene_valid(moving_pdb, True):
            moving_pdb_path = tomato_pdb_path + moving_pdb.capitalize() + ".pdb"
        else:
            return BARUtils.error_exit("Invalid moving pdb gene id"), 400

        # Check if model already exists
        phenix_file_name = fixed_pdb.upper() + "-" + moving_pdb.upper() + "-phenix.pdb"
        response = requests.get("https:" + phenix_pdb_link + phenix_file_name)

        # If not, generate the model
        if response.status_code != 200:
            subprocess.run(
                [
                    "phenix.superpose_pdbs",
                    "file_name=" + phenix_pdb_path + phenix_file_name,
                    fixed_pdb_path,
                    moving_pdb_path,
                ]
            )

        return BARUtils.success_exit(phenix_pdb_link + phenix_file_name)


@snps.route("/<string:species>/<string:gene_id>")
class GeneNameAlias(Resource):
    @snps.param("species", _in="path", default="poplar")
    @snps.param("gene_id", _in="path", default="Potri.019G123900.1")
    @cache.cached()
    def get(self, species="", gene_id=""):
        """
        Supported species = poplar, soybean, tomato
        Endpoint returns annotated SNP poplar data in order of (to match A th API format):
        AA pos (zero-indexed), sample id, 'missense_variant','MODERATE', 'MISSENSE', codon/DNA base change,
        AA change (DH), pro length, gene ID, 'protein_coding', 'CODING', transcript id, biotype
        values with single quotes are fixed
        """
        results_json = []

        # Escape input
        gene_id = escape(gene_id)

        if species == "poplar" and BARUtils.is_poplar_gene_valid(gene_id):
            query_db = poplar_nssnp_db
            protein_reference = PoplarProteinReference
            snps_to_protein = PoplarSnpsToProtein
            snps_reference = PoplarSnpsReference
        elif species == "tomato" and BARUtils.is_tomato_gene_valid(gene_id, True):
            query_db = tomato_nssnp_db
            protein_reference = TomatoProteinReference
            snps_to_protein = TomatoSnpsToProtein
            snps_reference = TomatoSnpsReference
        elif species == "soybean" and BARUtils.is_soybean_gene_valid(gene_id):
            query_db = soybean_nssnp_db
            protein_reference = SoybeanProteinReference
            snps_to_protein = SoybeanSnpsToProtein
            snps_reference = SoybeanSnpsReference
        else:
            return BARUtils.error_exit("Invalid gene id"), 400

        try:
            rows = (
                query_db.session.query(
                    protein_reference, snps_to_protein, snps_reference
                )
                .select_from(protein_reference)
                .join(snps_to_protein)
                .join(snps_reference)
                .filter(protein_reference.gene_identifier == gene_id)
                .all()
            )

            # BAR A Th API format is chr, AA pos (zero-indexed), sample id, 'missense_variant',
            # 'MODERATE', 'MISSENSE', codon/DNA base change, AA change (DH),
            # pro length, gene ID, 'protein_coding', 'CODING', transcript id, biotype
            for protein, snpsjoin, snpstbl in rows:
                itm_lst = [
                    snpstbl.chromosome,
                    # snpstbl.chromosomal_loci,
                    snpsjoin.aa_pos - 1,  # zero index-ed
                    snpstbl.sample_id,
                    "missense_variant",
                    "MODERATE",
                    "MISSENSE",
                    str(snpsjoin.transcript_pos)
                    + snpsjoin.ref_DNA
                    + ">"
                    + snpsjoin.alt_DNA,
                    snpsjoin.ref_aa + snpsjoin.alt_aa,
                    None,
                    re.sub(r".\d$", "", protein.gene_identifier),
                    "protein_coding",
                    "CODING",
                    protein.gene_identifier,
                    None,
                ]
                results_json.append(itm_lst)
        except OperationalError:
            return BARUtils.error_exit("An internal error has occurred"), 500

        # Return results if there are data
        if len(results_json) > 0:
            return BARUtils.success_exit(results_json)
        else:
            return BARUtils.error_exit("There are no data found for the given gene")


@snps.route("/<string:species>/samples")
class SampleDefinitions(Resource):
    @snps.param("species", _in="path", default="tomato")
    # @cache.cached()
    def get(self, species=""):
        """
        Endpoint returns sample/individual data for a given dataset(species).
        Data may vary between species.
        """

        aliases = {}

        if species == "tomato":
            try:
                rows = tomato_nssnp_db.session.query(TomatoLinesLookup).all()
            except OperationalError:
                return BARUtils.error_exit("An internal error has occurred"), 500
            for row in rows:
                aliases[row.lines_id] = {"alias": row.alias, "species": row.species}
        elif species == "soybean":
            try:
                rows = soybean_nssnp_db.session.query(SoybeanSampleNames).all()
            except OperationalError:
                return BARUtils.error_exit("An internal error has occurred"), 500
            for row in rows:
                aliases[row.sample_id] = {"dataset": row.dataset, "PI number": row.dataset_sample}
        else:
            return BARUtils.error_exit("Invalid gene id"), 400

        return BARUtils.success_exit(aliases)
