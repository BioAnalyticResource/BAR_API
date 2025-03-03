from api.utils.bar_utils import BARUtils

import tempfile
import os
import subprocess
from collections import defaultdict


class MfinderUtils:

    @staticmethod
    # Eliminates same pairs
    def uniq_with(arr, comp_func):
        unique_arr = []
        for item in arr:
            if not any(comp_func(item, unique_item) for unique_item in unique_arr):
                unique_arr.append(item)
        return unique_arr

    @staticmethod
    def is_equal(a, b):
        return a == b

    @staticmethod
    def find_key(d, value):
        return next(key for key, val in d.items() if val == value)

    # Check if JSON body data obj is an array of arrays (2d arr)
    # ex [ [ "AT1G010100", "AT5G01010" ], ["AT3G10000", "AT2G03240"]]
    # {Array<Array<string>>} input: the above arr
    @staticmethod
    def input_validation(input):
        if not isinstance(input, list):
            return "invalid JSON, not an arr"

        if len(input) == 0:
            return "arr length 0!"

        if any(len(i) != 2 for i in input):
            return "inner arr length is not of length 2!"

        if not all(isinstance(i, list) for i in input):
            return "invalid JSON, check arr members are arrs!"

        if not all(isinstance(j, str) for i in input for j in i):
            return "invalid JSON, check if inside arr members are strings!"

        if not all(BARUtils.is_arabidopsis_gene_valid(j) for i in input for j in i):
            return "Invalid gene ID contained!"

        # filter self-edges and duplicate edges (mFinder does not accept)
        return MfinderUtils.uniq_with([i for i in input if i[0] != i[1]], MfinderUtils.is_equal)

    # Some mFinders params allowed within reasonable server load. Namely mFinder takes 3 basic params: nd (non-directed network),
    # r (# of rand networks to gen), s (motif size), u (unique min), z (z-score min). The defaults are directed, 100, 3, 4, & 2
    # respectively. HOWEVER choose r of 30 for speed
    # Do a validation check on each value too!
    # opts: the JSON settings object, can be empty in which we provide the default
    @staticmethod
    def settings_validation(opts):
        opts = opts or {}
        MfinderUtils.injection_check(opts)
        settings_obj = opts.copy()
        if "nd" not in opts:
            settings_obj["nd"] = False
        elif not isinstance(opts["nd"], bool):
            return "incorrect nd setting - is it boolean?", 400

        if "r" not in opts:
            settings_obj["r"] = 50
        elif not isinstance(opts["r"], int) or opts["r"] > 150:
            return "incorrect r setting - is it a number under 151?", 400

        if "s" not in opts:
            settings_obj["s"] = 3
        elif not isinstance(opts["s"], int) or opts["s"] < 2 or opts["s"] > 4:
            return "incorrect s setting - is it a number between 2 and 4?", 400

        if "u" not in opts:
            settings_obj["u"] = 4
        elif not isinstance(opts["u"], int) or opts["u"] > 999:
            return "incorrect u setting - is it a number or below 1000?", 400

        if "z" not in opts:
            settings_obj["z"] = 2
        elif not isinstance(opts["z"], int) or opts["z"] > 99:
            return "incorrect z setting - is it a number or below 100?", 400

        return settings_obj

    # Check for injection, throw if suspiciously long command is found.
    # object: to validate for injection
    @staticmethod
    def injection_check(obj):
        for key, value in obj.items():
            if len(str(value)) > 10:
                return f"{key} settings param is too long", 400

    # Take in the filtered array of gene-id pairs (edges) and perform
    # mFinder analysis on them (create temp text files to do so)
    # Performed SYNCHRONOUSLY !!!
    @staticmethod
    def create_files_and_mfinder(input, opts_obj):

        # give read/write permissions to user but nada to anybody else
        tmpfile = tempfile.NamedTemporaryFile(mode="w+", suffix=".txt", delete=False)
        os.chmod(tmpfile.name, 0o600)

        # get a hash of IDs -> numbers for later lookup and writable string
        hash_of_ids, return_str = MfinderUtils.get_gene_id_hash_map(input)

        # write to temp file which mFinder will run/read on
        tmpfile.write(return_str)
        tmpfile.flush()

        # file_path = "/usr/src/app/mfinder/mfinder1.21_1/mfinder"

        # if os.access(file_path, os.X_OK):
        #     return (f"The file exists {tmpfile.name}")
        # else:
        #     return "The file does not exist"

        command = (
            f"/bartmp/mfinder {tmpfile.name} "
            f"-s {opts_obj['s']} "
            f"-r {opts_obj['r']} "
            f"-u {opts_obj['u']} "
            f"-z {opts_obj['z']} "
            f"{'-nd ' if opts_obj.get('nd') else ''}"
            "-omem"
        )
        subprocess.run(command, shell=True, check=True)

        with open(tmpfile.name[:-4] + "_OUT.txt", "r") as stats_file:
            mfinder_stats = stats_file.read()

        with open(tmpfile.name[:-4] + "_MEMBERS.txt", "r") as members_file:
            mfinder_members = members_file.read()

        tmpfile.close()
        print(f"Temporary file: {tmpfile.name}")
        os.remove(tmpfile.name)

        return {"hashOfIds": hash_of_ids, "mFinderStats": mfinder_stats, "mFinderMembers": mfinder_members}

    # Take an input of array of array of strings which represent edges and transform those gene IDs (unique!) to a hash table and
    # coinciding edges i.e. [["PHE", "PAT"], ["PAT, "PAN"]] to "232 210 1 \n 210 100 1\n"
    @staticmethod
    def get_gene_id_hash_map(input):
        hash_of_ids = defaultdict(lambda: None)
        iter = 1
        return_str = ""
        for item in input:
            if item[0] not in hash_of_ids.values():
                hash_of_ids[iter] = item[0]
                iter += 1
            if item[1] not in hash_of_ids.values():
                hash_of_ids[iter] = item[1]
                iter += 1
            return_str += f"{MfinderUtils.find_key(hash_of_ids, item[0])} {MfinderUtils.find_key(hash_of_ids, item[1])} 1\n"

        return hash_of_ids, return_str

    # Beautify the output file string and members file string
    @staticmethod
    def beautify_results(mfinder_res_obj):
        stats = mfinder_res_obj["mFinderStats"]
        mems = mfinder_res_obj["mFinderMembers"]
        id_map = mfinder_res_obj["hashOfIds"]
        ret_obj = {"sigMotifs": {}, "motifList": {}}

        try:
            sig_motifs_str = stats.split("[MILI]\t\n\n")[1].split("Full")[0].split("\n\n")
        # In case stats has less than 2 parts after split('[MILI]\t\n\n')[1]
        except IndexError:
            raise ValueError("Expected delimiter '[MILI]\t\n\n' or 'Full' not found in the stats string.")
        sig_motifs_str = sig_motifs_str[: len(sig_motifs_str) - 2 : 2]
        for item in sig_motifs_str:
            split_stats_for_motif_id = item.split("\t")
            ret_obj["sigMotifs"][split_stats_for_motif_id[0]] = {
                "numAppearances": split_stats_for_motif_id[1],
                "numAppearancesRand": split_stats_for_motif_id[2],
                "appearancesZScore": split_stats_for_motif_id[3],
                "pValue": split_stats_for_motif_id[4],
                "uniq": split_stats_for_motif_id[5],
                "conc": split_stats_for_motif_id[6],
            }

        subgraphs_list_str = mems.split("subgraph id = ")[1:]
        for subgraph_str in subgraphs_list_str:
            member_list_split = subgraph_str.split("\n")
            motif_mem_list = [i.rstrip("\t") for i in member_list_split[5:-2]]
            motif_mem_results = []
            for i in motif_mem_list:
                three_genes = i.split("\t")
                formatted_str = f"{id_map[int(three_genes[0])]}\t{id_map[int(three_genes[1])]}\t{id_map[int(three_genes[2])]}"  # i.e. PAT\tPAN\tEGFR
                motif_mem_results.append(formatted_str)
            ret_obj["motifList"][member_list_split[0]] = motif_mem_results

        return BARUtils.success_exit(ret_obj)
