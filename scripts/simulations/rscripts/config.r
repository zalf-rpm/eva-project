source("dir_config.r")
source("profil_configuration.r")

calc_ertrag         = 1
calc_soilmoisture   = 1
calc_soilnmin       = 1
calc_nconc          = 1
calc_bedgrad        = 1
calc_height         = 1
calc_bbch           = 1
calc_wasser_v4      = 0
calc_bodtemp        = 1

compare_with_measured_values = 1

if (standort==16) {
  location = "dornburg"
} else if (standort == 11) {
  location = "ascha"
} else if (standort == 17) {
  location = "ettlingen"
} else if (standort == 18) {
  location = "guelzow"
} else if (standort == 19) {
  location = "gueterfelde"
} else if (standort == 25) {
  location = "trossin"
} else if (standort == 27) {
  location = "werlte"
} else if (standort == 59) {
  location = "muencheberg"
} else if (standort == 44) {
  location = "bernburg"
}

if (classification == 1) {
  if (anlage==1) {
    legend_year=2009
  } else if (anlage==2) {
    legend_year=2010  
  } else if (anlage==3) {
    legend_year=2012    
  } else if (anlage==4) {
    legend_year=2012  
  }
  
  legend_date=ISOdate(legend_year,7,1)
  legend_date2=ISOdate(legend_year,7,1)
  legend_date3=ISOdate(legend_year,9,1)
}

if (classification == 9) {
 if (anlage == 1 || anlage==2 || anlage==3) {
    legend_year=2012
  } else if (anlage == 4 || anlage==5 || anlage==6) {
    legend_year=2012  
  }
  legend_date=ISOdate(legend_year,2,1)
  legend_date2=ISOdate(legend_year,2,1)
  legend_date3=ISOdate(legend_year,2,1)
  
}

if (standort == 59) {
  legend_year = 2011
}



print("Calculating statistics")
print(paste("Location:    ", standortname))
print(paste("Profil:      ", profil))
print(paste("Fruchtfolge: ", ff))
print(paste("Pfad:        ", root_folder))
print(paste("Verzeichnis: ", folder))


	
