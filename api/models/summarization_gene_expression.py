from api import db

class SummarizationGeneExpression(db.Model):
    Gene = db.Column(db.String(24), primary_key=True)
    Value = db.Column(db.Integer, primary_key=True)
    Sample = db.Column(db.String(32), primary_key=True)