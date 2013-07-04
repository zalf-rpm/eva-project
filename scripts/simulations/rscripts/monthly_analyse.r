source("config.r")

calcMonthlyValues <- function(years, month, month_names, datum, values, filename, name, ytext, color) 
{
  n_month = length(month)
  n_years = length(years)
  number_grafics = (n_years+1)/2
  height = min((6*number_grafics), 20)
  png(filename=paste(root_folder,folder,"/month/img/",location,"_monthly_analyse_ff",ff,"-anlage-", anlage, "-profil",profil,"-",filename,".png",sep=""), width=18, height=height, pointsize=12, res=300, units="cm") 
 
  # plot Einstellungen
  par(
    bty="l",    # Box in Form eines "L"
    cex.main=1.0, # Schriftgröße der Plot-Überschriften
    lwd=2,      # Linienstärke
    mar=c(4,4,2,3),  # Rahmen-Abstände (unten, links, oben, rechts)
    xpd=FALSE,    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    mfrow=c(number_grafics,2)
  )
  
  filename=paste(root_folder,folder,"/month/",location,"_monthly_analyse_ff",ff,"-anlage-", anlage, "-profil",profil,"-",filename,".txt",sep="")
  
  cat("", paste(month), "\n", file=filename, sep=";",append=FALSE)  
  cat("", paste(month_names), "Gesamt", "\n", file=filename, sep=";",append=TRUE)
  for (i in 1:(n_years)) {
    print(paste("Years: ", years[i]))
    monthly_sum = vector (n_month+1, mode="numeric")
    cat(paste(years[i]), file=filename, sep=";", append=TRUE)
    cat(";", file=filename, sep=";", append=TRUE)
    start = paste(years[i],"-01-01", sep="")
    end = paste(years[i]+1,"-01-01", sep="")
    dates <- seq(as.POSIXct(start), as.POSIXct(end), by='1 month')
    for (m in month) {
      #print(paste("Monat: ", month_names[m]))
      # find indizes for date that lay between the range
      # of 1.1.YEAR and 31.12.YEAR  
      min = (dates[m])      
      max =(dates[m+1])      
      
      indizes = which(datum>=min & datum<max)

      #print(paste("Min: ", min))
      #print(paste("Max: ", max))
      #print(modell_datum[indizes])
  
      monthly_sum[m] = sum(values[indizes])
      
      #cat(paste(monthly_sum[m]), file=filename, sep=";", append=TRUE)
      #cat(";", file=filename, sep=";", append=TRUE)
    } # month
    monthly_sum[n_month+1] = sum(monthly_sum[1:(n_month)])
    cat(paste(monthly_sum), "\n", file=filename, sep=";",append=TRUE)
    barplot(monthly_sum[1:(n_month)], col=color, main=paste(name, years[i]), names=month, ylab=ytext, xlab=years[i])
    grid(ny=NULL, nx=NA, col="black", lty=1, lwd=1)
    
    #cat("\n", file=filename, sep=";", append=TRUE)
  } # year
}


# read configuration for selecting the correct profile and cultivar

source("config.r")
source("dir_config.r")

# import functions for statistical parameters
source("r_statistical_calculations.r")


# filename specification
smout_file = paste(root_folder,folder, "/smout.dat", sep="")
rmout_file = paste(root_folder,folder, "/rmout.dat", sep="")

# read model data
smout = read.table(smout_file, header=T, sep="\t")
rmout = read.table(rmout_file, header=T, sep="\t")

month = seq(1:12)
month_names = c("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember")

modell_datum = strptime(smout$Datum,format="%d/%m/%Y")

min_date = min(modell_datum)
max_date = max(modell_datum)
min_year = format(min_date, "%Y")
max_year = format(max_date, "%Y")

years = seq(min_year,max_year)



modell_n_uptake = smout$TotNup
modell_nmin_0_90 = smout$N0.90 * 10  # Umrechnung von g/m2 in kg/ha
modell_recharge = rmout$Recharge
modell_nleaching = rmout$NLeach
modell_act_ET = rmout$act_ET
modell_runoff = rmout$Runoff
modell_precip = rmout$Precip



print("Calculating mongthly values for nuptake")
calcMonthlyValues(years, month, month_names, modell_datum,modell_n_uptake, "nuptake", "N-Aufnahme", "N-Aufnahme [kg N / ha]","khaki3")

print("Calculating mongthly values for Nmin 0-90cm")
calcMonthlyValues(years, month, month_names, modell_datum,modell_nmin_0_90, "Nmin_0_90", "Nmin 0-90cm", "N-Aufnahme [kg N / ha]", "khaki3")

print("Calculating mongthly values for GW Recharge")
calcMonthlyValues(years, month, month_names, modell_datum,modell_recharge, "gw_recharge", "Grundwasserneubildung", "Grundwasserneubildung [mm]","lightblue")

print("Calculating mongthly values for leaching N")
calcMonthlyValues(years, month, month_names, modell_datum,modell_nleaching, "n_leaching", "Stickstoffaustrag", "Stickstoffaustrag [kg N / ha]","khaki3")

print("Calculating mongthly values for act. ET")
calcMonthlyValues(years, month, month_names, modell_datum,modell_act_ET, "act_et", "Evapotranspiration", "Akt. ET [mm]","lightblue")

print("Calculating mongthly values for GW recharge")
calcMonthlyValues(years, month, month_names, modell_datum,modell_runoff, "runoff", "Oberfl.-Abfluss", "[mm]","lightblue")

print("Calculating mongthly values for precip")
calcMonthlyValues(years, month, month_names, modell_datum,modell_precip, "precip", "Korr. Niederschlag", "[mm]","lightblue")


# add total sum to vector

