from api import annotations_lookup_db as db


class AgiAlias(db.Model):
    __bind_key__ = "annotations_lookup"
    __tablename__ = "agi_alias"
    __table_args__ = (db.Index("alias_date_agi", "alias", "date", "agi"),)

    agi = db.Column(db.String(30), primary_key=True, nullable=False)
    alias = db.Column(db.String(30), primary_key=True, nullable=False)
    date = db.Column(db.Date, primary_key=True, nullable=False)
