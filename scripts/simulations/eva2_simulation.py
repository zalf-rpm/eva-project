#!/usr/bin/python
# -*- coding: UTF-8-*-

# adding the path of monica's python module to search path
# that is defined by the environment variable PYTHONPATH
import sys
import os
sys.path.append('..')
sys.path.append('.')

# specification of platform dependent path separators
sep = "/"
if (sys.platform.startswith('win')):
    # if windows
    sep = "\\"

# path to monica binary
sys.path.append(os.path.normpath("E:/Eigene Dateien prescher/development/GitHub/monica/monica-swig"))

import monica
import datetime

import shutil
from save_monica_results import *
from add_simulation_to_sql_db import *
import getopt
from eva2_config import *

# TODO: wichtig den Pfad zu den EVA-Daten zu spezifizieren
data_path = os.path.normpath("E:/Eigene Dateien prescher/eva_messdaten")
simulation_output_dir = os.path.normpath("E:/Eigene Dateien prescher/monica_simulations/runs")

def main():
    
    simulation_config = None
    
    try:
        opts, args = getopt.getopt(sys.argv[1:],
                                    "fapslcdghot:xybve",
                                     ["fruchtfolge=", "anlage=", "profil=",
                                      "standort=", "location=", "classification=",
                                      "pseudodate=", "startdate=", "enddate=",
                                      "simulationpath=", "copypath="])        
    except getopt.GetoptError, err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        sys.exit(2)
        
    print opts
    
    fruchtfolge = None
    anlage = []
    profil = None
    standort = None
    location = None
    classification = 1
    pseudo = False
    pseudo_date = ""
    save_results_to_db = 0

    start_date = None
    end_date = None
    simulationpath = None
    analyse = False 
    copypath = None
    verbose = False
    no_simulation = False
    
    print "Parse command line options"
    for option, arg in opts:
        print option, arg
        if option in ("-f", "--fruchtfolge"):            
            fruchtfolge = arg
        elif option in ("-a", "--anlage"):
            anlage.append(int(arg))
        elif option in ("-p", "--profil"):
            profil=int(arg)
        elif option in ("-s", "--standort"):
            standort=arg
        elif option in ("-l", "--location"):
            location=int(arg)
        elif option in ("-c", "--classification"):
            classification=int(arg)
        elif option == "-x":
            pseudo=True
        elif option in ("-d", "--pseudodate"):
            pseudo_date=arg
        elif option in ("-g", "--startdate"):
            start_date=arg
        elif option in ("-h", "--enddate"):
            end_date=arg
        elif option == "-b":
            save_results_to_db=True
        elif option == "-y":
            analyse=True
        elif option in("-o", "--simulationpath"):
            simulationpath = arg
        elif option in("-t", "--copypath"):
            copypath = os.path.normpath(arg)
        elif option == "-v":
            verbose=True
        elif option == "-e":
            no_simulation=True
        else:
            assert False, "unhandled option"

    print "Anlage-Vector: ", anlage
    anlage.sort()
    print anlage
    
    for anl in anlage:
        config = get_config(location, fruchtfolge, anl, classification)
        if (simulation_config == None):            
            simulation_config = config
        else:            
            additional_fruchtfolge_glied = config.getFruchtfolgeGlied()            
            additional_fruchtfolge_year = config.getFruchtfolgeYearInt()                        
            additional_fruchtart = config.getFruchtArt()
            
            for (fg, fy, fa) in zip( additional_fruchtfolge_glied, additional_fruchtfolge_year, additional_fruchtart):
                "Adding: ", fg, fa, fy
                simulation_config.setFruchtfolgeGlied(fg)
                simulation_config.setFruchtfolgeYear(str(fy))
                simulation_config.setFruchtArt(fa)
                simulation_config.addFfgAnlage(anl)
            
        if (classification == 1):
            if ( end_date != None):
                end_date_s = end_date.split("-")
                simulation_config.setEndDate(int(end_date_s[2]), int(end_date_s[1]), int(end_date_s[0]),1)            
                           
        if (classification == 9):
            if (end_date == None):            
                if (anl == 2 or anl == 3):
                    simulation_config.setEndDate(2011,12,31,1)
                elif (anl == 5 or anl == 6):
                    simulation_config.setEndDate(2011,12,31,1)
            else:
               
                end_date_s = end_date.split("-")
                simulation_config.setEndDate(int(end_date_s[2]), int(end_date_s[1]), int(end_date_s[0]),1)
    
    
    simulation_config.setLocationName(standort)
    simulation_config.setLocation(location)
    simulation_config.setClassification(classification)
    simulation_config.setPseudoSimulation(pseudo)
    
    
    print simulation_config.getFruchtfolgeGlied()
    print simulation_config.getFruchtfolgeYearInt()
    print simulation_config.getFruchtArt()
    

        
    if (profil != None):
        simulation_config.setProfil_number(profil)
    
    if (pseudo):
        plist = pseudo_date.split("-")
        simulation_config.setPseudoStartDate(int(plist[2]), int(plist[1]), int(plist[0]), 1)

    print "Starting calculation for " + standort

    #########################################
    # Pfadkonfiguration
    #########################################    
    output_path = ""
    rootpath = ""
    directory = ""
    time_dir = datetime.datetime.today().strftime("%Y-%m-%d_%H-%M-%S")
    
    versuch = "grundversuch"
    if (simulation_config.getClassification() == 9):
        versuch = "gaerrest"
        
        
    if (simulationpath != None):
        rootpath =simulationpath
        directory = os.path.normpath(standort + "/" + versuch + "/" + "ff" + simulation_config.getFruchtFolge() + "/" + "anlage-" + str(simulation_config.getVariante()) + "/" + time_dir + "/")
    else:
        rootpath = os.path.normpath(simulation_output_dir + "/" + standort + "/" + versuch + "/"+ "ff" + simulation_config.getFruchtFolge() + "/" + "anlage-" + str(simulation_config.getVariante()) + "/" + "results")
        directory = os.path.normpath(time_dir + "-profil-" + str(simulation_config.getProfil_number()))
    output_path = os.path.normpath(rootpath  + "/" + directory )
    simulation_data_path = os.path.normpath(data_path + "/" + standort + "/" + versuch + "/" + "ff" + simulation_config.getFruchtFolge() + "/" + "anlage-" + str(simulation_config.getVariante()))
    
    print "Output path1: ", output_path
    simulation_config.setOutputPath(output_path)
    os.makedirs(output_path)
    
    if (no_simulation):
        return monica.getEva2Env(simulation_config)

    if (analyse):
        os.makedirs(os.path.normpath(output_path + "/" + "quality_graphics"))

        # writing name of folder into a separate file that
        # is read by the r script that generates pictures
        r_config_file = open("rscripts" + "/" + "dir_config.r", "w")
        print >> r_config_file, "folder=\"" + directory.replace("\\","/") + "\""
        print >> r_config_file, "standort=" +  str(simulation_config.getLocation())
        print >> r_config_file, "profil=" +  str(simulation_config.getProfil_number())
        print >> r_config_file, "anlage=" +  str(simulation_config.getVariante())
        print >> r_config_file, "ff=\"" +  simulation_config.getFruchtFolge() + "\""
        print >> r_config_file, "classification=" + str(simulation_config.getClassification())
        print >> r_config_file, "root_folder=\"" +  rootpath.replace("\\","/") + "/\""
        print >> r_config_file, "standortname=\"" + standort + "\""
        print >> r_config_file, "data_folder =\"" + simulation_data_path.replace("\\","/") + "\""

        r_config_file.close() 

 
    # run MONICA model simulation   
    if (verbose):
        monica.activateDebugOutput(1)
    else:
        monica.activateDebugOutput(0)
    
    print "Previou to runEva2Simulation"
    result_object = monica.runEVA2Simulation(simulation_config)
    if (analyse):
        save_monica_results(result_object,output_path, standort, simulation_config.getClassification(), simulation_config.getFruchtFolge(),  simulation_config.getVariante(),simulation_config.getProfil_number(), simulation_config.getLocation())

    if (save_results_to_db):
        add_simulation_to_sql_db(simulation_config.getLocation(),
                                 simulation_config.getClassification(),
                                 simulation_config.getVariante(),
                                 simulation_config.getFruchtFolge(),
                                 output_path,
                                 start_date,
                                 end_date)
    
    if (analyse):
        print "Running R analysis"
        # analyse results of simulation with measured data
        os.chdir("rscripts")
        os.system("R --slave --vanilla < analyse.r")
        os.system("R --slave --vanilla < yearly_analyse.r")
        #os.system("R --slave --vanilla < monthly_analyse.r")
        os.chdir("..")
    
    
    if (copypath!=None):
        tmpdir = "\"" + copypath
        base = os.path.basename(output_path[0:-1]) 
           
        new_dir = os.path.normpath(copypath + "/" + standort + "-klass" + str(classification) + "-" + "ff" + simulation_config.getFruchtFolge() + "-anlage-" + str(simulation_config.getVariante())) #+ "-" +base
        if (os.path.isdir(new_dir)):
            shutil.rmtree(new_dir)
        print "Moving directory " + output_path + " to destination" + new_dir
        shutil.copytree(output_path,new_dir ) #+ "-" +base)
        print "Removing old directory: ", output_path
        shutil.rmtree(output_path)
    return output_path
    
main()

