from typing import Optional
from api import db
#from sqlalchemy.ext.declarative import declarative_base

#CanolaBase = declarative_base()
class CanolaProteinReference(db.Model):
    __bind_key__ = "canola_nssnp"
    __tablename__ = "protein_reference"

    protein_reference_id: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=True, autoincrement=True)
    gene_identifier: db.Mapped[str] = db.mapped_column(db.String(45), nullable=False)
    gene_name: db.Mapped[Optional[str]] = db.mapped_column(db.String(45), nullable=True)

    proteinsJoin = db.relationship("CanolaSnpsToProtein", backref="protein", cascade="all, delete-orphan")


class CanolaSnpsToProtein(db.Model):
    __bind_key__ = "canola_nssnp"
    __tablename__ = "snps_to_protein"

    snps_reference_id: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=True, autoincrement=True)
    protein_reference_id: db.Mapped[int] = db.mapped_column(
        db.Integer(), db.ForeignKey("protein_reference.protein_reference_id", ondelete="CASCADE"), primary_key=True
    )
    transcript_pos: db.Mapped[int] = db.mapped_column(db.Integer(), nullable=False)
    chromosome: db.Mapped[str] = db.mapped_column(db.String(25), nullable=False)
    chromosomal_loci: db.Mapped[int] = db.mapped_column(db.Integer(), nullable=False)
    ref_DNA: db.Mapped[str] = db.mapped_column(db.String(1), nullable=False)
    alt_DNA: db.Mapped[str] = db.mapped_column(db.String(45), nullable=False)
    aa_pos: db.Mapped[int] = db.mapped_column(db.Integer(), nullable=False)
    ref_aa: db.Mapped[str] = db.mapped_column(db.String(3), nullable=False)
    alt_aa: db.Mapped[str] = db.mapped_column(db.String(3), nullable=False)
    type: db.Mapped[str] = db.mapped_column(db.String(50), nullable=False)
    effect_impact: db.Mapped[str] = db.mapped_column(db.String(50), nullable=False)
    transcript_biotype: db.Mapped[Optional[str]] = db.mapped_column(db.String(45), nullable=True)
    alt_freq: db.Mapped[float] = db.mapped_column(db.Numeric(10, 5), nullable=False)
