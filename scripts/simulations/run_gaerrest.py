#!/usr/bin/python
# -*- coding: UTF-8-*-

import os
import datetime

import numpy



ff_collection = ["03"]


# Varianten-Konfiguration
# 2 50% 1. Anlage
# 3 100% 1. Anlage
# 5 50% 2. Anlage    
# 6 100% 2. Anlage

startdate1 = " --startdate=\"01-01-2009\""
enddate1 = " --enddate=\"31-12-2011\""

startdate2 = " --startdate=\"01-01-2009\""
enddate2 = " --enddate=\"31-12-2011\""

save_to_database = 0

time_dir = "full_runs/gaerrest/"

for ff in ff_collection:
    
    global_dir = "E:/Eigene Dateien prescher/monica_simulations/" + time_dir + "/ff" + ff
    dir = global_dir + "simulation/"
    
    
    ##########################################################
    # Gärrest versuch
    ##########################################################
    
    command_list = []
    
        
    # 1. Versuchsjahr ###########################################
#    command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 3 --standort ascha --location 11 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 2 --standort ascha --location 11 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 3 --standort ascha --location 11 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)    
#    
#    command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 1 --standort dornburg --location 16 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 2 --standort dornburg --location 16 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 3 --standort dornburg --location 16 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)    
#    
#    command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 1 --standort ettlingen --location 17 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 2 --standort ettlingen --location 17 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 3 --standort ettlingen --location 17 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)   
#    
#    command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 3 --standort guelzow --location 18 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 2 --standort guelzow --location 18 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 3 --standort guelzow --location 18 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    
#    command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 3 --standort trossin --location 25 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 2 --standort trossin --location 25 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 3 --standort trossin --location 25 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)
#    
#    command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 3 --standort werlte --location 27 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 2 --standort werlte --location 27 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
#    command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 3 --standort werlte --location 27 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)
#        
#
#    # 2. Versuchsjahr ###########################################
#
    #command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 4 --standort ascha --location 11 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 5 --standort ascha --location 11 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 6 --standort ascha --location 11 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)    
    
    #command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 4 --standort dornburg --location 16 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)       
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 5 --standort dornburg --location 16 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 6 --standort dornburg --location 16 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)    
    
    #command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 4 --standort ettlingen --location 17 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 5 --standort ettlingen --location 17 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 6 --standort ettlingen --location 17 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)   
    
    #command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 4 --standort guelzow --location 18 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 5 --standort guelzow --location 18 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 6 --standort guelzow --location 18 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)
    
    #command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 4 --standort trossin --location 25 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 5 --standort trossin --location 25 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 6 --standort trossin --location 25 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)
    
    #command_list.append("python eva2_simulation.py -y -v --fruchtfolge " + ff + " --anlage 4 --standort werlte --location 27 --classification 1 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 5 --standort werlte --location 27 --classification 9 --copypath \"" + dir + "\" " + startdate1 + enddate1)
    #command_list.append("python eva2_simulation.py -v -y --fruchtfolge " + ff + " --anlage 6 --standort werlte --location 27 --classification 9 --copypath \"" + dir + "\" " +  startdate1 + enddate1)


    for index, command in enumerate(command_list):
        if (save_to_database):
            command += " -b "
            
        os.system(command)
    
    # Sammeln der Ergebnisse fuer bessere Auswertung
    os.system("python order_results.py " + "\"" + global_dir + "\"")

