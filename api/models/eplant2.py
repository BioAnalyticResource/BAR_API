from api import db
from sqlalchemy.dialects.mysql import TEXT


class Isoforms(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "isoforms"
    __table_args__ = (db.Index("idx_gene_isoform", "gene", "isoform"),)

    gene = db.Column(db.String(10), primary_key=True)
    isoform = db.Column(db.String(12), primary_key=True)


class AgiAnnotation(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "agi_annotation"

    agi = db.Column(db.String(11), nullable=False, primary_key=True)
    annotation = db.Column(db.String(64000), nullable=False, primary_key=False)


class TAIR10FunctionalDescriptions(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "TAIR10_functional_descriptions"

    Model_name = db.Column(db.String(32), nullable=False, primary_key=True)
    Type = db.Column(db.String(32), nullable=False, primary_key=True)
    Short_description = db.Column(TEXT(), nullable=True, primary_key=True)
    Curator_summary = db.Column(TEXT(), nullable=True, primary_key=True)
    Computational_description = db.Column(TEXT(), nullable=True, primary_key=True)


class GeneRIFs(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "geneRIFs"

    gene = db.Column(db.String(11), nullable=False, primary_key=True)
    pubmed = db.Column(db.String(11), nullable=False, primary_key=True)
    RIF = db.Column(TEXT(), nullable=False, primary_key=True)
