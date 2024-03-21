from abc import ABC, abstractmethod
from typing import List
import os
import re
import subprocess
import math
import sys
import json
import datetime

HEX_BIN_PATH = '/usr/local/bin/hex/bin/hex'


class Receptor(ABC):
    """An abstract class that represents a receptor

    --- Attributes ---
    name (str): the name of the receptor
    file_path (str): the relative path to the receptors pdb file
    """
    @abstractmethod
    def __init__(self, name: str, file_path: str):
        self.name = name
        self.file_path = file_path


class MonomerReceptor(Receptor):
    """ A class that represents a receptor that is a monomer, meaning it consists
    of only one chain.

    --- Attributes ---
    name (str): the name of the receptor
    file_path (str): the relative path to the receptors pdb file
    """
    name: str
    file_path: str

    def __init__(self, name, file_path):
        super().__init__(name, file_path)


class ComplexReceptor(Receptor):
    """ A class that represents a receptor that is a complex, meaning it consists
    of more than one chain.

    --- Attributes ---
    name (str): the name of the receptor
    file_path (str): the relative path to the receptors pdb file
    monomer_list (List[str]): the list of monomers that make up the complex
    line_numbers (List[List[int]]): the list of line numbers that separate the monomers, e.g. [[100,200],[300,500]]
    """
    def __init__(self, name: str, file_path: str, monomers_list: List[str]):
        super().__init__(name, file_path)
        self.monomers_list = monomers_list
        self.line_numbers = self.separate_monomers()

    def separate_monomers(self):
        """Returns a list of lists, where each sublist contains the line
        numbers of the start and end of a monomer.
        For example, receptor X has 3 chains in this order: A, B, C.
        The method will return [[1, 6], [7, 9], [10, 15]].
        """
        line_numbers = []
        file = open(self.file_path, "r")
        line = file.readline()
        prev = None
        curr_line = 0
        while line != '':
            # the first line of the first monomer
            if line[:12] == "ATOM      1 ":
                prev = curr_line - 1
            # the last line of a monomer
            elif line[:3] == 'TER':
                # line_numbers.append(curr_line)
                line_numbers.append([prev + 1, curr_line])
                prev = curr_line
            curr_line += 1
            line = file.readline()

        return line_numbers


class Ligand:
    """A class that represents a ligand.

    --- Attributes ---
    name (str): the name of the receptor
    file_path (str): the relative path to the receptors pdb file
    """
    def __init__(self, name: str, file_path: str):
        self.name = name
        self.file_path = file_path


