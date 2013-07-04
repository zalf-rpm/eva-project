#!/usr/bin/python
# -*- coding: UTF-8-*-

import sys
sys.path.append('/home/specka/devel/git/master/monica/python')

import monica
import MySQLdb
import datetime

def main():
    get_config(25, "04", 1,1)
    

def get_config(standort, fruchtfolge, anlage, klassifikation = 1):
    
    print "get_config: ", standort, fruchtfolge, anlage, klassifikation
    # MONICA configuration object
    config = monica.Eva2SimulationConfiguration()    
    config.setFruchtFolge(fruchtfolge)
    config.setVariante(int(anlage))
    config.setLocation(standort)
    config.setClassification(klassifikation)
    
    conn = MySQLdb.connect (host = "mysql",
                       user = "gast",
                       passwd = "gast",
                       db = "eva2")
    cursor = conn.cursor () 
    
    # find out crop rotation information for building the id_pg strings
    id_string = str(standort) + str(klassifikation) + str(anlage) + fruchtfolge 
    query_string = """SELECT id_fruchtfolgeglied, id_frucht, erntejahr  FROM 3_70_Pruefglieder P 
                    WHERE id_pg like \"""" + id_string + """%\" 
                    AND id_fruchtfolgeglied>0 
                    group by id_pg 
                    order by id_pg"""
    
    print query_string
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    old_fruchtart = None
    for row in rows:
        
        ff_glied = row[0]
        frucht = row[1]
        year = row[2]
        
        if (len(str(frucht))==2):
            frucht = "0" + str(frucht)
        
        if (frucht != old_fruchtart or frucht == 141 or frucht == 176 or (frucht==180 and standort==44)):            
            print "Adding:", ff_glied, frucht, year
            config.setFruchtfolgeGlied(ff_glied)
            config.setFruchtArt(str(frucht))         
            config.setFruchtfolgeYear(str(year)) 
            config.addFfgAnlage(anlage)
            old_fruchtart = frucht 
            
    # find out start date of the crop experiment
    
    start_date = None
    if (klassifikation == 1):
        # grundversuch
        if (anlage == 1):
            start_date = "2005-01-01"
        elif(anlage == 2):
            start_date = "2006-01-01"
        elif(anlage == 3):
            start_date = "2009-01-01"
        elif(anlage == 4):
            start_date = "2010-01-01"
    
    elif (klassifikation == 9):
        # 50 % Gärrest oder 100% Gärrest
        if (anlage == 1 or anlage == 2 or anlage == 3):
            start_date = "2009-01-01"
            
        elif (anlage == 4 or anlage == 5 or anlage == 6):
            start_date = "2010-01-01"
            
    query_string = """SELECT Datum FROM 2_60_Bew_Daten B 
                    WHERE id_pg like \"""" + id_string + "1" + """%\"
                    AND Datum is not NULL
                    order by datum"""
                    
    print query_string
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    # only analyse the first result set because we are only looking for a start date
    # for simulation
    
    if (len(rows) == 0):
        print "ERROR: no information in 2_60_bew_daten available for simulation. Aborting now ..."
        sys.exit(-1)
    
    row = rows[0]
    datum = str(row[0])
    print "datum", datum
    
    db_date = datum.split("-")    
    orig_date = start_date.split("-")
        
    if (int(db_date[0]) < int(orig_date[0])):
        # test if year from first work step of database is before original start date
        print "python set start date"       
        if (standort == 44 and (datetime.date(int(db_date[0]), int(db_date[1]), int(db_date[2])))<datetime.date(2008,10,1) )  :
            # climate information are only available since this date
            config.setStartDate(2008,10,1,1)
        else:  
            config.setStartDate(int(db_date[0]), int(db_date[1]), int(db_date[2]), 1)
        print config.getStartDateMySQL()
        
    else:
        print "python set start date"
        config.setStartDate(int(orig_date[0]), int(orig_date[1]), int(orig_date[2]), 1)
        print config.getStartDateMySQL()

    # get profil information of location
    if (standort == 11):
        # ascha
        return get_ascha_config(fruchtfolge, anlage, config, klassifikation)
    
    elif (standort == 16):
        # dornburg
        return get_dornburg_config(fruchtfolge, anlage, config, klassifikation)
    
    elif (standort == 17):
        # ettlingen
        return get_ettlingen_config(fruchtfolge, anlage, config, klassifikation)
    
    elif (standort == 18):
        # guelzow
        return get_guelzow_config(fruchtfolge, anlage, config, klassifikation)
    
    elif (standort == 19):
        # gueterfelde
        return get_gueterfelde_config(fruchtfolge, anlage, config, klassifikation)
    
    elif (standort == 25):
        # trossin
        return get_trossin_config(fruchtfolge, anlage, config, klassifikation)
    
    elif (standort == 27):
        # werlte
        return get_werlte_config(fruchtfolge, anlage, config, klassifikation)
    
    elif (standort == 44):
        # werlte
        return get_bernburg_config(fruchtfolge, anlage, config, klassifikation)
    
    else:
        print "Cannot find simulation configuration for location " + str(standort)

    conn.close()        
    return config
    
    
