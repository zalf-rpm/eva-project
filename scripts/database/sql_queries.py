import MySQLdb
import sys
import numpy
import os
import database_config

separator=";"

# TODO: important output directory
data_directory = "E:/Eigene Dateien prescher/eva_messdaten"


ff = None
location = None
location_id = None
klassifikation = None
mess_station = None
exit_on_error = 0
start_year = None
end_year = None

print sys.argv

if (len(sys.argv)>=5):
    ff = str(sys.argv[1])
    anlage_param = int(sys.argv[2]) 
    location = str(sys.argv[3])
    location_id = int(sys.argv[4])

if (len(sys.argv)>=6):    
    klassifikation = int(sys.argv[5])

#########################################
# some configurations
#########################################


# define which 'anlagen' should be calculated
# if more than one 'anlage' is specified in the list,
# both 'anlagen' are calculated sequentielly
# anlage = [1,3] for a simulation from 2005-2011
anlage = None
if (anlage_param == 1):
    anlage = [1]    
elif (anlage_param == 2):
    anlage = [2]
elif (anlage_param == 3):
    anlage = [3]
elif (anlage_param == 4):
    anlage = [4]
elif (anlage_param == 5):
    anlage = [5]
elif (anlage_param == 6):
    anlage = [6]


# build regular exprestion for the id_pg that is later needed in the sql queries
id = str(location_id) + str(klassifikation) + "["
for ind, anl in enumerate(anlage):
    
    id = id + str(anl)
    if (ind < (len(anlage)-1)):
        id = id + str("|")    
id = id + "]" + ff

# name of the test
versuch = "grundversuch"
if (klassifikation == 9):
    versuch = "gaerrest"

# some debug output
print "Klassifikation: ", klassifikation, versuch, id, anlage

# create directory to save data
rootpath = data_directory+ "/" + location + "/" + versuch + "/" + "ff" + ff + "/anlage-" + str(anlage_param) + "/"
if (os.path.isdir(rootpath) == False):
    os.makedirs(rootpath)
    

print "Speicherpfad der SQL-Dateien: ", rootpath
query_file = open(rootpath + "/sql_abfragen.txt", "w")

def main():


    
    
    # login data for the my sql database
    conn = MySQLdb.connect (host = database_config.hostname,
                       user = database_config.username,
                       passwd = database_config.passwd,
                       db = database_config.database)
    cursor = conn.cursor ()   

    # comment queries that should not be executed
    query_yield(conn, cursor, id, "ertrag.txt")
    query_bedgrad(conn, cursor, id, "bedgrad.txt")
    query_yield_n(conn, cursor, id, "yield_n.txt")
    query_n_zeiternte(conn, cursor, id, "n_zeiternte.txt")
    query_zwischenernte(conn, cursor, id, "zwischenernte.txt")
    query_hoehe(conn, cursor, id, "hoehe.txt")
    query_nmin(conn, cursor, id, "nmin.txt")
    query_wasser(conn, cursor, id, "wasser.txt")
    query_bodtemp(conn, cursor, id, location_id)
    query_fertilizer(conn, cursor, id, "fertilizer.txt")
    query_bbch(conn, cursor, id, "bbch.txt")
    query_maengel(conn,cursor,id,"maengel_ereignis.txt")
    
    # v4 is the name of some Müncheberger Tests
    #query_v4_water(conn, cursor, mess_station, "wasser-v4.txt")

    conn.close()   
    
    query_file.close()
    