class Docking(ABC):
    """An abstract class that represents the docking between a receptor and a
    ligand.

    --- Attributes ---
    receptor (Receptor): a Receptor object that represents a receptor
    ligand (Ligand): a Ligand object that represents a ligand
    results_path (str): the file path to where the results are stored
    ligand_reserved_list (List[int]): a list of line numbers, one for each solution,
    the indicates where the "Docked ligand" section begins
    """

    @abstractmethod
    def __init__(self, receptor: Receptor, ligand: Ligand, results_path: str):
        self.receptor = receptor
        self.ligand = ligand
        self.results_path = results_path
        self.ligand_reserved_list = []

    def hex_docking(self):
        """Run hex docking using the command line.
        """
        hex_output_file = open(self.results_path + 'hex_output.txt', "w")

    # Function to call Hex, including hard coded settings

    # max_docking_solutions set at 5 for testing
        hex_command = """ open_receptor  """ + self.receptor.file_path + """
                open_ligand  """ + self.ligand.file_path + """
                docking_correlation 1
                docking_score_threshold 0
                max_docking_solutions 25
                docking_receptor_stepsize 5.50
                docking_ligand_stepsize 5.50
                docking_alpha_stepsize 2.80
                docking_main_scan 16
                receptor_origin C-825:VAL-O
                commit_edits
                activate_docking
                save_range 1 100 """ \
        + self.results_path + """ %s pdb""" % (self.receptor.name + '_' + self.ligand.name)
        subprocess.Popen(HEX_BIN_PATH,
                         stdin=subprocess.PIPE,
                         stderr=subprocess.STDOUT,
                         stdout=hex_output_file).communicate(bytes(hex_command.encode('utf-8')))
        hex_output_file.close()
        ct = datetime.datetime.now()
        print("current time:-", ct)
        print("Hex docking completed")

    def crte_ligand_reserved_attr(self):
        """This function populates the Docking instance's ligand_reserved_list attribute
        with a list of line numbers. Each line number is where the Docked Ligand section
        begins for each result.
        For example, [1500, 1499, 1500] means that there are three solutions. In the first
        solution, the "Docked Ligand" section begins at line 1500. In the second solution,
        it begins at line 1499, and so on ...
        """
        line_numbers = []
        for filename in os.listdir(self.results_path):
            if filename[-3:] == 'pdb':
                file = open(self.results_path + filename, "r")
                lines = file.readlines()
                for i in range(len(lines)):
                    if "Docked ligand coordinates..." in lines[i]:
                        line_numbers.append(i)
                        break
        self.ligand_reserved_list = line_numbers

    def parse_hex_output(self):
        """Returns a dictionary where the key is the cluster number and the
        value is a list of solution numbers. One of the keys is "num_soln",
        where its value is the total number of solutions.
        For example: {num_soln : 5, 1 : [2, 4], 2 : [1, 3, 5]}
        """
        hex_output = open(self.results_path + 'hex_output.txt', "r")
        lines = hex_output.readlines()
        # line number where the clustering starts and ends
        result_start = 0
        result_end = 0
        for i in range(len(lines)):
            splitted_line = lines[i].split(" ")
            if len(splitted_line) > 8 and splitted_line[0] == "Clst":
                result_start = i + 2
            if len(splitted_line) > 2 and "save_range" in splitted_line:
                result_end = i - 2
        clustering_lines = lines[result_start:result_end]
        clusters = {}
        clusters["num_soln"] = len(clustering_lines)
        for line in clustering_lines:
            cleaned_line = line.strip().split(" ")
            res = []
            # only keep non-blank items in line
            for ch in cleaned_line:
                if ch != "":
                    res.append(ch)
            clst = int(res[0])
            sln = int(res[1])
            if clst not in clusters:
                clusters[clst] = [sln]
            else:
                clusters[clst].append(sln)
        return clusters

    def result_dict_generator(self, monomer_number, threshold):
        """Return a dictionary where each key is a residue and each value is
        the energy. The distance between each residue in the monomer and each
        atom in the ligand is calculated, and only residues with distances
        below the threshold are included.
        """
        receptor_file = open(self.receptor.file_path, "r")

        if monomer_number != -1:  # if -1, go to monomer logic
            # get the start and end line numbers of the monomer in the receptor pdb
            monomer_start = self.receptor.line_numbers[monomer_number][0]
            monomer_end = self.receptor.line_numbers[monomer_number][1]

            # get the lines for that receptor only
            receptor_file_lines = receptor_file.readlines()[monomer_start:monomer_end]
        else:  # Monomer logic
            receptor_file_lines = receptor_file.readlines()

        # Store every receptor's atom coordinates information as a nested
        # dictionary called 'reference'
        reference = {}
        for line in receptor_file_lines:
            splitted_line = line.split()
            if line[0:4] == 'ATOM':

                # check if chain name and residue are in the same column, e.g. A1000
                if re.search(r'\d', splitted_line[4]) is None:
                    residue = splitted_line[5]
                else:
                    residue = splitted_line[4][1:]

                # Get the coordinates by regex matching, since they are not
                # always separated by a space
                pattern = r"[-+]?\d+\.\d+"
                stripped_coords = line[28:54].strip()
                # Find all matches in the input string
                matches = re.findall(pattern, stripped_coords)
                # Convert the matches to floats
                coord = [float(match) for match in matches]

                if int(residue) in reference:
                    reference[int(residue)][int(splitted_line[1])] = tuple(coord)
                else:
                    reference[int(residue)] = {int(splitted_line[1]) : tuple(coord)}

        # here, the structure of the reference dict is is {residue: {atom_num :(x, y, z)}},

        # The energy for each reference element will be stored in dictionary 'ac'
        ac = {}
        result_list = []
        for filename in os.listdir(self.results_path):
            if filename[-3:] == 'pdb':
                result_list.append(filename)

        lowest_en = None  # to keep track of lowest energy
        all_residue_list = []

        cluster_dict = self.parse_hex_output()

        for i in range(len(result_list)):
            energy = ''

            # get the ligand_reserved section of the result file
            file = open(self.results_path + result_list[i], 'r')
            ligand_reserved_start = self.ligand_reserved_list[i]
            ligand_reserved_section = file.readlines()[ligand_reserved_start:]

            # go through ligand reserved section to calculate energy
            residue_set = set()
            coor = []
            for line in ligand_reserved_section:
                if 'REMARK' in line.split(' ') and 'Energy' in line.split(' '):
                    cluster_size = len(cluster_dict[i + 1])
                    total_solutions = cluster_dict['num_soln']

                    # energy is weighed according to the number of solutions
                    # in that cluster
                    energy = ((float(line.split(' ')[6][:-1]))/total_solutions) * cluster_size

                    # record values if lowest energy
                    if lowest_en is None or energy < lowest_en:
                        lowest_en = energy
                elif line[:4] == 'ATOM':
                    # coordinates of one atom
                    coordinates = tuple(map(float, filter(None, line.split()[6:9])))
                    coor.append(coordinates)
            # each atom's coordinates is now stored in the list coordinates

            residue_set = set()
            for res in reference.keys():  # for each amino acid in the receptor file:
                distances = []

                for atom in coor:  # for each atom of the ligand
                    for aa in reference[res].keys():  # for each atom of that amino acid
                        # check if the distance between atoms of the ligands
                        # and of the amino acid are lower than chosen threshold (5)
                        distance = math.sqrt(sum([(reference[res][aa][0] - atom[0]) ** 2,
                                                  (reference[res][aa][1] - atom[1]) ** 2,
                                                  (reference[res][aa][2] - atom[2]) ** 2]))

                        distances.append(distance)

                # if at least one of the distances is lower than the threshold, otherwise skip
                if all(d >= threshold for d in distances):
                    continue
                else:
                    # adding energy (previosly divided by the number of results)
                    # if found multiple times, we would get an average
                    if res in ac.keys():
                        ac[res] += energy
                    else:
                        ac[res] = energy

                # Store the resi number into set
                residue_set.add(res)

            all_residue_list.append(residue_set)

        return ac

    @abstractmethod
    def best_result(self):
        pass

    @abstractmethod
    def crte_receptor_dict(self):
        pass

    @abstractmethod
    def normalize_results(self, threshold):
        pass


