from api import db


class Isoforms(db.Model):
    __bind_key__ = "eplant_poplar"
    __tablename__ = "isoforms"

    gene: db.Mapped[str] = db.mapped_column(
        db.String(20), nullable=False, primary_key=True
    )
    isoform: db.Mapped[str] = db.mapped_column(
        db.String(24), nullable=False, primary_key=True
    )


class GeneAnnotation(db.Model):
    __bind_key__ = "eplant_poplar"
    __tablename__ = "gene_annotation"

    gene: db.Mapped[str] = db.mapped_column(
        db.String(20), nullable=False, primary_key=True
    )
    annotation: db.Mapped[str] = db.mapped_column(
        db.String(64000), nullable=False, primary_key=False
    )
