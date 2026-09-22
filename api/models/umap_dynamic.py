"""Every SUPeR Viewer UMAP database exposes the same umap_coords and umap_expression
tables, so instead of hand-writing a model file per database we generate them here."""

from api import db

# Every UMAP database and the species its gene ids belong to. UMAP databases have no
# catalog entry, so the species that selects the gene id pattern is declared here.
UMAP_DATABASES = {
    "arabidopsis_NIE_umap": "arabidopsis",
    "arabidopsis_flower_lee_umap": "arabidopsis",
    "arabidopsis_root_shahan_umap": "arabidopsis",
    "arabidopsis_rosette_21d_lee_umap": "arabidopsis",
    "arabidopsis_rosette_30d_lee_umap": "arabidopsis",
    "arabidopsis_seed_0d_lee_umap": "arabidopsis",
    "arabidopsis_seed_martin_umap": "arabidopsis",
    "arabidopsis_seedling_12d_lee_umap": "arabidopsis",
    "arabidopsis_seedling_3d_lee_umap": "arabidopsis",
    "arabidopsis_seedling_6d_lee_umap": "arabidopsis",
    "arabidopsis_shoot_zhang_umap": "arabidopsis",
    "arabidopsis_silique_lee_umap": "arabidopsis",
    "arabidopsis_stem_lee_umap": "arabidopsis",
    "rice_OW_umap": "rice",
}


def _class_prefix(database):
    return "".join(part.capitalize() for part in database.split("_"))


def _umap_coords_model(database):
    return type(
        _class_prefix(database) + "UmapCoords",
        (db.Model,),
        {
            "__bind_key__": database,
            "__tablename__": "umap_coords",
            "cell_id": db.mapped_column(db.Integer, nullable=False, primary_key=True),
            "umap_1": db.mapped_column(db.Float, nullable=False),
            "umap_2": db.mapped_column(db.Float, nullable=False),
            "cell_type": db.mapped_column(db.String(128), nullable=False),
        },
    )


def _umap_expression_model(database):
    return type(
        _class_prefix(database) + "UmapExpression",
        (db.Model,),
        {
            "__bind_key__": database,
            "__tablename__": "umap_expression",
            "gene_id": db.mapped_column(db.String(32), nullable=False, primary_key=True),
            "expression": db.mapped_column(db.JSON, nullable=False),
        },
    )


UMAP_COORDS_MODELS = {database: _umap_coords_model(database) for database in UMAP_DATABASES}
UMAP_EXPRESSION_MODELS = {database: _umap_expression_model(database) for database in UMAP_DATABASES}
