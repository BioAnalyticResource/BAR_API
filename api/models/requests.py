from api import db


class Requests(db.Model):
    __bind_key__ = 'summarization'
    __tablename__ = 'requests'
    first_name = db.Column(db.String(32), index=True)
    last_name = db.Column(db.String(32), index=True)
    email = db.Column(db.String(120), index=True, primary_key=True, unique=True)
    telephone = db.Column(db.String(12), index=True, unique=True)
    contact_type = db.Column(db.String(5), index=True, unique=True)
    notes = db.Column(db.String(500), index=True)
