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

gene_expression = Namespace(
    "Gene Expression",
    description="Gene expression data from BAR eFP databases",
    path="/gene_expression",
)


@gene_expression.route("/expression/<string:database>/<string:gene_id>")
@gene_expression.doc(description="Retrieve gene expression values from a specified eFP database.")
@gene_expression.param(
    "gene_id",
    "Gene ID (e.g. AT1G01010 for Arabidopsis, or a probeset like 261585_at)",
    _in="path",
    default="AT1G01010",
)
@gene_expression.param(
    "database",
    "Database name (e.g. klepikova, atgenexp, sample_data)",
    _in="path",
    default="klepikova",
)
class GeneExpression(Resource):
    def get(self, database, gene_id):
        database = str(escape(database))
        gene_id = str(escape(gene_id))

        # 1. Resolve database species and expected input species.
        #    Cross-species databases (e.g. phelipanche) accept an Arabidopsis AGI
        #    even though the database itself belongs to a different species.
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

            # 5. Microarray / non-direct databases need gene ID → probeset conversion
            if database in PROBESET_DATABASES:
                probeset, err = convert_gene_to_probeset(gene_id, species, database)
                if err:
                    return BARUtils.error_exit(err), 404
                query_id = probeset
            else:
                query_id = gene_id

        result = query_efp_database_dynamic(database, query_id)

        if result["success"]:
            return BARUtils.success_exit(result)
        return BARUtils.error_exit(result["error"]), result.get("error_code", 500)


gene_expression.add_resource(GeneExpression, "/expression/<string:database>/<string:gene_id>")
