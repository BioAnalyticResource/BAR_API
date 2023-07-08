from api import db


class SampleData(db.Model):
    __bind_key__ = "selaginella"
    __tablename__ = "sample_data"

    proj_id: db.Mapped[str] = db.mapped_column(db.String(5), nullable=False)
    sample_id: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False)
    data_probeset_id: db.Mapped[str] = db.mapped_column(db.String(18), nullable=False, primary_key=True)
    data_signal: db.Mapped[float] = db.mapped_column(db.Float, primary_key=True)
    data_bot_id: db.Mapped[str] = db.mapped_column(db.String(36), nullable=False, primary_key=True)