#####################################################
# ASCHA
#####################################################
def get_ascha_config(fruchtfolge, anlage, config, klassifikation=1):
    if (klassifikation == 1):
        return get_ascha_config_grundversuch(fruchtfolge, anlage, config)
    else:
        return get_ascha_config_gaerrestversuch(fruchtfolge, anlage, config)

def get_ascha_config_gaerrestversuch(fruchtfolge, anlage, config):
    
    if (config.getVariante() == 2  or anlage == 3):
        config.setProfil_number(23) # 21-27
    elif (config.getVariante() == 5 or anlage == 6):        
        config.setProfil_number(24) # 21-27    
        
    return config
                                  
def get_ascha_config_grundversuch(fruchtfolge, anlage, config):    
    if (config.getVariante() == 1  or anlage == 3):
        config.setProfil_number(27) # 21-27
    elif (config.getVariante() == 2 or anlage == 4):        
        config.setProfil_number(21) # 21-27    
        
    return config

#####################################################
# DORNBURG
#####################################################
"""

"""
def get_dornburg_config(fruchtfolge, anlage, config, klassifikation=1):
    if (klassifikation == 1):
        return get_dornburg_config_grundversuch(fruchtfolge, anlage, config)
    else:
        return get_dornburg_config_gaerrestversuch(fruchtfolge, anlage, config)

"""

"""
def get_dornburg_config_gaerrestversuch(fruchtfolge, anlage, config):
    if (config.getVariante() == 1 or config.getVariante() == 2  or anlage == 3):
        config.setProfil_number(1) 
    elif (config.getVariante() == 4 or config.getVariante() == 5 or anlage == 6):        
        config.setProfil_number(1) 
    return config

"""

"""
def get_dornburg_config_grundversuch(fruchtfolge, anlage, config):

    if (config.getVariante() == 1):
        config.setProfil_number(1) # 1, 5, 6
        
    elif (config.getVariante() == 2):
        config.setProfil_number(1) # 1, 5, 6
    
    elif (config.getVariante() == 3):
        config.setProfil_number(1) # 1, 5, 6
    
    elif (config.getVariante() == 4):
        config.setProfil_number(1) # 1, 5, 6
        
    return config

#####################################################
# ETTLINGEN
#####################################################

"""

"""
def get_ettlingen_config(fruchtfolge, anlage, config, klassifikation=1):
    if (klassifikation == 1):
        return get_ettlingen_config_grundversuch(fruchtfolge, anlage, config)
    else:
        return get_ettlingen_config_gaerrestversuch(fruchtfolge, anlage, config)

