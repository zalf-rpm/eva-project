#!/usr/bin/python
# -*- coding: UTF-8-*-


import os
import datetime
import numpy


ff_collection = ["01", "02","03","04", "05", "06", "07", "08", "09"]

#ff_collection = ["05"]


for ff in ff_collection:
    print('FF', ff)
    klassifikation = 1
    #grundversuch
    os.system("python sql_queries.py \"" + ff + "\"  1 \"ascha\" 11 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"ascha\" 11 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"ascha\" 11 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"ascha\" 11 " + str(klassifikation))
    

    os.system("python sql_queries.py \"" + ff + "\"  1 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"dornburg\" 16 " + str(klassifikation))
    
    os.system("python sql_queries.py \"" + ff + "\"  1 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"ettlingen\" 17 " + str(klassifikation))
    
    os.system("python sql_queries.py \"" + ff + "\"  1 \"guelzow\" 18 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"guelzow\" 18 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"guelzow\" 18 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"guelzow\" 18 " + str(klassifikation))
    
    os.system("python sql_queries.py \"" + ff + "\"  1 \"gueterfelde\" 19 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"gueterfelde\" 19 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"gueterfelde\" 19 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"gueterfelde\" 19 " + str(klassifikation))
    
    os.system("python sql_queries.py \"" + ff + "\"  1 \"trossin\" 25 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"trossin\" 25 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"trossin\" 25 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"trossin\" 25 " + str(klassifikation))
    
    os.system("python sql_queries.py \"" + ff + "\"  1 \"werlte\" 27 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"werlte\" 27 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"werlte\" 27 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"werlte\" 27 " + str(klassifikation))
 
    os.system("python sql_queries.py \"" + ff + "\"  3 \"bernburg\" 44 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"bernburg\" 44 " + str(klassifikation))

#===============================================================================
    
    # gärrest versuch
    klassifikation = 9
    
    os.system("python sql_queries.py \"" + ff + "\"  2 \"ascha\" 11 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"ascha\" 11 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  1 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  1 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"guelzow\" 18 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"guelzow\" 18 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"gueterfelde\" 19 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"gueterfelde\" 19 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\" 2 \"trossin\" 25 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\" 3 \"trossin\" 25 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  2 \"werlte\" 27 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  3 \"werlte\" 27 " + str(klassifikation))
    
    os.system("python sql_queries.py \"" + ff + "\"  5 \"ascha\" 11 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  6 \"ascha\" 11 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  5 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  6 \"dornburg\" 16 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  4 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  5 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  6 \"ettlingen\" 17 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  5 \"guelzow\" 18 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  6 \"guelzow\" 18 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  5 \"gueterfelde\" 19 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  6 \"gueterfelde\" 19 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\" 5 \"trossin\" 25 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\" 6 \"trossin\" 25 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  5 \"werlte\" 27 " + str(klassifikation))
    os.system("python sql_queries.py \"" + ff + "\"  6 \"werlte\" 27 " + str(klassifikation))

print "----------------------Anne-Katrin Prescher-------------------------"
