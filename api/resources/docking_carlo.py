#libraries needed to run the script
from flask import Flask, flash, request, redirect, url_for, send_from_directory
from flask.templating import render_template
from werkzeug.utils import secure_filename
import re
import os
import math
import pandas as pd
#import matplotlib.pyplot as plt
import shutil
import json
import subprocess
import random


UPLOAD_FOLDER = 'https://bar.utoronto.ca/~cperolo/public_html/back_end_script/results/receptor_to_dock/'
ALLOWED_EXTENSIONS = {'pdb', 'sdf'}
home = 'https://bar.utoronto.ca/~cperolo/public_html/'
TEMPLATE_DIR = os.path.abspath(home)

app = Flask(__name__, template_folder=TEMPLATE_DIR)
app.config['SECRET_KEY'] = 'secret'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1000 * 1000
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


def hex_docking(rec_lig, rec_lig2, receptor, ligand):
    code = """ open_receptor ./results/receptor_to_dock/""" + receptor + """.pdb
open_ligand ./results/ligand_to_dock/""" + ligand + """.pdb
docking_correlation 1
docking_score_threshold 0
max_docking_solutions 5000
docking_receptor_stepsize 5.50
docking_ligand_stepsize 5.50
docking_alpha_stepsize 2.80
docking_main_scan 16
receptor_origin C-933:VAL-O
commit_edits
activate_docking
save_range 1 500 results/%s_folder/%s/result %s pdb""" % (rec_lig, rec_lig2, rec_lig)
    subprocess.Popen('hex', stdin=subprocess.PIPE, stderr=subprocess.STDOUT).communicate(bytes(code.encode('utf-8')))

def best_result(file_name, monomer, rec_lig, receptor, ligand):
    file_name_dir = str('./results/' + receptor + '_' + ligand + '_folder/' + receptor + '_' + monomer + '_' + ligand + '/result/')
    file_name_path = str(file_name_dir + file_name[:-20] + '.pdb')

    des1=file_name_dir + 'best_docking_results_for_' + file_name[:-24] + '.pdb'
    shutil.copyfile(file_name_path,des1)
    ori2='./results/' + receptor + '_' + ligand + '_folder/' + receptor + '_' + monomer + '_' + ligand + '/ligand_reserved_pdb/' + file_name
    des2='./results/' + receptor + '_' + ligand + '_folder/' + receptor + '_' + monomer + '_' + ligand + '/ligand_reserved_pdb/best_docking_results.pdb'
    shutil.copyfile(ori2,des2)
    with open(str(file_name_dir + 'best_docking_results_for_' + file_name[:-24] + '.pdb'), 'r') as file:
        lines = file.readlines()
        subpart1 = lines[:lines.index(
            'REMARK    Docked ligand coordinates...\n')]
        subpart2 = lines[lines.index(
            'REMARK    Docked ligand coordinates...\n'):]
    with open(str(file_name_dir + 'best_docking_results_for_' + receptor + '_' + monomer + '_' + ligand + '.pdb'), 'w') as file:
        for l in subpart1:
            file.write(l)
        for line in subpart2:
            if line[0:4] == 'ATOM' or line[:6] == 'HETATM' or line[:3] == 'TER':
                newline = line[:21] + 'Z' + line[22:]
                file.write(newline)
            else:
                file.write(line)
    print('best docking result file is generated for ' + file_name[:-24])

