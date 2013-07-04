# read configuration for selecting the correct profile and cultivar


index_of_equal_elements1<- function(a1,a2)
{
    a1.in.a2.rows <- which(a1 %in% a2)
    return(a1.in.a2.rows)
}






ignore_last_mn_uptake_values_count = 0

source("config.r")
source("dir_config.r")

# import functions for statistical parameters
source("r_statistical_calculations.r")


# filename specification
smout_file = paste(root_folder,folder, "/smout.dat", sep="")
rmout_file = paste(root_folder,folder, "/rmout.dat", sep="")
soil_data_file = paste(root_folder,
                        folder,
                         "/",
                         standortname,
                         "_soildata_ff", ff,
                         "_anlage",anlage, 
                         "_profil-", profil,".txt", sep="")



# read model data
smout = read.table(smout_file, header=T, sep="\t", skip=2)
hl = readLines(smout_file, 1)
hl = strsplit(hl, '\t')
colnames(smout) = hl[[1]]


rmout = read.table(rmout_file, header=T, sep="\t", skip=2)
soildata = read.table(soil_data_file, header=T, sep=";")
hl = readLines(rmout_file, 1)
hl = strsplit(hl, '\t')
colnames(rmout) = hl[[1]]

fc_data = soildata[[3]]/100.0
pwp_data = soildata[[4]]/100.0
print("FCCCCCCCCCCCCCCC")
fc[1]
fc_data[1:3]
fc[1] = mean(fc_data[1:3])
fc[1]
fc[2] = mean(fc_data[4:6])
fc[3] = mean(fc_data[7:9])

pwp[1] = mean(pwp_data[1:3])
pwp[2] = mean(pwp_data[4:6])
pwp[3] = mean(pwp_data[7:9])

modell_datum = strptime(smout$Datum,format="%d/%m/%Y")
#modell_yield = smout$AbBiom
modell_yield = smout$Yield
modell_above_bm = smout$AbBiom
modell_height = smout$Height
modell_trans_def = rmout$TraDef
modell_n_def = rmout$NDef
modell_above_bm_n = smout$AbBiomNc
modell_yield_n = smout$YieldNc
modell_bedgrad = smout$BedGrad
modell_dev_stage = smout$Stage

modell_n_uptake = modell_yield * modell_yield_n
modell_n_uptake_abm = modell_above_bm * modell_above_bm_n
h 
modell_moisture_0_30 = smout$"M0-30"*100.0
modell_moisture_0_30 = smout$"M0-30"*100.0
modell_moisture_30_60 = smout$"M30-60"*100.0
modell_moisture_60_90 = smout$"M60-90"*100.0

modell_moisture_0_90 = smout$"M0-90"*100.0




modell_bodtemp5 = rmout$STemp0
modell_bodtemp20 = (rmout$STemp1 + rmout$STemp2) / 2.0

modell_moisture30 = ((rmout$Mois2+rmout$Mois3)/2) * 100.0
modell_moisture60 = ((rmout$Mois5+rmout$Mois6)/2) * 100.0
modell_moisture90 = ((rmout$Mois8+rmout$Mois9)/2) * 100.0


modell_nmin_0_30 = smout$"N0-30" / 3.0
modell_nmin_30_60 = smout$"N30-60" / 3.0
modell_nmin_60_90 = smout$"N60-90" / 3.0
modell_nmin_90_120 = smout$"N90-120" / 6.0
modell_nmin_0_90 = smout$"N0-90" / 9.0


modell_recharge = rmout$Recharge
modell_nleaching = rmout$NLeach
modell_ETa = rmout$act_ET

# Umrechnung der phys. Kenngrößen des Bodens
fc = fc*100.0
pwp = pwp*100.0



# get measured data
if (calc_ertrag == 1) {
  print("Lese ertrag.tx")
  yield_data = read.table(paste(data_folder, "ertrag.txt", sep=""), header=T, sep=";")
  yield_data$tm_prz
  yielddatum = strptime(yield_data$datumernte, format="%Y-%m-%d")
  crop=yield_data$id_pg
  sorte = as.character(yield_data$sorte)
  messertrag = ((yield_data$ertfm_jeefl_kg/yield_data$efl_m2)*100*100) * yield_data$tm_prz / 100.0
  
  
  probe = yield_data$datumernte
  probe = table(probe)
  probe = names(probe)
  n = length(probe)
  
  avg_messertrag = vector (n, mode="numeric")
  avg_crop_id = vector (n, mode="character")
  avg_sorte = vector (n, mode="character")
  avg_yielddatum = strptime(probe, format="%Y-%m-%d")
  for (i in 1:n) {
  	index = which (yield_data$datumernte==probe[i])
  	avg_messertrag[i] = mean(messertrag[index])
  	avg_crop_id[i] = substr(crop[index[1]],8,10)
  	 
  	avg_sorte[i] = sorte[index[1]]
  
  }
  print("MESSERTRAG")
  print(avg_yielddatum)
  print(avg_messertrag)
  
  
  print("Lese zwischenernte.tx")
  zwischenernte_data = read.table(paste(data_folder, "zwischenernte.txt", sep=""), header=T, sep=";")
  zwischenernte_datum = strptime(zwischenernte_data$datumernte, format="%Y-%m-%d")
  zwischenernte = ((zwischenernte_data$ertfm_jeefl_kg/zwischenernte_data$efl_m2)*100*100) * zwischenernte_data$tm_prz / 100.0
  
  
  
  probe = zwischenernte_data$datumernte
  probe = table(probe)
  probe = names(probe)
  n = length(probe)
  
  print("Ermittle Durchschnittswerte für Zeiternten")
  if (n==0) {
  	mean_zwischenernte = avg_messertrag
  	mean_zwischenernte_datum = avg_yielddatum
  } else {
  	mean_zwischenernte = vector (n, mode="numeric")
  	mean_zwischenernte_datum = strptime(probe, format="%Y-%m-%d")
  	for (i in 1:n) {
  		index = which (zwischenernte_data$datumernte==probe[i])
  		mean_zwischenernte[i] = mean(zwischenernte[index])
  	}
  #	mean_zwischenernte = append(mean_zwischenernte, avg_messertrag)
  #	mean_zwischenernte_datum = append(mean_zwischenernte_datum, avg_yielddatum)
  }

} # end calc_ertrag


if (calc_bbch == 1) {
  print("BBCH")
  bbch_data = read.table(paste(data_folder, "bbch.txt", sep=""), header=T, sep=";")
  bbch_datum = strptime(bbch_data$Datumereignis, format="%Y-%m-%d")
  bbch = bbch_data$BBCH_Ist
  
  
  m = length(bbch)
  bbch_mess = vector (m, mode="numeric")
  id_pg = bbch_data$id_pg
  #print(paste("id_pg: ", id_pg))
  for (j in 1:m) {
      bbch_mess[j] = getDevStageOfBBCH(bbch[j],id_pg[j])
  }
} # end calc_bbch


if (calc_height == 1) {
  print("Lese hoehe.tx")
  data_height = read.table(paste(data_folder, "hoehe.txt", sep=""), header=T, sep=";")
  height_datum = strptime(data_height$datumereignis, format="%Y-%m-%d")
  height = data_height$messwert/100.0
}

print("Lese fertilizer.tx")
fertilizer = read.table(paste(data_folder, "fertilizer.txt", sep=""), header=T, sep=";")
fertilizer_datum = strptime(fertilizer$Datum, format="%Y-%m-%d")
fert_len = length(fertilizer$id_versuch)
print (paste("Fertilizer: ", fert_len))

if (calc_nconc == 1) {
  print("Lese yield_n.tx")
  yield_n_data = read.table(paste(data_folder, "yield_n.txt", sep=""), header=T, sep=";")
  yield_n_datum = strptime(yield_n_data$datumernte, format="%Y-%m-%d")
  yield_n = yield_n_data$n_prz  / 100.0 # Umrechnung von [%] in [kg N / kg]
  
  probe = yield_n_data$datumernte
  probe = table(probe)
  probe = names(probe)
  n = length(probe)
  
  mean_yield_n = vector (n, mode="numeric")
  mean_n_uptake = vector (n, mode="numeric")
  mean_yield_n_datum = strptime(probe, format="%Y-%m-%d")
  mean_n_uptake_datum = mean_yield_n_datum
  n_uptake_index = 1
  print("Calculation of N-Uptake")
  print(mean_n_uptake_datum)
  for (i in 1:n) {
    print(i)
  	index = which (yield_n_data$datumernte==probe[i])
  	mean_yield_n[i] = mean(yield_n[index]) # * avg_messertrag[i]
  	yn_date = mean_yield_n_datum[i]
  	ertrag_date = which(yn_date == avg_yielddatum)

    if (length(ertrag_date)>0) {
        print("Datum gefunden")
        mean_n_uptake[n_uptake_index] = mean_yield_n[i] * avg_messertrag[ertrag_date]
        n_uptake_index = n_uptake_index + 1

    } else {
        print("Ungültiges Datum")        
        print(mean_n_uptake_datum)
        mean_n_uptake_datum <-mean_n_uptake_datum[-1*n_uptake_index]
        mean_n_uptake <- mean_n_uptake[-1*n_uptake_index]
        print(mean_n_uptake_datum)
    }
    
  }
  
  
  print("Lese n_zeiternte.tx")
  n_zeiternte_data = read.table(paste(data_folder, "n_zeiternte.txt", sep=""), header=T, sep=";")
  n_zeiternte_parzellen = n_zeiternte_data$n_prz  / 100.0 # Umrechnung von [%] in [kg N / kg]
  
  probe = n_zeiternte_data$datumernte
  probe = table(probe)
  probe = names(probe)
  n = length(probe)
  
  n_zeiternte = vector (n, mode="numeric")
  n_uptake_abm = vector (n, mode="numeric")
  n_zeiternte_datum = strptime(probe, format="%Y-%m-%d")
  n_uptake_abm_datum = n_zeiternte_datum 
  n_uptake_index = 1

  for (i in 1:n) {
  	index = which (n_zeiternte_data$datumernte==probe[i])
  	n_zeiternte[i] = mean(n_zeiternte_parzellen[index]) # * mean_zwischenernte[i]

    yn_date = n_zeiternte_datum[i]
  	ertrag_date = which(yn_date == mean_zwischenernte_datum)

    if (length(ertrag_date)>0) {
        print("Datum gefunden")
        #n_uptake_abm[n_uptake_index] = n_zeiternte[i] * mean_zwischenernte[ertrag_date]
        #n_uptake_index = n_uptake_index + 1

    } else {
        #print("Ungültiges Datum")        
        #print(n_uptake_abm_datum)
        #%n_uptake_abm_datum <n_uptake_abm_datum[-1*n_uptake_index]
        #n_uptake_abm <- n_uptake_abm[-1*n_uptake_index]
        #print(n_uptake_abm_datum)
    }
  }
  
  #n_zeiternte = append(n_zeiternte, mean_yield_n)
  #n_zeiternte_datum = append(n_zeiternte_datum, mean_yield_n_datum)
  
} # end calc_nconc


