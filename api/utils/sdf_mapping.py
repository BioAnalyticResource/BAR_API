import os
import re
from typing import List

def get_substance_name(filename: str, folder_path: str):
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
    # while line != "":
        # check regex to see if it contains lowercase
        # matched = re.search("[a-z]", line)
        # if matched is not None:
        #     return line
        # else:
        #     line = file.readline().strip()
        names.append(line)
        line = file.readline().strip()
    return names

def create_mapping(folder_path: str):
    mapped_sdf = {}
    sdf_files = os.listdir(folder_path)
    for file in sdf_files:
        if file[0] != "." and file[-4:] == ".sdf":
            file_number = file[:file.index("_")]
            name = file[file.index("_") + 1:-4]
            # the commented out section is for sdfs that have not been filtered
            # names = get_substance_name(file, folder_path)
            # print(name)
            # sdf_number = file.split(".")[0]
            # mapped_sdf[sdf_number] = ",".join(names)
            mapped_sdf[file_number] = name  # check if want to map file_number or file name
    return mapped_sdf

if __name__ == "__main__":
    sdf_folder_paths = ['/home/diennguyen/BAR_API/HEX_API/HEX_SMALL_MOLECULES']
    print(create_mapping(sdf_folder_paths[0]))