class MonomerDocking(Docking):
    """A class the represents a docking between a monomer receptor and a monomer.

    --- Attributes ---
    receptor (MonomerReceptor): a Receptor object that represents a monomer receptor
    ligand (Ligand): a Ligand object that represents a ligand
    results_path (str): the file path to where the results are stored
    ligand_reserved_list (List[int]): a list of line numbers, one for each solution,
        the indicates where the "Docked ligand" section begins
    """

    def __init__(self, receptor: MonomerReceptor, ligand: Ligand, results_path: str):
        super().__init__(receptor, ligand, results_path)

    def best_result(self):
        pass

    def crte_receptor_dict(self, threshold):
        """"Return a dictionary that contains the residue-energy
        dictionary of the monomer. This is not necessary, but maintains
        consistency between monomer and complex receptor dictionaries.
        """
        receptor_res = {}
        res_dict = self.result_dict_generator(-1, threshold)
        ligand_res = {}
        ligand_res[self.ligand.name] = res_dict
        receptor_res[self.receptor.name] = ligand_res
        return receptor_res

    def normalize_results(self, threshold):
        """Return normalized residue-energy dictionaries for the
        receptor.
        """
        results_dict = self.crte_receptor_dict(threshold)
        receptor_key = list(results_dict.keys())[0]
        ligand_key = list(results_dict[receptor_key].keys())[0]

        inside_dict = results_dict[receptor_key][ligand_key]
        max_energy = None
        min_energy = None

        # To eliminate empty dictionaries that might cause division errors below
        # normalized_mon_dicitonary calculations
        if inside_dict != {}:
            min_energy = min(inside_dict.values())
            max_energy = max(inside_dict.values())

        all_normalized_results = {}

        normalized_mon_dict = {}
        normalized_mon_dict[receptor_key] = {}
        normalized_mon_dict[receptor_key][ligand_key] = {}

        # prevent substraction of equal values or values that doesn't make any sense
        # in terms of accuracy
        if min_energy == max_energy:
            for k, v in inside_dict.items():
                normalized_mon_dict[receptor_key][ligand_key][k] = 1
        else:
            for k, v in inside_dict.items():
                normalized_value = (v - min_energy) / (max_energy - min_energy)
                normalized_mon_dict[receptor_key][ligand_key][k] = normalized_value
        all_normalized_results.update(normalized_mon_dict)
        return all_normalized_results


