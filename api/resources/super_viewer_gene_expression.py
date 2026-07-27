
from flask_restx import Namespace, Resource
from markupsafe import escape

from api.services.efp_data import query_efp_database_dynamic
from api.utils.bar_utils import BARUtils
from api.utils.gene_id_utils import (
    CROSS_SPECIES_DATABASES,
    DATABASE_SPECIES,
    PROBESET_DATABASES,
    convert_gene_to_probeset,
    is_probeset_id,
    normalize_gene_id,
    validate_gene_id,
)

# Must match MEAN_CTRL_BOT_ID in generate_pseudobulk_dumps.py
MEAN_CTRL_BOT_ID = "Mean_CTRL"

super_viewer_gene_expression = Namespace(
    "SUPeR Viewer Gene Expression",
    description=(
        "Per-tissue and dataset-wide mean gene expression from SUPeR "
        "Viewer eFP pseudobulk databases."
    ),
    path="/super_viewer_gene_expression",
)


def _split_rows(rows):
    """
    Split sample_data rows into (tissue_rows, mean_row).

    tissue_rows : list of every row except Mean_CTRL — the normal
                  per-tissue/condition expression values.
    mean_row    : the single Mean_CTRL row (or None if the database/gene
                  predates the Mean_CTRL rollout and has no such row).

    NOTE: query_efp_database_dynamic's rows come back shaped as
    {"name": <tissue/bot_id>, "value": <expression>} — confirmed from a
    live response — not {"data_bot_id": ..., "data_signal": ...} as
    originally assumed. Update this if the shape changes again.
    """
    tissue_rows = []
    mean_row = None
    for row in rows:
        bot_id = row.get("name")
        if bot_id == MEAN_CTRL_BOT_ID:
            mean_row = row
        else:
            tissue_rows.append(row)
    return tissue_rows, mean_row


@super_viewer_gene_expression.route("/expression/<string:database>/<string:gene_id>")
@super_viewer_gene_expression.doc(
    description=(
        "Retrieve per-tissue expression values and the dataset-wide mean "
        "(Mean_CTRL) for a gene from a specified SUPeR Viewer eFP database."
    )
)
@super_viewer_gene_expression.param(
    "gene_id",
    "Gene ID (e.g. AT1G01010 for Arabidopsis, or a probeset like 261585_at)",
    _in="path",
    default="AT1G01010",
)
@super_viewer_gene_expression.param(
    "database",
    "Database name (e.g. arabidopsis_NIE_pseudobulk, rice_OW_pseudobulk)",
    _in="path",
    default="arabidopsis_NIE_pseudobulk",
)
class SUPeRViewerGeneExpression(Resource):
    def get(self, database, gene_id):
        """Retrieve per-tissue values and the all-cell mean for a gene.
        """
        database = str(escape(database))
        gene_id = str(escape(gene_id))

        # 1. Resolve database species and expected input species.
        species = DATABASE_SPECIES.get(database)
        if species is None:
            return BARUtils.error_exit(f"Unknown database '{database}'"), 400
        input_species = CROSS_SPECIES_DATABASES.get(database, species)

        # 2. If the caller already supplied a probeset ID, use it directly
        if is_probeset_id(gene_id):
            query_id = gene_id
        else:
            # 3. Validate gene ID format against the expected input species regex
            if not validate_gene_id(gene_id, input_species):
                return BARUtils.error_exit(f"Invalid {input_species} gene ID: '{gene_id}'"), 400

            # 4. Normalise (e.g. strip maize transcript suffix _T##)
            gene_id = normalize_gene_id(gene_id, species)

            # 5. Microarray / non-direct databases need gene ID -> probeset conversion
            if database in PROBESET_DATABASES:
                probeset, err = convert_gene_to_probeset(gene_id, species, database)
                if err:
                    return BARUtils.error_exit(err), 404
                query_id = probeset
            else:
                query_id = gene_id

        result = query_efp_database_dynamic(database, query_id)

        if not result["success"]:
            error_code = result.get("error_code", 500)
            if error_code == 404:
                return BARUtils.error_exit("No data found for the given gene"), 404
            if error_code == 503:
                return BARUtils.error_exit("Database not available"), 503
            return BARUtils.error_exit("An error occurred"), 500

        rows = result.get("data", [])
        tissue_rows, mean_row = _split_rows(rows)

        return BARUtils.success_exit({
            "expression": tissue_rows,
            "mean_expression": mean_row,
        })


super_viewer_gene_expression.add_resource(
    SUPeRViewerGeneExpression, "/expression/<string:database>/<string:gene_id>"
)
