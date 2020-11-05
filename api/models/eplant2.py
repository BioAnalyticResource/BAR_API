from api import db


class isoforms(db.Model):
    __bind_key__ = 'eplant2'
    __tablename__ = 'isoforms'
    gene = db.Column(db.String(10), primary_key=True)
    isoform = db.Column(db.String(12), primary_key=True)
