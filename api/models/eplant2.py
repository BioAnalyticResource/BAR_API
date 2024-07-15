from api import db
from sqlalchemy.dialects.mysql import TEXT


class Isoforms(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "isoforms"
    __table_args__ = (db.Index("idx_gene_isoform", "gene", "isoform"),)

    gene: db.Mapped[str] = db.mapped_column(db.String(10), primary_key=True)
    isoform: db.Mapped[str] = db.mapped_column(db.String(12), primary_key=True)


class AgiAnnotation(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "agi_annotation"

    agi: db.Mapped[str] = db.mapped_column(db.String(11), nullable=False, primary_key=True)
    annotation: db.Mapped[str] = db.mapped_column(db.String(64000), nullable=False, primary_key=False)


class TAIR10FunctionalDescriptions(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "TAIR10_functional_descriptions"

    Model_name: db.Mapped[str] = db.mapped_column(db.String(32), nullable=False, primary_key=True)
    Type: db.Mapped[str] = db.mapped_column(db.String(32), nullable=False, primary_key=True)
    Short_description: db.Mapped[str] = db.mapped_column(TEXT(), nullable=True, primary_key=True)
    Curator_summary: db.Mapped[str] = db.mapped_column(TEXT(), nullable=True, primary_key=True)
    Computational_description: db.Mapped[str] = db.mapped_column(TEXT(), nullable=True, primary_key=True)


class GeneRIFs(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "geneRIFs"

    gene: db.Mapped[str] = db.mapped_column(db.String(11), nullable=False, primary_key=True)
    pubmed: db.Mapped[str] = db.mapped_column(db.String(11), nullable=False, primary_key=True)
    RIF: db.Mapped[str] = db.mapped_column(TEXT(), nullable=False, primary_key=True)


class Publications(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "publications"

    gene: db.Mapped[str] = db.mapped_column(db.String(12), nullable=False, primary_key=True)
    author: db.Mapped[str] = db.mapped_column(db.String(64), nullable=False, primary_key=True)
    year: db.Mapped[str] = db.mapped_column(db.String(6), nullable=False, primary_key=True)
    journal: db.Mapped[str] = db.mapped_column(db.String(64), nullable=False, primary_key=True)
    title: db.Mapped[str] = db.mapped_column(TEXT(), nullable=False, primary_key=True)
    pubmed: db.Mapped[str] = db.mapped_column(db.String(16), nullable=False, primary_key=True)