if (calc_bedgrad == 1) {
  print("Lese bedgrad.tx")
  bedgrad_data = read.table(paste(data_folder, "bedgrad.txt", sep=""), header=T, sep=";")
  bedgrad_datum = strptime(bedgrad_data$datumereignis, format="%Y-%m-%d")
  bedgrad = bedgrad_data$messwert
} # end calc_bedgrad

if (calc_soilnmin == 1) {
  print("Lese nmin.tx")
  nmin_data = read.table(paste(data_folder, "nmin.txt", sep=""), header=T, sep=";")
  nmin_datum = strptime(nmin_data$datumbdprobe, format="%Y-%m-%d")
  
  print("Ermittle Nmin-Durchschnittswerte für die Tiefen 0-30, 30-60 und 60-90cm")
  nmin30 = nmin_data$no3[which(nmin_data$tiefe_cm == "0-30")] + nmin_data$nh4[which(nmin_data$tiefe_cm == "0-30")]
  nmin30_datum = nmin_datum[which(nmin_data$tiefe_cm == "0-30")]
  nmin60 = nmin_data$no3[which(nmin_data$tiefe_cm == "30-60")] + nmin_data$nh4[which(nmin_data$tiefe_cm == "30-60")]
  nmin60_datum = nmin_datum[which(nmin_data$tiefe_cm == "30-60")]
  nmin90 = nmin_data$no3[which(nmin_data$tiefe_cm == "60-90")] + nmin_data$nh4[which(nmin_data$tiefe_cm == "60-90")]
  nmin90_datum = nmin_datum[which(nmin_data$tiefe_cm == "60-90")]
  
} # end calc_soilnmin

if (calc_soilmoisture == 1) {
  print("Lese wasser.tx")
  moisture_data =  read.table(paste(data_folder, "wasser.txt", sep=""), header=T, sep=";")
  moisture_datum = strptime(moisture_data$datumbdprobe, format="%Y-%m-%d")
  
  print("Ermittle H2O-Durchschnittswerte für die Tiefen 0-30, 30-60 und 60-90cm")
  moisture30 = moisture_data$h2o[which(moisture_data$tiefe_cm == "0-30")]
  moisture30_datum = moisture_datum[which(moisture_data$tiefe_cm == "0-30")]
  moisture60 = moisture_data$h2o[which(moisture_data$tiefe_cm == "30-60")]
  moisture60_datum = moisture_datum[which(moisture_data$tiefe_cm == "30-60")]
  moisture90 = moisture_data$h2o[which(moisture_data$tiefe_cm == "60-90")]
  moisture90_datum = moisture_datum[which(moisture_data$tiefe_cm == "60-90")]
  
  print("Umrechnung von gravimetrischen in volumetrischen Wassergehalt")
  moisture30 = moisture30*bd_dichte30 # Umrechnung von gravimetrischen in volumetrischen Wassergehalt
  moisture60 = moisture60*bd_dichte60 # Umrechnung von gravimetrischen in volumetrischen Wassergehalt
  moisture90 = moisture90*bd_dichte90 # Umrechnung von gravimetrischen in volumetrischen Wassergehalt

}


if (calc_bodtemp == 1) {
  print("Lese bodtemp5.tx")
  bodtemp5_data =  read.table(paste(data_folder, "bodtemp5cm.txt", sep=""), header=T, sep=";")
  bodtemp5_datum = strptime(bodtemp5_data$Datum, format="%Y-%m-%d")

  print("Lese bodtemp20.tx")
  bodtemp20_data =  read.table(paste(data_folder, "bodtemp20cm.txt", sep=""), header=T, sep=";")
  bodtemp20_datum = strptime(bodtemp20_data$Datum, format="%Y-%m-%d")
 

  bodtemp5 = bodtemp5_data$Wert
  bodtemp20 = bodtemp20_data$Wert

}


if (calc_wasser_v4 == 1) {
  print("Lese wasser.tx")
  moisture_data =  read.table(paste(data_folder, "wasser-v4.txt", sep=""), header=T, sep=";")
  moisture_datum = strptime(moisture_data$datumbdprobe, format="%Y-%m-%d")
  
  print("Ermittle H2O-Durchschnittswerte für die Tiefen 0-30, 30-60 und 60-90cm")
  moisture30 = moisture_data$h2o[which(moisture_data$tiefe_cm == "0-30")]
  moisture30_datum = moisture_datum[which(moisture_data$tiefe_cm == "0-30")]
  moisture60 = moisture_data$h2o[which(moisture_data$tiefe_cm == "30-60")]
  moisture60_datum = moisture_datum[which(moisture_data$tiefe_cm == "30-60")]
  moisture90 = moisture_data$h2o[which(moisture_data$tiefe_cm == "60-90")]
  moisture90_datum = moisture_datum[which(moisture_data$tiefe_cm == "60-90")]
  
  moisture_data_grav =  read.table(paste(data_folder, "wasser.txt", sep=""), header=T, sep=";")
  moisture_datum_grav = strptime(moisture_data_grav$datumbdprobe, format="%Y-%m-%d")
  
  print("Ermittle H2O-Durchschnittswerte für die Tiefen 0-30, 30-60 und 60-90cm")
  moisture30_grav = moisture_data_grav$h2o[which(moisture_data_grav$tiefe_cm == "0-30")]
  moisture30_datum_grav = moisture_datum_grav[which(moisture_data_grav$tiefe_cm == "0-30")]
  moisture60_grav = moisture_data_grav$h2o[which(moisture_data_grav$tiefe_cm == "30-60")]
  moisture60_datum_grav = moisture_datum_grav[which(moisture_data_grav$tiefe_cm == "30-60")]
  moisture90_grav = moisture_data_grav$h2o[which(moisture_data_grav$tiefe_cm == "60-90")]
  moisture90_datum_grav = moisture_datum_grav[which(moisture_data_grav$tiefe_cm == "60-90")]
  
  print("Umrechnung von gravimetrischen in volumetrischen Wassergehalt")
  moisture30_grav = moisture30_grav*bd_dichte30 # Umrechnung von gravimetrischen in volumetrischen Wassergehalt
  moisture60_grav = moisture60_grav*bd_dichte60 # Umrechnung von gravimetrischen in volumetrischen Wassergehalt
  moisture90_grav = moisture90_grav*bd_dichte90 # Umrechnung von gravimetrischen in volumetrischen Wassergehalt

}

if (calc_ertrag == 1 & calc_nconc == 1 & length(mean_zwischenernte)>0 & length(n_zeiternte)>0) {
  # Datum - indizes bestimmen, wenn N Konzentrationswerte und Zwischenernten vorliegen
  # Nur gemeinsame Daten werden multipliziert
  index_zwischenernte = vector (min(length(mean_zwischenernte), length(n_zeiternte)), mode="numeric")
  index_n_zeiternte = vector (min(length(mean_zwischenernte), length(n_zeiternte)), mode="numeric")
  
  count = 1
  for (i in 1:length(mean_zwischenernte)) {
    for (j in 1:length(n_zeiternte)) {
      #print(paste("i: ", i, "   j: ", j, " ", mean_zwischenernte_datum[i], " ",  n_zeiternte_datum[j]))
      if (! is.na(n_zeiternte_datum[j]) &  mean_zwischenernte_datum[i] == n_zeiternte_datum[j]) {      
        
        index_zwischenernte[count] = i
        index_n_zeiternte[count] = j
        #print(paste("Equal: ", count))
        #print(index_zwischenernte)
        #print(index_n_zeiternte)
        count = count + 1
        
      }
    }
  }
  
  na.omit(index_zwischenernte)
  na.omit(index_n_zeiternte)
  
  
  #print(paste("N-Uptake Datum: ", n_zeiternte_datum[index_n_zeiternte]))
  #n_uptake = (mean_zwischenernte[index_zwischenernte] * n_zeiternte[index_n_zeiternte])
  #na.omit(n_uptake)



  #nuptake_size = length(index_zwischenernte)
  #n_uptake = n_uptake[1:(nuptake_size-ignore_last_mn_uptake_values_count)]
  #n_uptake_datum = n_zeiternte_datum[index_n_zeiternte]
  #n_uptake_datum = n_uptake_datum[1:(nuptake_size-ignore_last_mn_uptake_values_count)]
  
  # 10% zu den messwerten zuaddieren, da Wurzel in Biomasse der Messwerte nicht enthalten ist, im Modell jedoch schon
  #n_uptake = n_uptake * 1.1
  
} # end if (calc_ertrag == 1 & calc_nconc == 1) {

 



