from abc import ABC, abstractmethod
from typing import List
import os
import re
import subprocess

HEX_BIN_PATH = '/home/diennguyen/hex/bin/hex'

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
    line_numbers (List[int]): the list of line numbers that separate the monomers
    """
    def __init__(self, name: str, file_path: str, monomers_list: List[str]):
        super().__init__(name, file_path)
        self.monomers_list = monomers_list
        self.line_numbers = []

    def separate_monomers(self):
        pass

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
        hex_output_file = open(self.results_path + 'hex_output.txt', "w")

    # Function to call Hex, including hard coded settings

    # max_docking_solutions set at 5 for testing
        code = """ open_receptor  """ + self.receptor.file_path + """
    open_ligand  """ + self.ligand.file_path + """
    docking_correlation 1
    docking_score_threshold 0
    max_docking_solutions 5
    docking_receptor_stepsize 5.50
    docking_ligand_stepsize 5.50
    docking_alpha_stepsize 2.80
    docking_main_scan 16
    receptor_origin C-825:VAL-O
    commit_edits
    activate_docking
    save_range 1 100 """ + self.results_path + """ %s pdb""" % (self.receptor.name + '_' + self.ligand.name)
        subprocess.Popen(HEX_BIN_PATH, 
                         stdin=subprocess.PIPE,
                         stderr=subprocess.STDOUT, 
                         stdout=hex_output_file).communicate(bytes(code.encode('utf-8')))
        hex_output_file.close()
        print("Hex docking completed")

    @abstractmethod
    def ligand_reserved(self):
        pass

    @abstractmethod
    def result_dict_generator(self):
        pass

    @abstractmethod
    def best_result(self):
        pass

    @abstractmethod
    def color_surfaces(self):
        pass

class MonomerDocking(Docking):
    """A class the represents a docking between a monomer receptor and a monomer.
    
    --- Attributes ---
    receptor (MonomerReceptor): a Receptor object that represents a monomer receptor
    ligand (Ligand): a Ligand object that represents a ligand
    results_path (str): the file path to where the results are stored
    ligand_reserved (List[int]): a list of line numbers, one for each solution,
        the indicates where the "Docked ligand" section begins
    """

    def __init__(self, receptor: MonomerReceptor, ligand: Ligand, results_path: str):
        super().__init__(receptor, ligand, results_path)

    def ligand_reserved(self):
        pass

    def result_dict_generator(self):
        pass

    def best_result(self):
        pass

    def color_surfaces(self):
        pass

class ComplexDocking(Docking):
    """A class that represents a docking between a complex receptor and a ligand.
    
        --- Attributes ---
    receptor (MonomerReceptor): a Receptor object that represents a monomer receptor
    ligand (Ligand): a Ligand object that represents a ligand
    results_path (str): the file path to where the results are stored
    ligand_reserved (List[int]): a list of line numbers, one for each solution,
        the indicates where the "Docked ligand" section begins
    split_results (List[List[Tuple[int]]]): a list where each sublist is a chain,
        which contains a list of tuples. Each tuple indicates the line numbers
        of the start and end of that chain in a results file.
    """

    def __init__(self, receptor: ComplexReceptor, ligand: Ligand, results_path: str):
        super().__init__(receptor, ligand, results_path)
        split_results = []

    def separate_results(self):
        pass

    def ligand_reserved(self):
        pass

    def result_dict_generator(self):
        pass

    def best_result(self):
        pass

    def color_surfaces(self):
        pass

class Docker:
    """A class that represents the controller to create docking pairs and carry
    out the docking"""

    @staticmethod
    def start(receptor: str, ligand: str, docking_pdb_path: str):
        
        # create docking object
        docking = Docker.create_docking(receptor, ligand, docking_pdb_path)
        if docking is None:
            return
        
        docking.hex_docking()
    
    def create_receptor(receptor_name: str, receptor_file_path: str):
        with open(receptor_file_path) as f:
            is_monomer = True
            for line in f.readlines():
                if re.match(r'COMPND   \d CHAIN: \w, \w*', line) != None:
                    is_monomer = False
					#if the receptor would be a monomer the regex would be 
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
        
        # check that the docking combination has not been run before
        results_path = docking_pdb_path + 'results/' + receptor_name + '_' + ligand_name + '_testing/'
        if os.path.exists(results_path):
            print("The docking between {0} and {1} has already been done.".format(receptor_name, ligand_name))
            return None
        
        os.makedirs(results_path)
        
        # find receptor file and create receptor object
        receptor_folder =  docking_pdb_path + 'results/receptor_to_dock'
        receptor_found = False

        for receptor_file in os.listdir(receptor_folder):
            if receptor_file[0] != '.' and len(receptor_file.split('.')) == 2 and \
            receptor_file.split('.')[1] == 'pdb' and \
            receptor_file[:-4].lower() == receptor_name.lower():
                receptor_file_found = True
                receptor_file_path = receptor_folder + '/' + receptor_file
                receptor = Docker.create_receptor(receptor_name, receptor_file_path)

        # find ligand file and create ligand object
        ligand_folder = docking_pdb_path + 'results/ligand_to_dock'
        ligand_file_found = False

        for ligand_file in os.listdir(ligand_folder):
            if ligand_file[0] != '.' and len(ligand_file.split('.')) == 2 and \
            ligand_file.split('.')[1] == 'pdb' and \
            ligand_file[:-4].lower() == ligand_name.lower():
                ligand_file_found = True
                ligand_file_path = ligand_folder + '/' + ligand_file
                ligand = Ligand(ligand_name, ligand_file_path)

        if not receptor_file_found:
            print("Receptor file not found")
            return
        elif not ligand_file_found:
            print("Ligand file not found")
            return 
        
        # receptor and ligand objects are created and ready for docking
        if isinstance(receptor, MonomerReceptor):
            docking = MonomerDocking(receptor, ligand, results_path)
        else:
            docking = ComplexDocking(receptor, ligand, results_path)
        return docking
            
if __name__ == "__main__":
    # receptor = Docker.create_receptor("5gij_ATOM", "/home/diennguyen/BAR_API/docking_test_pdbs/results/receptor_to_dock/5gij_ATOM.pdb")
    # print(receptor.name)
    # print(receptor.file_path)
    # receptor2 = Docker.create_receptor("8g2j", "/home/diennguyen/BAR_API/docking_test_pdbs/results/receptor_to_dock/8g2j.pdb")
    # print(receptor2.name)
    # print(receptor2.file_path)
    # print(receptor2.monomers_list)
    docking = Docker.create_docking("8g2j", "UPG", "/home/diennguyen/BAR_API/docking_test_pdbs/")
    print(docking.results_path)
    print(docking.receptor.file_path)
    docking.hex_docking()