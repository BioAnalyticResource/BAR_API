from api import eplant_rice_db as db


class GeneAnnotation(db.Model):
    __bind_key__ = "eplant_rice"
    __tablename__ = "gene_annotation"

    gene = db.Column(db.String(20), nullable=False, primary_key=True)
    annotation = db.Column(db.String(64000), nullable=False, primary_key=False)
