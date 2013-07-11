#!/usr/bin/python
# -*- coding: UTF-8-*-

import os
import sys
sys.path.append('../python')
sys.path.append('../python/eva2')


args = ["--fruchtfolge=\"01\" ",
        "--anlage=1 ",
        "--standort=\"ascha\" ",
        "--location=11 ",
        "--classification=1 "
        #"--startdate=\"01-01-2009\" "
        #"--enddate=\"31-12-2005\" "
        "-y " 
        #"--copypath=\"E:/Eigene Dateien prescher/monica_simulations/single_simulations/\""
        ]


call = "python eva2_simulation.py " + " ".join(args)

os.system(call)