"""

"""
def get_ettlingen_config_gaerrestversuch(fruchtfolge, anlage, config):
    if (config.getVariante() == 1 or config.getVariante() == 2  or anlage == 3):
        config.setProfil_number(43) 
    elif (config.getVariante() == 4 or config.getVariante() == 5 or anlage == 6):        
        config.setProfil_number(43) 
    return config

def get_ettlingen_config_grundversuch(fruchtfolge, anlage, config):
    
    if (config.getVariante() == 1 or anlage == 3):
        config.setProfil_number(42) # 41-46  
        
    elif (config.getVariante() == 2 or anlage == 4):
        config.setProfil_number(45)# 41-46
        
    return config


#####################################################
# GUELZOW
#####################################################

"""

"""
def get_guelzow_config(fruchtfolge, anlage, config, klassifikation=1):
    if (klassifikation == 1):
        return get_guelzow_config_grundversuch(fruchtfolge, anlage, config)
    else:
        return get_guelzow_config_gaerrestversuch(fruchtfolge, anlage, config)

"""

"""
def get_guelzow_config_gaerrestversuch(fruchtfolge, anlage, config):
    if (config.getVariante() == 2  or anlage == 3):
        config.setProfil_number(73) 
    elif (config.getVariante() == 5 or anlage == 6):        
        config.setProfil_number(70)
    return config 

def get_guelzow_config_grundversuch(fruchtfolge, anlage, config):
    
    if (config.getVariante() == 1 or anlage == 3):
        config.setProfil_number(73) 
        
    elif (config.getVariante() == 2 or anlage == 4):
        config.setProfil_number(70) 
    
    return config

#####################################################
# GUETERFELDE
#####################################################
"""

"""
def get_gueterfelde_config(fruchtfolge, anlage, config, klassifikation = 1):
    if (klassifikation == 1):
        return get_gueterfelde_config_grundversuch(fruchtfolge, anlage, config)
    elif(klassifikation == 9):
        return get_gueterfelde_config_gaerrestversuch(fruchtfolge, anlage, config)

"""

"""
def get_gueterfelde_config_gaerrestversuch(fruchtfolge, anlage, config):
    pass

def get_gueterfelde_config_grundversuch(fruchtfolge, anlage, config):
    
    if (config.getVariante() == 1 or anlage == 3):
        config.setProfil_number(53) #51-54    
        
    elif (config.getVariante() == 2 or anlage == 4):
        config.setProfil_number(52) 
        
    return config

#####################################################
# TROSSIN
#####################################################
"""

"""
def get_trossin_config(fruchtfolge, anlage, config, klassifikation = 1):
    if (klassifikation == 1):
        return get_trossin_config_grundversuch(fruchtfolge, anlage, config)
    elif (klassifikation== 9):
        return get_trossin_config_gaerrestversuch(fruchtfolge, anlage, config)

"""
Konfiguration des Gärrest-Versuchs für Trossin
"""
def get_trossin_config_gaerrestversuch(fruchtfolge, anlage, config):
    
    if (anlage == 2 or anlage == 3):
        config.setProfil_number(11) # 11-16
        
    elif (anlage == 5 or anlage == 6):
        config.setProfil_number(11) # 11-16
         
    return config
    
    
def get_trossin_config_grundversuch(fruchtfolge, anlage, config):
    
    if (config.getVariante() == 1 or anlage == 3):
        config.setProfil_number(13) # 11-16
        
    elif (config.getVariante() == 2 or anlage == 4):
        config.setProfil_number(14) # 11-16
            
    return config

#####################################################
# WERLTE
#####################################################
"""

"""
def get_werlte_config(fruchtfolge, anlage, config, klassifikation = 1):
    if (klassifikation == 1):
        return get_werlte_config_grundversuch(fruchtfolge, anlage, config)
    else:
        return get_werlte_config_gaerrestversuch(fruchtfolge, anlage, config)

