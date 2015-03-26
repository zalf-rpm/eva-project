#!/usr/bin/python
# -*- coding: UTF-8-*-

# Letzte Änderung: 2014-03-10 17:00 (AKP)

import MySQLdb
import sys
import numpy
import csv
import os
import datetime
from scipy import stats
import database_config



# Ausgabeverzeichnis angeben
output_directory="E:/Eigene Dateien prescher/"

#######################################################
# Konfigurationsbereich
standort="11"            # ID des Standortes, für die die Niederschläge korregiert werden sollen
jahr_min = 2005
jahr_max = 2013
debug_output = 1        # Umfangreiche Kommandozeilenausgaben werden mit debug_output=1 aktiviert

#######################################################


separator=";"           # Trennzeichen der CSV-Ausgabedatei

# Konstanten
min=0
max=1


# --------------------------------------------------------------
""" 
Startroutine
"""
def main():
    
    # Test ob das Verzeichnis existiert, wenn nicht, wird eins angelegt
    if (not os.path.isdir(output_directory)):
        os.makedirs(output_directory)   
        
    csv_writer = csv.writer(open(output_directory + "P_corrected_" + str(standort) + "_" + jahr_min + "-" + jahr_max + ".txt", "wb"),delimiter=separator)
    
    
    # write header of csv file
    tmp_stages = getDefStages(frucht)

    if (len(tmp_stages) == 0):
        print "ERROR: FÃ¼r diese Pflanze wurden keine Entwicklungsstadien definiert!"
        sys.exit(-1)
        
    tmp_stages.insert(0, "Stadium")
    csv_writer.writerow(tmp_stages)   
    
    # listen für die Mittelwertsberechnung
    avg_sum = []
    avg_counter = []
    temp_sum_collector = []
    # Initialisierung
    for stage in tmp_stages:
        avg_sum.append(0)
        avg_counter.append(0)
        temp_sum_collector.append([])
    
    
    # Initialisierung der Datenbankverbindung
    conn = MySQLdb.connect (host = database_config.hostname,
                       user = database_config.username,
                       passwd = database_config.passwd,
                       db = database_config.database)

    cursor = db_connection.cursor ()       
    
    
    # Liste von id_pgs ermitteln, in denen die Frucht angebaut worden ist
    list_of_id_pg = getID_PG(cursor, frucht)
    
    print "Analysing " + str(len(list_of_id_pg)) + " id_pg's"
    
    dev_stages = getDefStages(frucht)
    
    # iteriere über alle id_pg in list
    for id_nr, id_pg in enumerate(list_of_id_pg):
                
        print "\n" +  str(id_nr) + "/" + str(len(list_of_id_pg)) + "\t" + str(id_pg)
        
        datum_list = []
        for index, stage in enumerate(dev_stages):
            if (debug_output==1):
                print "Suche Grenzen fuer das " + str(index+1) + ". Entwicklungsstadium " + str(stage) + " raus" 
            
            # Grenzen der BBCH-Stadien aus der Liste von dev_stages entnehmen
            min_bbch = stage[min]
            max_bbch = stage[max]
            delta_bbch = stage[2]
            
            # Initialisierung
            min_datum=None
            max_datum=None
            
            
            # Suche die ungefaehren Datum fÃƒÆ’Ã‚Â¼r die min- und max BBCH Grenzen heraus
            if (index == 0):
                # wenn das erste Stadium behandel wird, dann ist das Aussat-Datum
                # das gesucht Datum fuer min_bbch
                min_datum=getSowingDate(cursor, id_pg)     
                if (min_datum==None) :
                    # if no sowing date, continue with next id_pg
                    csv__missing_writer.writerow([id_pg])
                    datum_list.append([])
                    break      
            else:            
                min_datum=getDatumForBBCH(cursor, min_bbch, id_pg, delta_bbch)
                
            max_datum=getDatumForBBCH(cursor, max_bbch, id_pg, delta_bbch)
            
            if (debug_output==1):    
                print "Min-Datum: " + str(min_datum) + " for BBCH-Grenze " + str(min_bbch)
                print "Max-Datum: " + str(max_datum) + " for BBCH-Grenze " + str(max_bbch)
            
            datum_list.append([min_datum, max_datum])
            #print ""
        
        
        # ÃƒÅ“berprüfen, ob für jedes Stadium auch Datums gefunden wurden
        # wenn nicht, dann ist wohl vorher ein Fehler aufgetreten, wie z.B.
        # kein Saatdatum gefunden
        if (len(datum_list) == len(dev_stages)):

            datum_list = reworkDatumList(datum_list)            
            
            for date in datum_list:
                print str(date)
            
            
            
            # temperatursumme für die Entwicklungsstadien aus Wetterdatenbank ermitteln
            temp_sum_list = getTempSumForDates(cursor, id_pg, datum_list, dev_stages)
            
            for index, sum in enumerate(temp_sum_list):
                if (sum!=None):
                    avg_sum[index] = avg_sum[index] + sum
                    avg_counter[index] = avg_counter[index] + 1
                    temp_sum_collector[index].append(sum)
            
            # vor dem Speichern die id_pg, für die die Temperatursumme gebildet wurde,
            # in die Liste an erster Stelle einfügen
            temp_sum_list.insert(0,id_pg)
        
            # ergebnisse für die id in eine Zeile der CSV-Datei schreiben    
            csv_writer.writerow(temp_sum_list)

        
        
    # Mittelwerteberechnung
    avg_list = ["Mittelwert"]
    median_list = ["Median"]
    min_list = ["Minimum"]
    max_list= ["Maximum"]
    quantil25 = ["1.Quartil"]
    quantil75 = ["3.Quartil"]
    print avg_sum
    for index, avgs in enumerate(avg_sum):
        
        # Test ob werte für das Stadium vorhanden sind
        if (avg_counter[index]>0):
            avg = avgs / avg_counter[index]
            avg_list.append(avg)
        else:
            # für dieses Stadium wurden keine Werte gefunden,
            # also wird auch kein Mittelwert berechnet
            avg_list.append(None)
        
        # Bilde den Median nur, wenn Werte vorhanden sind
        if (len(temp_sum_collector[index])>0):
            median_list.append(numpy.median(temp_sum_collector[index]))
            min_list.append(numpy.min(temp_sum_collector[index]))
            max_list.append(numpy.max(temp_sum_collector[index]))
            quantil25.append(stats.scoreatpercentile(temp_sum_collector[index], 25))
            quantil75.append(stats.scoreatpercentile(temp_sum_collector[index], 75))
        else:
            median_list.append(None)
            min_list.append(None)
            max_list.append(None)
            quantil25.append(None)
            quantil75.append(None)

            

    # Abschliessende Ausgabe in der Datei mit der 
    # statistischen Auswertung            
    avg_counter.insert(0, "Anzahl")
    csv_writer.writerow(avg_counter)
    csv_writer.writerow(avg_list)    
    csv_writer.writerow(min_list)
    csv_writer.writerow(max_list)
    csv_writer.writerow(quantil25)
    csv_writer.writerow(median_list)
    csv_writer.writerow(quantil75)
    
    
