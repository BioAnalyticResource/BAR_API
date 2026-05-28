"""
Reena Obmina | UTEA Project 2026 | University of Toronto

Gene density endpoint for the BAR API.

Returns per-bin gene density across all Arabidopsis thaliana chromosomes for a
given bin size (in base pairs), as used by Eplant's ChromosomeView to colour
chromosomes by gene density.

Reads:  eplant2.tair10_gff3
Writes: JSON — list of chromosomes with density arrays

Usage::

    GET /gene_density?species=Arabidopsis_thaliana&bin_size=143061.51645207437
"""

from flask import request
from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy import func
from api import db
from api.models.eplant2 import TAIR10GFF3
from api.utils.bar_utils import BARUtils
import math

gene_density = Namespace("Gene Density", description="Gene density API", path="/gene_density")

# Arabidopsis thaliana chromosome lengths (bp) and display order
_CHR_LENGTHS = {
    "1": 30427671,
    "2": 19698289,
    "3": 23459830,
    "4": 18585056,
    "5": 26975502,
    "C": 154478,
    "M": 366924,
}
_CHR_ORDER = ["1", "2", "3", "4", "5", "C", "M"]


@gene_density.route("")
class GeneDensity(Resource):
    @gene_density.param("species", description="Species name", default="Arabidopsis_thaliana")
    @gene_density.param("bin_size", description="Bin size in base pairs", default="143061.51645207437")
    def get(self):
        """Returns gene density per chromosome bin for the given species and bin size."""
        species = escape(request.args.get("species", ""))
        bin_size_str = request.args.get("bin_size", "")

        if not species:
            return BARUtils.error_exit("Missing species parameter"), 400
        if not bin_size_str:
            return BARUtils.error_exit("Missing bin_size parameter"), 400

        try:
            bin_size = float(bin_size_str)
            if bin_size <= 0:
                return BARUtils.error_exit("bin_size must be a positive number"), 400
        except ValueError:
            return BARUtils.error_exit("Invalid bin_size"), 400

        if species != "Arabidopsis_thaliana":
            return BARUtils.error_exit("Invalid species"), 400

        bins = {c: [0] * math.ceil(_CHR_LENGTHS[c] / bin_size) for c in _CHR_ORDER}

        chr_expr = func.substr(TAIR10GFF3.geneId, 3, 1)
        start_bin_expr = func.floor(TAIR10GFF3.Start / bin_size)
        end_bin_expr = func.floor(TAIR10GFF3.End / bin_size)

        # Aggregated query for single-bin genes (~98%+ of all genes at typical zoom levels).
        # FLOOR(start/binSize) == FLOOR(end/binSize) means the gene fits within one bin,
        # so GROUP BY is safe and avoids fetching one row per gene.
        single_bin_rows = db.session.execute(
            db.select(chr_expr, start_bin_expr, func.count())
            .where(
                TAIR10GFF3.Type == "gene",
                start_bin_expr == end_bin_expr,
            )
            .group_by(chr_expr, start_bin_expr)
        ).all()

        for chr_char, bin_idx, cnt in single_bin_rows:
            if chr_char in bins:
                idx = int(bin_idx)
                if 0 <= idx < len(bins[chr_char]):
                    bins[chr_char][idx] += cnt

        # Individual rows for genes that span multiple bins (rare — typically <2% of genes).
        # Each such gene is counted once in every bin it spans, matching the original behaviour.
        multi_bin_rows = db.session.execute(
            db.select(chr_expr, start_bin_expr, end_bin_expr)
            .where(
                TAIR10GFF3.Type == "gene",
                start_bin_expr != end_bin_expr,
            )
        ).all()

        for chr_char, start_bin, end_bin in multi_bin_rows:
            if chr_char in bins:
                for n in range(int(start_bin), int(end_bin) + 1):
                    if 0 <= n < len(bins[chr_char]):
                        bins[chr_char][n] += 1

        output = [{"name": f"Chr {c}", "density": bins[c]} for c in _CHR_ORDER]
        return BARUtils.success_exit(output)
