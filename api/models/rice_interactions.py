from datetime import datetime
from typing import Optional

from api import db


class Interactions(db.Model):
    __bind_key__ = "rice_interactions"
    __tablename__ = "interactions"
    Protein1: db.Mapped[str] = db.mapped_column(db.String(14), primary_key=True)
    Protein2: db.Mapped[str] = db.mapped_column(db.String(14), primary_key=True)
    S_cerevisiae: db.Mapped[int] = db.mapped_column(
        db.SmallInteger(), primary_key=False
    )
    S_pombe: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Worm: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Fly: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Human: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Mouse: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Total_hits: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Num_species: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Quality: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Index: db.Mapped[int] = db.mapped_column(db.SmallInteger(), primary_key=False)
    Pcc: db.Mapped[Optional[str]] = db.mapped_column(db.Float, primary_key=False)
    Bind_id: db.Mapped[Optional[str]] = db.mapped_column(
        db.SmallInteger(), primary_key=False
    )


class Rice_mPLoc(db.Model):
    __bind_key__ = "rice_interactions"
    __tablename__ = "Rice_mPLoc"
    gene_id: db.Mapped[str] = db.mapped_column(db.String(20), primary_key=True)
    alias: db.Mapped[Optional[str]] = db.mapped_column(db.String(), primary_key=False)
    lab_description: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    gfp: db.Mapped[Optional[str]] = db.mapped_column(db.String(), primary_key=False)
    mass_spec: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    swissprot: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    amigo: db.Mapped[Optional[str]] = db.mapped_column(db.String(), primary_key=False)
    annotation: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_ipsort: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_mitopred: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_mitopred2: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_predator: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_peroxp: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_subloc: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_targetp: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_wolfpsort: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_multiloc: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_loctree: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )
    pred_mPLoc: db.Mapped[Optional[str]] = db.mapped_column(
        db.String(), primary_key=False
    )


class RGI_annotation(db.Model):
    __bind_key__ = "rice_interactions"
    __tablename__ = "RGI_annotation"
    loc: db.Mapped[str] = db.mapped_column(db.String(14), primary_key=True)
    annotation: db.Mapped[str] = db.mapped_column(db.String(), primary_key=True)
    date: db.Mapped[datetime] = db.mapped_column(db.Date(), primary_key=True)
