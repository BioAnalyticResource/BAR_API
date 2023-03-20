from typing import Optional
from api import db


# Not sure how to set up db.relationship in SQLAlchemy 2.0 multiple dbs.
class ProteinReference(db.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "protein_reference"
    protein_reference_id: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=True)
    gene_identifier: db.Mapped[Optional[str]] = db.mapped_column(db.String(45), primary_key=False)
    # proteinsJoin = db.relationship("SnpsToProtein", backref="prot")


class SnpsToProtein(db.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "snps_to_protein"
    snps_reference_id: db.Mapped[int] = db.mapped_column(
        db.Integer(),
        db.ForeignKey("snps_reference.snps_reference_id"),
        primary_key=True,
    )
    protein_reference_id: db.Mapped[int] = db.mapped_column(
        db.Integer(),
        db.ForeignKey("protein_reference.protein_reference_id"),
        primary_key=True,
    )
    transcript_pos: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=False)
    ref_DNA: db.Mapped[Optional[str]] = db.mapped_column(db.String(1), primary_key=False)
    alt_DNA: db.Mapped[Optional[str]] = db.mapped_column(db.String(1), primary_key=False)
    aa_pos: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=False)
    ref_aa: db.Mapped[Optional[str]] = db.mapped_column(db.String(3), primary_key=False)
    alt_aa: db.Mapped[Optional[str]] = db.mapped_column(db.String(3), primary_key=False)
    type: db.Mapped[Optional[str]] = db.mapped_column(db.String(50), primary_key=False)
    effect_impact: db.Mapped[Optional[str]] = db.mapped_column(db.String(50), primary_key=False)
    transcript_biotype: db.Mapped[Optional[str]] = db.mapped_column(db.String(45), primary_key=False)


class SnpsReference(db.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "snps_reference"
    snps_reference_id: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=True)
    chromosome: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=False)
    chromosomal_loci: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=False)
    ref_allele: db.Mapped[Optional[str]] = db.mapped_column(db.String(1), primary_key=False)
    alt_allele: db.Mapped[Optional[str]] = db.mapped_column(db.String(1), primary_key=False)
    sample_id: db.Mapped[Optional[str]] = db.mapped_column(db.String(45), primary_key=False)
    # snpsJoin = db.relationship("SnpsToProtein", backref="snp")


class LinesLookup(db.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "lines_lookup"
    lines_id: db.Mapped[Optional[str]] = db.mapped_column(db.String(45), primary_key=True)
    species: db.Mapped[Optional[str]] = db.mapped_column(db.String(35), primary_key=False)
    alias: db.Mapped[Optional[str]] = db.mapped_column(db.String(35), primary_key=False)