def separate_results(monomer, file_dir, first_file_name, dir_final, monomers_list): 

    ends = [0]
    # Open the .pdb file to separate
    with open (file_dir + first_file_name, 'r+') as r:
        lines = r.readlines()
        for l in lines:
            if l.startswith('ATOM      1  '):
                ends.append(lines.index(l))

        # Searches the .pdb files for the lines that indicate the end of a chain
        for l in lines:
            if l[0:3] == 'TER': 
                ends.append(lines.index(l)) 
        if os.path.isdir(dir_final) == False: 
            os.makedirs(dir_final)
        
        # The end of the previous chain is the start of the current one, 
        # 0 was previosuly included in the list ends to be the start of the first chain 
        start_pos = ends[monomers_list.index(monomer)+1]
        end_pos = ends[monomers_list.index(monomer)+2]

    # It copies every line that is not refererncing an antom coordinates 
    # or that it is in the range of the monomer we want to isolate
    file_list = os.listdir(file_dir)
    for r in file_list:
        file_path = str(file_dir + '/' + r)
        new_file_path = str(dir_final + r[:-4] + '_' + monomer + '.pdb')
        with open(file_path, 'r') as file:
            lines = [line for line in file.readlines()]
            # Everything before the first coordinate line, between the lines that cointain the monomer coordinates, and after the last receptor's coordinates is copied
            lines = lines[ends[0]:ends[1]] + lines[start_pos:end_pos] + lines[ends[-1]:]
        with open(new_file_path, 'w') as file:
            file.writelines(lines)


def separate_monomers(monomer, file_dir, file_name, dir_final, monomers_list): 
    
    # Open the .pdb file to separate
    with open (file_dir + '/' + file_name + '.pdb', 'r+') as r:
        lines = r.readlines()
        ends = [0]

        # Searches the .pdb files for the lines that indicate the end of a chain
        for l in lines:
            if l[0:3] == 'TER': 
                ends.append(lines.index(l)) 
        if os.path.isdir(dir_final) == False: 
            os.makedirs(dir_final)
        monomer_pdb = open(dir_final + '/' + file_name + '_' + monomer + '.pdb', 'a+')
        
        # The end of the previous chain is the start of the current one, 
        # 0 was previosuly included in the list ends to be the start of the first chain 
        start_pos = ends[monomers_list.index(monomer)]
        end_pos = ends[monomers_list.index(monomer)+1]

        # It copies every line that is not refererncing an antom coordinates 
        # or that it is in the range of the monomer we want to isolate
        for l in lines:
            if l[0:4] != 'ATOM' or lines.index(l) in range(start_pos, end_pos): 
                monomer_pdb.write(l)
            # It needs to copy also the ligand data (if there is any) which is labeled with SDF
            elif l[17:20] == 'SDF':
                monomer_pdb.write(l)


def ligand_reserved(monomer, rec_lig, receptor, ligand):

    dir_path = str('./results/'+ rec_lig + '_folder' + '/' + receptor + '_' + monomer + '_' + ligand + '/result')
    print('Isolating ' + rec_lig)
    os.makedirs('./results/'+ rec_lig + '_folder' + '/' + receptor + '_' + monomer + '_' + ligand + '/ligand_reserved_pdb')
    file_list = os.listdir(dir_path)
    result_list = []

    # Some operative system will create hidden files, the script consider .pdb files only
    for i in file_list:
        if i[0] != '.' and len(i.split('.')) == 2 and i.split('.')[1] == 'pdb':
            result_list.append(i)
    for r in result_list:
        file_path = str(dir_path + '/' + r)
        ligand_reserved_file_path = str('./results/'+ rec_lig + '_folder' + '/' + receptor + '_' + monomer + '_' + ligand + '/ligand_reserved_pdb/' + r[:-4] + '_ligand_reserved.pdb')
        with open(file_path, 'r') as file:
            lines = [line for line in file.readlines()]
            # Everything below the line 'REMARK    Docked ligand coordinates...' is data of the ligand
            lines = lines[lines.index('REMARK    Docked ligand coordinates...\n'):]
        with open(ligand_reserved_file_path, 'w') as file:
            file.writelines(lines)



