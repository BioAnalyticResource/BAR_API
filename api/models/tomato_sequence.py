from typing import Optional
from api import db


class Tomato32SequenceInfo(db.Model):
    __bind_key__ = "tomato_sequence"
    __tablename__ = "tomato_3_2_sequence_info"

    gene_id: db.Mapped[str] = db.mapped_column(db.String(20), nullable=False, primary_key=True)
    full_seq: db.Mapped[Optional[str]] = db.mapped_column(db.String(9999), nullable=True)