############################################
# ertrag.txt
############################################
def query_yield(conn, cursor, id, filename):
    
    query_string = """SELECT id_ertrag, id_pg, sagwdh, sorte, id_termin, id_probenform, 
                   datumernte, bbch_ist, bbch_vorgabe, efl_m2, ertfm_jeefl_kg, tm_prz 
                   FROM 2_10_Ertraege E 
                   WHERE id_pg in (SELECT id_pg FROM 2_10_Ertraege B 
                       WHERE id_pg REGEXP \'""" + id + """\')
                   AND (id_termin>=61 and id_termin<=67) 
                   AND (id_probenform=20 or id_probenform=40 or id_probenform=30) 
                   AND (ertfm_jeefl_kg>0.0 and tm_prz>0.0)
                   AND (M_TM=\"TM105\")
                   AND Q_Efl not like \"u\"
                   AND Q_FM_jeEfl not like \"u\"
                   AND Q_TM not like \"u\" 
                   order by datumernte """
                   
    print >> query_file, "##################################"
    print >> query_file, "# ertrag.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file, "\n\n"
    
    print query_string
    print
    cursor.execute(query_string)    
    rows = cursor.fetchall()
        
    header = ["id_ertrag", "id_pg", "sagwdh", "sorte", "id_termin", "id_probenform",
              "datumernte", "bbch_ist", "bbch_vorgabe", "efl_m2", "ertfm_jeefl_kg", "tm_prz"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)
    
        
############################################
# bedgrad.txt
############################################
def query_bedgrad(conn, cursor, id, filename):
    
    if (location_id == 27):
    
        query_string = """SELECT E.id_pg, E.sagwdh, E.id_ereignis, E.datumereignis, 
                        E.id_probenform, E.Wert AS messwert_orig, E.E_Wert , avg(D.Deckungsgrad_Prz) as messwert, D.Einheit
                        FROM 2_40_Ereignis as E, S_Deckungsgrad_Ujvarosi_Londo as D 
                        WHERE(E.Wert = D.Boniturwert)
                        and id_pg in (SELECT id_pg FROM 2_40_Ereignis B 
                            WHERE id_pg REGEXP \'""" + id + """\')
                        AND E.id_ereignis=31
                        AND D.Einheit="Ujv.-Note"
                        group by E.datumereignis"""
        header = ["id_pg", "sagwdh", "id_ereignis", "datumereignis", "id_probenform", "messwert_orig", "E_Wert",
                  "messwert", "Einheit"]
        
    else:
        query_string = """SELECT id_pg, id_ereignis, datumereignis, id_probenform, avg(Wert) AS messwert, E_Wert 
                        FROM 2_40_Ereignis E
                        WHERE id_pg in (SELECT id_pg FROM 2_40_Ereignis B 
                           WHERE id_pg REGEXP \'""" + id + """\')                        
                        AND id_ereignis=31
                        AND datumereignis<=\"""" + end_year + """\"
                        GROUP BY datumereignis
                        """
        header = ["id_pg", "id_ereignis", "datumereignis", "id_probenform", "messwert", "E_Wert"]
    
    print >> query_file, "##################################"    
    print >> query_file, "# bedgrad.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
    
    print query_string
    print

    cursor.execute(query_string)    
    rows = cursor.fetchall()
        
    
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)


############################################
# yield_n.txt
############################################
def query_yield_n(conn, cursor, id, filename):
    
    query_string = """SELECT id_pg, sagwdh, id_termin, id_probenform, datumernte, c_prz, n_prz 
                    FROM 2_20_Pflanze_Elemente E 
                    WHERE id_pg in (SELECT id_pg FROM 2_20_Pflanze_Elemente B 
                           WHERE id_pg REGEXP \'""" + id + """\') 
                    AND (id_probenform=20 or id_probenform=40 or id_probenform=30)
                    AND n_prz>0.0 
                   AND (id_termin>=61 and id_termin<=67)order by datumernte, sagwdh """
                   
    print >> query_file, "##################################"
    print >> query_file, "# yield_n.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
        
    header = ["id_pg", "sagwdh", "id_termin", "id_probenform", "datumernte", "c_prz", "n_prz" ]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)




