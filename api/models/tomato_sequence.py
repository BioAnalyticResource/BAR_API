from api import tomato_seq_db as db


class Tomato32SequenceInfo(db.Model):
    __bind_key__ = "tomato_sequence"
    __tablename__ = "tomato_3_2_sequence_info"

    gene_id = db.Column(db.String(20), nullable=False, primary_key=True)
    full_seq = db.Column(db.String(9999), nullable=True, primary_key=False)
