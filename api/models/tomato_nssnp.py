from api import tomato_nssnp_db as tomdb


class TomProteinReference(tomdb.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "protein_reference"
    protein_reference_id = tomdb.Column(tomdb.Integer(), primary_key=True)
    gene_identifier = tomdb.Column(tomdb.String(45), primary_key=False)
    proteinsJoin = tomdb.relationship("TomSnpsToProtein", backref="prot")


class TomSnpsToProtein(tomdb.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "snps_to_protein"
    snps_reference_id = tomdb.Column(
        tomdb.Integer(),
        tomdb.ForeignKey("snps_reference.snps_reference_id"),
        primary_key=True,
    )
    protein_reference_id = tomdb.Column(
        tomdb.Integer(),
        tomdb.ForeignKey("protein_reference.protein_reference_id"),
        primary_key=True,
    )
    transcript_pos = tomdb.Column(tomdb.Integer(), primary_key=False)
    ref_DNA = tomdb.Column(tomdb.String(1), primary_key=False)
    alt_DNA = tomdb.Column(tomdb.String(1), primary_key=False)
    aa_pos = tomdb.Column(tomdb.Integer(), primary_key=False)
    ref_aa = tomdb.Column(tomdb.String(3), primary_key=False)
    alt_aa = tomdb.Column(tomdb.String(3), primary_key=False)
    type = tomdb.Column(tomdb.String(50), primary_key=False)
    effect_impact = tomdb.Column(tomdb.String(50), primary_key=False)
    transcript_biotype = tomdb.Column(tomdb.String(45), primary_key=False)


class TomSnpsReference(tomdb.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "snps_reference"
    snps_reference_id = tomdb.Column(tomdb.Integer(), primary_key=True)
    chromosome = tomdb.Column(tomdb.Integer(), primary_key=False)
    chromosomal_loci = tomdb.Column(tomdb.Integer(), primary_key=False)
    ref_allele = tomdb.Column(tomdb.String(1), primary_key=False)
    alt_allele = tomdb.Column(tomdb.String(1), primary_key=False)
    sample_id = tomdb.Column(tomdb.String(45), primary_key=False)
    snpsJoin = tomdb.relationship("TomSnpsToProtein", backref="snp")


class TomLinesLookup(tomdb.Model):
    __bind_key__ = "tomato_nssnp"
    __tablename__ = "lines_lookup"
    lines_id = tomdb.Column(tomdb.String(45), primary_key=True)
    species = tomdb.Column(tomdb.String(35), primary_key=False)
    alias = tomdb.Column(tomdb.String(35), primary_key=False)
