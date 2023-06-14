from api import db


class SampleData(db.Model):
    __bind_key__ = "physcomitrella_db"
    __tablename__ = "sample_data"

    proj_id: db.Mapped[str] = db.mapped_column(db.String(30), nullable=False)
    sample_id: db.Mapped[int] = db.mapped_column(db.String(30), nullable=False)
    data_probeset_id: db.Mapped[str] = db.mapped_column(db.String(40), nullable=False, primary_key=True)
    data_signal: db.Mapped[float] = db.mapped_column(db.Float, primary_key=True)
    data_bot_id: db.Mapped[str] = db.mapped_column(db.String(40), nullable=False, primary_key=True)
