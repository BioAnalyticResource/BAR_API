from api import poplar_nssnp_db as popdb


class PopProteinReference(popdb.Model):
    __bind_key__ = "poplar_nssnp"
    __tablename__ = "protein_reference"
    protein_reference_id = popdb.Column(popdb.Integer(), primary_key=True)
    gene_identifier = popdb.Column(popdb.String(45), primary_key=False)
    proteinsJoin = popdb.relationship("PopSnpsToProtein", backref="prot")


class PopSnpsToProtein(popdb.Model):
    __bind_key__ = "poplar_nssnp"
    __tablename__ = "snps_to_protein"
    snps_reference_id = popdb.Column(
        popdb.Integer(),
        popdb.ForeignKey("snps_reference.snps_reference_id"),
        primary_key=True,
    )
    protein_reference_id = popdb.Column(
        popdb.Integer(),
        popdb.ForeignKey("protein_reference.protein_reference_id"),
        primary_key=True,
    )
    transcript_pos = popdb.Column(popdb.Integer(), primary_key=False)
    ref_DNA = popdb.Column(popdb.String(1), primary_key=False)
    alt_DNA = popdb.Column(popdb.String(1), primary_key=False)
    aa_pos = popdb.Column(popdb.Integer(), primary_key=False)
    ref_aa = popdb.Column(popdb.String(3), primary_key=False)
    alt_aa = popdb.Column(popdb.String(3), primary_key=False)
    type = popdb.Column(popdb.String(50), primary_key=False)
    effect_impact = popdb.Column(popdb.String(50), primary_key=False)
    transcript_biotype = popdb.Column(popdb.String(45), primary_key=False)


class PopSnpsReference(popdb.Model):
    __bind_key__ = "poplar_nssnp"
    __tablename__ = "snps_reference"
    snps_reference_id = popdb.Column(popdb.Integer(), primary_key=True)
    chromosome = popdb.Column(popdb.Integer(), primary_key=False)
    chromosomal_loci = popdb.Column(popdb.Integer(), primary_key=False)
    ref_allele = popdb.Column(popdb.String(1), primary_key=False)
    alt_allele = popdb.Column(popdb.String(1), primary_key=False)
    sample_id = popdb.Column(popdb.String(45), primary_key=False)
    snpsJoin = popdb.relationship("PopSnpsToProtein", backref="snp")
