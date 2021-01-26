from api import db


class Users(db.Model):
    __bind_key__ = 'summarization'
    __tablename__ = 'users'
    first_name = db.Column(db.String(32), index=True)
    last_name = db.Column(db.String(32), index=True)
    email = db.Column(db.String(120), index=True, unique=True)
    telephone = db.Column(db.String(12), index=True, unique=True)
    contact_type = db.Column(db.String(5), index=True, unique=True)
    api_key = db.Column(db.String(120), primary_key=True)
    status = db.Column(db.String(32), index=True)
    date_added = db.Column(db.Date, nullable=False)
    uses_left = db.Column(db.Integer, index=True, default=25)
