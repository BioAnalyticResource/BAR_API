from api import db


class SampleData(db.Model):
    __bind_key__ = "arabidopsis_ecotypes"
    __tablename__ = "sample_data"

    sample_id: db.Mapped[int] = db.mapped_column(db.Integer, nullable=False)
    proj_id: db.Mapped[str] = db.mapped_column(db.String(15), nullable=False)
    sample_file_name: db.Mapped[str] = db.mapped_column(db.String)
    data_probeset_id: db.Mapped[str] = db.mapped_column(db.String(30), nullable=False, primary_key=True)
    data_signal: db.Mapped[float] = db.mapped_column(db.Float)
    data_call: db.Mapped[str] = db.mapped_column(db.String)
    data_p_val: db.Mapped[float] = db.mapped_column(db.Float)
    data_bot_id: db.Mapped[str] = db.mapped_column(db.String(16), nullable=False)
