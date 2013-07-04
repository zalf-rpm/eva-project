#!/usr/bin/python
# -*- coding: ISO-8859-15-*-

import MySQLdb
import os
import csv
import codecs
import datetime

import database_config

#########################################################
#########################################################
######################################################### 
separator=";"

# Grundversuch
#classification = 1
#anlagen = [1,2,3,4]
#fruchtfolgen = ["01","02","03","04","05","06","07","08","09"]
#location_list = [11,44,16,17,18,19,25,27]

# kleiner gärrest
classification = 9
anlagen = [2,3,5,6]
fruchtfolgen = ["03"]
location_list = [11,16,17,18,25,27]
#location_list = [11,16]

# ökovers - V1
#classification = 8
#anlagen = [3]
#duengung_varianten = [0,4,5,6,7]
#fruchtfolgen = ["1","2","3"]
#location_list = [16,20,23,24,27,28]


#########################################################

rootpath = "docs"
exit_on_error = 0
debug_output = 0

datum = datetime.datetime.today().strftime("%Y-%m-%d_%H-%M-%S")

#########################################################
#########################################################
#########################################################

"""
Main routine
"""
def main():
    
    
    conn = MySQLdb.connect (host = database_config.hostname,
                       user = database_config.username,
                       passwd = database_config.passwd,
                       db = database_config.database)

    cursor = conn.cursor ()   
    
    output_names = get_location_name_map()         
    ff_stellungen = get_ff_stellung_map(cursor, conn)    
    nutzungs_map = get_nutzungsart_map(cursor, conn)

    
    if (not os.path.isdir(rootpath)):
            os.makedirs(rootpath) 

    # generate files that are sorted by anlagen, location, ff
    # iterate through all anlagen and locations
    for anlage in anlagen:
        output_file = open(rootpath + "/" + str(classification)  + "-eva2_fruchtfolgen_anlage" + str(anlage) + ".csv", "wb")
        csv_output = csv.writer(output_file, delimiter=separator)    
        
        csv_output.writerow(["Datenabfrage am: " + datum])
        csv_output.writerow([])
        
        years = get_years_of_anlage(anlage)
        header = ["Standort", "FF", "Anl."] + years
        
        for location in location_list:
            csv_output.writerow(header)
            get_ff_infos_for_location(location, anlage, fruchtfolgen, conn, cursor, csv_output, output_names, ff_stellungen,nutzungs_map)
            #csv_output.writerow([])
        
        output_file.close()
        
        
    # generate files that are sorted by location, ff, anlagen
    # iterate through all anlagen and locations
    
    output_file = open(rootpath + "/"  + str(classification) + "-"  + "_fruchtfolgen.csv", "wb")
    csv_output = csv.writer(output_file, delimiter=separator)    
    
    csv_output.writerow(["Datenabfrage am: " + datum])
    csv_output.writerow([])
        
    for location in location_list:
        
        years = ["Jahr 1", "Jahr 2", "Jahr 3", "Jahr 4"]
        header = ["Standort", "FF", "Anl."] + years
        
        csv_output.writerow(header)
        
        for ff in fruchtfolgen:
            for anlage in anlagen:         
                print "Analyse:", location, ff, anlage   
                get_ff_infos_for_location(location, anlage, [ff], conn, cursor, csv_output, output_names, ff_stellungen,nutzungs_map)
            #csv_output.writerow([])
        
    output_file.close()
        
    conn.close()       
    

#########################################################
#########################################################
#########################################################
    
