from api import db


class homologs(db.Model):
    __bind_key__ = "homologs_db"
    __tablename__ = "homologs"

    homologs_id: db.Mapped[int] = db.mapped_column(db.Integer(), primary_key=True, autoincrement=True)
    search_protein_name: db.Mapped[str] = db.mapped_column(db.String(45), nullable=False)
    result_protein_name: db.Mapped[str] = db.mapped_column(db.String(45), nullable=False)
    search_species_name: db.Mapped[str] = db.mapped_column(db.String(45), nullable=False)
    result_species_name: db.Mapped[str] = db.mapped_column(db.String(45), nullable=False)
    Percent_id: db.Mapped[float] = db.mapped_column(db.Numeric(10, 5), nullable=False)
    e_score: db.Mapped[str] = db.mapped_column(db.String(10), nullable=False)
