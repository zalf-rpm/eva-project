#!/usr/bin/python
# -*- coding: UTF-8-*-


import MySQLdb
import sys
import numpy
import csv
import os
import datetime
from scipy import stats
import re
import database_config


# Ausgabeverzeichnis angeben
output_directory = "/home/specka/devel/git/monica/python/eva2/gaerrest_ids-2011/"


#######################################################

location_id = 25
replace_in_database = False # True/False
debug_output = 0        # Umfangreiche Kommandozeilenausgaben werden mit debug_output=1 aktiviert

#######################################################

# Initialisierung der Datenbankverbindung

db_connection = MySQLdb.connect (host = database_config.hostname,
                       user = database_config.username,
                       passwd = database_config.passwd,
                       db = database_config.database,
                       use_unicode=True)

cursor = db_connection.cursor ()  

#######################################################

# --------------------------------------------------------------

""" 
Startroutine
"""
def main():
    
    
    
    # Test ob das Verzeichnis existiert, wenn nicht, wird eins angelegt
    if (not os.path.isdir(output_directory)):
        os.makedirs(output_directory)   
       
    location_map = getLocationMap()
    
    c_file = open(output_directory + str(location_map[location_id]) +  ".csv", "wb")    
    csv_writer = csv.writer(c_file, delimiter=";")
    
    
    # Duengerliste für den Standort erstellen
    list_of_org_duenger = getDuengerIDs(cursor,location_map)
    print list_of_org_duenger
    
    # Liste, die Bewirtschaftungsdaten des Standortes nur für Düngearbeitsschritte enthält    
    id_bew_daten_list = getIDBewDaten(cursor)
    
    
    for id_bew in id_bew_daten_list:
        print "Check id_bew_daten", id_bew.id, id_bew.date, id_bew.arbeit
        checkTabBewDaten(cursor, id_bew, list_of_org_duenger, csv_writer)

    c_file.close()

# --------------------------------------------------------------

"""

"""
def getDuengerIDs(cursor, location_map):

    print "getDuengerIDs"
    query_string = """
                    SELECT id_duenger, duenger_kurz
                    FROM S_Duenger S 
                    WHERE id_duengerart = 1 
                    AND id_duenger_numerisch>=611
                   """

    if (debug_output==1):
        print query_string, "\n"
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    # Abbruch, wenn keine Ergebnisse erzielt wurden
    if (cursor.rowcount == 0):
        print "ERROR: query \n" + query_string + "\n got no result!"
        sys.exit(1)
    
    # das Ergebnis der Datenbankabfrage so umsortieren,
    # dass eine Liste von id_pg entsteht
    duenger_list = []
    for row in rows:
        
        if (analyseLocation(row[1], location_map[location_id])):
            id = row[0]            
            (start, end) = analyseYear(row[1])
            exception = hasException(row[1])
            duenger = GaerrestDuenger(id, location_id, start, end, exception)
            duenger_list.append(duenger)
        
    return duenger_list

# --------------------------------------------------------------

"""
Tests if the duenger id text belongs to the
selected location
"""
def analyseLocation(text, loc_name):    
    regex = re.compile(".*" + loc_name)
    result = regex.match(text)
    if (result):
        return True
    
    return False

# --------------------------------------------------------------

"""
Gets start and end date for the fertiliser
application
"""
def analyseYear(text):
    
    

    # Test if the fertiliser was applied for a whole year    
    regex_year = re.compile(".*(\d{4})(?!-)")
    result = regex_year.match(text)
    if (result):
        
        reg_result = result.groups()
        year = int(reg_result[0])        
        return (datetime.date(year,1,1), datetime.date(year,12,31))
    
    
    # Test if there is a date specified at which the fertiliser
    # was applied
    regex_date = re.compile(".*(\d{4})-(\d{2})-(\d{2})")
    result = regex_date.match(text)
    if (result):
        
        reg_result = result.groups()
        year = int(reg_result[0])
        month = int(reg_result[1])
        day = int(reg_result[2])        
        return (datetime.date(year,month,day), None)
    
    return (None, None)
    

# --------------------------------------------------------------

"""

"""
def hasException(text):
    regex = re.compile(".*au.er")
    result = regex.match(text)
    if (result):
       
        # Test if there is a date specified at which the fertiliser
        # was not applied
        regex_date = re.compile(".*(\d{4})-(\d{2})-(\d{2})")
        result = regex_date.match(text)
        if (result):
            reg_result = result.groups()
            year = int(reg_result[0])
            month = int(reg_result[1])
            day = int(reg_result[2])
            return datetime.date(year,month,day)
    
    return None


# --------------------------------------------------------------

