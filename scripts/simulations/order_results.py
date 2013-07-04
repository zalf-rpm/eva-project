#! /usr/bin/python


import re
import os
import sys
import shutil


def main():

    # receive path to analyse from command line parameter
    if (len(sys.argv)>=2):
        path = str(sys.argv[1])   
    
    # create directory for image and stats file if they do not already exist
    if (not os.path.isdir(path + "stats")):
        os.makedirs(path + "stats")        
    if (not os.path.isdir(path + "yield_pics")):
        os.makedirs(path + "yield_pics")
    if (not os.path.isdir(path + "soil_pics")):
        os.makedirs(path + "soil_pics")
    if (not os.path.isdir(path + "yearly_stats")):
        os.makedirs(path + "yearly_stats")
    if (not os.path.isdir(path + "crop_results")):
        os.makedirs(path + "crop_results")
    if (not os.path.isdir(path + "monthly_results")):
        os.makedirs(path + "monthly_results")
    if (not os.path.isdir(path + "soil_data")):
        os.makedirs(path + "soil_data")
    if (not os.path.isdir(path + "/quality_images")):
        os.makedirs(path + "/quality_images")
    if (not os.path.isdir(path + "/quality_images/bbch")):
        os.makedirs(path + "/quality_images/bbch")
    if (not os.path.isdir(path + "/quality_images/ertrag")):
        os.makedirs(path + "/quality_images/ertrag")
    if (not os.path.isdir(path + "/quality_images/ob-biomasse")):
        os.makedirs(path + "/quality_images/ob-biomasse")
    if (not os.path.isdir(path + "/quality_images/hoehe")):
        os.makedirs(path + "/quality_images/hoehe")
    if (not os.path.isdir(path + "/quality_images/defizite")):
        os.makedirs(path + "/quality_images/defizite")        
    if (not os.path.isdir(path + "/quality_images/wasserhaushalt")):
        os.makedirs(path + "/quality_images/wasserhaushalt")
    if (not os.path.isdir(path + "/quality_images/bodenwasser/30")):
        os.makedirs(path + "/quality_images/bodenwasser/30")
    if (not os.path.isdir(path + "/quality_images/bodenwasser/60")):
        os.makedirs(path + "/quality_images/bodenwasser/60")
    if (not os.path.isdir(path + "/quality_images/bodenwasser/90")):
        os.makedirs(path + "/quality_images/bodenwasser/90")
    if (not os.path.isdir(path + "/quality_images/nmin")):
        os.makedirs(path + "/quality_images/nmin")
    if (not os.path.isdir(path + "/quality_images/n-concentration")):
        os.makedirs(path + "/quality_images/n-concentration")
    if (not os.path.isdir(path + "/quality_images/n-uptake")):
        os.makedirs(path + "/quality_images/n-uptake")
        
    simulation_path = path + "simulation/" 
    dir_list =  getDirInDirectory(simulation_path)
    
    for dir in dir_list:
        print "Analysing: " + dir
        files = getFilesInDirectory(simulation_path +  dir)
        qfiles = []
        if (os.path.isdir(simulation_path + dir + "/quality_graphics")):
            qfiles = getFilesInDirectory(simulation_path + dir + "/quality_graphics/" )
        
        for file in files:
            # searching for yield images
            regex_ertrag = re.compile("_ertrag_")
            result = regex_ertrag.search(file)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + file, path + "yield_pics/" + file)
                
            # searching for soil images
            regex_soil = re.compile("_boden_")
            result = regex_soil.search(file)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + file, path + "soil_pics/" + file)
                
            # searching for stat files
            regex_stats = re.compile("_statistics_")
            result = regex_stats.search(file)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + file, path + "stats/" + file)   
    
            # searching for yearly stat files
            regex_yearly_stats = re.compile("_yearly_(.)*\.txt")
            result = regex_yearly_stats.search(file)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + file, path + "yearly_stats/" + file)   
                
            # searching for yearly stat files
            regex_crop_results = re.compile("_cropresults_")
            result = regex_crop_results.search(file)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + file, path + "crop_results/" + file)   
                
            # searching for monthly stat files
            regex_month_results = re.compile("_monthlyresults_")
            result = regex_month_results.search(file)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + file, path + "monthly_results/" + file)   
        
            # searching for soil data files
            regex_soildata_results = re.compile("soildata")
            result = regex_soildata_results.search(file)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + file, path + "soil_data/" + file)   

        qdir = "quality_graphics/"
        
        for qfile in qfiles:
            # searching for quality bbch images
            regex = re.compile("-bbch.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/bbch/" + qfile)
                
            # searching for yield images
            regex = re.compile("-defizite.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/defizite/" + qfile)
                
            # searching for yield images
            regex = re.compile("-ertrag.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/ertrag/" + qfile)                

            # searching for yield images
            regex = re.compile("-ob-biomasse.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/ob-biomasse/" + qfile)  

            # searching for yield images
            regex = re.compile("-hoehe.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/hoehe/" + qfile)  
                
            # searching for yield images
            regex = re.compile("-wasser0-30cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/bodenwasser/30/" + qfile)      
                
            # searching for yield images
            regex = re.compile("-wasser30-60cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/bodenwasser/60/" + qfile)
                
            # searching for yield images
            regex = re.compile("-wasser60-90cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/bodenwasser/90/" + qfile)   

            # searching for yield images
            regex = re.compile("-wasserhaushalt.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/wasserhaushalt/" + qfile)  

            # searching for yield images
            regex = re.compile("-nmin0-90cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/nmin/" + qfile)       
                
            # searching for yield images
            regex = re.compile("-nmin0-30cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/nmin/" + qfile)
                
            # searching for yield images
            regex = re.compile("-nmin30-60cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/nmin/" + qfile)
                
            # searching for yield images
            regex = re.compile("-nmin60-90cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/nmin/" + qfile)
                
            # searching for yield images
            regex = re.compile("-nmin90-120cm.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/nmin/" + qfile)                                                        
                
            # searching for yield images
            regex = re.compile("-n-concentration.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/n-concentration/" + qfile)     
                
            # searching for yield images
            regex = re.compile("-Nuptake.png")
            result = regex.search(qfile)
            if (result is not None):
                shutil.copy(simulation_path +  dir + "/" + qdir + qfile, path + "/quality_images/n-uptake/" + qfile)                           

""" 
Returns a list with all files that are located in the 
directory specified by 'path'
"""
def getFilesInDirectory(path):
    directory_list = os.listdir(path)    
    files = []
    
    for item in directory_list:
        if os.path.isfile(path + '/' + item):
            files.append(item)
    
    files.sort()
    return (files)


""" 
Returns a list with all directories that are located in the 
directory specified by 'path'
"""
def getDirInDirectory(path):
    directory_list = os.listdir(path)    
    dirs = []
    
    for item in directory_list:
        if os.path.isdir(path + '/' + item):
            dirs.append(item)
    
    return (dirs)


main()