class ComplexDocking(Docking):
    """A class that represents a docking between a complex receptor and a ligand.

        --- Attributes ---
    receptor (ComplexReceptor): a Receptor object that represents a monomer receptor
    ligand (Ligand): a Ligand object that represents a ligand
    results_path (str): the file path to where the results are stored
    ligand_reserved (List[int]): a list of line numbers, one for each solution,
        which indicates where the "Docked ligand" section begins
    split_results (List[List[Tuple[int]]]): a list where each sublist is a chain,
        which contains a list of tuples. Each tuple indicates the line numbers
        of the start and end of that chain in a results file.
    """

    def __init__(self, receptor: ComplexReceptor, ligand: Ligand, results_path: str):
        super().__init__(receptor, ligand, results_path)
        self.split_results = []

    def separate_results(self):
        """For each solution, record the start and end line number (0-based) of
        each chain. Then, populate self.split_results with the final list.

        Each sublist represents one solution file. Each tuple in the sublist
        contains the start and end of one chain. The order of the tuples in
        the sublist is the same as the order of the monomers in the receptor's
        monomers_list.
        """
        results_files = os.listdir(self.results_path)

        # for each solution
        for file in results_files:
            if file[-3:] != "pdb":
                break
            result_file = open(self.results_path + file)

            # this list contains indices of the start and end of each chain
            line_numbers = []
            line = result_file.readline()
            curr_line = 0
            prev = None
            while line != '':
                # the start of the first chain
                if line.split()[0] == "ATOM" and line.split()[1] == "1":
                    # if line.startswith('ATOM      1  '):
                    prev = curr_line - 1

                # the end of a chain
                elif line[0:3] == 'TER':
                    line_numbers.append([prev + 1, curr_line])
                    prev = curr_line

                # read next line
                line = result_file.readline()
                curr_line += 1

        # populate split_results attribute
        self.split_results = line_numbers

    def best_result(self):
        pass

    def crte_receptor_dict(self, threshold):
        all_monomers = []
        for i in range(len(self.receptor.monomers_list)):
            ligand_res = {}
            res_dict = self.result_dict_generator(i, threshold)
            ligand_res[self.ligand.name] = res_dict
            all_monomers.append({self.receptor.name + '_' + self.receptor.monomers_list[i] : ligand_res})
        return all_monomers

    def normalize_results(self, threshold):
        min_values = []
        max_values = []
        abs_max = None
        abs_min = None
        all_monomers_dict = self.crte_receptor_dict(threshold)
        for i in range(len(all_monomers_dict)):
            monomer_dict = all_monomers_dict[i]
            monomer_key = list(monomer_dict.keys())[0]
            ligand_key = list(monomer_dict[monomer_key].keys())[0]

            inside_dict = monomer_dict[monomer_key][ligand_key]

            # To eliminate empty dictionaries that might cause division errors below
            # normalized_mon_dicitonary calculations
            if inside_dict == {}:
                continue
            else:
                mini = min(inside_dict.values())
                maxi = max(inside_dict.values())

                min_values.append(mini)
                max_values.append(maxi)

                abs_max = max(max_values)
                abs_min = min(min_values)

                print("This is the maximum value: ", abs_max, file=sys.stderr)
                print("This is the minimum value: ", abs_min, file=sys.stderr)

        # Now looping through every monomer, and calculating every residue energy to be
        # normalized by using absolute minimum and maximum.
        all_normalized_results = {}
        for i in range(len(all_monomers_dict)):
            monomer_dict = all_monomers_dict[i]
            monomer_key = list(monomer_dict.keys())[0]
            ligand_key = list(monomer_dict[monomer_key].keys())[0]

            inside_dict = monomer_dict[monomer_key][ligand_key]

            normalized_mon_dict = {}
            normalized_mon_dict[monomer_key] = {}
            normalized_mon_dict[monomer_key][ligand_key] = {}

            # prevent substraction of equal values or values that doesn't make any sense
            # in terms of accuracy
            if abs_min == abs_max:
                for k, v in inside_dict.items():
                    normalized_mon_dict[monomer_key][ligand_key][k] = 1
            else:
                for k, v in inside_dict.items():
                    normalized_value = (v - abs_min) / (abs_max - abs_min)
                    normalized_mon_dict[monomer_key][ligand_key][k] = normalized_value
            all_normalized_results.update(normalized_mon_dict)
        return all_normalized_results