# remove zero values from data vectors
if (calc_nconc == 1) {

  print("Statistic calc_nconc")
  print (mean_n_uptake)
  print(class(mean_n_uptake))
  print(mean_n_uptake_datum)
  mean_yield_n_datum = remove_zero_values(mean_yield_n,mean_yield_n_datum)
  mean_yield_n = remove_zero_values(mean_yield_n,mean_yield_n)

  mean_n_uptake_datum = remove_zero_values(mean_n_uptake,mean_n_uptake_datum)
  mean_n_uptake = remove_zero_values(mean_n_uptake,mean_n_uptake)
  print(class(mean_n_uptake))
  
  n_zeiternte_datum = remove_zero_values(n_zeiternte,n_zeiternte_datum)
  n_zeiternte = remove_zero_values(n_zeiternte,n_zeiternte)
  
  modell_yield_n_values = get_values_at_dates(mean_yield_n_datum,modell_datum, modell_yield_n,1)
  modell_n_uptake_values = get_values_at_dates(mean_n_uptake_datum,modell_datum, modell_n_uptake,1)
  modell_n_zeiternten_values = get_values_at_dates(n_zeiternte_datum,modell_datum, modell_above_bm_n,1)
  
  max_index = length(mean_yield_n)
  yield_n_percent = (abs(modell_yield_n_values[max_index]-mean_yield_n[max_index])/modell_yield_n_values[max_index])*100.0
  
  
  mae_yield_n = calc_mae(p = modell_yield_n_values, o=mean_yield_n)
  mbe_yield_n = calc_mbe(p = modell_yield_n_values, o=mean_yield_n)
  rsme_yield_n = calc_rsme(p = modell_yield_n_values, o=mean_yield_n)
  ef_yield_n = calc_ef(p = modell_yield_n_values, o=mean_yield_n)
  ioa_yield_n = calc_ioa(p = modell_yield_n_values, o=mean_yield_n)
  nmae_yield_n = calc_nmae(p = modell_yield_n_values, o=mean_yield_n)  
  nmses_yield_n = calc_nmses(p = modell_yield_n_values, o=mean_yield_n)
  nmseu_yield_n = 1-nmses_yield_n
  sample_yield_n = length(mean_yield_n)

  mae_n_uptake = calc_mae(p = modell_n_uptake_values, o=mean_n_uptake)
  mbe_n_uptake = calc_mbe(p = modell_n_uptake_values, o=mean_n_uptake)
  rsme_n_uptake = calc_rsme(p = modell_n_uptake_values, o=mean_n_uptake)
  ef_n_uptake = calc_ef(p = modell_n_uptake_values, o=mean_n_uptake)
  ioa_n_uptake = calc_ioa(p = modell_n_uptake_values, o=mean_n_uptake)
  nmae_n_uptake = calc_nmae(p = modell_n_uptake_values, o=mean_n_uptake)  
  nmses_n_uptake = calc_nmses(p = modell_n_uptake_values, o=mean_n_uptake)
  nmseu_n_uptake = 1-nmses_n_uptake
  sample_size_n_uptake = length(mean_n_uptake)
  
  mae_n_zeiternte = calc_mae(p = modell_n_zeiternten_values, o=n_zeiternte)
  mbe_n_zeiternte = calc_mbe(p = modell_n_zeiternten_values, o=n_zeiternte)
  rsme_n_zeiternte = calc_rsme(p = modell_n_zeiternten_values, o=n_zeiternte)
  ef_n_zeiternte = calc_ef(p = modell_n_zeiternten_values, o=n_zeiternte)
  ioa_n_zeiternte = calc_ioa(p = modell_n_zeiternten_values, o=n_zeiternte)
  nmae_n_zeiternte = calc_nmae(p = modell_n_zeiternten_values, o=n_zeiternte)
  nmses_n_zeiternte = calc_nmses(p = modell_n_zeiternten_values, o=n_zeiternte)
  nmseu_n_zeiternte = 1-nmses_n_zeiternte
  sample_size_n_zeiternte = length(n_zeiternte)
}

if (calc_ertrag == 1) {
    print("Statistic calc_ertrag")
  avg_yielddatum = remove_zero_values(avg_messertrag,avg_yielddatum)
  avg_messertrag = remove_zero_values(avg_messertrag,avg_messertrag)
  mean_zwischenernte_datum = remove_zero_values(mean_zwischenernte,mean_zwischenernte_datum)
  mean_zwischenernte = remove_zero_values(mean_zwischenernte,mean_zwischenernte)
  
  
  modell_ertrag = get_values_at_dates(avg_yielddatum,modell_datum, modell_yield,1)
  modell_zwischenernte = get_values_at_dates(mean_zwischenernte_datum,modell_datum, modell_yield,1)
  
  max_index = length(mean_zwischenernte)
  ertrag_percent = (abs(mean_zwischenernte[max_index]-modell_zwischenernte[max_index])/modell_zwischenernte[max_index])*100.0
  
  mae_ertrag = calc_mae(p = modell_ertrag, o=avg_messertrag)
  mbe_ertrag = calc_mbe(p = modell_ertrag, o=avg_messertrag)
  rsme_ertrag = calc_rsme(p = modell_ertrag, o=avg_messertrag)
  ioa_ertrag = calc_ioa(p = modell_ertrag, o=avg_messertrag)
  ef_ertrag = calc_ef(p = modell_ertrag, o=avg_messertrag)
  nmae_ertrag = calc_nmae(p = modell_ertrag, o=avg_messertrag)
  nmses_ertrag = calc_nmses(p = modell_ertrag, o=avg_messertrag)
  nmseu_ertrag = 1-nmses_ertrag
  sample_size_ertrag = length(avg_messertrag)
  
  mae_zwischenernte = calc_mae(p = modell_zwischenernte, o=mean_zwischenernte)
  mbe_zwischenernte = calc_mbe(p = modell_zwischenernte, o=mean_zwischenernte)
  rsme_zwischenernte = calc_rsme(p = modell_zwischenernte, o=mean_zwischenernte)
  ioa_zwischenernte = calc_ioa(p = modell_zwischenernte, o=mean_zwischenernte)
  ef_zwischenernte = calc_ef(p = modell_zwischenernte, o=mean_zwischenernte)
  nmae_zwischenernte = calc_nmae(p = modell_zwischenernte, o=mean_zwischenernte)
  nmses_zwischenernte = calc_nmses(p = modell_zwischenernte, o=mean_zwischenernte)
  nmseu_zwischenernte = 1-nmses_zwischenernte
  sample_size_zwischenernte = length(mean_zwischenernte)
}



if (calc_soilnmin == 1) {
  print("Statistic calc_soilnmin")
  nmin30_datum = remove_zero_values(nmin30,nmin30_datum)
  nmin30 = remove_zero_values(nmin30,nmin30)
  nmin60_datum = remove_zero_values(nmin60,nmin60_datum)
  nmin60 = remove_zero_values(nmin60,nmin60)
  nmin90_datum = remove_zero_values(nmin90,nmin90_datum)
  nmin90 = remove_zero_values(nmin90,nmin90)

 
  
  modell_nmin_0_30_values = get_values_at_dates(nmin30_datum,modell_datum, modell_nmin_0_30, 1)
  modell_nmin_30_60_values = get_values_at_dates(nmin60_datum,modell_datum, modell_nmin_30_60, 1)
  modell_nmin_60_90_values = get_values_at_dates(nmin90_datum,modell_datum, modell_nmin_60_90, 1)
  
  
  nmin30_df = data.frame(datum=nmin30_datum, nmin=nmin30)
  nmin60_df = data.frame(datum=nmin60_datum, nmin=nmin60)
  nmin90_df = data.frame(datum=nmin90_datum, nmin=nmin90)

  # first add nmin values of 0-30 and 30-60 meters
  nmin30_index = index_of_equal_elements1(nmin30_df$datum,nmin60_df$datum)
  nmin60_index = index_of_equal_elements1(nmin60_df$datum,nmin30_df$datum)
  
  sum_nmin = nmin30[nmin30_index] + nmin60[nmin60_index]
  sum_nmin_datum = nmin30_datum[nmin30_index]  
  
  sum_nmin_modell_values = modell_nmin_0_30 + modell_nmin_30_60

  sum_nmin_df = data.frame(datum=sum_nmin_datum, nmin=sum_nmin)

  nmin90_index = index_of_equal_elements1(nmin90_df$datum,sum_nmin_df$datum)
  sum_nmin_index = index_of_equal_elements1(sum_nmin_df$datum,nmin90_df$datum)
  print("Sum Nmin 90 index")
  print(nmin90_index)
  print(sum_nmin_index)
  if (length(nmin90_index)>5) {
    # found more than 5 elements
    print(" found more than 5 elements, so I use nmin of 60-90 cm, too")
    sum_nmin = sum_nmin[sum_nmin_index] +  nmin90[nmin90_index]
    sum_nmin_datum = sum_nmin_datum[sum_nmin_index]

    #print(sum_nmin_modell_values)
    sum_nmin_modell_values = sum_nmin_modell_values + modell_nmin_60_90
    #print(sum_nmin_modell_values)
  }


  
  sum_nmin_modell = get_values_at_dates(sum_nmin_datum,modell_datum, sum_nmin_modell_values, 1)
  print("Summe Nmin")
  print(sum_nmin_datum)
  print(sum_nmin) 
  print(sum_nmin_modell)

  
  
  ioa_nmin30 = calc_ioa(p = modell_nmin_0_30_values, o=nmin30)
  ef_nmin30 = calc_ef(p = modell_nmin_0_30_values, o=nmin30)
  mae_nmin30 = calc_mae(p = modell_nmin_0_30_values, o=nmin30)
  mbe_nmin30 = calc_mbe(p = modell_nmin_0_30_values, o=nmin30)
  rsme_nmin30 = calc_rsme(p = modell_nmin_0_30_values, o=nmin30)
  nmae_nmin30 = calc_nmae(p = modell_nmin_0_30_values, o=nmin30)
  nmses_nmin30 = calc_nmses(p = modell_nmin_0_30_values, o=nmin30)
  nmseu_nmin30 = 1-nmses_nmin30
  sample_size_nmin30 = length(nmin30)
  
  
  ioa_nmin60 = calc_ioa(p = modell_nmin_30_60_values, o=nmin60)
  ef_nmin60 = calc_ef(p = modell_nmin_30_60_values, o=nmin60)
  mae_nmin60 = calc_mae(p = modell_nmin_30_60_values, o=nmin60)
  mbe_nmin60 = calc_mbe(p = modell_nmin_30_60_values, o=nmin60)
  rsme_nmin60 = calc_rsme(p = modell_nmin_30_60_values, o=nmin60)
  nmae_nmin60 = calc_nmae(p = modell_nmin_30_60_values, o=nmin60)
  nmses_nmin60 = calc_nmses(p = modell_nmin_30_60_values, o=nmin60)
  nmseu_nmin60 = 1-nmses_nmin60
  sample_size_nmin60 = length(nmin60)
  
  ioa_nmin90 = calc_ioa(p = modell_nmin_60_90_values, o=nmin90)
  ef_nmin90 = calc_ef(p = modell_nmin_60_90_values, o=nmin90)
  mae_nmin90 = calc_mae(p = modell_nmin_60_90_values, o=nmin90)
  mbe_nmin90 = calc_mbe(p = modell_nmin_60_90_values, o=nmin90)
  rsme_nmin90 = calc_rsme(p = modell_nmin_60_90_values, o=nmin90)
  nmae_nmin90 = calc_nmae(p = modell_nmin_60_90_values, o=nmin90)
  nmses_nmin90 = calc_nmses(p = modell_nmin_60_90_values, o=nmin90)
  nmseu_nmin90 = 1-nmses_nmin30
  sample_size_nmin90 = length(nmin90)




  ioa_nmin1_3 = calc_ioa(p = sum_nmin_modell, o=sum_nmin)
  ef_nmin1_3 = calc_ef(p = sum_nmin_modell, o=sum_nmin)
  mae_nmin1_3 = calc_mae(p = sum_nmin_modell, o=sum_nmin)
  mbe_nmin1_3 = calc_mbe(p = sum_nmin_modell, o=sum_nmin)
  rsme_nmin1_3 = calc_rsme(p = sum_nmin_modell, o=sum_nmin)
  nmae_nmin1_3 = calc_nmae(p = sum_nmin_modell, o=sum_nmin)
  nmses_nmin1_3 = calc_nmses(p = sum_nmin_modell, o=sum_nmin)
  nmseu_nmin1_3 = 1-nmses_nmin1_3
  sample_size_nmin1_3 = length(sum_nmin)
}

