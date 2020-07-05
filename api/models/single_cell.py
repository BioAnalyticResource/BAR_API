from api import db


class SingleCell(db.Model):
    __bind_key__ = 'single_cell'
    __tablename__ = 'sample_data'
    data_probeset_id = db.Column(db.String(24), primary_key=True)
    data_signal = db.Column(db.Integer, primary_key=True)
    data_bot_id = db.Column(db.String(32), primary_key=True)
