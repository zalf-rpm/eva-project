import MySQLdb
import sys
import numpy
import os
import csv
import datetime

"""
main routine: configuration of a test case
"""
#def main():
#    add_simulation_to_sql_db(11,        # location
#                             1,         # classification
#                             1,         # amlage
#                             "01",      # fruchtfolge                             
#                             "/home/specka/devel/git/models/monica/python/"
#                             "eva2/ascha/ff01/anlage-1/results/2011-08-12_15-12-45-profil-21",# output_path
#                              "2005-01-01", # start_date
#                              "2008-12-31") # end_date


"""
Interface method that is called by individual python scripts
for adding simulation results into the EVA_MONICA database
"""
def add_simulation_to_sql_db(standort, klassifikation,variante, fruchtfolge, output_path, start_date, end_date):
    
    print "standort: ", standort
    print "klassifikation: ", klassifikation
    print "variante: ", variante
    print "fruchtfolge: ", fruchtfolge
    
    id_pg = str(standort) + str(klassifikation) + str(variante) + str(fruchtfolge)
    print "Adding simulation of \"" + str(id_pg) + "\" to database"
    
    conn = get_db_connection()   
    cursor = conn.cursor()
    
    simulation_date = datetime.datetime.today().strftime("%Y-%m-%d") 
    simulation_time =  datetime.datetime.today().strftime("%H:%M:%S")    
    
    smout = read_file(output_path, "smout.dat")    
    rmout = read_file(output_path, "rmout.dat")
    
    write_simulations(cursor, id_pg, standort, klassifikation, fruchtfolge, variante, simulation_date, simulation_time, start_date, end_date )
    write_ergebnisse(cursor, id_pg, smout, rmout, standort, klassifikation, fruchtfolge, variante, simulation_date, simulation_time)
    

def write_simulations(cursor, id_pg, standort, klassifikation, fruchtfolge, variante, simulation_date, simulation_time, start_date, end_date ):

    values = [str(id_pg), str(standort),str(klassifikation), str(fruchtfolge), str(variante), str(simulation_date), str(simulation_time), str(start_date), str(end_date),"%s"]
    query = """INSERT INTO Simulationen (ID_Pg, ID_Standort, Klassifikation, Fruchtfolge, Anlage, SimDatum, SimTime, StartDatum, EndDatum, ID)
             VALUES (\"""" + '\",\"'.join(values) + """\")"""
    
    print "Adding entry to simulations table"
    print query
    try:
        cursor.execute(query, [None])
    except:
        pass

"""

"""
def write_ergebnisse(cursor, id_pg, smout, rmout, standort, klassifikation, fruchtfolge, variante, simulation_date, simulation_time):

    smout_header = get_header(smout)
    rmout_header = get_header(rmout)
    
    smout_map = get_smout_indices_map(smout_header)
    rmout_map = get_rmout_indices_map(rmout_header)
    
    smout_keys = smout_map.keys()
    rmout_keys = rmout_map.keys()
    
    simulation_id = get_simulation_id(cursor, id_pg, simulation_date, simulation_time)
    
    place_holder =["%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s"]
    for n in range(len(smout_keys)):
        place_holder.append("%s")
    for n in range(len(rmout_keys)):
        place_holder.append("%s")
        
    values = []
    counter = 0
    smout_keys = []
    rmout_keys = []
    
    for rm_row, sm_row in zip(rmout, smout):
        
        # skip first line of rmout and smout because its the table header
        
        # initialse first 4 columns
        x = [None, str(id_pg), str(simulation_date), str(simulation_time),str(standort), str(klassifikation), str(fruchtfolge), str(variante), str(simulation_id)]
        
        for key, value in smout_map.iteritems():
            if (counter == 0):
                key = str(key).replace('-','_')
                smout_keys.append(key)
                check_column(cursor, key)
                
            if (key == "Datum"):
                # formating of date string into MySQL Format
                date_str = sm_row[value]
                str_list = date_str.split("/")
                date  = "-".join([str_list[2], str_list[1], str_list[0]])
                x.append(date)
            else:            
                x.append(str(sm_row[value]))
            
        for key, value in rmout_map.iteritems():   
            if (counter == 0):
                key = key.replace("-","_")
                rmout_keys.append(key)   
                check_column(cursor, key)
                  
            x.append(str(rm_row[value]))
        
        values.append(x)
        counter+=1
        
        query = """INSERT INTO Ergebnisse (ID, id_pg, SimDatum, SimTime, 
                ID_Standort, Klassifikation, Fruchtfolge, Anlage, ID_Simulation, """ + ','.join(smout_keys) + """
                ,""" +  ','.join(rmout_keys) + """) VALUES (""" + ','.join(place_holder) + """)"""
            
            
        if (counter%500 == 0):
            print "Executing query:"
            cursor.executemany(query, values)
            values = []        
    
    print "Executing query:"
    
    query = """INSERT INTO Ergebnisse (ID, id_pg, SimDatum, SimTime, 
            ID_Standort, Klassifikation, Fruchtfolge, Anlage, ID_Simulation, """ + ','.join(smout_keys) + """
            ,""" +  ','.join(rmout_keys) + """) VALUES (""" + ','.join(place_holder) + """)"""
    cursor.executemany(query, values)

    
    cursor.close()


