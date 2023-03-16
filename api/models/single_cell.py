from api import db


class SingleCell(db.Model):
    __bind_key__ = "single_cell"
    __tablename__ = "sample_data"
    __table_args__ = (
        db.Index("data_probeset_id", "data_probeset_id", "data_bot_id", "data_signal"),
    )

    proj_id = db.Column(db.String(5), nullable=False)
    sample_id = db.Column(db.Integer, nullable=False)
    data_probeset_id = db.Column(db.String(24), nullable=False, primary_key=True)
    data_signal = db.Column(db.Float, primary_key=True)
    data_bot_id = db.Column(db.String(32), nullable=False, primary_key=True)