############################################
# n_zeiternte.txt
############################################
def query_n_zeiternte(conn, cursor, id, filename):
    
    query_string = """SELECT id_pg, sagwdh, id_termin, id_probenform, datumernte, c_prz, n_prz 
                    FROM 2_20_Pflanze_Elemente E 
                    WHERE id_pg in (SELECT id_pg FROM 2_20_Pflanze_Elemente 
                           WHERE id_pg REGEXP \'""" + id + """\') 
                    AND n_prz>0.0
                   AND id_termin!=61 and id_termin<61 order by datumernte """

    print >> query_file, "##################################"
    print >> query_file, "# n_zeiternte.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"        
               
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
        
    header = ["id_pg", "sagwdh", "id_termin", "id_probenform", "datumernte", "c_prz", "n_prz" ]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)


############################################
# zwischenernte.txt
############################################
def query_zwischenernte(conn, cursor, id, filename):
    
    query_string = """SELECT id_ertrag, id_pg, sagwdh, sorte, id_termin, id_probenform, 
                    datumernte, bbch_ist, bbch_vorgabe, efl_m2, ertfm_jeefl_kg, tm_prz
                    FROM 2_10_Ertraege E 
                    WHERE id_pg in (SELECT id_pg FROM 2_10_Ertraege 
                           WHERE id_pg REGEXP \'""" + id + """\')
                    AND (datumernte not in ( SELECT datumernte FROM 2_10_Ertraege E WHERE id_pg like \"""" + id + """%\" AND id_termin=61 and datumernte is not null group by datumernte ))
                    AND id_termin!=61 and id_termin<61
                    AND (efl_m2<>0 and ertfm_jeefl_kg<>0 and tm_prz>0.0)  
                    and tm_prz is not NULL
                    and efl_m2 is not null
                    AND (id_probenform=20 or id_probenform=40 or id_probenform=31)
                    AND (M_TM=\"TM105\")
                    order by datumernte                   
                   """
    print >> query_file, "##################################"
    print >> query_file, "# zwischenernte.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
            
    header = ["id_ertrag","id_pg","sagwdh","sorte","id_termin","id_probenform","datumernte","bbch_ist",
              "bbch_vorgabe","efl_m2","ertfm_jeefl_kg","tm_prz"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)
    
    
    
############################################
# hoehe.txt
############################################
def query_hoehe(conn, cursor, id, filename):
    
    query_string = """SELECT id_pg, sagwdh, id_ereignis, datumereignis, avg(Wert) as messwert, E_Wert 
                    FROM 2_40_Ereignis E
                    WHERE id_pg in (SELECT id_pg FROM 2_40_Ereignis 
                           WHERE id_pg REGEXP \'""" + id + """\')
                    AND id_ereignis=37 
                    and datumereignis<=\"""" + end_year + """\"
                    and Wert!="---"
                    group by datumereignis
                    order by datumereignis                                         
                   """
    print >> query_file, "##################################"
    print >> query_file, "# hoehe.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
            
    header = ["id_pg","sagwdh","id_ereignis","datumereignis","messwert", "E_Wert"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)
    
    
    
############################################
# nmin.txt
############################################
def query_nmin(conn, cursor, id, filename):
    
    query_string = """SELECT id_pg, sagwdh, datumbdprobe, tiefe_cm, avg(no3_n_kg_jehaschi) AS no3, 
                    avg(nh4_n_kg_jehaschi) AS nh4 
                    FROM 2_30_Boden_jaehrl_Analysen B 
                    WHERE id_pg in (SELECT id_pg FROM 2_30_Boden_jaehrl_Analysen 
                           WHERE id_pg REGEXP \'""" + id + """\')
                    AND datumbdprobe IS NOT NULL                   
                    and datumbdprobe<=\"""" + end_year + """\"
                    and q_no3_n not like \"u\" and q_nh4_n not like \"u\" 
                    group by datumbdprobe, tiefe_cm   
                    order by datumbdprobe                                   
                    """
    
    print >> query_file, "##################################"
    print >> query_file, "# nmin.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                   
    print query_string
    print
    
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
            
    header = ["id_pg","sagwdh","datumbdprobe","tiefe_cm","no3","nh4"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)    
    
    
    