"""

"""
def get_werlte_config_gaerrestversuch(fruchtfolge, anlage, config):
    if (anlage == 2 or anlage == 3):
        config.setProfil_number(82) # 11-16
        
    elif (anlage == 5 or anlage == 6):
        config.setProfil_number(85) # 11-16
         
    return config

def get_werlte_config_grundversuch(fruchtfolge, anlage, config):
    
    if (config.getVariante() == 1 or anlage == 3):
        config.setProfil_number(82)  # 81-85
        
    elif (config.getVariante() == 2 or anlage == 4):
        config.setProfil_number(85) # 81-85
    
    return config

#####################################################
# BERNBURG
#####################################################
"""

"""
def get_bernburg_config(fruchtfolge, anlage, config, klassifikation = 1):
    if (klassifikation == 1):
        return get_bernburg_config_grundversuch(fruchtfolge, anlage, config)
    else:
        return get_bernburg_config_gaerrestversuch(fruchtfolge, anlage, config)

"""

"""
def get_bernburg_config_gaerrestversuch(fruchtfolge, anlage, config):
    pass

def get_bernburg_config_grundversuch(fruchtfolge, anlage, config):
    
    if (anlage == 3):
        config.setProfil_number(150)  
        
    elif (anlage == 4):
        config.setProfil_number(151) 
    
    return config
    
    
        
def get_muencheberg_config(fruchtfolge, anlage, config):
    
    #  Unberegnet, Gepflügt

    # Varianten
    # 1: Bodenbearbeitung, unberegnet
    # 2: Direktsaat, unberegnet
    # 3: Bodenbearbeitung, beregnet
    # 4: Direktsaat, beregnet
    config.setVariante(anlage)
    config.setProfil_number(19) # 19,20,21   - 43, 45  - 67, 69
    config.setClassification(0) 

    config.setStartDate(1,9,2007,1)
    config.setEndDate(31,12,2010,1)
    
    if (config.getFruchtFolge() == "01" or config.getFruchtFolge() == "02"):
    
        config.setFruchtfolgeGlied(1)
        config.setFruchtArt("172")          # Winterroggen
        config.setFruchtfolgeYear("2008")
        
        config.setFruchtfolgeGlied(2)
        config.setFruchtArt("141")          # Silomais
        config.setFruchtfolgeYear("2008")
        
        config.setFruchtfolgeGlied(3)
        config.setFruchtArt("172")          # Winterroggen
        config.setFruchtfolgeYear("2009")
        
        config.setFruchtfolgeGlied(4)
        config.setFruchtArt("141")          # Silomais
        config.setFruchtfolgeYear("2009")
        
        
        config.setFruchtfolgeGlied(5)
        config.setFruchtArt("172")          # Winterroggen
        config.setFruchtfolgeYear("2010")
        
        config.setFruchtfolgeGlied(6)
        config.setFruchtArt("141")          # Silomais
        config.setFruchtfolgeYear("2010")
        
    elif (config.getFruchtFolge() == "03" or config.getFruchtFolge() == "04"):
        
        config.setFruchtfolgeGlied(1)
        config.setFruchtArt("172")          # Winterroggen
        config.setFruchtfolgeYear("2008")
        
        config.setFruchtfolgeGlied(2)
        config.setFruchtArt("180")          # Zuckerhirse
        config.setFruchtfolgeYear("2008")
            
    
        config.setFruchtfolgeGlied(3)
        config.setFruchtArt("175")          # Wintertriticale
        config.setFruchtfolgeYear("2009")
        
        config.setFruchtfolgeGlied(5)
        config.setFruchtArt("140")          # Luzernekleegras
        config.setFruchtfolgeYear("2010")
    
        
        #config.setFruchtfolgeGlied(5)
        #config.setFruchtArt("140")          # Luzernekleegras
        #config.setFruchtfolgeYear("2010")
  
    return config

#main()