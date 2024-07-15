from datetime import datetime
from api import db


class AgiAlias(db.Model):
    __bind_key__ = "annotations_lookup"
    __tablename__ = "agi_alias"
    __table_args__ = (db.Index("alias_date_agi", "alias", "date", "agi"),)

    agi: db.Mapped[str] = db.mapped_column(db.String(30), primary_key=True, nullable=False)
    alias: db.Mapped[str] = db.mapped_column(db.String(30), primary_key=True, nullable=False)
    date: db.Mapped[datetime] = db.mapped_column(db.Date, primary_key=True, nullable=False)


class AtAgiLookup(db.Model):
    __bind_key__ = "annotations_lookup"
    __tablename__ = "at_agi_lookup"
    __table_args__ = (db.Index("probeset_date_agi", "probeset", "agi", "date"),)

    probeset: db.Mapped[str] = db.mapped_column(db.String(60), primary_key=True, nullable=False)
    agi: db.Mapped[str] = db.mapped_column(db.String(30), primary_key=True, nullable=False)
    date: db.Mapped[datetime] = db.mapped_column(db.Date, primary_key=True, nullable=False)