############################################
# wasser.txt
############################################
def query_wasser(conn, cursor, id, filename):
    
    query_string = """SELECT id_pg, sagwdh, datumbdprobe, tiefe_cm, avg(h2o_przm) as h2o 
                    FROM 2_30_Boden_jaehrl_Analysen B 
                    WHERE id_pg in (SELECT id_pg FROM 2_30_Boden_jaehrl_Analysen 
                           WHERE id_pg REGEXP \'""" + id + """\')
                    AND datumbdprobe IS NOT NULL
                    and datumbdprobe>=\"""" + start_year + """\"                   
                    and datumbdprobe<=\"""" + end_year + """\"
                    and h2o_przm != 0
                    group by datumbdprobe, tiefe_cm  
                    order by datumbdprobe                                     
                    """
                    
    print >> query_file, "##################################"
    print >> query_file, "# wasser.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                   
    print query_string
    print
    
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
            
    header = ["id_pg","sagwdh","datumbdprobe","tiefe_cm","h2o"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename)    
    
############################################
# Bodentemperature.txt
############################################
def query_bodtemp(conn, cursor, id, location):
    
    messgroessen = [20050, 20100, 20200, 20300, 20500, 20750, 21000]
    files = ["bodtemp5cm.txt", "bodtemp10cm.txt", "bodtemp20cm.txt", "bodtemp30cm.txt", "bodtemp50cm.txt", "bodtemp75cm.txt", "bodtemp100cm.txt"]
    
    for index, messgroesse in enumerate(messgroessen):
        
        print "Bodentemperatur: ", messgroesse
        filename = files[index]
    
        wstation_query = """SELECT W_Station_kurz FROM S_W_Station 
                            WHERE id_w_station in (SELECT id_w_station FROM S_W_Station_je_Messgroesse
                            WHERE id_messgroesse=""" + str(messgroesse) + """ 
                            AND ID_Standort= """ + str(location) + """ 
                            AND ((Alternative="Standard") OR (Alternative is null))
                            ORDER BY startdatum)"""
                        
        print wstation_query
            
        cursor.execute(wstation_query)    
        rows = cursor.fetchall()
        if (len(rows) == 0):
            continue
        
        wstations = rows
        print "WSTATION: ", wstations
        wstation_text = ""
        if (len(wstations) == 1):
            wstation = wstations[0][0]
            wstation_text = """ WHERE wstation=\"""" + wstation + """\" """            
        else:
            wstation_text = """ WHERE ( """ 
            for wnr, wstation in enumerate(wstations):
                if (wnr==0):
                    wstation_text +=  """wstation=\"""" + wstation[0] + """\" """
                else:      
                    wstation_text +=  """ or wstation=\"""" + wstation[0] + """\" """
            wstation_text +=""")"""
        
                                    
        
        query_string = """SELECT Datum, Wert,id_messgroesse, WStation
                          FROM 1_50_Wetter""" + wstation_text + """
                          AND id_messgroesse = """ + str(messgroesse) + """
                          AND Datum>=\"""" + start_year + """\"                   
                          AND Datum<=\"""" + end_year + """\"
                          AND Wert is not NULL
                          group by Datum order by Datum                                     
                           """
                    
        print >> query_file, "######################################"
        print >> query_file, "# bodtemp-" + str(messgroesse) + ".txt"                   
        print >> query_file, "#######################################"
        print >> query_file, query_string
        print >> query_file,"\n\n"
                       
        print query_string
        print
        
        
        cursor.execute(query_string)    
        rows = cursor.fetchall()
                
        header = ["Datum", "Wert", "Messgroesse", "WStation"]
        
        if (cursor.rowcount == 0):
            print "WARNING: query got no result!"
            print query_string
        else:
            save_query_results(rows, header, filename)   
        
        print "-------------------------------"
    
    