def result_dict_generator(threshold, monomer, rec_lig, receptor, ligand):

    result_dir_path = str('./results/'+ rec_lig + '_folder' + '/' + receptor + '_' + monomer + '_' + ligand + '/ligand_reserved_pdb/')
    receptor_file_path = str('./results/receptor_to_dock/monomers/' + receptor + '_' + monomer + '.pdb')

    # Store receptor coordinate information as reference
    with open(receptor_file_path, 'r') as file:
        reference = {}
        for line in file.readlines():
            if line[0:4] == 'ATOM':
                reference[int(line[22:27])] = tuple(map(float, filter(None, line[31:54].split(' '))))

    # The energy for each refenrence element will be stored in ac
    ac = {}
    file_list = os.listdir(result_dir_path)
    result_list = []

    # Generate the list for all .pdb names in the directory
    for i in file_list:
        if i[0] != '.' and len(i.split('.')) == 2 and i.split('.')[1] == 'pdb':
            result_list.append(i)

    en_list = []
    file_names = []
    resi_list = []
    first_file_path = str(result_dir_path + receptor + '_' + ligand + '0001_' + monomer + '_ligand_reserved.pdb')
    z=open(first_file_path)
    lines_first=z.readlines()
    x=lines_first[2]
    print (x)

    # Store energy values for each ligand_reserved file
    for r in result_list:
        print('current file:' + r)
        energy = ''
        file_path = str(result_dir_path + r)
        with open(file_path) as file:
            lines = file.readlines()
            for l in lines:
                if 'REMARK' in l.split(' ') and 'Energy' in l.split(' '):
                    # The energy is divided by the number of results to 
                    # later obtain an average energy when we will sum the 
                    energy = (float(l.split(' ')[6][:-1]))/(len(result_list))
                    # Generate file and energy list by order
                    file_names.append(str(r))
                    en_list.append(energy)   
            
            # Go over every coordiate of atoms in the ligand_reserved file and store into coor
            coor = [tuple(map(float, filter(None, line[31:54].split(' ')))) 
                    for line in lines if line[0:4] == 'ATOM']
            lst = []
            
            for atom in coor:
                # for the coor of each atom of the ligand
                for res in reference.keys():
                    # check if the distance between atoms of the ligands 
                    # and of the receptor (referencies) are lower than chosen threshold (5)
                    if math.sqrt((reference[res][0] - atom[0]) ** 2 + (reference[res][1] - atom[1])** 2 
                                 + (reference[res][2] - atom[2]) ** 2) < threshold:
                        if res in ac.keys():
                            #adding energy (previosly divided by the number of results) more times if 
                            # found multiple times, that way you would have an average
                            ac[res] += energy 
                        else:
                            ac[res] = energy

                        # Store the resi number into lst
                        if res not in lst:
                            lst.append(res)
        # Store rei_num for one file into resi_list as a list
        resi_list.append(lst)

    best_result_name = ''
    # Find the resi number with the lowest energy
    red_resi = ''
    for k, v in ac.items():
        if v == min(ac.values()):
            red_resi = k
    print('red_resi:' + str(red_resi))
    # Find the file that both satisfies the lowest energy and containing the lowest energy resi
    max_en = 0
    for f in file_names:
        if en_list[file_names.index(f)] <= max_en:
            temp = resi_list[file_names.index(f)]
            for i in temp:
                if i == red_resi:
                    best_result_name = f

    res_dict_path = result_dir_path + 'res_dict.json'

    # Use the result file from /result/, change the name to best docking result, and convert it into chain Z
    try:
        best_result(best_result_name, monomer, rec_lig, receptor, ligand)
    except FileNotFoundError:
        f_file = receptor + '_' + ligand + '0001_' + monomer + '_ligand_reserved.pdb'
        best_result(f_file, monomer, rec_lig, receptor, ligand)
    print(ac)

    with open(res_dict_path, 'w') as file:
        file.write(json.dumps(ac))
    print('res_dict.json is generated')
    return ac


