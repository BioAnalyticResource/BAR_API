from api import db


class Isoforms(db.Model):
    __bind_key__ = "eplant_soybean"
    __tablename__ = "isoforms"
    __table_args__ = (db.Index("idx_gene_isoform", "gene", "isoform"),)

    gene = db.Column(db.String(20), nullable=False, primary_key=True)
    isoform = db.Column(db.String(24), nullable=False, primary_key=True)


class GeneAnnotation(db.Model):
    __bind_key__ = "eplant_soybean"
    __tablename__ = "gene_annotation"

    gene = db.Column(db.String(20), nullable=False, primary_key=True)
    annotation = db.Column(db.String(64000), nullable=False, primary_key=False)