# --------------------------------------------------------------

# --------------------------------------------------------------
"""
Stellt eine Abfrage an die Tabelle Tab_Versuchsglieders,
um alle Pruefglieder herauszufinden, in denen die Frucht 
angebaut worden ist
"""    
def getID_PG(cursor, frucht):
    
    query_string = """SELECT id_pg FROM 3_70_Pruefglieder T 
                   WHERE ID_Frucht=\"""" + frucht + """\" """
                      

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
    id_list=[]
    for row in rows:
        for item in row:
            id_list.append(str(int(item)))    
        
    return id_list

# --------------------------------------------------------------
      
# --------------------------------------------------------------
"""
Sucht das Saatdatum zur id_pg heraus ueber eine
Abfrage an Tabelle 2_60_Bew_Daten
"""
def getSowingDate(cursor, id_pg):
    
    query_string = """SELECT Datum FROM 2_60_Bew_Daten WHERE id_pg LIKE \"""" + str(id_pg) + """\" 
                   AND id_arbeit LIKE \"2%\" ORDER by Datum DESC"""                   

    if (debug_output==1):
        print query_string, "\n"
    
    cursor.execute(query_string)    
    
    
    # Abbruch, wenn keine Ergebnisse erzielt wurden
    if (cursor.rowcount == 0):
        print "ERROR: query \n" + query_string + "\n got no result!"
        return None
    
    # das Ergebnis der Datenbankabfrage so umsortieren,
    # dass eine Liste von id_pg entsteht
    row = cursor.fetchone()
        
    return row[0]

# --------------------------------------------------------------

