from api import summarization_db as db


class SummarizationGeneExpression(db.Model):
    __bind_key__ = "summarization"
    __tablename__ = "summarization"
    data_probeset_id = db.Column(db.String(24), primary_key=True)
    data_signal = db.Column(db.Integer, primary_key=True)
    data_bot_id = db.Column(db.String(32), primary_key=True)


class Requests(db.Model):
    __bind_key__ = "summarization"
    __tablename__ = "requests"
    first_name = db.Column(db.String(32), index=True)
    last_name = db.Column(db.String(32), index=True)
    email = db.Column(db.String(120), index=True, primary_key=True, unique=True)
    notes = db.Column(db.String(500), index=True)


class Users(db.Model):
    __bind_key__ = "summarization"
    __tablename__ = "users"
    first_name = db.Column(db.String(32), index=True)
    last_name = db.Column(db.String(32), index=True)
    email = db.Column(db.String(120), index=True, unique=True)
    api_key = db.Column(db.String(120), primary_key=True)
    status = db.Column(db.String(32), index=True)
    date_added = db.Column(db.Date, nullable=False)
    uses_left = db.Column(db.Integer, index=True, default=25)
