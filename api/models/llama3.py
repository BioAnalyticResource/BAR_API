from api import db


class Llama3(db.Model):
    __bind_key__ = "llama3_summaries"
    __tablename__ = "summaries"

    gene_id: db.Mapped[str] = db.mapped_column(db.String(13), nullable=False, primary_key=True)
    summary: db.Mapped[int] = db.mapped_column(db.String(), nullable=False)
    bert_score: db.Mapped[str] = db.mapped_column(db.Float, nullable=False)