def color_surfaces(monomer, receptor, ligand, rec_lig):

    result_dict = {}
    folder_name = str(receptor + '_' + monomer + '_' + ligand)
    if receptor + '_' + monomer not in result_dict.keys():
        result_dict[receptor + '_' + monomer] = {}
    if os.path.isfile('./results/' + rec_lig + '_folder' + '/' + folder_name + '/ligand_reserved_pdb/res_dict.json') == False:
        result_dict[receptor+ '_' + monomer][ligand] = result_dict_generator(5, monomer, rec_lig, receptor, ligand)
    else:
        result_dict[receptor+ '_' + monomer][ligand] = eval(
            open('./results/' + rec_lig + '_folder' + '/' + folder_name + '/ligand_reserved_pdb/res_dict.json', 'r').read())
        print('res_dict.json previously exists and has read')

    resultjson_path = './results/' + rec_lig + '_folder' + '/' + folder_name + '/results.json'
    # Initialize results.json
    ini = {}
    with open(resultjson_path, 'w') as file:
        file.write(json.dumps(ini))
    # with open(resultjson_path, 'r') as file:
    #    results = json.loads(file.read())
    results = {}
    for r in result_dict:
        if r in results.keys():
            for v in result_dict[r]:
                results[r][v] == result_dict[r][v]
        else:
            results[r] = result_dict[r]
    with open(resultjson_path, 'w') as file:
        file.write(json.dumps(results))
    print('result.json is finished')


'''def plot_frequencies(monomer):
    
    dict_final = result_dict_generator(5, monomer)
    
    # To add in the dictionary the residues that were never close to the ligand
    with open(receptor_folder + '_' + monomer + '/' + receptor + '_' + monomer+ '.pdb', 'r') as re:
        to_plot = {}
        for line in re.readlines():        
            if line[0:4] == 'ATOM':
                residue = int(line[22:27])
                if residue in dict_final:
                    continue
                else:
                    to_plot[residue] = 0
    
    # To plot the dictionary as a Pandas DataFrame
    to_plot.update(dict_final)
    df = pd.DataFrame(list(to_plot.items()),columns = ['residue','contact_frequency'])
    df_sorted = df.sort_values(by = 'residue')
    df_sorted.plot(x ='residue', y='contact_frequency', kind = 'line')
    plt.show()'''


def pipeline(rec_lig, is_monomer, receptor, ligand, monomers_list):

    print('Current pair:' + rec_lig)
    if is_monomer == True:
        rec_lig2 = receptor + '_monomer_' + ligand
        rec_lig3 = receptor + '_' + ligand + '_monomer'
        os.makedirs('./results/' + rec_lig + '_folder' + '/' + rec_lig2 + '/result/')
        hex_docking(rec_lig, rec_lig2, receptor, ligand)
        results_dir = './results/' + rec_lig + '_folder/' + rec_lig2 + '/result/'
        results_list = os.listdir(results_dir)
        for r in results_list:
            re = './results/' + rec_lig + '_folder/' + rec_lig2 + '/result/' + r
            new_r = re[:-4] + '_monomer.pdb'
            os.rename(re, new_r)
        first_file_name = str(receptor + '_' + ligand + '0001.pdb')

    else:
        os.makedirs('./results/' + rec_lig + '_folder' + '/' + rec_lig + '/result/')
        hex_docking(rec_lig, rec_lig, receptor, ligand)        
        results_dir = './results/' + rec_lig + '_folder/' + rec_lig + '/result/'
        results_list = os.listdir(results_dir)
        first_file_name = str(receptor + '_' + ligand + '0001.pdb')
    
    # Repeats the analysis for every monomer in the receptor

    for monomer in monomers_list:
        dir_final = './results/'+ rec_lig + '_folder' + '/' + receptor + '_' + monomer + '_' + ligand + '/result/'
        print('plotting monomer: ' + monomer + ' with the ligand: ' + ligand)
        separate_results(monomer, results_dir, first_file_name, dir_final, monomers_list)
        ligand_reserved(monomer, rec_lig, receptor, ligand)
        print('Ligands are now reserved in docking results.')
        color_surfaces(monomer, receptor, ligand, rec_lig)
        #plot_frequencies(monomer)