"""

"""
def getIDBewDaten(cursor):

    query_string = """
                    SELECT id_bew_daten, id_arbeit, datum 
                    FROM 2_60_Bew_Daten B 
                    WHERE id_pg like \"""" + str(location_id) + """9%\" 
                    AND id_arbeit like "3%"
                   """

    if (debug_output==1):
        print query_string, "\n"
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    # Abbruch, wenn keine Ergebnisse erzielt wurden
    if (cursor.rowcount == 0):
        print "ERROR: query \n" + query_string + "\n got no result!"
        sys.exit(1)
    
    # das Ergebnis der Datenbankabfrage so umsortieren,
    # dass eine Liste von id_pg entsteht
    id_bew_daten_list = []
    for row in rows:
        id_bew = row[0]
        arbeit = row[1]
        date = row[2]
        id_bew_daten_list.append(IdBewDaten(id_bew, arbeit, date))
        
    return id_bew_daten_list

# --------------------------------------------------------------             
  

"""
Returns a map with the assignment of
location_id --> location_name
"""
def getLocationMap():
    location_map = {}
    
    location_map[11] = "Ascha"
    location_map[16] = "Dornburg"
    location_map[17] = "Ettlingen"
    location_map[18] = "Gülzow"
    location_map[19] = "Güterfelde"
    location_map[25] = "Trossin"
    location_map[27] = "Werlte"
    location_map[44] = "Bernburg"
    
    return location_map

        
# --------------------------------------------------------------


def checkTabBewDaten(cursor, id_bew, list_of_org_duenger, csv_writer):
    
    query_string = """
                        SELECT id_duenger
                        FROM 2_63_Betriebsmittel_Duenger B 
                        WHERE id_bew_daten = \"""" + str(id_bew.id) + """\"                        
                   """
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    
    # Abbruch, wenn keine Ergebnisse erzielt wurden
    if (cursor.rowcount == 0):
        print "ERROR: query \n" + query_string + "\n got no result!"
        return None
        #sys.exit(1)
    
    # das Ergebnis der Datenbankabfrage so umsortieren,
    # dass eine Liste von id_pg entsteht    
    for row in rows:
    
        id_duenger = row[0]
        
        s_duenger_id = None
        
        if (id_duenger == "D137" or
            id_duenger == "D138" or
            id_duenger == "D142" or
            id_duenger == "D143" or
            id_duenger == "D215" or
            id_duenger == "D217" or
            id_duenger == "D218"
            ):
            
            s_duenger_id = findDuengerId( list_of_org_duenger,id_bew)
            
            if (s_duenger_id != None):
                
                 print "Replace: ", id_bew.id, id_bew.date, id_bew.arbeit, id_duenger, s_duenger_id
                 csv_writer.writerow([id_bew.id, id_bew.date, id_bew.arbeit, id_duenger, s_duenger_id])
                 query_string = """
                                 UPDATE 2_63_Betriebsmittel_Duenger
                                 SET Id_Duenger = \"""" + str(s_duenger_id) + """\"
                                 WHERE id_bew_daten = \"""" + str(id_bew.id) + """\" 
                                 AND Id_Duenger = \"""" + str(id_duenger) + """\"
                                """
                                 
                 print query_string, "\n"
                 if (replace_in_database):
                     cursor.execute(query_string)
        else:
            print "Ignore: ", id_bew.id, id_bew.date, id_bew.arbeit, id_duenger, s_duenger_id                
            csv_writer.writerow([id_bew.id, id_bew.date, id_bew.arbeit, id_duenger, s_duenger_id])
        
# --------------------------------------------------------------                 
    
"""
Looks for the correct fertiliser in the organic fertiliser list.
The application date for the fertilisation work step is used
as selection criteria
"""
def findDuengerId(list_of_org_duenger, id_bew):
    
    id = id_bew.id
    fert_date = id_bew.date
        
    # go through all fertlisers of this location
    for duenger in list_of_org_duenger:
        d_start_date = duenger.start_date
        d_end_date = duenger.end_date
        d_exception = duenger.exception_date
        d_id = duenger.id
        
        
        if (d_end_date == None):            
            
            # a specific application date was given
            if (d_start_date == fert_date):
                return d_id
            
        if (d_end_date != None):
            
            # a date range for the application of this fertiliser was specified
            if (fert_date>=d_start_date and fert_date<=d_end_date):
                
                if (d_exception != fert_date):
                    return d_id
        
            
        
# --------------------------------------------------------------        

"""
"""
class GaerrestDuenger:
    
    def __init__(self, id, location, start, end, exception=None):
        self.id = id
        self.location = location
        self.start_date = start
        self.end_date = end
        self.exception_date = exception


# --------------------------------------------------------------  

"""
"""
class IdBewDaten:
    
    def __init__(self, id, arbeit, date):
        self.id = id
        self.arbeit = arbeit
        self.date = date


# --------------------------------------------------------------  
# --------------------------------------------------------------      
main()
# --------------------------------------------------------------      
# --------------------------------------------------------------      
