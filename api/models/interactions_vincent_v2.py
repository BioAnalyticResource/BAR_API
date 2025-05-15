from api import db
from sqlalchemy import Enum
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.mysql import TEXT
from sqlalchemy import ForeignKey
from typing import List
from datetime import datetime


class Interactions(db.Model):
    __bind_key__ = "interactions_vincent_v2"
    __tablename__ = "interactions"

    interaction_id: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False, primary_key=True)
    pearson_correlation_coeff: db.Mapped[float] = db.mapped_column(db.Float, nullable=True, primary_key=False)
    entity_1: db.Mapped[str] = db.mapped_column(db.String(50), nullable=False, primary_key=False)
    entity_2: db.Mapped[str] = db.mapped_column(db.String(50), nullable=False, primary_key=False)
    interaction_type_id: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False, primary_key=False)
    children: db.Mapped[List["InteractionsSourceMiJoin"]] = relationship()


class InteractionsSourceMiJoin(db.Model):
    __bind_key__ = "interactions_vincent_v2"
    __tablename__ = "interactions_source_mi_join_table"

    interaction_id: db.Mapped[int] = db.mapped_column(ForeignKey("interactions.interaction_id"), primary_key=True)
    source_id: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False, primary_key=False)
    external_db_id: db.Mapped[str] = db.mapped_column(db.String(30), nullable=False, primary_key=False)
    mode_of_action: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False, primary_key=False)
    mi_detection_method: db.Mapped[str] = db.mapped_column(db.String(10), nullable=False, primary_key=False)
    mi_detection_type: db.Mapped[str] = db.mapped_column(db.String(10), nullable=False, primary_key=False)


class TagLookupTable(db.Model):
    __bind_key__ = "interactions_vincent_v2"
    __tablename__ = "tag_lookup_table"

    tag_name: db.Mapped[str] = db.mapped_column(db.String(20), nullable=False, primary_key=True)
    tag_group: db.Mapped[str] = db.mapped_column(Enum("Gene", "Experiment", "Condition", "Misc"), nullable=False, primary_key=False)


class ExternalSource(db.Model):
    __bind_key__ = "interactions_vincent_v2"
    __tablename__ = "external_source"

    source_id: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False, comment="surrogate key", primary_key=True)
    source_name: db.Mapped[str] = db.mapped_column(db.String(500), nullable=False, comment="name of the source, can be a pubmed identifier like “PMIDXXXXXXX” or “Asher’s sql dump”", primary_key=False)
    comments: db.Mapped[str] = db.mapped_column(TEXT(), nullable=False, comment="Comments regarding the source", primary_key=False)
    date_uploaded: db.Mapped[datetime] = db.mapped_column(db.Date(), nullable=False, comment="When it was uploaded to database", primary_key=False)
    url: db.Mapped[str] = db.mapped_column(db.String(350), nullable=True, comment="URL if available to paper/source (does not have to be a DOI, can be a link to a databases’ source)", primary_key=False)
    image_url: db.Mapped[str] = db.mapped_column(db.String(300), nullable=True, primary_key=False)
    grn_title: db.Mapped[str] = db.mapped_column(db.String(200), nullable=True, primary_key=False)
    cyjs_layout: db.Mapped[str] = db.mapped_column(db.String(1000), nullable=True, primary_key=False)
    children: db.Mapped[List["SourceTagJoinTable"]] = relationship()


class SourceTagJoinTable(db.Model):
    __bind_key__ = "interactions_vincent_v2"
    __tablename__ = "source_tag_join_table"

    source_id: db.Mapped[int] = db.mapped_column(
        db.Integer(),
        db.ForeignKey("external_source.source_id"),
        primary_key=True
    )
    tag_name: db.Mapped[str] = db.mapped_column(
        db.String(20),
        db.ForeignKey("tag_lookup_table.tag_name"),
        primary_key=True
    )