if (calc_height == 1) {
  print("Statistic calc_height")
  modell_height_values = get_values_at_dates(height_datum,modell_datum, modell_height,0)
  ioa_height = calc_ioa(p = modell_height_values, o=height)
  ef_height = calc_ef(p = modell_height_values, o=height)
  mae_height = calc_mae(p = modell_height_values, o=height)
  mbe_height = calc_mbe(p = modell_height_values, o=height)
  rsme_height = calc_rsme(p = modell_height_values, o=height)
  nmae_height = calc_nmae(p = modell_height_values, o=height)
  nmses_height = calc_nmses(p = modell_height_values, o=height)
  nmseu_height = 1-nmses_height
  sample_size_height = length(height)
}

if (calc_bedgrad == 1) {
  print("Statistic calc_bedgrad")
  modell_bedgrad_values = get_values_at_dates(bedgrad_datum,modell_datum, modell_bedgrad,0)
  
  ioa_bedgrad = calc_ioa(p = modell_bedgrad_values, o=bedgrad)
  ef_bedgrad = calc_ef(p = modell_bedgrad_values, o=bedgrad)
  mae_bedgrad = calc_mae(p = modell_bedgrad_values, o=bedgrad)
  mbe_bedgrad = calc_mbe(p = modell_bedgrad_values, o=bedgrad)
  rsme_bedgrad = calc_rsme(p = modell_bedgrad_values, o=bedgrad)
  nmae_bedgrad = calc_nmae(p = modell_bedgrad_values, o=bedgrad)
  nmses_bedgrad = calc_nmses(p = modell_bedgrad_values, o=bedgrad)
  nmseu_bedgrad = 1-nmses_bedgrad
  sample_size_bedgrad = length(bedgrad)
}

if (calc_soilmoisture == 1) {
  modell_moisture_0_30_values = get_values_at_dates(moisture30_datum,modell_datum, modell_moisture_0_30,1)
  modell_moisture_30_60_values = get_values_at_dates(moisture60_datum,modell_datum, modell_moisture_30_60,1)
  modell_moisture_60_90_values = get_values_at_dates(moisture90_datum,modell_datum, modell_moisture_60_90,1)
  
  
  moisture30_df = data.frame(datum=moisture30_datum, moisture=moisture30)
  moisture60_df = data.frame(datum=moisture60_datum, moisture=moisture60)
  moisture90_df = data.frame(datum=moisture90_datum, moisture=moisture90)

  # first add moisture values of 0-30 and 30-60 meters
  moisture30_index = index_of_equal_elements1(moisture30_df$datum,moisture60_df$datum)
  moisture60_index = index_of_equal_elements1(moisture60_df$datum,moisture30_df$datum)
  
  sum_moisture = moisture30[moisture30_index] + moisture60[moisture60_index]
  sum_moisture_datum = moisture30_datum[moisture30_index]  
  sum_moisture_modell_values = modell_moisture_0_30 + modell_moisture_30_60

  sum_moisture_df = data.frame(datum=sum_moisture_datum, moisture=sum_moisture)

  moisture90_index = index_of_equal_elements1(moisture90_df$datum,sum_moisture_df$datum)
  sum_moisture_index = index_of_equal_elements1(sum_moisture_df$datum,moisture90_df$datum)
  print("Sum moisture 90 index")
  print(moisture90_index)
  print(sum_moisture_index)
  if (length(moisture90_index)>5) {
    # found more than 5 elements
    print(" found more than 5 elements")
    sum_moisture = sum_moisture[sum_moisture_index] +  moisture90[moisture90_index]
    sum_moisture = sum_moisture/3.0
    sum_moisture_datum = sum_moisture_datum[sum_moisture_index]

    sum_moisture_modell_values = sum_moisture_modell_values + modell_moisture_60_90
    sum_moisture_modell_values = sum_moisture_modell_values / 3.0
  } else {
    sum_moisture = sum_moisture/2.0
    sum_moisture_modell_values = sum_moisture_modell_values / 2.0
  }


  sum_moisture_modell = get_values_at_dates(sum_moisture_datum,modell_datum, sum_moisture_modell_values, 1)
  print("Summe moisture")
  print(sum_moisture_datum)
  print(sum_moisture) 
  print(sum_moisture_modell)
  
  ioa_moisture30 = calc_ioa(p = modell_moisture_0_30_values, o=moisture30)
  ef_moisture30 = calc_ef(p = modell_moisture_0_30_values, o=moisture30)
  mae_moisture30 = calc_mae(p = modell_moisture_0_30_values, o=moisture30)
  mbe_moisture30 = calc_mbe(p = modell_moisture_0_30_values, o=moisture30)
  rsme_moisture30 = calc_rsme(p = modell_moisture_0_30_values, o=moisture30)
  nmae_moisture30 = calc_nmae(p = modell_moisture_0_30_values, o=moisture30)
  nmses_moisture30 = calc_nmses(p = modell_moisture_0_30_values, o=moisture30)
  nmseu_moisture30 = 1-nmses_moisture30
  sample_size_moisture30 = length(moisture30)
  
  
  ioa_moisture60 = calc_ioa(p = modell_moisture_30_60_values, o=moisture60)
  ef_moisture60 = calc_ef(p = modell_moisture_30_60_values, o=moisture60)
  mae_moisture60 = calc_mae(p = modell_moisture_30_60_values, o=moisture60)
  mbe_moisture60 = calc_mbe(p = modell_moisture_30_60_values, o=moisture60)
  rsme_moisture60 = calc_rsme(p = modell_moisture_30_60_values, o=moisture60)
  nmae_moisture60 = calc_nmae(p = modell_moisture_30_60_values, o=moisture60)
  nmses_moisture60 = calc_nmses(p = modell_moisture_30_60_values, o=moisture60)
  nmseu_moisture60 = 1-nmses_moisture60
  sample_size_moisture60 = length(moisture60)
  
  ioa_moisture90 = calc_ioa(p = modell_moisture_60_90_values, o=moisture90)
  ef_moisture90 = calc_ef(p = modell_moisture_60_90_values, o=moisture90)
  mae_moisture90 = calc_mae(p = modell_moisture_60_90_values, o=moisture90)
  mbe_moisture90 = calc_mbe(p = modell_moisture_60_90_values, o=moisture90)
  rsme_moisture90 = calc_rsme(p = modell_moisture_60_90_values, o=moisture90)
  nmae_moisture90 = calc_nmae(p = modell_moisture_60_90_values, o=moisture90)
  nmses_moisture90 = calc_nmses(p = modell_moisture_60_90_values, o=moisture90)
  nmseu_moisture90 = 1-nmses_moisture90
  sample_size_moisture90 = length(moisture90)
  
  
  ioa_moisture1_3 = calc_ioa(p = sum_moisture_modell, o=sum_moisture)
  ef_moisture1_3 = calc_ef(p = sum_moisture_modell, o=sum_moisture)
  mae_moisture1_3 = calc_mae(p = sum_moisture_modell, o=sum_moisture)
  mbe_moisture1_3 = calc_mbe(p = sum_moisture_modell, o=sum_moisture)
  rsme_moisture1_3 = calc_rsme(p = sum_moisture_modell, o=sum_moisture)
  nmae_moisture1_3 = calc_nmae(p = sum_moisture_modell, o=sum_moisture)
  nmses_moisture1_3 = calc_nmses(p = sum_moisture_modell, o=sum_moisture)
  nmseu_moisture1_3 = 1-nmses_moisture1_3
  sample_size_moisture1_3 = length(sum_moisture)
   print("End moisture")
}

