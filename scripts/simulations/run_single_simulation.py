#!/usr/bin/python
# -*- coding: UTF-8-*-

import os
import sys
sys.path.append('../python')
sys.path.append('../python/eva2')


args = ["--fruchtfolge=\"04\" ",
        "--anlage=2 ",
        #"--anlage=4",
        "--standort=\"gueterfelde\"",
        "--location=19 ",
        "--classification=1 "
        #"--startdate=\"01-01-2009\" "
        #"--enddate=\"31-12-2010\" "
        "-y " 
        #"--copypath=/home/specka/promotion/dissertation/data/sensitivity_analysis/vernalisation_tests/"
        ]


call = "python eva2_simulation.py " + " ".join(args)

os.system(call)