class Docker:
    """A class that represents the controller to create docking pairs and carry
    out the docking.
    """

    @staticmethod
    def start(receptor: str, ligand: str, docking_pdb_path: str):
        """Start the docking process and analyze results. Return the
        normalized residue-energyy dictionary.
        """
        # create docking object
        ct = datetime.datetime.now()
        ct_string = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print("Starting the docking process at {}".format(ct))
        docking = Docker.create_docking(receptor, ligand, docking_pdb_path)
        if isinstance(docking, list):
            # receptor = receptor.split('.')[0]
            # results_path = docking_pdb_path + receptor + '_' + ligand + '/'
            results_path = docking[1]
            with open(results_path + "final.json") as json_file:
                final_json = json.load(json_file)
            return final_json
        elif docking == "Receptor file not found":
            return "Receptor file not found"
        elif docking == "Ligand file not found":
            return "Ligand file not found"

        results_path = docking_pdb_path + docking.receptor.name + '_' + ligand + '/'

        # create folder to store docking results
        os.makedirs(results_path)

        docking.hex_docking()
        if isinstance(docking, ComplexDocking):
            docking.separate_results()
        docking.crte_ligand_reserved_attr()
        normalized_results = docking.normalize_results(5)
        final_json = {}
        final_json["energies_json"] = normalized_results
        final_json["path"] = '//bar.utoronto.ca/HEX_RESULTS/' + docking.receptor.name + '_' + ligand + '/'
        final_json["best_HEX_result_path"] = final_json["path"] + docking.receptor.name + '_' + ligand + '0001.pdb'
        final_json["date"] = ct_string
        new_json = docking.results_path + "final.json"
        with open(new_json, 'w') as file:
            file.write(json.dumps(final_json))
        print("current time:-", datetime.datetime.now())
        return final_json

    def create_receptor(receptor_name: str, receptor_file_path: str):
        """Return a new receptor with the name receptor_name, by parsing
        the file at recepter_file_path.
        """
        with open(receptor_file_path) as f:
            is_monomer = True
            for line in f.readlines():
                if re.match(r'COMPND   \d CHAIN: \w, \w*', line) is not None:
                    is_monomer = False
                    # if the receptor would be a monomer the regex would be
                    # r'COMPND   \d CHAIN: \w;'

                    # To make a list of the monomers' labels
                    print(receptor_name + ' identified as a protein complex')
                    if line[11:16] == 'CHAIN':
                        monomers_list = line.split(': ')[-1].split(', ')
                        # The COMPND line ends with ';' therefore it needs to be
                        # removed from the last label
                        monomers_list[-1] = monomers_list[-1][0]
                        new_receptor = ComplexReceptor(receptor_name,
                                                       receptor_file_path,
                                                       monomers_list)
                        return new_receptor
                    print("Unknown pdb structure, need further investigation")

            if is_monomer:
                new_receptor = MonomerReceptor(receptor_name,
                                               receptor_file_path)
                return new_receptor

    def create_docking(receptor_name: str, ligand_name: str, docking_pdb_path: str):
        """Return a docking pair, which contains a Receptor and a Ligand, as
        specified by receptor_name and ligand_name, respectively.
        """
        # find receptor file and create receptor object
        receptor_folder = "/DATA/AF2-pdbs/Arabidopsis/AF2_Ath_PDBs_FAs_renamed/"

        # check that the docking combination has not been run before
        # results_path = docking_pdb_path + 'RESULTS/' + receptor_name + '_' + ligand_name + '/'
        if '.' in receptor_name:
            receptor_name = receptor_name[:receptor_name.index('.')]
        command = ['ls ' + 'AF2_' + receptor_name + '*.pdb']
        completed_process = subprocess.run(command,
                                       shell = True, 
                                       cwd = receptor_folder,
                                       stdout = subprocess.PIPE, 
                                       stderr = subprocess.PIPE, 
                                       text = True)
        if completed_process.returncode != 0:
            print("Receptor file not found")
            # return "Receptor file not found"
        receptor_file = completed_process.stdout[:-1]
        
        receptor_file_path = receptor_folder + receptor_file
        receptor_name = receptor_file[4:(receptor_file.index('.') + 2)]
        
        results_path = docking_pdb_path + receptor_name + '_' + ligand_name + '/'
        print(results_path)

        if os.path.exists(results_path):
            print("The docking between {0} and {1} has already been done.".format(receptor_name,
                                                                                  ligand_name))
            return [None, results_path]
        receptor = Docker.create_receptor(receptor_name, receptor_file_path)

        # for receptor_file in os.listdir(receptor_folder):
        #     if receptor_file[0] != '.' and receptor_file[-4:] == '.pdb' and \
        #             (receptor_name in receptor_file):
        #         receptor_file_path = receptor_folder + receptor_file
        #         receptor = Docker.create_receptor(receptor_name, receptor_file_path)

        # find ligand file and create ligand object
        ligand_folder = '/DATA/HEX_API/HEX_SELECTED_LIGANDS/'
        ligand_file_found = False

        for ligand_file in os.listdir(ligand_folder):
            if ligand_file[0] != '.' and len(ligand_file.split('.')) == 2 and \
                ligand_file.split('.')[1] == 'sdf' and \
                    ligand_file[:-4].lower() == ligand_name.lower():
                ligand_file_found = True
                ligand_file_path = ligand_folder + '/' + ligand_file
                ligand = Ligand(ligand_name, ligand_file_path)
            
        if not ligand_file_found:
            return "Ligand file not found"

        # receptor and ligand objects are created and ready for docking
        if isinstance(receptor, MonomerReceptor):
            docking = MonomerDocking(receptor, ligand, results_path)
        else:
            docking = ComplexDocking(receptor, ligand, results_path)
        return docking