"""

"""
def get_ff_infos_for_location(location, anlage, ffs, conn, cursor, csv_output, output_names, ff_stellungen, nutzungs_map):
    
    print "get infos: ", ffs
        
    # get start year the Anlage
    start_year = int(get_years_of_anlage(anlage)[0])
    
    for ff in ffs:                
        output_row = [output_names[location], ff, anlage]
        
        
        id= str(location) + str(classification) + str(anlage) + ff 
        print "Analysing\t", id
        
        query_string = """SELECT id_pg, id_ff_stellung_willms,
                          id_fruchtfolgeglied, id_frucht, frucht,
                          id_nutzung, erntejahr  
                          FROM 3_70_Pruefglieder P where id_pg like \""""  + id + """%\" 
                          order by id_fruchtfolgeglied"""
        
        if (debug_output):
            print query_string
            print
            
        cursor.execute(query_string)    
        rows = cursor.fetchall()
        
        if (cursor.rowcount == 0):
            print "ERROR: query got no result!"
            if (exit_on_error):
                sys.exit(1)
        
        
        old_erntejahr = None
        row_text = ""
        for row in rows:
            ff_stellung = ff_stellungen[int(row[1])]
            ff_glied = int(row[2])
            id_frucht = int(row[3])
            frucht = row[4]
            nutzung = nutzungs_map[int(row[5])]
            erntejahr = int(row[6])
            
            new_ffg = frucht + " (" + str(id_frucht) + "), " +  str(ff_stellung) + ", " + nutzung + ", (" + str(erntejahr) + ") "
            
            cutting_number = get_cutting_number(id, ff_glied, cursor, conn )
            if (cutting_number>0):
                new_ffg += "(Cuts: " + str(cutting_number) + ")"
                
            if ( (old_erntejahr != erntejahr) and (old_erntejahr != None) and (erntejahr>=start_year)):
                output_row.append(row_text)
                row_text = ""
        
            if (len(row_text)>0):
                row_text += " - "    
            row_text += new_ffg
            old_erntejahr = erntejahr
        
        output_row.append(row_text)
            
        print output_row
        csv_output.writerow(output_row)
                
#########################################################
#########################################################
#########################################################        
             
"""
Returns a map with text to coded ff_stellungen
"""             
def get_ff_stellung_map(cursor, conn):
    
    query_string = """SELECT id_ff_stellung, ff_stellung_kurz FROM S_FF_Stellungen"""        
    
    if (debug_output):
        print query_string
        print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
        
    ff_stellung_map = {}
    
    for row in rows:
        id = int(row[0])
        text = str(row[1])
        ff_stellung_map[id] = text
    
    return ff_stellung_map        

#########################################################
#########################################################
#########################################################

"""
Returns a map with text to coded ff_stellungen
"""             
def get_nutzungsart_map(cursor, conn):
    
    query_string = """SELECT id_nutzung, k_nutzung FROM S_Nutzungen"""        
    if (debug_output):
        print query_string
        print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
        
    nutzung_map = {}
    
    for row in rows:
        id = int(row[0])
        text = str(row[1])
        nutzung_map[id] = text
    
    return nutzung_map       

#########################################################
#########################################################
#########################################################

def get_cutting_number(id, ff_glied, cursor, conn):
    
    new_id = id + str(ff_glied)
    
    query_string = """SELECT DatumErnte FROM 2_10_Ertraege T 
                      where id_pg like \"""" + new_id + """%\"
                      and (id_termin>=62 and id_termin<=69) and datumernte is not null
                      group by DatumErnte"""
                      
    if (debug_output):
        print query_string
        print
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    return cursor.rowcount
        
                      
                               
    
#########################################################
#########################################################
######################################################### 

"""
Returns name of location with given ID
"""
def get_location_name_map():
    locations = {}
    locations[10] = "Aholfing"
    locations[11] = "Ascha"
    locations[12] = "Bandow"
    locations[13] = "Berge"
    locations[14] = "Bruchhausen"
    locations[15] = "Burkersdorf"    
    locations[16] = "Dornburg"
    locations[17] = "Ettlingen"
    locations[18] = "Guelzow"
    locations[19] = "Gueterfelde"
    locations[20] = "Haus Duesse"
    locations[21] = "Oberweißbach"
    locations[22] = "Paulinenaue"
    locations[23] = "Rauischholzhausen"
    locations[24] = "Straubing"
    locations[25] = "Trossin"
    locations[26] = "Wehnen"
    locations[27] = "Werlte"
    locations[44] = "Bernburg"
    return locations   

#########################################################
#########################################################
######################################################### 

def get_years_of_anlage(anlage):
    years = []
    if (classification == 1):
        # Grundversuch
        if (anlage == 1):
            years = ["2005","2006","2007","2008"]
        elif (anlage == 2):
            years = ["2006","2007","2008","2009"]
        elif (anlage == 3):
            years = ["2009","2010","2011","2012"]
        elif (anlage == 4):
            years = ["2010","2011","2012","2013"]
            
    elif(classification == 9):
        
        if (anlage == 1 or anlage == 2 or anlage == 3):
            years = ["2009","2010","2011","2012"]
        elif (anlage == 4 or anlage == 5 or anlage == 6):
            years = ["2010","2011","2012","2013"]
    
    return years

# Call of main routine
main()