def start():

    # Check if the receptor is a monomer or a cmomplex and save the receptor and ligand names as variables
    receptor_folder = './results/receptor_to_dock'
    receptor_folder_list = os.listdir(receptor_folder)
    #os.makedirs(receptor_folder)
    #os.makedirs('./results/ligand_to_dock')
    ligand_folder = os.listdir('./results/ligand_to_dock')
    
    for rec in receptor_folder_list:
        # There could be hidden files in the receptor or ligand directory
        if rec[0] != '.' and len(rec.split('.')) == 2 and rec.split('.')[1] == 'pdb':
            receptor = rec[:-4]
        
            # To check if the receptor is a monomer or not, the script will search the .pdb file 
            # for the line that indicated the presence of multiple chains,
            with open(receptor_folder + '/' + rec, 'r+') as f:
                is_monomer = True
                for x in f.readlines():
                    if re.match(r'COMPND   \d CHAIN: \w, \w*', x) != None: 
                        is_monomer = False
                        #if the receptor would be a monomer the regex would be r'COMPND   \d CHAIN: \w;'
                    
                        # To make a list of the monomers' labels 
                        print(receptor + ' identified as a protein complex')
                        if x[11:16] == 'CHAIN':
                            monomers_list = x.split(': ')[-1].split(', ') 
                            # The COMPND line ends with ';' therefore it needs to be removed from the last label
                            monomers_list[-1] = monomers_list[-1][0]
                                               
    for lig in ligand_folder:
        if lig[0] != '.' and len(lig.split('.')) == 2 and lig.split('.')[1] == 'pdb':
            ligand = lig[:-4]
            
    rec_lig = receptor + '_' + ligand
    
    # Call to the pipeline with different parameters whether the receptor is a monomer or a complex
    if is_monomer == False: 
        dir_final = './results/receptor_to_dock/monomers'
        for monomer in monomers_list:
            print('separating monomer: ' + monomer)
            separate_monomers(monomer, receptor_folder, receptor, dir_final, monomers_list)
        pipeline(rec_lig, is_monomer, receptor, ligand, monomers_list)   
    else:
        dir_final = './results/receptor_to_dock/monomers'
        monomers_list = ['monomer']
        separate_monomers('monomer', receptor_folder, receptor, dir_final, monomers_list)
        pipeline(rec_lig, is_monomer, receptor, ligand, monomers_list)

    #to put together the json files
    new_json = './results/'+ rec_lig + '_folder' + '/final.json'
    final_json = {}
    for monomer in monomers_list:
        monomer_json = './results/' + rec_lig + '_folder' + '/' + str(receptor + '_' + monomer + '_' + ligand) + '/results.json'
        with open(monomer_json, 'r') as file:
            monomer_dict = json.load(file)
            final_json.update(monomer_dict)
    with open(new_json, 'w') as file:
        file.write(json.dumps(final_json))
    print('result.json is finished')


    # To remove the temporary files and directories created
    for m in monomers_list:
        shutil.rmtree('./results/receptor_to_dock/monomers', ignore_errors = True)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def move_ligand(ligand):
    os.replace(UPLOAD_FOLDER + '/' + ligand, './results/ligand_to_dock/' + ligand)
    
    

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        curfile = request.files["curfile"]
        newfile = request.files["newfile"]
        if curfile and allowed_file(curfile.filename):
            filename = secure_filename(curfile.filename)
            curfile.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        if newfile and allowed_file(newfile.filename):
            filename2 = secure_filename(newfile.filename)
            newfile.save(os.path.join(app.config['UPLOAD_FOLDER'], filename2))
            move_ligand(filename2)
            start()
            return render_template("michelle.html", receptor=filename.rsplit('.', 1)[0].lower(), ligand=filename2.rsplit('.', 1)[0].lower())

    return '''<!DOCTYPE html>
<head>
    <title>Test</title>
</head>
<html>
<body>
    <form method="post" enctype="multipart/form-data">
        <h2>Upload Receptor</h2>
        <input type="file" name="curfile">
        <h2>Upload Ligand</h2>
        <input type="file" name="newfile">
        <p></p>
        <input type="submit" value="Upload">
    </form>
</html>'''