"""
Returns a map with columns of the smout file
"""
def get_smout_indices_map(header):
        
    map = {}
    
    keys = ["Datum", "Stage", "Height","Root", "Root10", "Leaf",
            "Shoot", "Fruit","AbBiom", "AbGBiom","Yield","EarNo",
            "GrainNo","LAI","AbBiomNc","YieldNc","AbBiomN","YieldN",
            "TotNup","NGrain","Protein","BedGrad","M0-30","M30-60",
            "M60-90","M0-60","M0-90","PAW0-200","PAW0-160","PAW0-130",
            "N0-30","N30-60","N60-90","N0-60","N0-90","N0-200",
            "N0-160","N0-130","NH430","NH460","NH490","Co0-10","Co0-30",
            "T0-10","T20-30","T50-60","CO2","NH3","N2O","N2","Ngas",
            "NFert","Irrig"]
    
    for key in keys:
        if (key not in header):
            print "ERROR: Cannot find " + key + " in smout file"
            sys.exit(-1)
            
        map[key] = header.index(key)

    return map

"""
Returns a map with columns of the rmout file
"""
def get_rmout_indices_map(header):
        
    map = {}
    
    keys = ["TraDef","Tra","NDef","TempSum","VernF","DaylF","IncLeaf",
            "NetPhot","RelDev","GroPhot","Assim","Assim","Maint","MaintAS",
            "GPP","NPP","StomRes","RootDep","NBiom","SumNUp","ActNup",
            "PotNup","Target","CritN","HeatRed","Mois0","Mois1","Mois2",
            "Mois3","Mois4","Mois5","Mois6","Mois7","Mois8","Mois9","Mois10",
            "Mois11","Mois12","Mois13","Mois14","Mois15","Mois16","Mois17",
            "Mois18","Mois19","Precip","Infilt","Surface","RunOff","SnowD",
            "FrostD","ThawD","SurfTemp","STemp0","STemp1","STemp2","STemp3",
            "STemp4","act_Ev","act_ET","ET0","Kc","atmCO2","Groundw","Recharge",
            "NLeach","NO3-0","NO3-1","NO3-2","NO3-3","NO3-4","NO3-5","NO3-6",
            "NO3-7","NO3-8","NO3-9","NO3-10","NO3-11","NO3-12","NO3-13","NO3-14",
            "NO3-15","NO3-16","NO3-17","NO3-18","NO3-19","SOC-0","SOC-1","SOC-2",
            "SOC-3","AOMf-0","AOMs-0","SMBf-0","SMBs-0","SOMf-0","SOMs-0","CBal-0",
            "Nmin-0","Nmin-1","Nmin-2","NetNmin","SumDenit","NEP","NEE","tmin",
            "tavg","tmax","wind","globrad","relhumid","sunhours"]
    
    for key in keys:
        
        if (key not in header):
            print "ERROR: Cannot find " + key + " in rmout file"
            sys.exit(-1)
            
        map[key] = header.index(key)
    
    return map
    

"""
Opens a file in CSV mode and returns csv-handle
"""    
def read_file(output_path, file):
    
    print output_path + "/" + file 
    file = csv.reader(open(output_path + "/" + file , "rb"),delimiter='\t')
    return file

    
"""
Checks if column exists; if not, a new column will be created
in 'Ergebnisse' table
"""
def check_column(cursor,key):
    
    query = """ALTER TABLE Ergebnisse ADD COLUMN """ + key + """ DOUBLE"""
    try:
        cursor.execute(query)
    except:
        pass

    
    query2 = """INSERT INTO Abk_MONICA_Outputs (Abk) VALUES (\"""" + key + """\")"""
    try:
        cursor.execute(query2)
    except:
        pass
    
"""
Creates database connection to eva database
"""    
def get_db_connection():
    conn = MySQLdb.connect (host = "mysql",
                            user = "specka",
                            passwd = "figaro06",
                            db = "EVA_MONICA_Ergebnisse")
    return conn  

def get_header(csv):
    
    csv_header = []
    for row in csv:
        for item in row:
            csv_header.append(item.strip())
        return csv_header
    

def get_simulation_id(cursor, id_pg, simulation_date, simulation_time):
    query = """SELECT id FROM Simulationen where id_pg=\"""" + str(id_pg) + """\" AND SimDatum=\"""" + simulation_date + """\" AND SimTime=\"""" + simulation_time + """\" """
    
    print query
    cursor.execute(query)    
    rows = cursor.fetchall()
    
    for row in rows:
        for item in row:
            print "Simulation ID: ", item
            return item
    
#main()