if (calc_wasser_v4 == 1) {
  moisture30_datum = remove_zero_values(moisture30,moisture30_datum)
  moisture30 = remove_zero_values(moisture30,moisture30)
  moisture60_datum = remove_zero_values(moisture60,moisture60_datum)
  moisture60 = remove_zero_values(moisture60,moisture60)
  moisture90_datum = remove_zero_values(moisture90,moisture90_datum)
  moisture90 = remove_zero_values(moisture90,moisture90)
  
  
  modell_moisture_30_values = get_values_at_dates(moisture30_datum,modell_datum, modell_moisture30,1)
  modell_moisture_60_values = get_values_at_dates(moisture60_datum,modell_datum, modell_moisture60,1)
  modell_moisture_90_values = get_values_at_dates(moisture90_datum,modell_datum, modell_moisture90,1)
  
  # create vector with all data from soilmoisture layers
  moisture1_3 = c()
  modell_moisture1_3 = c()
  moisture1_3 = append(moisture1_3, moisture30)
  modell_moisture1_3 = append(modell_moisture1_3, modell_moisture_30_values)
  moisture1_3 = append(moisture1_3, moisture60)
  modell_moisture1_3 = append(modell_moisture1_3, modell_moisture_60_values)
  moisture1_3 = append(moisture1_3, moisture90)
  modell_moisture1_3 = append(modell_moisture1_3, modell_moisture_90_values)
  
  ioa_moisture30 = calc_ioa(p = modell_moisture_30_values, o=moisture30)
  ef_moisture30 = calc_ef(p = modell_moisture_30_values, o=moisture30)
  mae_moisture30 = calc_mae(p = modell_moisture_30_values, o=moisture30)
  mbe_moisture30 = calc_mbe(p = modell_moisture_30_values, o=moisture30)
  rsme_moisture30 = calc_rsme(p = modell_moisture_30_values, o=moisture30)
  nmae_moisture30 = calc_nmae(p = modell_moisture_30_values, o=moisture30)
  nmses_moisture30 = calc_nmses(p = modell_moisture_30_values, o=moisture30)
  nmseu_moisture30 = 1-nmses_moisture30
  sample_size_moisture30 = length(moisture30)
  
  
  ioa_moisture60 = calc_ioa(p = modell_moisture_60_values, o=moisture60)
  ef_moisture60 = calc_ef(p = modell_moisture_60_values, o=moisture60)
  mae_moisture60 = calc_mae(p = modell_moisture_60_values, o=moisture60)
  mbe_moisture60 = calc_mbe(p = modell_moisture_60_values, o=moisture60)
  rsme_moisture60 = calc_rsme(p = modell_moisture_60_values, o=moisture60)
  nmae_moisture60 = calc_nmae(p = modell_moisture_60_values, o=moisture60)
  nmses_moisture60 = calc_nmses(p = modell_moisture_60_values, o=moisture60)
  nmseu_moisture60 = 1-nmses_moisture60
  sample_size_moisture60 = length(moisture60)
  
  ioa_moisture90 = calc_ioa(p = modell_moisture_90_values, o=moisture90)
  ef_moisture90 = calc_ef(p = modell_moisture_90_values, o=moisture90)
  mae_moisture90 = calc_mae(p = modell_moisture_90_values, o=moisture90)
  mbe_moisture90 = calc_mbe(p = modell_moisture_90_values, o=moisture90)
  rsme_moisture90 = calc_rsme(p = modell_moisture_90_values, o=moisture90)
  nmae_moisture90 = calc_nmae(p = modell_moisture_90_values, o=moisture90)
  nmses_moisture90 = calc_nmses(p = modell_moisture_90_values, o=moisture90)
  nmseu_moisture90 = 1-nmses_moisture90
  sample_size_moisture90 = length(moisture90)
  
  
  ioa_moisture1_3 = calc_ioa(p = modell_moisture1_3, o=moisture1_3)
  ef_moisture1_3 = calc_ef(p = modell_moisture1_3, o=moisture1_3)
  mae_moisture1_3 = calc_mae(p = modell_moisture1_3, o=moisture1_3)
  mbe_moisture1_3 = calc_mbe(p = modell_moisture1_3, o=moisture1_3)
  rsme_moisture1_3 = calc_rsme(p = modell_moisture1_3, o=moisture1_3)
  nmae_moisture1_3 = calc_nmae(p = modell_moisture1_3, o=moisture1_3)
  nmses_moisture1_3 = calc_nmses(p = modell_moisture1_3, o=moisture1_3)
  nmseu_moisture1_3 = 1-nmses_moisture1_3
  sample_size_moisture1_3 = length(moisture1_3)
}

if (calc_bodtemp == 1) {
  print("Calc bodtemp statistics")
  modell_bodtemp5_values = get_values_at_dates(bodtemp5_datum,modell_datum, modell_bodtemp5,0)
  
  print (length(modell_bodtemp5_values))
  print (length(bodtemp5))
  ioa_bodtemp5 = calc_ioa(p = modell_bodtemp5_values, o=bodtemp5)
  ef_bodtemp5 = calc_ef(p = modell_bodtemp5_values, o=bodtemp5)
  mae_bodtemp5 = calc_mae(p = modell_bodtemp5_values, o=bodtemp5)
  mbe_bodtemp5 = calc_mbe(p = modell_bodtemp5_values, o=bodtemp5)
  rsme_bodtemp5 = calc_rsme(p = modell_bodtemp5_values, o=bodtemp5)
  nmae_bodtemp5 = calc_nmae(p = modell_bodtemp5_values, o=bodtemp5)
  nmses_bodtemp5 = calc_nmses(p = modell_bodtemp5_values, o=bodtemp5)
  nmseu_bodtemp5 = 1-nmses_bodtemp5
  sample_size_bodtemp5 = length(bodtemp5)

  modell_bodtemp20_values = get_values_at_dates(bodtemp20_datum,modell_datum, modell_bodtemp20,0)
  print (length(modell_bodtemp20_values))
  print (length(bodtemp20))
  
  ioa_bodtemp20 = calc_ioa(p = modell_bodtemp20_values, o=bodtemp20)
  ef_bodtemp20 = calc_ef(p = modell_bodtemp20_values, o=bodtemp20)
  mae_bodtemp20 = calc_mae(p = modell_bodtemp20_values, o=bodtemp20)
  mbe_bodtemp20 = calc_mbe(p = modell_bodtemp20_values, o=bodtemp20)
  rsme_bodtemp20 = calc_rsme(p = modell_bodtemp20_values, o=bodtemp20)
  nmae_bodtemp20 = calc_nmae(p = modell_bodtemp20_values, o=bodtemp20)
  nmses_bodtemp20 = calc_nmses(p = modell_bodtemp20_values, o=bodtemp20)
  nmseu_bodtemp20 = 1-nmses_bodtemp20
  sample_size_bodtemp20 = length(bodtemp20)
  print("End bodtemp statistics")
}


png(filename=paste(root_folder,folder,"/",standortname,"_ertrag_klass-",classification,"_ff",ff,"-anlage-", anlage, "-profil",profil,".png",sep=""), width=1600, height=900, pointsize=16) 
# plot Einstellungen
par(
bty="l", 		# Box in Form eines "L"
cex.main=1.0,	# Schriftgröße der Plot-Überschriften
lwd=1,			# Linienstärke
mar=c(4.5,4,3,15), 	# Rahmen-Abstände (unten, links, oben, rechts)
xpd=FALSE,		# Außerhalb des Rahmen Zeichnen (z.B. Legende)
mfrow=c(3,2)
)

mess_filename=paste(root_folder,folder,"/",standortname,"_messwert_verarbeitung_ff",ff,"-anlage-", anlage, "-profil",profil,"-klass-",classification,".txt",sep="")
cat("Messwert-Berechnung R-Skript", "\n",  file=mess_filename, sep=";", append=FALSE)


# Ertrag ------------------------------------------------------------
print("Plot Ertrag")
max_y = 30000

plot(modell_datum,modell_yield,col="red",main="Ertrag", xlab="Datum", ylab="Trockenmasseertrag [kg ha-1]", ylim=c(0,max_y), type="l")
lines(modell_datum,modell_above_bm, col="darkgrey")
lines(modell_datum,modell_yield, col="red")
grid(col="lightgrey")

if (calc_ertrag == 1 & compare_with_measured_values==1) {
  points(mean_zwischenernte_datum,mean_zwischenernte, col="darkgrey")
  points(avg_yielddatum,avg_messertrag, col="red")
  
  for (i in seq(1:length(mean_zwischenernte_datum))) {
     print(mean_zwischenernte_datum[i])
     print(mean_zwischenernte[i])
     cat("Zwischenernte",as.character(mean_zwischenernte_datum[i]), as.numeric(mean_zwischenernte[i]), "\n", file=mess_filename, sep=";", append=TRUE)    
  }
  
  for (i in seq(1:length(avg_yielddatum))) {
     cat("Ertrag",as.character(avg_yielddatum[i]), as.numeric(avg_messertrag[i]), "\n", file=mess_filename, sep=";", append=TRUE)    
  }
  
  
}

