from api import rice_interactions_db as db


class Interactions(db.Model):
    __bind_key__ = "rice_interactions"
    __tablename__ = "interactions"
    Protein1 = db.Column(db.String(14), primary_key=True)
    Protein2 = db.Column(db.String(14), primary_key=True)
    S_cerevisiae = db.Column(db.SmallInteger(), primary_key=False)
    S_pombe = db.Column(db.SmallInteger(), primary_key=False)
    Worm = db.Column(db.SmallInteger(), primary_key=False)
    Fly = db.Column(db.SmallInteger(), primary_key=False)
    Human = db.Column(db.SmallInteger(), primary_key=False)
    Mouse = db.Column(db.SmallInteger(), primary_key=False)
    Total_hits = db.Column(db.SmallInteger(), primary_key=False)
    Num_species = db.Column(db.SmallInteger(), primary_key=False)
    Quality = db.Column(db.SmallInteger(), primary_key=False)
    Index = db.Column(db.SmallInteger(), primary_key=False)
    Pcc = db.Column(db.Float, primary_key=False)
    Bind_id = db.Column(db.SmallInteger(), primary_key=False)


class Rice_mPLoc(db.Model):
    __bind_key__ = "rice_interactions"
    __tablename__ = "Rice_mPLoc"
    gene_id = db.Column(db.String(20), primary_key=True)
    alias = db.Column(db.String(), primary_key=False)
    lab_description = db.Column(db.String(), primary_key=False)
    gfp = db.Column(db.String(), primary_key=False)
    mass_spec = db.Column(db.String(), primary_key=False)
    swissprot = db.Column(db.String(), primary_key=False)
    amigo = db.Column(db.String(), primary_key=False)
    annotation = db.Column(db.String(), primary_key=False)
    pred_ipsort = db.Column(db.String(), primary_key=False)
    pred_mitopred = db.Column(db.String(), primary_key=False)
    pred_mitopred2 = db.Column(db.String(), primary_key=False)
    pred_predator = db.Column(db.String(), primary_key=False)
    pred_peroxp = db.Column(db.String(), primary_key=False)
    pred_subloc = db.Column(db.String(), primary_key=False)
    pred_targetp = db.Column(db.String(), primary_key=False)
    pred_wolfpsort = db.Column(db.String(), primary_key=False)
    pred_multiloc = db.Column(db.String(), primary_key=False)
    pred_loctree = db.Column(db.String(), primary_key=False)
    pred_mPLoc = db.Column(db.String(), primary_key=False)


class RGI_annotation(db.Model):
    __bind_key__ = "rice_interactions"
    __tablename__ = "RGI_annotation"
    loc = db.Column(db.String(14), primary_key=True)
    annotation = db.Column(db.String(), primary_key=True)
    date = db.Column(db.Date(), primary_key=True)
