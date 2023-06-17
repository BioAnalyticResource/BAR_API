class HotspotUtils:
    # Files with probabilities of SNP significance based on shuffles
    P_SNP_DIR = "/home/ihazelwood/BCB330-hotspot-data"
    ARA_STRUCT_P_SNP = P_SNP_DIR + "/ara_struct_10_0.1_10000.tsv"
    POP_STRUCT_P_SNP = P_SNP_DIR + "/pop_struct_10_0.1_10000.tsv"
    ARA_SEQ_P_SNP = P_SNP_DIR + "/ara_seq_3_0.1_10000.tsv"
    POP_SEQ_P_SNP = P_SNP_DIR + "/pop_seq_3_0.1_10000.tsv"

    # File with analyzed homologue pairs
    HOMOLOGUE_DIR = "/home/ihazelwood/BCB330-Homologues"
    ARA_POP_HOMOLOGUE = HOMOLOGUE_DIR + "/ara-pop3.0-all-valid.tsv"

    @staticmethod
    def verify_ara_pop_homologue(ara_id, pop_id):
        """If both Arabidopsis and Poplar IDs are given, verifies they are a
        homologous pair. If only only one is given and the other is None
        find the matching homologous ID. Returns the IDs and their sequences

        :param ara_id: str of TAIR10 gene ID, or None
        :param pop_id: str of Pop v3.0 gene ID, or None
        :returns: Tuple of IDs and sequences, or None if invalid IDs
        :rtype: Tuple[str, str, str, str] or None

        """
        if ara_id is None and pop_id is None:  # Both invalid inputs
            return None
        with open(HotspotUtils.ARA_POP_HOMOLOGUE, "r") as f_ara_pop_homologue:
            for line in f_ara_pop_homologue:
                # Columns: araid, popid, araseq, popseq, rmsd
                cols = line.split("\t")
                if cols[0][4:-4].upper() == ara_id and cols[1][4:-4].upper() == pop_id:  # Both ID match
                    return cols[0][4:-4].upper(), cols[1][4:-4].upper(), cols[2], cols[3]
                if cols[0][4:-4].upper() == ara_id and pop_id is None:  # Ara ID match, fill Pop
                    return cols[0][4:-4].upper(), cols[1][4:-4].upper(), cols[2], cols[3]
                if cols[1][4:-4].upper() == pop_id and ara_id is None:  # Pop ID match, fill Ara
                    return cols[0][4:-4].upper(), cols[1][4:-4].upper(), cols[2], cols[3]
            return None  # No match

    @staticmethod
    def load_p_snp_data(id, spe, shuffle="struct"):
        """Load the probability of SNP significance at each residue of the given
        protein from the cache file.

        :param id: str of TAIR10 or Pop v3.0 gene ID
        :param spe: Either "ara" or "pop" based on id species
        :param shuffle: Either "struct" or "seq" for significance method.
            Defaults to "struct"
        :returns: List of significance scores at residue positions,
            or None if invalid ID.
        :rtype: List[float] or None

        """
        # Select appropriate file
        if spe == "ara":
            if shuffle == "struct":
                p_snps_file = HotspotUtils.ARA_STRUCT_P_SNP
            elif shuffle == "seq":
                p_snps_file = HotspotUtils.ARA_SEQ_P_SNP
            else:
                return None
        elif spe == "pop":
            if shuffle == "struct":
                p_snps_file = HotspotUtils.POP_STRUCT_P_SNP
            elif shuffle == "seq":
                p_snps_file = HotspotUtils.POP_SEQ_P_SNP
            else:
                return None
        else:
            return None

        # Load data from file
        with open(p_snps_file, "r") as f_p_snps:
            for line in f_p_snps:
                if line.upper().startswith(id):
                    return [float(p) for p in line.split("\t")[1].split(",")]
        return None

    @staticmethod
    def mark_significant(null_probs, p):
        """Mark residues with p-significant SNPs.

        :param null_probs: List of significance scores at residue positions.
        :param p: p-value for significance
        :returns: Boolean list of residues significant at given p-value.
        :rtype: List[bool]

        """
        return [(prob >= p) for prob in null_probs]

    @staticmethod
    def match_residues(aln):
        """For each index in the first protein which aligns with a residue in the
        second protein (not a gap), provide the aligned index in the second protein.

        :param aln: Tuple of Arabidopsis and Poplar protein sequences
        :returns: Dict from index in first protein to index in second protein
        :rtype: Dict[int, int]
        """
        matching = {}
        curr_prot1 = 1  # Current index in first protein
        curr_prot2 = 1  # Current index in second protein
        # Iterate over all positions in the proteins
        for i in range(len(aln[0])):
            # If both not gaps, match the indices
            if aln[0][i] != "-" and aln[1][i] != "-":
                matching[curr_prot1] = curr_prot2
            # If the position in the first protein is not a gap, increment index
            if aln[0][i] != "-":
                curr_prot1 += 1
            # If the position in the second protein is not a gap, increment index
            if aln[1][i] != "-":
                curr_prot2 += 1
        return matching

    @staticmethod
    def significant_in_both(sig1, sig2, aln_matching):
        """Mark a residue as significant in both if it aligns with a residue
        in the other protein and those residues are both marked significant.

        :param sig1: Boolean list of significant residues in protein 1.
        :param sig2: Boolean list of significant residues in protein 2.
        :param aln_matching: Dictionary of aligned indices from protein 1 to 2.
        :returns: Two Boolean lists of significant residues in both proteins
        :rtype: List[bool], List[bool]
        """
        # Create significance array for overlap, initialize to false
        both_sig1 = [False] * len(sig1)
        both_sig2 = [False] * len(sig2)
        # For each aligned index in protein 1
        for i in aln_matching:
            # If that reside and the counterpart in protein 2 are both significant,
            # mark those residues as significant in both.
            # Dictionary stores 1-indexed positions, list is 0-indexed
            if sig1[i - 1] and sig2[aln_matching[i] - 1]:
                both_sig1[i - 1] = True
                both_sig2[aln_matching[i] - 1] = True
        return both_sig1, both_sig2

    @staticmethod
    def get_sig_index(sig):
        """Return the 1-based indexes marked as significant (true in input list).

        :param sig: Boolean list of significant residues.
        :returns: List of 1-indexed positions marked significant.
        :rtype: List[int]
        """
        return [(i + 1) for i in range(len(sig)) if sig[i]]

    @staticmethod
    def cluster_components(hotspots, neighbours):
        """Determine clusters of hotspots residues. Clusters are connected
        components in the neighbourhood graph, found using DFS.

        BFS algorithm: Initialize a frontier of positions to explore.
        Add the starting residue to the frontier. While the frontier is not empty,
        remove the last item from the frontier and add its significant non-explored
        residues to the frontier.

        :param hotspots: List of hotspot indices
        :param neighbours: Adjacency list of neighbourhood graph, mapping each index
            to a tuple of neighbouring indices
        :returns: List of clusters, each a list of indices
        :rtype: List[List[int]]
        """
        clusters = []
        # Track explored residues. Set non-hotspot residues to explored, so the
        # algorithm will not visit them.

        explored = [not hotspot for hotspot in hotspots]
        residue_frontier = []
        # explored and residue_fronter is 0-indexed
        # neighbors and clusters is 1-indexed.
        for i in range(len(hotspots)):  # O-indexed i
            if not explored[i]:
                residue_frontier.append(i)  # Expand: add to frontier, set explored
                explored[i] = True
                curr_cluster = []
                while len(residue_frontier) > 0:
                    curr_res = residue_frontier.pop()
                    curr_cluster.append(curr_res + 1)  # Add to cluster
                    for neighbour in neighbours[i + 1]:  # Push neighbours
                        if not explored[neighbour - 1]:
                            residue_frontier.append(neighbour - 1)
                            explored[neighbour - 1] = True
                clusters.append(curr_cluster)  # Save component on DFS finish
        return clusters