############################################
# fertilizer.txt
############################################
def query_fertilizer(conn, cursor, id, filename):
    
    query_string = """SELECT T.id_pg, T.Datum, D.id_duenger, D.Menge, S.Nges_PrzFM
                    FROM 2_60_Bew_Daten as T 
                    INNER JOIN 2_63_Betriebsmittel_Duenger as D
                    on T.id_bew_daten = D.id_bew_daten
                    INNER JOIN S_Duenger as S
                    on D.id_Duenger = S.ID_Duenger
                    where T.id_pg in (SELECT id_pg FROM 2_60_Bew_Daten 
                           WHERE id_pg REGEXP \'""" + id + """\')  
                    and T.id_arbeit like "3%"   
                    and (S.Nges_PrzFM is not NULL or D.id_duenger = "D143")
                    and (S.Nges_PrzFM != \"0\" or D.id_duenger = "D143") 
                    group by T.Datum     
                    order by T.Datum                                   
                    """
                    
                    #and S.N_Prz is not NULL
                    #and S.N_Prz != \"0\"
    
    print >> query_file, "##################################"
    print >> query_file, "# fertilizer.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                  
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
            
    header = ["id_versuch", "Datum", "Duenger", "Menge", "Nges_PrzFM"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename) 
        
    
############################################
# bbch.txt
############################################
def query_bbch(conn, cursor, id, filename):
    
    query_string = """SELECT id_pg, BBCH_Ist, Datumereignis FROM 2_40_Ereignis E 
                     WHERE id_pg in (SELECT id_pg FROM 2_40_Ereignis 
                           WHERE id_pg REGEXP \'""" + id + """\')
                    and 0 < BBCH_Ist
                    and Datumereignis is not NULL
                    and BBCH_Ist is not NULL group by BBCH_Ist
                    order by datumereignis                                   
                    """
    
    print >> query_file, "##################################"
    print >> query_file, "# bbch.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
            
    header = ["id_pg", "BBCH_Ist","Datumereignis"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
    
    save_query_results(rows, header, filename) 
    
    
############################################
# maengel_ereignis.txt
############################################
def query_maengel(conn, cursor, id, filename):
    
    query_string = """SELECT id_pg, SagWdh,ID_Ereignis,Ereignis_spez,ID_Termin, DatumEreignis,BBCH_Ist,MP,
                      ID_Probenform, Wert, E_Wert, Q_Wert, M_Wert, BBCH_Vorgabe,Info_Ereignis
                     FROM 2_40_Ereignis E 
                    WHERE id_pg in (SELECT id_pg FROM 2_40_Ereignis 
                           WHERE id_pg REGEXP \'""" + id + """\')
                    and ((id_ereignis=50 and wert>=5) or
                    (id_ereignis=33 and wert>=10))
                    order by datumereignis                                   
                    """
    
    print >> query_file, "##################################"
    print >> query_file, "# maengel_ereignis.txt"                   
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"
                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
            
    header = ["id_pg", "SagWdh","ID_Ereignis","Ereignis_spez","ID_Termin", "DatumEreignis","BBCH_Ist","MP",
              "ID_Probenform", "Wert", "E_Wert", "Q_Wert", "M_Wert", "BBCH_Vorgabe","Info_ereignis"]
    
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        #if (exit_on_error):
            #sys.exit(1)
    
    save_query_results(rows, header, filename)     
    
    
    
def query_v4_water(conn, cursor, mess_station, filename):    
    
    query_string = """SELECT datum, wert FROM 3c_Boden_taegl_Messungen where mess_station = """ + str(mess_station) + """
                      and id_parameter = 80300 
                      AND datum IS NOT NULL                   
                      AND datum<=\"""" + str(end_year) + """\"
                      AND datum>=\"""" + str(start_year) + """\" """
    
    print >> query_file, "##################################"
    print >> query_file, "# V4 Bodenwasser 0-30cm"
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
                
    
    new_rows = []
    for r in rows:
        row = []
        for i in r:
            row.append(i)
        row.append("0-30")
        new_rows.append(row)
        
    # ---------------------------------------------        
        
    query_string = """SELECT datum, wert FROM 3c_Boden_taegl_Messungen where mess_station = """ + str(mess_station) + """
                      and id_parameter = 80600 
                      AND datum IS NOT NULL                   
                      AND datum<=\"""" + str(end_year) + """\"
                      AND datum>=\"""" + str(start_year) + """\" """
    
    print >> query_file, "##################################"
    print >> query_file, "# V4 Bodenwasser 30-60cm"
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
                
    for r in rows:
        row = []
        for i in r:
            row.append(i)
        row.append("30-60")
        new_rows.append(row)
    
    # ---------------------------------------------        
        
    query_string = """SELECT datum, wert FROM 3c_Boden_taegl_Messungen where mess_station = """ + str(mess_station) + """
                      and id_parameter = 80900 
                      AND datum IS NOT NULL                   
                      AND datum<=\"""" + str(end_year) + """\"
                      AND datum>=\"""" + str(start_year) + """\" """
    
    print >> query_file, "##################################"
    print >> query_file, "# V4 Bodenwasser 30-60cm"
    print >> query_file, "##################################"
    print >> query_file, query_string
    print >> query_file,"\n\n"                   
    print query_string
    print
    
    cursor.execute(query_string)    
    rows = cursor.fetchall()
    if (cursor.rowcount == 0):
        print "ERROR: query got no result!"
        if (exit_on_error):
            sys.exit(1)
                
    for r in rows:
        row = []
        for i in r:
            row.append(i)
        row.append("60-90")
        new_rows.append(row)
        
    header = ["datumbdprobe","h2o", "tiefe_cm"]
    
    save_query_results(new_rows, header, filename)   
    
    

###############################################
#
###############################################
"""
Save results of query into cultivar specific file 
"""
def save_query_results(rows, header, filename):
        
    file = open(rootpath + "/" + filename, "w")
 
    text = ""
    index = 0
    for item in header:
        text += "\"%s\"" % item
        if (index<(len(header)-1)):
            text += separator
        index += 1 
    
    print >> file, text    

    for row in rows:
        index = 0
        text = ""
        for item in row:    
                 
               
            if (item == None):
                item = 0.0
            if (header[index] == "id_pg"):   
                text += "%d" % item
            else:
                text += "%s" % item
            if (index<(len(header)-1)):
                text += separator
            index += 1
        print >> file, text   
                      
    file.close()

"""
Definitions for start and end year
"""
def get_start_and_end_year(klassifikation, anlage):

    start_year = None
    end_year = None

    # define start and end year of the respective 'anlagen'
    if (klassifikation == 1):

        if (anlage_param==1):

            start_year = "2005-01-01"
            end_year= "2008-12-31"

        elif (anlage_param == 2):

            start_year = "2006-01-01"
            end_year= "2009-12-31"

        elif (anlage_param == 3):

            start_year = "2009-01-01"
            end_year= "2011-12-31"

        elif (anlage_param == 4):

            start_year = "2010-01-01"
            end_year= "2011-12-31"
            
    # define start and end year of the respective 'anlagen' of 'gärrest versuch'        
    elif (klassifikation == 9):

        if (anlage_param==1 or anlage_param==2 or anlage_param == 3):

            start_year = "2009-01-01"
            end_year= "2011-12-31"

        elif (anlage_param==4 or anlage_param==5 or anlage_param == 6):

            start_year = "2009-01-01"
            end_year= "2011-12-31"

    return start_year, end_year
    
   
start_year, end_year = get_start_and_end_year(klassifikation, anlage)
main()
