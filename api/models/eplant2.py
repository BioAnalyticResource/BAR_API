from api import eplant2_db as db


class Isoforms(db.Model):
    __bind_key__ = "eplant2"
    __tablename__ = "isoforms"
    __table_args__ = (db.Index("idx_gene_isoform", "gene", "isoform"),)

    gene = db.Column(db.String(10), primary_key=True)
    isoform = db.Column(db.String(12), primary_key=True)
