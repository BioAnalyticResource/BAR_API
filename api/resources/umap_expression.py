import json

from flask_restx import Namespace, Resource
from markupsafe import escape
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from api import db
from api.utils.bar_utils import BARUtils
from api.utils.gene_id_utils import (
    CROSS_SPECIES_DATABASES,
    DATABASE_SPECIES,
    normalize_gene_id,
    validate_gene_id,
)

umap_expression = Namespace(
    "UMAP Expression",
    description="Per-cell UMAP coordinates and expression data for SUPeR Viewer",
    path="/umap_expression",
)

# Maps UMAP database names to their pseudobulk counterpart species.
# Add a new entry here whenever a new UMAP dump is generated.
UMAP_DATABASE_SPECIES: dict[str, str] = {
    "rice_OW_umap":                   "rice",
    "arabidopsis_NIE_umap":           "arabidopsis",
    "arabidopsis_root_shahan_umap":   "arabidopsis",
    "arabidopsis_seed_martin_umap":   "arabidopsis",
    "arabidopsis_flower_lee_umap":    "arabidopsis",
    "arabidopsis_silique_lee_umap":   "arabidopsis",
    "arabidopsis_stem_lee_umap":      "arabidopsis",
}


@umap_expression.route("/<string:database>/<string:gene_id>")
@umap_expression.doc(description="Retrieve per-cell UMAP coordinates and expression values for a gene.")
@umap_expression.param(
    "gene_id",
    "Gene ID (e.g. AT1G01010 for Arabidopsis, Os10g0168500 for rice)",
    _in="path",
    default="Os10g0168500",
)
@umap_expression.param(
    "database",
    "UMAP database name (e.g. rice_OW_umap, arabidopsis_NIE_umap)",
    _in="path",
    default="rice_OW_umap",
)
class UMAPExpression(Resource):
    def get(self, database, gene_id):
        """Retrieve per-cell UMAP coordinates and expression for a gene."""
        database = str(escape(database))
        gene_id = str(escape(gene_id))

        # 1. Resolve database species
        species = UMAP_DATABASE_SPECIES.get(database)
        if species is None:
            return BARUtils.error_exit(
                f"Unknown UMAP database '{database}'. "
                f"Available: {', '.join(sorted(UMAP_DATABASE_SPECIES.keys()))}"
            ), 400

        # 2. Validate gene ID format against the expected input species regex
        input_species = CROSS_SPECIES_DATABASES.get(database, species)
        if not validate_gene_id(gene_id, input_species):
            return BARUtils.error_exit(f"Invalid {input_species} gene ID: '{gene_id}'"), 400

        # 3. Normalise (e.g. strip maize transcript suffix _T##)
        gene_id = normalize_gene_id(gene_id, species)

        # 4. Get SQLAlchemy bind engine for this database
        engine = db.engines.get(database)
        if engine is None:
            return BARUtils.error_exit("Database not available"), 503

        # 5. Query expression JSON array for this gene (single PK lookup)
        expr_sql = text(
            "SELECT expression FROM umap_expression WHERE gene_id = :gene_id"
        )

        try:
            with Session(engine) as session:
                row = session.execute(expr_sql, {"gene_id": gene_id}).first()
        except SQLAlchemyError as exc:
            return BARUtils.error_exit(f"Database query failed: {str(exc)}"), 500

        # Retry with uppercase (some datasets store IDs in uppercase)
        if row is None:
            try:
                with Session(engine) as session:
                    row = session.execute(expr_sql, {"gene_id": gene_id.upper()}).first()
            except SQLAlchemyError as exc:
                return BARUtils.error_exit(f"Database query failed: {str(exc)}"), 500

        if row is None:
            return BARUtils.error_exit("No data found for the given gene"), 404

        # Parse expression JSON array: [val0, val1, val2, ...]
        expr_raw = row.expression
        expr_list = json.loads(expr_raw) if isinstance(expr_raw, str) else expr_raw

        # 6. Query all coords ordered by cell_id (same for every gene)
        coords_sql = text(
            "SELECT cell_id, umap_1, umap_2, cell_type "
            "FROM umap_coords ORDER BY cell_id"
        )

        try:
            with Session(engine) as session:
                coords = session.execute(coords_sql).all()
        except SQLAlchemyError as exc:
            return BARUtils.error_exit(f"Database query failed: {str(exc)}"), 500

        # 7. Merge coords + expression by position
        data = [
            {
                "umap_1":     float(c.umap_1),
                "umap_2":     float(c.umap_2),
                "expression": float(expr_list.get(str(c.cell_id), 0.0)),
                "cell_type":  str(c.cell_type),
            }
            for i, c in enumerate(coords)
        ]

        return BARUtils.success_exit({
            "gene_id":      gene_id,
            "database":     database,
            "species":      species,
            "record_count": len(data),
            "data":         data,
        })


umap_expression.add_resource(UMAPExpression, "/<string:database>/<string:gene_id>")