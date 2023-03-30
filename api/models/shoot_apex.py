from api import db


class SampleData(db.Model):
    __bind_key__ = "shoot_apex"
    __tablename__ = "sample_data"

    proj_id: db.Mapped[str] = db.mapped_column(db.String(2), nullable=False)
    sample_id: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False)
    data_probeset_id: db.Mapped[str] = db.mapped_column(db.String(12), nullable=False, primary_key=True)
    data_signal: db.Mapped[float] = db.mapped_column(db.Float, primary_key=True)
    data_bot_id: db.Mapped[str] = db.mapped_column(db.String(8), nullable=False, primary_key=True)
