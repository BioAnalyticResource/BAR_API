from api import db
import enum
from sqlalchemy.dialects.mysql import DECIMAL, ENUM
from sqlalchemy.orm import relationship
from sqlalchemy import ForeignKey
from typing import List


class Sites(db.Model):
    __bind_key__ = "fastpheno"
    __tablename__ = "sites"

    sites_pk: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False, primary_key=True)
    site_name: db.Mapped[str] = db.mapped_column(db.String(45), nullable=False)
    site_desc: db.Mapped[str] = db.mapped_column(db.String(99), nullable=True)
    children: db.Mapped[List["Trees"]] = relationship()


class Trees(db.Model):
    __bind_key__ = "fastpheno"
    __tablename__ = "trees"

    trees_pk: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False, primary_key=True)
    sites_pk: db.Mapped[int] = db.mapped_column(ForeignKey("sites.sites_pk"))
    longitude: db.Mapped[float] = db.mapped_column(db.Float, nullable=False)
    latitude: db.Mapped[float] = db.mapped_column(db.Float, nullable=False)
    genotype_id: db.Mapped[str] = db.mapped_column(db.String(5), nullable=True)
    external_link: db.Mapped[str] = db.mapped_column(db.String(200), nullable=True)
    tree_given_id: db.Mapped[str] = db.mapped_column(db.String(25), nullable=True)
    children: db.Mapped[List["Band"]] = relationship()


class MonthChoices(enum.Enum):
    jan = '1'
    feb = '2'
    mar = '3'
    apr = '4'
    may = '5'
    jun = '6'
    jul = '7'
    aug = '8'
    sep = '9'
    oct = '10'
    nov = '11'
    dec = '12'


class Band(db.Model):
    __bind_key__ = "fastpheno"
    __tablename__ = "band"

    trees_pk: db.Mapped[int] = db.mapped_column(ForeignKey("trees.trees_pk"), primary_key=True)
    month: db.Mapped[str] = db.mapped_column(ENUM(MonthChoices), nullable=False, primary_key=True)
    band: db.Mapped[float] = db.mapped_column(db.String(100), nullable=False, primary_key=True)
    value: db.Mapped[float] = db.mapped_column(DECIMAL(20, 15), nullable=False)


class Height(db.Model):
    __bind_key__ = "fastpheno"
    __tablename__ = "height"

    trees_pk: db.Mapped[int] = db.mapped_column(ForeignKey("trees.trees_pk"), primary_key=True)
    month: db.Mapped[str] = db.mapped_column(ENUM(MonthChoices), nullable=False, primary_key=True)
    tree_height_proxy: db.Mapped[float] = db.mapped_column(DECIMAL(20, 15), nullable=False)
    ground_height_proxy: db.Mapped[float] = db.mapped_column(DECIMAL(20, 15), nullable=False)