# --------------------------------------------------------------
"""
"""
def getDatumForBBCH(cursor, min_bbch, id_pg, delta_bbch):
    
    query_string = """SELECT DATE(FROM_UNIXTIME(AVG(UNIX_TIMESTAMP(T.datumereignis))))
                    FROM(
                        SELECT id_pg, id_termin, bbch_ist, datumereignis FROM 2_40_Ereignis 
                        WHERE id_pg LIKE \"""" + id_pg + """\" 
                        AND bbch_ist IS NOT NULL
                        AND bbch_ist>=""" + str(min_bbch-delta_bbch) + """ 
                        AND bbch_ist<=""" + str(min_bbch+delta_bbch) + """
                        AND Q_BBCH <> "u"
                        AND bbch_ist <> "---"
                        group by datumereignis
                    ) AS T
                    GROUP BY id_pg"""                   

    if (debug_output==1):
        print query_string, "\n"
    
    cursor.execute(query_string)  
    row = cursor.fetchone()
    
    if (row==None):
        if (debug_output==1):
            print "Keine Ereignis zum genannten BBCH - Bereich vorhanden"
        return None
    
    return row[0]

# --------------------------------------------------------------

# --------------------------------------------------------------
"""
ÃƒÅ“berarbeitet die Liste mit dem Datum, so dass Anfangs- und End-Datum
der Entwicklungsstadien kontinuierlich sind
"""    
def reworkDatumList(datum_list):
    
    if (debug_output==1):
        print "Rework date list"

    for stadium, dates in enumerate(datum_list):
        
        # test ob das minimale datum für das aktuelle
        # stadium unbekannt ist 
        if (datum_list[stadium][min] == None):
            
            # wenn ja, dann prüfen, ob man das maximale
            # datum vom vorherigen stadium nehmen kann
            if (stadium>0 and datum_list[stadium-1][max]!=None):
                datum_list[stadium][min] = datum_list[stadium-1][max]
                
        # test ob das maximale datum für das aktuelle
        # stadium unbekannt ist 
        if (datum_list[stadium][max] == None):
            # wenn ja, dann prüfen, ob man das minimale
            # datum vom nächsten stadium nehmen kann
            if (stadium+1<len(datum_list) and datum_list[stadium+1][min]!=None):
                datum_list[stadium][max] = datum_list[stadium+1][min]
    
        # Berechne den Mittelwert zwischen den Grenzen von zwei Entwicklungsstadium
        # falls max vom alten und min vom neuem stadium nicht identisch sind
        
        if( (stadium+1<len(datum_list)) and         # test ob noch nicht im letzten stadium angekommen 
            (datum_list[stadium][max]!=None) and    # test, ob im max-Datum des aktuellen stadiums ein gültiger Wert enthalten ist
            (datum_list[stadium+1][min]!=None) and  # test, ob im min-Datum des nächsten stadiums ein gültiger Wert enthalten ist
            (datum_list[stadium][max] != datum_list[stadium+1][min]) #  test ob max des aktuellen und min des nächsten Stadiums unterschiedlich sind
            ):
            
            print "Berechne das mittlere Datum von " + str(datum_list[stadium][max]) + " und " + str(datum_list[stadium+1][min])
            diff = datum_list[stadium+1][min] - datum_list[stadium][max]
            days = diff.days // 2
            print days
            
            # addiere die tage zum maximalen datum des aktuellen stadiums
            datum_list[stadium][max] = datum_list[stadium][max] + datetime.timedelta(days)
            
            # setzte das minimale datum des nächsten stadiums auf das aktuelle max datum
            datum_list[stadium+1][min] = datum_list[stadium][max]
            print "Neues Datum = " + str(datum_list[stadium][max])
            
            
        return datum_list

# --------------------------------------------------------------

