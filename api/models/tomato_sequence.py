from api import tomato_seq_db as db


class Tomato32SequenceInfo(db.Model):
    __bind_key__ = "tomato_sequence"
    __tablename__ = "tomato_3_2_sequence_info"

    gene_id = db.Column(db.String(20), nullable=False, primary_key=True)
    full_seq = db.Column(db.String(9999), nullable=True, primary_key=False)
    full_seq_len = db.Column(db.Integer(), nullable=True, primary_key=False)
    phyre2_seq = db.Column(db.String(9999), nullable=True, primary_key=False)
    phyre2_seq_start = db.Column(db.Integer(), nullable=True, primary_key=False)
    phyre2_seq_end = db.Column(db.Integer(), nullable=True, primary_key=False)
