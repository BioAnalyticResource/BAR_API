try:  # try block needed for those w/o native pymol installation; pymol not in PIP
    from pymol import cmd, stored, CmdException
except ImportError:
    pass

protein_letters = {
    "A": "ALA",
    "C": "CYS",
    "D": "ASP",
    "E": "GLU",
    "F": "PHE",
    "G": "GLY",
    "H": "HIS",
    "I": "ILE",
    "K": "LYS",
    "L": "LEU",
    "M": "MET",
    "N": "ASN",
    "P": "PRO",
    "Q": "GLN",
    "R": "ARG",
    "S": "SER",
    "T": "THR",
    "V": "VAL",
    "W": "TRP",
    "Y": "TYR",
}


class PymolCmds:
    @staticmethod
    def find_range(chain):
        """
        helper function
        return the message of input range residue position and name
        """
        if chain == "NONE":
            chain_str = ""  # monomer, so chain arg is empty
            chain = ""
        else:
            chain_str = "and c. " + chain
        sequence = cmd.get_fastastr("/target//" + chain)
        start_residue = sequence.split("\n")[1][0]  # get residue name of the first AA
        end_residue = sequence.strip()[-1]  # get residue name of the last AA
        cmd.select(
            "start",
            "(first resn {start} {chain})".format(start=protein_letters[start_residue], chain=chain_str),
        )  # select the first
        cmd.select(
            "end",
            "(last resn {end} {chain})".format(end=protein_letters[end_residue], chain=chain_str),
        )  # select the last
        stored.residues = []  # place holder array
        cmd.iterate("start", "stored.residues.append(resv)")  # append the first residue postion int to place holder
        cmd.iterate("end", "stored.residues.append(resv)")  # append the last residue position int
        if chain == "":
            return "residues range start from {start}({startRes}) to {end}({endRes})".format(
                start=stored.residues[0],
                startRes=start_residue,
                end=stored.residues[1],
                endRes=end_residue,
            )
        else:
            return "residues range in chain {c} start from {start}({startRes}) to {end}({endRes})".format(
                c=chain,
                start=stored.residues[0],
                startRes=start_residue,
                end=stored.residues[1],
                endRes=end_residue,
            )

    @staticmethod
    def residue_validation(model, chain, snps):
        """Check if AA submitted to pymol are valid in PDB model
        :param model: Gene model URI e.g. //bar.utoronto.ca/eplant_poplar/pdb/Potri.016G107900.1.pdb
        :param chain: Chain if available, e.g. 'NONE'
        :param snps: List of SNPs, e.g. ['V25L', 'E26A']
        """
        cmd.load("https:" + model, "target")
        query_string = "i. "
        if chain.upper() != "NONE":  # multimer, introduce the c. for chain selection
            query_string = "c. " + chain.upper() + " & " + query_string

        for each in snps:
            print("each", each)
            try:
                locus_selected = cmd.select(query_string + each[1:-1])  # select by residue postion
                resn_selected = cmd.select(
                    query_string + each[1:-1] + " & resn " + protein_letters[each[0]]
                )  # select by residue position + name
            except CmdException:
                return {"status": False, "msg": "CmdException error for select"}
            else:
                if locus_selected == 0:  # empty select by residue position, wrong locus
                    range_info = PymolCmds.find_range(chain)  # get sequence start and end information
                    return {
                        "status": False,
                        "msg": f"Invalid SNP input range, see locus {each[1:-1]}; {range_info}",
                    }
                if resn_selected == 0:  # empty select by residue position + name, unmatch original AA
                    cmd.select("curr", query_string + each[1:-1])  # select the residue at the postion, named "curr"
                    ori = cmd.get_fastastr("curr").strip()[-1]  # get the residue name for "curr"
                    return {
                        "status": False,
                        "msg": f"Invalid SNP residue, residue {each[1:-1]} of the model is {ori}",
                    }
        return {"status": True}

    @staticmethod
    def compute_mutation(model, filename, chain, snps):
        """Use pymol mutagensis wizard, along with pymol commands to get most predicted mutated PDB
        :model: Gene model URI e.g. //bar.utoronto.ca/eplant_poplar/pdb/Potri.016G107900.1.pdb
        :filename: Path of target PDB filename (includes directory, i.e. you need write access) e.g. var/www/html/pymol-mutated-pdbs/POTRI.016G107900.1-V25L-R27A.pdb
        :chain: Chain if available, e.g. 'NONE'
        :param snps: List of SNPs, e.g. ['V25L', 'E26A']
        """
        cmd.load("https:" + model, "target")

        # init mutagenesis
        cmd.wizard("mutagenesis")

        # check if chain is altered
        chain_str = "/target//"
        if chain.upper() != "NONE":
            chain_str += chain.upper() + "/"
        else:
            chain_str += "/"

        # looping all snps inputs
        for each in snps:
            cmd.get_wizard().do_select(chain_str + each[1:-1] + "/")
            mut = protein_letters[each[-1].upper()]
            cmd.get_wizard().set_mode(mut)
            cmd.frame(1)
            cmd.get_wizard().apply()
        cmd.save(filename, "target", -1)
