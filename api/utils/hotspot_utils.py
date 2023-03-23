from typing import List, Tuple, Dict

# Files with probabilities of SNP significance based on shuffles
P_SNP_DIR = "/Users/isaiahhazelwood/Documents/UofT/Y3/BCB330/data/hotspots/"
ARA_STRUCT_P_SNP = P_SNP_DIR + "ara_struct_10_0.1_10000.tsv"
POP_STRUCT_P_SNP = P_SNP_DIR + "pop_struct_10_0.1_10000.tsv"
ARA_SEQ_P_SNP = P_SNP_DIR + "ara_seq_3_0.1_10000.tsv"
POP_SEQ_P_SNP = P_SNP_DIR + "pop_seq_3_0.1_10000.tsv"

# File with analyzed homologue pairs
HOMOLOGUE_DIR = "/Users/isaiahhazelwood/Documents/UofT/Y3/BCB330/data/homologue-info-pop3.0/"
ARA_POP_HOMOLOGUE = HOMOLOGUE_DIR + "ara-pop3.0-all-valid.tsv"


def verify_ara_pop_homologue(ara_id: str, pop_id: str = ""):
    """
    If only ara_id is provided, find the matching poplar pair.
    If ara_id and pop_id are provided, ensure they are a homologue pair.
    Returns a valid pair and their sequences as a tuple 
        (araid, popid, araseq, popseq), or None if not a valid pair.
    """
    with open(ARA_POP_HOMOLOGUE, 'r') as f_ara_pop_homologue:
        for line in f_ara_pop_homologue:
            # Columns: araid, popid, araseq, popseq, rmsd
            cols = line.split('\t')
            if cols[0][4:-4] == ara_id:
                if pop_id == "": # Found poplar match
                    return (cols[0][4:-4], cols[1][4:-4], cols[2], cols[3])
                elif pop_id == cols[1][4:-4]: # Poplar valid pair
                    return (cols[0][4:-4], cols[1][4:-4], cols[2], cols[3])
                else: # Poplar invalid
                    return None
        return None # Ara not matched         


def load_p_snp_data(id: str, spe: str, shuffle: str = "struct"):
    """
    Load the probability of SNP significance at each resude for the given protein.
    spe is either "ara" or "pop".
    shuffle is either struct or seq, for shuffle approach.
    If invalid id, return None.
    """
    # Select appropriate file
    if spe == "ara":
        if shuffle == "struct":
            p_snps_file = ARA_STRUCT_P_SNP
        elif shuffle == "seq":
            p_snps_file = ARA_SEQ_P_SNP
        else:
            return None
    elif spe == "pop":
        if shuffle == "struct":
            p_snps_file = POP_STRUCT_P_SNP
        elif shuffle == "seq":
            p_snps_file = POP_SEQ_P_SNP
        else:
            return None
    else: 
        return None

    # Load data from file
    with open(p_snps_file, 'r') as f_p_snps:
        for line in f_p_snps:
            if line.startswith(id):
                return [float(p) for p in line.split('\t')[1].split(',')]
    return None


def mark_significant(null_probs: List[float], p: float) -> List[bool]:
    """
    Mark residues with p-significant SNPs.
    """
    return [(prob >= p) for prob in null_probs]


def match_residues(aln: Tuple[str, str]) -> Dict[int, int]:
    """
    For each index in the first protein which aligns with a residue in the 
    second protein (not a gap), provide the corresponding index.
    """
    matchings = {}
    curr_prot1 = 1
    curr_prot2 = 1
    for i in range(len(aln[0])):
        if (aln[0][i] != '-' and aln[1][i] != '-'):
            matchings[curr_prot1] = curr_prot2 
        if aln[0][i] != '-':
            curr_prot1 += 1
        if aln[1][i] != '-':
            curr_prot2 += 1
    return matchings


def significant_in_both(sig1: List[bool], sig2: List[bool], 
                        aln_matching: Dict[int, int]) -> \
                            Tuple[List[bool], List[bool]]:
    """
    For each aligned pair of residues, mark it as significant if both residues
    are individually marked as significant. 
    Returns a significance list for both proteins.
    """
    # Create significance array for overlap, initialize to false
    both_sig1 = [False] * len(sig1)
    both_sig2 = [False] * len(sig2)
    for i in aln_matching: # Only consider aligned residues
        if sig1[i - 1] and sig2[aln_matching[i] - 1]:
            both_sig1[i - 1] = True
            both_sig2[aln_matching[i] - 1] = True
    return (both_sig1, both_sig2)


def get_sig_index(sig: List[bool]) -> List[int]:
    """
    Return the 1-based indexes marked as significant (true in input list).
    """
    return [(i + 1) for i in range(len(sig)) if sig[i]]


# Find hotspot clusters
def cluster_components(hotspots: List[int], 
                       neighbours: Dict[int, Tuple[int]]) -> List[List[int]]:
    """
    Determine clusters of hotspots residues, using DFS to find connected 
    components (in the neighbourhood graph) as a cluster. 
    """
    clusters = []
    # Track explored residues, and only explore hotspot residues
    # explored and residue_fronter is 0-indexed
    # neighbors and clusters is 1-indexed.
    explored = [not hotspot for hotspot in hotspots]
    residue_frontier = []
    for i in range(len(hotspots)): # O-indexed i
        if not explored[i]:
            residue_frontier.append(i) # Expand: add to frontier, set explored
            explored[i] = True
            curr_cluster = []
            while len(residue_frontier) > 0:
                curr_res = residue_frontier.pop()
                curr_cluster.append(curr_res + 1) # Add to cluster
                for neighbour in neighbours[i + 1]: # Push neighbours
                    if not explored[neighbour - 1]:
                        residue_frontier.append(neighbour - 1)
                        explored[neighbour - 1] = True
            clusters.append(curr_cluster) # Save component on DFS finish
    return clusters

