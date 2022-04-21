from pymol import cmd, stored, CmdException
from sys import argv

protein_letters = {'A': 'ALA', 'C': 'CYS', 'D': 'ASP', 'E': 'GLU',
                   'F': 'PHE', 'G': 'GLY', 'H': 'HIS', 'I': 'ILE',
                   'K': 'LYS', 'L': 'LEU', 'M': 'MET', 'N': 'ASN',
                   'P': 'PRO', 'Q': 'GLN', 'R': 'ARG', 'S': 'SER',
                   'T': 'THR', 'V': 'VAL', 'W': 'TRP', 'Y': 'TYR'}


def checkResidueValidation(model, chain, snps):
    cmd.load("https:"+model, "target")
    query_string = "i. "
    if chain.upper() != 'NONE':  # multimer, introduce the c. for chain selection
        query_string = "c. " + chain.upper() + " & " + query_string

    for each in snps:
        print('each', each)
        try:
            locus_selected = cmd.select(query_string + each[1:-1])  # select by residue postion
            resn_selected = cmd.select(
                query_string + each[1:-1] + " & resn " + protein_letters[each[0]])  # select by residue position + name
        except CmdException:
            print("CmdException error for select")
        else:
            if (locus_selected == 0):  # empty select by residue position, wrong locus
                rangeInfo = __findRange(chain)  # get sequence start and end information
                print('out of range;' + each[1:-1] + ';' + rangeInfo)
                return
            if (resn_selected == 0):  # empty select by residue position + name, unmatch original AA
                cmd.select("curr", query_string + each[1:-1])  # select the residue at the postion, named "curr"
                ori = cmd.get_fastastr('curr').strip()[-1]  # get the residue name for "curr"
                print('invalid:' + each[1:-1] + " ori:%s" % ori)  # print the correct original AA
                return


def computeMutation(model, filename, chain, snps):
    cmd.load("https:"+model, "target")

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


def __findRange(chain):
    """
    helper function
    return the message of input range residue position and name
    """
    if chain == 'NONE':
        chain_str = ''  # monomer, so chain arg is empty
        chain = ''
    else:
        chain_str = "and c. " + chain
    sequence = cmd.get_fastastr("/target//"+chain)
    startResidue = sequence.split("\n")[1][0]  # get residue name of the first AA
    endResidue = sequence.strip()[-1]  # get residue name of the last AA
    cmd.select("start", "(first resn {start} {chain})".format(start=protein_letters[startResidue], chain=chain_str))  # select the first
    cmd.select("end", "(last resn {end} {chain})".format(end=protein_letters[endResidue], chain=chain_str))  # select the last
    stored.residues = []  # place holder array
    cmd.iterate("start", 'stored.residues.append(resv)')  # append the first residue postion int to place holder
    cmd.iterate("end", 'stored.residues.append(resv)')  # append the last residue position int
    if chain == '':
        return "residues range start from {start}({startRes}) to {end}({endRes})".format(
            start=stored.residues[0],
            startRes=startResidue, end=stored.residues[1], endRes=endResidue
        )
    else:
        return "residues range in chain {c} start from {start}({startRes}) to {end}({endRes})".format(
            c=chain, start=stored.residues[0],
            startRes=startResidue, end=stored.residues[1], endRes=endResidue
        )


"""
argv[2]: loading pdb url
argv[3]: filename for export
argv[4]: chain selector (for multimers, monomer is none)
argv[5:]: snps"""
# select
if argv[1] == "check_residue":
    checkResidueValidation(argv[2], argv[3], argv[4:])
elif argv[1] == 'mutate_snps':
    computeMutation(argv[2], argv[3], argv[4], argv[5:])

cmd.extend('checkResidueValidation', checkResidueValidation)
cmd.extend('computeMutation', computeMutation)