for (i in seq(1:fert_len)) {
	x=c(fertilizer_datum[i],fertilizer_datum[i])
	y=c(0,max_y)
	lines(x,y, col="darkgrey")
}
par(xpd=TRUE)
if (calc_ertrag == 1) {
  text(avg_yielddatum, max_y, labels=avg_crop_id, cex=0.9, col="black")
  text(avg_yielddatum, max_y*0.95, labels=avg_sorte, cex=0.9, col="black")
  text(legend_date,12000.0, labels=paste("MBE:   ",round(mbe_ertrag,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,10500, labels=paste("MAE:    ",round(mae_ertrag,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,9000, labels=paste("nMAE:  ",round(nmae_ertrag,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,7500, labels=paste("EF:  ",round(ef_ertrag,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,6000, labels=paste("IoA:  ",round(ioa_ertrag,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell Ertrag", "Modell Ob. Biom.", "Messwert Endernte", "Messwert Zwischenernte","Düngung"), pch=c("_","_","o","o","_"), col=c("red","darkgrey","red","darkgrey", "darkgrey"))
par(xpd=FALSE)

# Grafik - Defizite ----------------------------------------------------

print("Plot Defizite")
max_y=1.5
plot(modell_datum,modell_trans_def, type="l", col="slateblue1", main="Defizite", xlab="Datum", ylab="", ylim=c(0.0, max_y), yaxt="n")
grid(col="lightgrey")
lines(modell_datum,modell_n_def,col="firebrick4")
for (i in seq(1:fert_len)) {
	x=c(fertilizer_datum[i],fertilizer_datum[i])
	y=c(0,max_y)
	lines(x,y, col="black")
}

par(new=T)	# neue grafik in gleichen plot darstellen

max_y=7
plot(modell_datum,modell_dev_stage, type="l", col="grey", axes=F, xlab="", ylab="",yaxt="n", xaxt="n", ylim=c(0,max_y))
mtext("Entwicklungsstadium",side=4, line=2, cex=0.7)
axis(4, cex=0.7, col="blue") # rechte y achse zeichnen

par(xpd=TRUE)
legend(legend_date2, max_y,inset=c(0.01,0.02), c("Transpiration-Defizit","N-Defizit", "Düngung", "Entw.-stadium"), pch=c("_","_","_","_"), col=c("slateblue1","firebrick4","darkgrey", "grey"))
par(xpd=FALSE)

max_y = 8
# Entwicklungsstadien
print("Plot Entwicklungsstadien")
plot(modell_datum,modell_dev_stage, type="l", col="black", xlab="Datum", ylab="Entwicklungsstadien", ylim=c(0,max_y))
if (calc_bbch == 1 & compare_with_measured_values==1) {
  points(bbch_datum, bbch_mess, col="red")
}
grid(col="lightgrey")


par(xpd=TRUE)
legend(legend_date2, max_y,inset=c(0.01,0.02), c("Entw.-Stad.","Düngung", "Messpunkte"), pch=c("_","_","o"), col=c("black","darkgrey","red"))
par(xpd=FALSE)

# Bestandeshöhe -------------------------------------------------------

print("Plot Höhe")
max_y=4
plot(modell_datum,modell_height,col="red",main="Bestandeshöhe", xlab="Datum", ylab="Höhe [m]", ylim=c(0,max_y), type="l", cex=1.0)

if (calc_height == 1 & compare_with_measured_values==1) {
  points(height_datum,height, col="black")
}

grid(col="lightgrey")
for (i in seq(1:fert_len)) {
  x=c(fertilizer_datum[i],fertilizer_datum[i])
  y=c(0,max_y)
  lines(x,y, col="darkgrey")
}
par(xpd=TRUE)
if (calc_height == 1) {
  text(legend_date,2.5, labels=paste("MBE:   ",round(mbe_height,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,2, labels=paste("MAE:    ",round(mae_height,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,1.5, labels=paste("nMAE:  ",round(nmae_height,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,1, labels=paste("EF:    ",round(ef_height,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,0.5, labels=paste("IOA:  ",round(ioa_height,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell","Messpunkte", "Düngung"), pch=c("_","o","_"), col=c("red", "black", "darkgrey"))
par(xpd=FALSE)

#############################################
# Stickstoffmenge
#############################################
print("Plot Stickstoff")
max_y=0.3
plot(modell_datum,modell_yield_n,col="red",main="Stickstoffmenge", xlab="Datum", ylab="Stickstoff [kg N / kg]",ylim=c(0,max_y), type="l", cex=1.0) 

if (calc_nconc == 1 & compare_with_measured_values==1) {
    points(mean_yield_n_datum,mean_yield_n, col="black")
  
  for (i in seq(1:length(mean_yield_n_datum))) {
     cat("N-Conc",as.character(mean_yield_n_datum[i]), as.numeric(mean_yield_n[i]), "\n", file=mess_filename, sep=";", append=TRUE)    
  }
  
}

#grid(col="lightgrey")

#lines(modell_datum,modell_above_bm_n,col="hotpink")
for (i in seq(1:fert_len)) {
	x=c(fertilizer_datum[i],fertilizer_datum[i])
	y=c(0,max_y)
	lines(x,y, col="darkgrey")
}
par(xpd=TRUE)
legend(legend_date2, max_y,inset=c(0.01,0.02), c("N Conc","Düngung"), pch=c("_","_"), col=c("red", "darkgrey"))



if (calc_nconc == 1) {
  text(legend_date2,0.2, labels=paste("MBE:   ",round(mbe_yield_n,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,0.15, labels=paste("MAE:    ",round(mae_yield_n,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,0.1, labels=paste("nMAE:  ",round(nmae_yield_n,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,0.05, labels=paste("EF:  ",round(ef_yield_n,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,0, labels=paste("IOA:  ",round(ioa_yield_n,4)), adj=0,col="black", cex=0.9 )


  #text(legend_date2,90, labels=paste("MBE:   ",round(mbe_n_uptake,4)), adj=0,col="blue", cex=0.9 )
#  text(legend_date2,70, labels=paste("MAE:    ",round(mae_n_uptake,4)), adj=0,col="blue", cex=0.9 )
#  text(legend_date2,50, labels=paste("RSME:  ",round(rsme_n_uptake,4)), adj=0,col="blue", cex=0.9 )
#  text(legend_date2,30, labels=paste("EF:    ",round(ef_n_uptake,4)), adj=0,col="blue", cex=0.9 )
#  text(legend_date2,10, labels=paste("IOA:  ",round(ioa_n_uptake,4)), adj=0,col="blue", cex=0.9 )
}
#legend(legend_date2, max_y,inset=c(0.01,0.02), c("N-TM", "Messpunkte N-TM", "Düngung", "Modell N-Ob.BM"), pch=c("_","o","_","_"), col=c("red", "red", "darkgrey", "blue", "blue"))

par(xpd=FALSE)

#par(new=T)  # neue grafik in gleichen plot darstellen
#max_y=250
#plot(modell_datum,modell_yield_n,col="red",main="Stickstoffmenge", xlab="Datum", ylab="", ylim=c(0,max_y), type="l", cex=1.0, yaxt="n")
#if (calc_nconc == 1 & compare_with_measured_values==1) {
# points(mean_yield_n_datum,mean_yield_n, col="red")
# points(n_zeiternte_datum,n_zeiternte, col="red")
#}

max_y = 500
#################################################
# N Uptake ##############################

print("NUPTAKE")
plot(modell_datum,modell_n_uptake,col="red",main="N Uptake", xlab="Datum", ylab="Stickstoff [kg N ha-1]", ylim=c(0,max_y), type="l", cex=1.0)
for (i in seq(1:fert_len)) {
  x=c(fertilizer_datum[i],fertilizer_datum[i])
  y=c(0,max_y)
  lines(x,y, col="darkgrey")
}
lines(modell_datum, modell_n_uptake_abm, col="grey")
lines(modell_datum, modell_n_uptake, col="red")

print(mean_n_uptake_datum)
print(mean_n_uptake)
if (calc_nconc == 1 & compare_with_measured_values==1) {
  points(mean_n_uptake_datum,mean_n_uptake, col="black")
  points(n_uptake_abm_datum, n_uptake_abm, col="darkgrey")
  
  for (i in seq(1:length(mean_n_uptake_datum))) {
     cat("N-Uptake",as.character(mean_n_uptake_datum[i]), as.numeric(mean_n_uptake[i]), "\n", file=mess_filename, sep=";", append=TRUE)    
  }
  
   for (i in seq(1:length(n_uptake_abm_datum))) {
     cat("N-Uptake ZE",as.character(n_uptake_abm_datum[i]), as.numeric(n_uptake_abm[i]), "\n", file=mess_filename, sep=";", append=TRUE)    
  }
    
}
par(xpd=TRUE)
legend(legend_date2, max_y,inset=c(0.01,0.02), c("N Ob. Biomasse","Düngung"), pch=c("_","_"), col=c("red", "darkgrey"))
if (calc_nconc == 1) {
  text(legend_date2,300, labels=paste("MBE:   ",round(mbe_n_uptake,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,250, labels=paste("MAE:    ",round(mae_n_uptake,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,200, labels=paste("nMAE:  ",round(nmae_n_uptake,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,150, labels=paste("EF:  ",round(ef_n_uptake,4)), adj=0,col="black", cex=0.9 )
  text(legend_date2,100, labels=paste("IOA:  ",round(ioa_n_uptake,4)), adj=0,col="black", cex=0.9 )
}

#################################################
# bedeckungsgrad
#print("Plot Bedeckungsgrad")
#max_y=100
#plot(modell_datum,modell_bedgrad,col="red",main="Boden-Bedeckungsgrad", xlab="Datum", ylab="Bedeckungsgrad[%]", ylim=c(0,max_y), type="l", cex=1.0)
#grid(col="lightgrey")
#points(bedgrad_datum,bedgrad, col="black")
#for (i in seq(1:fert_len)) {
#	x=c(fertilizer_datum[i],fertilizer_datum[i])
#	y=c(0,max_y)
#	lines(x,y, col="darkgrey")
#}
#par(xpd=TRUE)
#text(legend_date,60, labels=paste("MBE:   ",round(mbe_bedgrad,2)), adj=0,col="black", cex=0.9 )
#text(legend_date,50, labels=paste("MAE:    ",round(mae_bedgrad,2)), adj=0,col="black", cex=0.9 )
#text(legend_date,40, labels=paste("RSME:  ",round(rsme_bedgrad,2)), adj=0,col="black", cex=0.9 )
#text(legend_date,30, labels=paste("EF:    ",round(ef_bedgrad,2)), adj=0,col="black", cex=0.9 )
#text(legend_date,20, labels=paste("IOA:  ",round(ioa_bedgrad,2)), adj=0,col="black", cex=0.9 )
#legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte", "Düngung"), pch=c("_","o","_"), col=c("red", "black", "darkgrey"))
#par(xpd=FALSE)



##############################################################
# other grafic
##############################################################

png(filename=paste(root_folder,folder,"/",standortname,"_boden_klass-",classification,"_ff",ff,"-anlage-", anlage, "-profil",profil,".png",sep=""), width=1600, height=900, pointsize=16) 
# plot Einstellungen
par(
bty="l", 		# Box in Form eines "L"
cex.main=1.0,	# Schriftgröße der Plot-Überschriften
lwd=1,			# Linienstärke
mar=c(4.5,4,3,15), 	# Rahmen-Abstände (unten, links, oben, rechts)
xpd=FALSE,		# Außerhalb des Rahmen Zeichnen (z.B. Legende)
mfrow=c(4,2)
)


nmin_0_30_max = 300
nmin_30_60_max = 300
nmin_60_90_max = 300
wasser_max = 50

print("Plot Wasser 0-30cm")
# Wassergehalt 0-30 cm
max_y=wasser_max
if (calc_soilmoisture == 1) {
  plot(modell_datum, modell_moisture_0_30,col="red",main="Bodenwassergehalt 0-30cm", xlab="Datum", ylab="Wassergehalt [Vol-%]", ylim=c(0,max_y), type="l", cex=1.0)
  
  abline(h=fc[1], col="darkgrey")
  abline(h=pwp[1], col="darkgrey")

    if (compare_with_measured_values==1) {
     points(moisture30_datum, moisture30, col="black")
    }
}

if (calc_wasser_v4) {
  plot(modell_datum, modell_moisture30,col="red",main="Bodenwassergehalt 30cm", xlab="Datum", ylab="Wassergehalt [Vol-%]", ylim=c(0,max_y), type="l", cex=1.0)
  lines(moisture30_datum, moisture30, col="black")
    if (compare_with_measured_values==1) {
      points(moisture30_datum_grav, moisture30_grav, col="blue")
    }
}
grid(col="lightgrey")
par(xpd=TRUE)
if (calc_soilmoisture == 1 | calc_wasser_v4==1) {
  text(legend_date,32, labels=paste("MBE:   ",round(mbe_moisture30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,26, labels=paste("MAE:    ",round(mae_moisture30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,20, labels=paste("nMAE:  ",round(nmae_moisture30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,14, labels=paste("EF:    ",round(ef_moisture30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,8, labels=paste("IOA:  ",round(ioa_moisture30,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte"), pch=c("_","o"), col=c("red", "black"))
par(xpd=FALSE)


max_y = nmin_0_30_max
# NMIN-Gehalt
print("Plot Nmin 0-30cm")
plot(modell_datum, modell_nmin_0_30,col="red",main="Boden-Nmin 0-30cm", xlab="Datum", ylab=" [kg N / ha]", ylim=c(0,max_y), type="l", cex=1.0)
grid(col="lightgrey")
for (i in seq(1:fert_len)) {
	x=c(fertilizer_datum[i],fertilizer_datum[i])
	y=c(0,max_y)
	lines(x,y, col="darkgrey")
}
if (calc_soilnmin == 1 & compare_with_measured_values==1) {
  points(nmin30_datum, nmin30, col="black")
}
par(xpd=TRUE)
if (calc_soilnmin == 1) {
  text(legend_date,100, labels=paste("MBE:   ",round(mbe_nmin30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,80, labels=paste("MAE:    ",round(mae_nmin30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,60, labels=paste("nMAE:  ",round(nmae_nmin30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,40, labels=paste("EF:    ",round(ef_nmin30,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,20, labels=paste("IOA:  ",round(ioa_nmin30,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte", "Düngung"), pch=c("_","o","_"), col=c("red", "black", "darkgrey"))
par(xpd=FALSE)


max_y=wasser_max
# Wassergehalt 30-60 cm
print("Plot Wasser 30-60cm")
if (calc_soilmoisture == 1) {
  plot(modell_datum, modell_moisture_30_60,col="red",main="Bodenwassergehalt 30-60cm", xlab="Datum", ylab="Wassergehalt [Vol-%]", ylim=c(0,max_y), type="l", cex=1.0)
  
  abline(h=fc[2], col="darkgrey")
  abline(h=pwp[2], col="darkgrey")
if (compare_with_measured_values==1) {
  points(moisture60_datum, moisture60, col="black")
}
}
if (calc_wasser_v4) {
  plot(modell_datum, modell_moisture60,col="red",main="Bodenwassergehalt 60cm", xlab="Datum", ylab="Wassergehalt [Vol-%]", ylim=c(0,max_y), type="l", cex=1.0)
  lines(moisture60_datum, moisture60, col="black")
    if (compare_with_measured_values==1) {
      points(moisture60_datum_grav, moisture60_grav, col="blue")
    }
}
grid(col="lightgrey")
par(xpd=TRUE)
if (calc_soilmoisture == 1 | calc_wasser_v4==1) {
  text(legend_date,32, labels=paste("MBE:   ",round(mbe_moisture60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,26, labels=paste("MAE:    ",round(mae_moisture60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,20, labels=paste("nMAE:  ",round(nmae_moisture60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,14, labels=paste("EF:    ",round(ef_moisture60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,8, labels=paste("IOA:  ",round(ioa_moisture60,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte"), pch=c("_","o"), col=c("red", "black"))
par(xpd=FALSE)


# NMIN-Gehalt
if (calc_soilnmin==1) {
max_y = nmin_30_60_max
print("Plot Nmin 30-60cm")
plot(modell_datum, modell_nmin_30_60,col="red",main="Boden-Nmin 30-60cm", xlab="Datum", ylab=" [kg N / ha]", ylim=c(0,max_y), type="l", cex=1.0)
grid(col="lightgrey")
for (i in seq(1:fert_len)) {
	x=c(fertilizer_datum[i],fertilizer_datum[i])
	y=c(0,max_y)
	lines(x,y, col="darkgrey")
}
if (calc_soilnmin == 1 & compare_with_measured_values==1) {
  points(nmin60_datum, nmin60, col="black")
}
par(xpd=TRUE)
if (calc_soilnmin == 1) {
  text(legend_date,100, labels=paste("MBE:   ",round(mbe_nmin60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,80, labels=paste("MAE:    ",round(mae_nmin60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,60, labels=paste("nMAE:  ",round(nmae_nmin60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,40, labels=paste("EF:    ",round(ef_nmin60,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,20, labels=paste("IOA:  ",round(ioa_nmin60,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte", "Düngung"), pch=c("_","o","_"), col=c("red", "black", "darkgrey"))
par(xpd=FALSE)
}

max_y=wasser_max
# Wassergehalt 60-90 cm
print("Plot Wasser 60-90cm")
if (calc_soilmoisture == 1) {
  plot(modell_datum, modell_moisture_60_90,col="red",main="Bodenwassergehalt 60-90cm", xlab="Datum", ylab="Wassergehalt [Vol-%]", ylim=c(0,max_y), type="l", cex=1.0)  
  abline(h=fc[3], col="darkgrey")
  abline(h=pwp[3], col="darkgrey")
    if (compare_with_measured_values==1) {
      points(moisture90_datum, moisture90, col="black")
    }
}
if (calc_wasser_v4) {
  plot(modell_datum, modell_moisture90,col="red",main="Bodenwassergehalt 90cm", xlab="Datum", ylab="Wassergehalt [Vol-%]", ylim=c(0,max_y), type="l", cex=1.0)
  lines(moisture90_datum, moisture90, col="black")
    if (compare_with_measured_values==1) {
      points(moisture90_datum_grav, moisture90_grav, col="blue")
    }
}
grid(col="lightgrey")
par(xpd=TRUE)
if (calc_soilmoisture == 1 | calc_wasser_v4==1) {
  text(legend_date,32, labels=paste("MBE:   ",round(mbe_moisture90,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,26, labels=paste("MAE:    ",round(mae_moisture90,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,20, labels=paste("nMAE:  ",round(nmae_moisture90,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,14, labels=paste("EF:    ",round(ef_moisture90,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,8, labels=paste("IOA:  ",round(ioa_moisture90,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte"), pch=c("_","o"), col=c("red", "black"))
par(xpd=FALSE)



# NMIN-Gehalt
print("Plot Nmin 0-90cm")
if (calc_soilnmin==1) {
max_y = 300
plot(modell_datum, modell_nmin_0_90,col="red",main="Boden-Nmin 0-90cm", xlab="Datum", ylab=" [kg N / ha]", ylim=c(0,max_y), type="l", cex=1.0)
grid(col="lightgrey")
for (i in seq(1:fert_len)) {
	x=c(fertilizer_datum[i],fertilizer_datum[i])
	y=c(0,max_y)
	lines(x,y, col="darkgrey")
}
if (calc_soilnmin == 1 & compare_with_measured_values==1) {
  points(sum_nmin_datum, sum_nmin, col="black")
}
par(xpd=TRUE)
if (calc_soilnmin == 1) {
  text(legend_date,100, labels=paste("MBE:   ",round(mbe_nmin1_3,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,80, labels=paste("MAE:    ",round(mae_nmin1_3,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,60, labels=paste("nMAE:  ",round(nmae_nmin1_3,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,40, labels=paste("EF:    ",round(ef_nmin1_3,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,20, labels=paste("IOA:  ",round(ioa_nmin1_3,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte", "Düngung"), pch=c("_","o","_"), col=c("red", "black", "darkgrey"))
par(xpd=FALSE)

}

bodtemp_max = 30

# Bodentemperatur 5cm
print("Plot Soil temperature 5cm")
max_y = bodtemp_max
plot(modell_datum, modell_bodtemp5,col="red",main="Bodentemperatur 0-10cm", xlab="Datum", ylab=" [°C]", ylim=c(0,max_y), type="l", cex=1.0)
grid(col="lightgrey")

if (calc_bodtemp == 1 & compare_with_measured_values==1) {
  points(bodtemp5_datum, bodtemp5, col="black", pch='.')
}

par(xpd=TRUE)
if (calc_bodtemp  == 1) {
  text(legend_date,14, labels=paste("MBE:   ",round(mbe_bodtemp5,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,11, labels=paste("MAE:    ",round(mae_bodtemp5,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,8, labels=paste("nMAE:  ",round(nmae_bodtemp5,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,5, labels=paste("EF:    ",round(ef_bodtemp5,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,2, labels=paste("IOA:  ",round(ioa_bodtemp5,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte"), pch=c("_","o"), col=c("red", "black"))
par(xpd=FALSE)



# Bodentemperatur 20cm
print("Plot Soil temperature 20cm")
max_y = bodtemp_max
plot(modell_datum, modell_bodtemp5,col="red",main="Bodentemperatur 20cm", xlab="Datum", ylab=" [°C]", ylim=c(0,max_y), type="l", cex=1.0)
grid(col="lightgrey")

if (calc_bodtemp == 1 & compare_with_measured_values==1) {
    points(bodtemp20_datum, bodtemp20, col="black", pch='.')
}

par(xpd=TRUE)
if (calc_bodtemp == 1) {
  text(legend_date,14, labels=paste("MBE:   ",round(mbe_bodtemp20,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,11, labels=paste("MAE:    ",round(mae_bodtemp20,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,8, labels=paste("nMAE:  ",round(nmae_bodtemp20,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,5, labels=paste("EF:    ",round(ef_bodtemp20,2)), adj=0,col="black", cex=0.9 )
  text(legend_date,2, labels=paste("IOA:  ",round(ioa_bodtemp20,2)), adj=0,col="black", cex=0.9 )
}
legend(legend_date, max_y,inset=c(0.01,0.02), c("Modell", "Messpunkte"), pch=c("_","o"), col=c("red", "black"))
par(xpd=FALSE)

##############################################################
# other grafic
##############################################################

png(filename=paste(root_folder,folder,"/",standortname,"_recharge_nleaching_klass-",classification, "_ff",ff,"-anlage-", anlage, "-profil",profil,".png",sep=""), width=900, height=900, pointsize=16) 
# plot Einstellungen
par(
bty="l",    # Box in Form eines "L"
cex.main=1.0, # Schriftgröße der Plot-Überschriften
lwd=1,      # Linienstärke
mar=c(4.5,4,3,15),  # Rahmen-Abstände (unten, links, oben, rechts)
xpd=FALSE,    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
mfrow=c(2,1)
)

print("Plot Leaching N")
max_y = 5
plot(modell_datum, modell_nleaching,col="red",main="Leaching N", xlab="Datum", ylim=c(0,max_y), type="l", cex=1.0, yaxt="n", ylab="")
#grid(col="lightgrey")
for (i in seq(1:fert_len)) {
  x=c(fertilizer_datum[i],fertilizer_datum[i])
  y=c(0,max_y)
  lines(x,y, col="darkgrey")
}

mtext("Stickstoff [kg N / ha]",side=2, line=3.0, cex=0.7)
axis(2, cex=0.7, col="red")   # linke y achse zeichnen


par(new=T)  # neue grafik in gleichen plot darstellen

max_y= 27000
plot(modell_datum,modell_above_bm,col="darkgrey", axes=F, ylab="", ylim=c(0,max_y), type="l", cex=1.0, xaxt="n", yaxt="n")
mtext("Ob. Biomasse [kg TM / ha]",side=4, line=2, cex=0.7)
axis(4, cex=0.7, col="black") # rechte y achse zeichnen


par(xpd=TRUE)
legend(legend_date2, max_y,inset=c(0.01,0.02), c("Modell leaching N", "Düngung", "Ob. Biomasse"), pch=c("_","_","_"), col=c("red", "darkgrey","darkgrey"))
par(xpd=FALSE)




print("Plot recharge")
max_y = 30
plot(modell_datum, modell_recharge,col="lightblue",main="Groundwater recharge", xlab="Datum", ylim=c(0,max_y), type="l", cex=1.0, ylab="")

mtext("Grundwassererneuerung [mm]",side=2, line=3.0, cex=0.7)
axis(2, cex=0.7, col="blue")   # linke y achse zeichnen


par(new=T)  # neue grafik in gleichen plot darstellen

max_y= 27000
plot(modell_datum,modell_above_bm,col="black", axes=F, ylab="", ylim=c(0,max_y), type="l", cex=1.0, xaxt="n", yaxt="n")
mtext("Ob. Biomasse [kg TM / ha]",side=4, line=2, cex=0.7)
axis(4, cex=0.7, col="black") # rechte y achse zeichnen

lines(modell_datum,modell_above_bm,col="darkgrey")
par(xpd=TRUE)
legend(legend_date2, max_y,inset=c(0.01,0.02), c("Grundwasserneubildung", "Ob. Biomasse"), pch=c("_","_","_"), col=c("lightblue", "darkgrey", "darkgrey"))
par(xpd=FALSE)


print(paste("Saving results in '", root_folder, folder, "' ...", sep="")) 


filename=paste(root_folder,folder,"/",standortname,"_statistics_", "klass-",classification, "-ff",ff,"-anlage-", anlage, "-profil",profil,".txt",sep="")

cat("", "Size", "MBE", "MAE", "nMAE", "RSME", "nMSEs", "nMSEu", "IoA", "EF", "\n",  file=filename, sep=";", append=FALSE)

if (calc_ertrag == 1) {
  cat("Yield", 
      sample_size_ertrag,
      mbe_ertrag/1000.0,
      mae_ertrag/1000.0,
      nmae_ertrag,
      rsme_ertrag/1000.0,
      nmses_ertrag,
      nmseu_ertrag,
      ioa_ertrag,
      ef_ertrag,
      "\n", file=filename, sep=";", append=TRUE)
}

if (calc_height == 1) {
  cat("Height", 
      sample_size_height,
      mbe_height,
      mae_height,
      nmae_height,
      rsme_height,
      nmses_height,
      nmseu_height,
      ioa_height,
      ef_height,
      "\n", file=filename, sep=";", append=TRUE)
}

if (calc_nconc == 1) {
  cat("Crop N Concentration", 
      sample_yield_n,
      mbe_yield_n,
      mae_yield_n,
      nmae_yield_n,
      rsme_yield_n,
      nmses_yield_n,
      nmseu_yield_n,
      ioa_yield_n,
      ef_yield_n,
      "\n", file=filename, sep=";", append=TRUE)
}    

if ( (calc_ertrag == 1) & (calc_nconc == 1) ) {
  cat("Crop N Uptake", 
      sample_size_n_uptake,
      mbe_n_uptake,
      mae_n_uptake,
      nmae_n_uptake,
      rsme_n_uptake,
      nmses_n_uptake,
      nmseu_n_uptake,
      ioa_n_uptake,
      ef_n_uptake,
      "\n", file=filename, sep=";", append=TRUE)
}

if (calc_bedgrad == 1) {    
  cat("Bedgrad", 
      sample_size_bedgrad,
      mbe_bedgrad,
      mae_bedgrad,
      nmae_bedgrad,
      rsme_bedgrad,
      nmses_bedgrad,
      nmseu_bedgrad,
      ioa_bedgrad,
      ef_bedgrad,
      "\n", file=filename, sep=";", append=TRUE)
}
    
if (calc_soilnmin == 1) {
  cat("Nmin 0-30cm", 
    sample_size_nmin30,
    mbe_nmin30,
    mae_nmin30,
    nmae_nmin30,
    rsme_nmin30,
    nmses_nmin30,
    nmseu_nmin30,
    ioa_nmin30,
    ef_nmin30,
    "\n", file=filename, sep=";", append=TRUE)


  cat("Nmin 30-60cm",
    sample_size_nmin60, 
    mbe_nmin60,
    mae_nmin60,
    nmae_nmin60,
    rsme_nmin60,
    nmses_nmin60,
    nmseu_nmin60,
    ioa_nmin60,
    ef_nmin60,
    "\n", file=filename, sep=";", append=TRUE)

  cat("Nmin 60-90cm",
    sample_size_nmin90, 
    mbe_nmin90,
    mae_nmin90,
    nmae_nmin90,
    rsme_nmin90,
    nmses_nmin90,
    nmseu_nmin90,
    ioa_nmin90,
    ef_nmin90,
    "\n", file=filename, sep=";", append=TRUE)
    
    
  cat("Nmin 0-90cm",
    sample_size_nmin1_3, 
    mbe_nmin1_3,
    mae_nmin1_3,
    nmae_nmin1_3,
    rsme_nmin1_3,
    nmses_nmin1_3,
    nmseu_nmin1_3,
    ioa_nmin1_3,
    ef_nmin1_3,
    "\n", file=filename, sep=";", append=TRUE)
}

if (calc_soilmoisture == 1) {
  cat("Wasser 0-30cm",
    sample_size_moisture30, 
    mbe_moisture30,
    mae_moisture30,
    nmae_moisture30,
    rsme_moisture30,
    nmses_moisture30,
    nmseu_moisture30,
    ioa_moisture30,
    ef_moisture30,
    "\n", file=filename, sep=";", append=TRUE)


  cat("Wasser 30-60cm", 
    sample_size_moisture60,
    mbe_moisture60,
    mae_moisture60,
    nmae_moisture60,
    rsme_moisture60,
    nmses_moisture60,
    nmseu_moisture60,
    ioa_moisture60,
    ef_moisture60,
    "\n", file=filename, sep=";", append=TRUE)
    
  cat("Wasser 60-90cm", 
    sample_size_moisture90,
    mbe_moisture90,
    mae_moisture90,
    nmae_moisture90,
    rsme_moisture90,
    nmses_moisture90,
    nmseu_moisture90,
    ioa_moisture90,
    ef_moisture90,
    "\n", file=filename, sep=";", append=TRUE)
    
  cat("Wasser 0-90cm", 
    sample_size_moisture1_3,
    mbe_moisture1_3,
    mae_moisture1_3,
    nmae_moisture1_3,
    rsme_moisture1_3,
    nmses_moisture1_3,
    nmseu_moisture1_3,
    ioa_moisture1_3,
    ef_moisture1_3,
    "\n", file=filename, sep=";", append=TRUE)
    
}    

if (calc_bodtemp == 1) {
  cat("BodTemp 5cm",
    sample_size_bodtemp5, 
    mbe_bodtemp5,
    mae_bodtemp5,
    nmae_bodtemp5,
    rsme_bodtemp5,
    nmses_bodtemp5,
    nmseu_bodtemp5,
    ioa_bodtemp5,
    ef_bodtemp5,
    "\n", file=filename, sep=";", append=TRUE)
  cat("BodTemp 20cm",
    sample_size_bodtemp20, 
    mbe_bodtemp20,
    mae_bodtemp20,
    nmae_bodtemp20,
    rsme_bodtemp20,
    nmses_bodtemp20,
    nmseu_bodtemp20,
    ioa_bodtemp20,
    ef_bodtemp20,
    "\n", file=filename, sep=";", append=TRUE)

 }



source("quality_graphics.r")