class SDFMapping:
    """
    A class for mapping SDF names to their file names in the BAR.
    """

    def get_substance_name(self, filename: str, folder_path: str):
        """Parse and return the names of a substance from a .sdf file. It
        requires the line "> <PUBCHEM_SUBSTANCE_SYNONYM>" to be present
        in the file.
        """
        file = open(folder_path + filename, "r")
        line = file.readline().strip()
        if line == "":
            return None
        while line != "> <PUBCHEM_SUBSTANCE_SYNONYM>" and line != "$$$$":
            line = file.readline().strip()
        # right now, line == "> <PUBCHEM_SUBSTANCE_SYNONYM>" or line is empty
        if line == "$$$$":
            return None
        line = file.readline().strip()
        names = []
        while line != "":
            if len(line) > 0 and line[0] == ">":
                break
            names.append(line)
            line = file.readline().strip()
        return names

    @staticmethod
    def create_mapping_filtered(folder_path: str, results_path: str):
        """Create a json file that maps the name of the ligand to the
        file name, for example: {"bld": "115196_bld.sdf"}.

        It only works for sdf files that are formatted like the
        example shown above.

        folder_path: where the sdf files are stored
        results_path: where the json file should be created
        """
        mapped_sdf = []
        sdf_files = os.listdir(folder_path)
        for file in sdf_files:
            if file[0] != "." and file[-4:] == ".sdf":
                name = file[file.index("_") + 1:-4]
                mapped_sdf.append({'value': file, 'text': name})
                # mapped_sdf[name] = file
        json_file = results_path + "sdf_mapping_filtered.json"
        with open(json_file, 'w') as file:
            file.write(json.dumps(mapped_sdf))
        return mapped_sdf

    def create_mapping_unfiltered(self, folder_path: str, results_path: str):
        """Create a json file that maps the names of the ligand to the
        file name, for example: {"122234": "Corn sugar gum,Xanthan gum"}.

        It only works for sdf files that contain this line:
        "> <PUBCHEM_SUBSTANCE_SYNONYM>".

        folder_path: where the sdf files are stored
        results_path: where the json file should be created
        """
        mapped_sdf = {}
        sdf_files = os.listdir(folder_path)
        for file in sdf_files:
            if file[0] != "." and file[-4:] == ".sdf":
                names = self.get_substance_name(file, folder_path)
                sdf_number = file.split(".")[0]
                mapped_sdf[sdf_number] = ",".join(names)
        json_file = results_path + "sdf_mapping_unfiltered.json"
        with open(json_file, 'w') as file:
            file.write(json.dumps(mapped_sdf))
        return mapped_sdf

# if __name__ == "__main__":
#     Docker.start("AT3G22150", "801_Auxin", "/DATA/HEX_API/RESULTS/")