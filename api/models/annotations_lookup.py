from api import db


class AgiAlias(db.Model):
    __bind_key__ = 'annotations_lookup'
    __tablename__ = 'agi_alias'
    agi = db.Column(db.String(30), primary_key=True)
    alias = db.Column(db.String(30), primary_key=True)
