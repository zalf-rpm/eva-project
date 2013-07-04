#!/usr/bin/python
# -*- coding: UTF-8-*-

import os
import datetime


from mpi4py import MPI
import numpy


comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()
name = MPI.Get_processor_name()

# Abfragen der Messgroessn aus der Datenbank
#ff="05"



#ff_collection = ["06","07","08"]
ff_collection = ["01","02","03"]
#ff_collection = ["01","02", "03", "04", "05", "06", "07", "08"]
#ff_collection = ["01", "02", "03", "04", "05", "06", "07", "08"]

save_to_database = 0

#option_enddate1 = "--enddate=\"31-12-2008\""
#option_enddate2 = "--enddate=\"31-12-2009\""
#option_enddate3 = "--enddate=\"31-12-2011\""
#option_enddate4 = "--enddate=\"31-12-2011\""

# end dates for nleaching analysis
option_enddate1 = "--enddate=\"30-06-2009\""
option_enddate2 = "--enddate=\"30-06-2010\""
option_enddate3 = "--enddate=\"31-12-2011\""
option_enddate4 = "--enddate=\"31-12-2011\""

#anlage1 = "--anlage 1 --anlage 3"
#anlage2 = "--anlage 2 --anlage 4"

anlage1 = "--anlage 1"
anlage2 = "--anlage 2"
anlage3 = "--anlage 3"
anlage4 = "--anlage 4"



#time_dir = datetime.datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

time_dir = "simulations/2013-04-16"

for ff in ff_collection:
    
    global_dir = "/home/specka/promotion/dissertation/data/optimierung/" + time_dir + "/ff" + ff + "/"
    #global_dir = "/home/specka/QPE/V4/simulations/2011-05-06-c/ff" + ff + "/"
    #global_dir = "/home/specka/eva_2/devel/parametrisierung/fruchtfolgen/grundversuch/optimierungstests/" + time_dir +  "/ff" + ff + "/"
    
    dir = global_dir + "simulation/"
    

    command_list = []
    
    ##########################################################
    # Grundversuch
    ##########################################################
    
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage1 + " --standort ascha --location 11 --classification 1 --copypath \"" + dir + "\" " + option_enddate1)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage2 + " --standort ascha --location 11 --classification 1 --copypath \"" + dir + "\" " + option_enddate2)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage3 + " --standort ascha --location 11 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage4 + " --standort ascha --location 11 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)
#
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage3 + " --standort bernburg --location 44 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage4 + " --standort bernburg --location 44 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)
#    
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage1 + " --standort dornburg --location 16 --classification 1 --copypath \"" + dir + "\" " + option_enddate1)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage2 + " --standort dornburg --location 16 --classification 1 --copypath \"" + dir + "\" " + option_enddate2)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage3 + " --standort dornburg --location 16 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage4 + " --standort dornburg --location 16 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)
##
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage1 + " --standort ettlingen --location 17 --classification 1 --copypath \"" + dir + "\" " + option_enddate1)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage2 + " --standort ettlingen --location 17 --classification 1 --copypath \"" + dir + "\" " + option_enddate2)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage3 + " --standort ettlingen --location 17 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage4 + " --standort ettlingen --location 17 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)
# 
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage1 + " --standort guelzow --location 18 --classification 1 --copypath \"" + dir + "\" " + option_enddate1)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage2 + " --standort guelzow --location 18 --classification 1 --copypath \"" + dir + "\" " + option_enddate2)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage3 + " --standort guelzow --location 18 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage4 + " --standort guelzow --location 18 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)
## 
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage1 + " --standort gueterfelde --location 19 --classification 1 --copypath \"" + dir + "\" " + option_enddate1)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage2 + " --standort gueterfelde --location 19 --classification 1 --copypath \"" + dir + "\" " + option_enddate2)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage3 + " --standort gueterfelde --location 19 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff + " " + anlage4 + " --standort gueterfelde --location 19 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)
#
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage1 + " --standort trossin --location 25 --classification 1 --copypath \"" + dir + "\" " + option_enddate1)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage2 + " --standort trossin --location 25 --classification 1 --copypath \"" + dir + "\" " + option_enddate2)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage3 + " --standort trossin --location 25 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage4 + " --standort trossin --location 25 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)

    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage1 + " --standort werlte --location 27 --classification 1 --copypath \"" + dir + "\" " + option_enddate1)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage2 + " --standort werlte --location 27 --classification 1 --copypath \"" + dir + "\" " + option_enddate2)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage3 + " --standort werlte --location 27 --classification 1 --copypath \"" + dir + "\" " + option_enddate3)
    command_list.append("python eva2_simulation.py --fruchtfolge " + ff +  " " + anlage4 + " --standort werlte --location 27 --classification 1 --copypath \"" + dir + "\" " + option_enddate4)


    for index, command in enumerate(command_list):
        print index, size, (index % size) == rank
        if ((index % size) == rank):
            if (save_to_database):
                command += " -b "
            print rank, command
            
            os.system(command)
    
    # Sammeln der Ergebnisse fuer bessere Auswertung
    if (rank==0):
        os.system("python order_results.py " + global_dir)