# --------------------------------------------------------------
"""
Abfrage der Wetterdaten für die id_pg in dem Zeitraum des 
Entwicklungsstadiums. Wenn die Grenz-Datum fehlen, dann wird
None in die Liste eingefügt, weil einfach keine Temperatursumme
ermittelt werden kann
"""
def getTempSumForDates(cursor, id_pg, datum_list, stages):
    
    temp_sum_list = []
    
    # Iteriere über jedes Datum-Tupel
    for stadium, datum in enumerate(datum_list):
        print "Stadium", stadium
        # Teste, ob es eine gültige minimale und maximale Datumsgrenze gibt
        if (datum[min]!=None and datum[max]!=None):
            # Stationnamen der Wetterstation des Standorts ermitteln
            
            base_temperature = str(stages[stadium][3])

            if (stadium == 0):
                
                diff = datum[min] - datum[max]
                days = numpy.abs(diff.days) + 1
                
                # first test if soil temperature values are available for 5 cm
                messgroesse = 20050
                station = getClimateStationForID_PG(cursor, id_pg, messgroesse)    
                if (station!=None):
                    query_string = """SELECT SUM(Wert-""" + base_temperature + """), count(Wert) FROM 1_50_Wetter W 
                                      WHERE id_messgroesse=""" + str(messgroesse) + """
                                      AND wstation=\"""" + station + """\"
                                      AND datum>=\"""" + str(datum[min]) + """\"
                                      AND datum<=\"""" + str(datum[max]) + """\" 
                                      AND Wert>""" + base_temperature
                    
                    if (debug_output==1):
                        print query_string, "\n"
                    
                    cursor.execute(query_string)
                    row = cursor.fetchone()
                    print "Rows1: ",row[1], days
                    if (int(row[1]) == days):                             
                        temp_sum_list.append(row[0])
                        continue
                    
                        
                # test if there are soil temperature values available for 10 cm
                messgroesse = 20100
                station = getClimateStationForID_PG(cursor, id_pg, messgroesse)    
                if (station!=None):
                    query_string = """SELECT SUM(Wert-""" + base_temperature + """), count(Wert) FROM 1_50_Wetter W 
                                  WHERE id_messgroesse=""" + str(messgroesse) + """
                                  AND wstation=\"""" + station + """\"
                                  AND datum>=\"""" + str(datum[min]) + """\"
                                  AND datum<=\"""" + str(datum[max]) + """\" 
                                  AND Wert>""" + base_temperature
                                  
                    cursor.execute(query_string)
                    row = cursor.fetchone()
                    print row
                    print "Rows2: ",row[1], days
                    if (int(row[1]) == days):                             
                        temp_sum_list.append(row[0])
                        continue
                    
                    
                # test if there are soil temperature values available for 10 cm
                messgroesse = 20200
                station = getClimateStationForID_PG(cursor, id_pg, messgroesse)    
                if (station!=None):
            
                    query_string = """SELECT SUM(Wert-""" + base_temperature + """), count(Wert) FROM 1_50_Wetter W 
                                  WHERE id_messgroesse=""" + str(messgroesse) + """
                                  AND wstation=\"""" + station + """\"
                                  AND datum>=\"""" + str(datum[min]) + """\"
                                  AND datum<=\"""" + str(datum[max]) + """\" 
                                  AND Wert>""" + base_temperature
                                  
                    cursor.execute(query_string)
                    row = cursor.fetchone()
                    print row
                    print "Rows3: ",row[1], days
                    if (int(row[1]) == days):                             
                        temp_sum_list.append(row[0])
                        continue
        
                
            else:
                messgroesse = 12000
                station = getClimateStationForID_PG(cursor, id_pg, messgroesse)
                if (station!=None):
                    query_string = """SELECT SUM(Wert-""" + base_temperature + """) FROM 1_50_Wetter W 
                                      WHERE id_messgroesse=""" + str(messgroesse) + """ 
                                      AND wstation=\"""" + station + """\"
                                      AND datum>=\"""" + str(datum[min]) + """\"
                                      AND datum<=\"""" + str(datum[max]) + """\" 
                                      AND Wert>""" + base_temperature
                    
                    if (debug_output==1):
                        print query_string, "\n"
                    
                    cursor.execute(query_string)    
                    row = cursor.fetchone()
                    
                    # Abbruch, wenn keine Ergebnisse erzielt wurden
                    if (cursor.rowcount == 0):
                        print "ERROR: query \n" + query_string + "\n got no result!"
                        sys.exit(1)
                    temp_sum_list.append(row[0])

        else:
            # einen leeren Eintrag hinzufügen, wenn die Datumsgrenzen
            # nicht definiert waren
            temp_sum_list.append(None)
            
    return temp_sum_list
# --------------------------------------------------------------

# --------------------------------------------------------------
"""
Den Namen der Wetterstation herausfinden aufgrund der
Standortinformation in der id_pg
"""
def getClimateStationForID_PG(cursor, id_pg, messgroesse):
    
    standort_id = id_pg[0:2]
    
    query_string = """SELECT id_w_station 
                      FROM S_W_Station_je_Messgroesse S 
                      WHERE id_messgroesse=""" + str(messgroesse) + """ and id_standort=""" + str(standort_id) + """
                      """
    
    if (debug_output==1):
        print query_string, "\n"
    
    cursor.execute(query_string)    
    row = cursor.fetchone()
    
    # Abbruch, wenn keine Ergebnisse erzielt wurden
    if (cursor.rowcount == 0):
        return None
    
    # das Ergebnis der Datenbankabfrage so umsortieren,
    # dass eine Liste von id_pg entsteht
    id_station = row[0]
    
    query_string = """SELECT w_station_kurz FROM S_W_Station S 
                      WHERE id_w_station=""" + str(id_station)
                      
    if (debug_output==1):
        print query_string, "\n"
    
    cursor.execute(query_string)    
    row = cursor.fetchone()
    
    station_name = row[0]
    
    return station_name

# --------------------------------------------------------------

main()        
