# read configuration for selecting the correct profile and cultivar

source("config.r")
source("dir_config.r")

# import functions for statistical parameters
source("r_statistical_calculations.r")


# filename specification
smout_file = paste(root_folder,folder, "/smout.dat", sep="")
rmout_file = paste(root_folder,folder, "/rmout.dat", sep="")

# read model data
smout = read.table(smout_file, header=T, sep="\t", skip=2)
hl = readLines(smout_file, 1)
hl = strsplit(hl, '\t')
colnames(smout) = hl[[1]]


rmout = read.table(rmout_file, header=T, sep="\t", skip=2)
hl = readLines(rmout_file, 1)
hl = strsplit(hl, '\t')
colnames(rmout) = hl[[1]]


modell_datum = strptime(smout$Datum,format="%d/%m/%Y")

min_date = min(modell_datum)
max_date = max(modell_datum)
min_year = format(min_date, "%Y")
max_year = format(max_date, "%Y")

years = seq(min_year,max_year)

n = length(years) + 1

modell_n_uptake = smout$TotNup
modell_nmin_0_90 = smout$N0.90 * 10 # Umrechnung von g/m2 in kg/ha
modell_recharge = rmout$Recharge
modell_nleaching = rmout$NLeach
modell_act_ET = rmout$act_ET
modell_runoff = rmout$RunOff
modell_precip = rmout$Precip

sum_n_uptake = vector (n, mode="numeric")
sum_nmin = vector (n, mode="numeric")
sum_recharge = vector (n, mode="numeric")
sum_nleaching = vector (n, mode="numeric")
sum_act_ET = vector (n, mode="numeric")
sum_runoff = vector (n, mode="numeric")
sum_precip = vector (n, mode="numeric")

for (i in 1:(n-1)) {
  
  # find indizes for date that lay between the range
  # of 1.1.YEAR and 31.12.YEAR  
  min = ISOdate(years[i]-1,12,31)
  max = ISOdate(years[i],12,31)
  indizes = which(modell_datum>min & modell_datum<max)

  #print(paste("Min: ", min))
  #print(paste("Max: ", max))
  #print(modell_datum[indizes])
  
  sum_n_uptake[i] = sum(modell_n_uptake[indizes])
  sum_nmin[i] = sum(modell_nmin_0_90[indizes])
  sum_recharge[i] = sum(modell_recharge[indizes])
  sum_nleaching[i] = sum(modell_nleaching[indizes])
  sum_act_ET[i] = sum(modell_act_ET[indizes])
  sum_runoff[i] = sum(modell_runoff[indizes])
  sum_precip[i] = sum(modell_precip[indizes])
}

# add total sum to vector
sum_n_uptake[n] = sum(sum_n_uptake[1:n-1])
sum_nmin[n] = sum(sum_nmin[1:n-1])
sum_recharge[n] = sum(sum_recharge[1:n-1])
sum_nleaching[n] = sum(sum_nleaching[1:n-1])
sum_act_ET[n] = sum(sum_act_ET[1:n-1])
sum_runoff[n] = sum(sum_runoff[1:n-1])
sum_precip[n] = sum(sum_precip[1:n-1])



png(filename=paste(root_folder,folder,"/",location,"_yearly_analyse_ff",ff,"-anlage-", anlage, "-profil",profil,".png",sep=""), width=1600, height=450, pointsize=16) 
# plot Einstellungen
par(
bty="l",    # Box in Form eines "L"
cex.main=1.0, # Schriftgröße der Plot-Überschriften
lwd=2,      # Linienstärke
mar=c(4.5,4,3,5),  # Rahmen-Abstände (unten, links, oben, rechts)
xpd=FALSE,    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
mfrow=c(1,2)
)

#barplot(sum_n_uptake[1:n-1], col="khaki3", main="N-Uptake pro Jahr", names=years, ylab="N-Aufnahme [kg N / ha]")
#grid(ny=NULL, nx=NA, col="black")
#barplot(sum_nmin[1:n-1], col="palegreen", main="Nmin pro Jahr", names=years, ylab="Nmin 0-90cm [kg N / ha]")
#grid(ny=NULL, nx=NA, col="black")
barplot(sum_recharge[1:n-1], col="lightblue", main="Jährliche Grundwasserneubildung", names=years, ylab="Grundwasserneubildung [mm]")
grid(ny=NULL, nx=NA, col="black")
barplot(sum_nleaching[1:n-1], col="lightsalmon4", main="Stickstoffaustrag pro Jahr", names=years, ylab="[kg N / ha]")
grid(ny=NULL, nx=NA, col="black")







#data_folder = paste(root_folder, "../", sep="")

filename=paste(root_folder,folder,"/",location,"_yearly_analyse_ff",ff,"-anlage-", anlage, "-profil",profil,".txt",sep="")
print(filename)
cat("", years, "Gesamt","\n", file=filename, sep=";",append=FALSE)
cat("N-Uptake", sum_n_uptake,"\n", file=filename, sep=";", append=TRUE)
cat("Nmin", sum_nmin,"\n", file=filename, sep=";", append=TRUE)
cat("GW-Recharge", sum_recharge,"\n", file=filename, sep=";", append=TRUE)
cat("leachingN", sum_nleaching,"\n", file=filename, sep=";", append=TRUE)
cat("actET", sum_act_ET,"\n", file=filename, sep=";", append=TRUE)
cat("SurfaceRunOff", sum_runoff,"\n", file=filename, sep=";", append=TRUE)
cat("Precip", sum_precip,"\n", file=filename, sep=";", append=TRUE)
