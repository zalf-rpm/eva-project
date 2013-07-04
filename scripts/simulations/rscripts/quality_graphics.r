path = paste(root_folder,folder,"/quality_graphics/",location,"-ff",ff,"-anlage-", anlage, "-profil",profil,sep="")

###########################################################
# Konfiguration
###########################################################
w=18
h=8
ps = 24

cex_main=1.0
cex_axis=1.0

lwd_curve = 3
lwd_general = 3
lwd_grid = 1
lwd_axis = 2
lwd_fertilizer = 1

color_grid = "darkgrey"
color_fertilizer = "darkgreen"
color_axis = "black"
show_grid = 0

legend_date=ISOdate(legend_year,7,1)
legend_date2=ISOdate(legend_year,7,1)
legend_date3=ISOdate(legend_year,9,1)

###########################################################
modell_datum = strptime(smout$Datum,format="%d/%m/%Y")

min_date = min(modell_datum)
max_date = max(modell_datum)
min_year = format(min_date, "%Y")
max_year = format(max_date, "%Y")
max_year = as.numeric(max_year)+1

max_date = paste(max_year, format(max_date, "-%m-%d"), sep="")

quartals <- seq(as.POSIXct(format(min_date, "%Y-%m-%d")), as.POSIXct(max_date), by='3 month')
print(quartals)
half_years <- seq(as.POSIXct(format(min_date, "%Y-%m-%d")), as.POSIXct(max_date), by='6 month')
years <- seq(as.POSIXct(format(min_date, "%Y-%m-%d")), as.POSIXct(max_date), by='1 year')
print(years)
labels = format(years, "%Y")
print(labels)

###########################################################
# Ertrag
###########################################################

if (calc_ertrag == 1) {
    print("Q-Plot Ertrag")

    filename = paste(path, "-ertrag.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y = 200
    plot(modell_datum, modell_yield/100.0, 
         col="#42a46b", 
    #     main="Yield", 
         xlab="Datum", 
         ylab="TM-Ertrag [dt ha-1]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )

    # grid
#    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(avg_yielddatum,avg_messertrag/1000.0, col="black")
    }

    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

}


###########################################################
# Ertrag
###########################################################

if (calc_ertrag == 1 ) {
    print("Q-Plot Oberirdische Biomasse")

    filename = paste(path, "-ob_biomasse.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y = 30
    plot(modell_datum, modell_above_bm/1000.0, 
         col="red", 
    #     main="Yield", 
         xlab="Datum", 
         ylab="Trockenmasseertrag [t ha-1]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )

    # grid
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        #points(avg_yielddatum,avg_messertrag/1000.0, col="black")
    }

    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

}
###########################################################
# Oberirdische Biomasse
###########################################################

if ((calc_ertrag == 1) & (calc_nconc == 1)) {

print("Q-Plot N-Uptake")

filename = paste(path, "-Nuptake.png", sep="")
png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

# plot Einstellungen
par(
  bty="l",    # Box in Form eines "L"
  cex.main=cex_main, # Schriftgröße der Plot-Überschriften
  lwd=lwd_general,      # Linienstärke
  mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
  xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
)

max_y = 500
plot(modell_datum,modell_n_uptake, 
     col="red", 
#     main="Yield", 
     xlab="Datum", 
     ylab="N-Uptake [kg N ha-1]", 
     ylim=c(0,max_y),
     type="l", 
     lwd=lwd_curve,
     xaxt="n"
)

# grid
grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
#abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(mean_yield_n_datum,mean_n_uptake, col="black")
    }

#fertilizer
#abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

# x-Achse
axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

}

###########################################################
# BBCH
###########################################################

if (calc_bbch == 1) {

print("Q-Plot BBCH")

filename = paste(path, "-bbch.png", sep="")
png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=12) 

# plot Einstellungen
par(
  bty="l",    # Box in Form eines "L"
  cex.main=cex_main, # Schriftgröße der Plot-Überschriften
  lwd=lwd_general,      # Linienstärke
  mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
  xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
)

max_y = 8
plot(modell_datum, modell_dev_stage, 
     col="red", 
     main="Entwicklungsstadien", 
     xlab="Datum", 
     ylab="Entwicklungsstadien", 
     ylim=c(0,max_y),
     type="l", 
     lwd=lwd_curve,
     xaxt="n"
)

# grid
grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
#abline(v=half_years, col=color_grid, lwd=lwd_grid)
    if ( compare_with_measured_values==1) {
        # messpunkte
        points(bbch_datum, bbch_mess, col="black")
    }

# x-Achse
axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

}

###########################################################
# Defizite
###########################################################

print("Q-Plot Defizite")

filename = paste(path, "-defizite.png", sep="")
png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

# plot Einstellungen
par(
  bty="l",    # Box in Form eines "L"
  cex.main=cex_main, # Schriftgröße der Plot-Überschriften
  lwd=lwd_general,      # Linienstärke
  mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
  xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
)

max_y = 1.5
plot(modell_datum, modell_trans_def, 
     col="slateblue1", 
     main="Defizite", 
     xlab="Datum", 
     ylab="", 
     ylim=c(0,max_y),
     type="l", 
     lwd=lwd_curve,
     xaxt="n",
     yaxt="n"
)

# grid
#grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
#abline(v=half_years, col=color_grid, lwd=lwd_grid)

lines(modell_datum,modell_n_def,col="firebrick4", lwd=lwd_curve)

#fertilizer
#abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

# x-Achse
axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen


#par(new=T)  # neue grafik in gleichen plot darstellen
#
#max_y=30
#plot(modell_datum, modell_yield/1000.0, 
#     col="darkgrey", 
#     xlab="Datum", 
#     ylab="Developmental stage", 
#     ylim=c(0,max_y),
#     type="l", 
#     lwd=1,
#     xaxt="n",
#     yaxt="n"
#)


###########################################################
# Höhe
###########################################################

if (calc_height == 1) {

    print("Q-Plot Höhe")

    filename = paste(path, "-hoehe.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y = 4
    plot(modell_datum, modell_height, 
         col="red", 
         #main="Bestandeshöhe", 
         xlab="Datum", 
         ylab="Height [m]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )

    # grid
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(height_datum,height, col="black")
    }

    #fertilizer
    abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

}

###########################################################
# N Konzentration
###########################################################

if (calc_nconc == 1) {

    print("Q-Plot N-Konzentration")

    filename = paste(path, "-n-concentration.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y = 0.2
    plot(modell_datum, modell_yield_n, 
         col="red", 
         #main="Yield N concentration", 
         xlab="Datum", 
         ylab="N concentration [kg N kg-1]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )

    # grid
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
    # messpunkte
    points(mean_yield_n_datum,mean_yield_n, col="black")
    #points(n_zeiternte_datum,n_zeiternte, col="black")
    }

    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

}

###########################################################
# Nmin summiert über 0-90cm
###########################################################

if (calc_soilnmin == 1) {

    print("Q-Plot Nmin summiert über 0-90cm")

    filename = paste(path, "-nmin0-90cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    
    max_y = 300
    plot(modell_datum, sum_nmin_modell_values, 
         col="#c85a2e", 
         #main="Soil Nmin 0-90cm", 
         xlab="Datum", 
         ylab="Nmin [kg N ha-1]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )


    # grid
#    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(sum_nmin_datum,sum_nmin, col="black")
    }

    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
}

###########################################################
# Nmin summiert über 0-30cm
###########################################################

if (calc_soilnmin == 1) {

    print("Q-Plot Nmin summiert über 0-30cm")

    filename = paste(path, "-nmin0-30cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    modell_nmin_sum = modell_nmin_0_30

    max_y = nmin_0_30_max
    plot(modell_datum, modell_nmin_sum, 
         col="red", 
         #main="Soil Nmin 0-30cm", 
         xlab="Datum", 
         ylab="Soil Nmin [kg N / ha]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )


    # grid
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(nmin30_datum,nmin30, col="black")
    }

    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
}

###########################################################
# Nmin summiert über 0-30cm
###########################################################

if (calc_soilnmin == 1) {

    print("Q-Plot Nmin summiert über 30-60cm")

    filename = paste(path, "-nmin30-60cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    modell_nmin_sum = modell_nmin_30_60

    max_y = nmin_0_30_max
    plot(modell_datum, modell_nmin_sum, 
         col="red", 
         #main="Soil Nmin 0-30cm", 
         xlab="Datum", 
         ylab="Soil Nmin [kg N / ha]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )


    # grid
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(nmin60_datum,nmin60, col="black")
    }

    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
}

###########################################################
# Nmin summiert über 60-90cm
###########################################################

if (calc_soilnmin == 1) {

    print("Q-Plot Nmin summiert über 60-90cm")

    filename = paste(path, "-nmin60-90cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    modell_nmin_sum = modell_nmin_60_90

    max_y = nmin_0_30_max
    plot(modell_datum, modell_nmin_sum, 
         col="red", 
         #main="Soil Nmin 0-30cm", 
         xlab="Datum", 
         ylab="Soil Nmin [kg N / ha]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )


    # grid
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(nmin90_datum,nmin90, col="black")
    }

    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
}

###########################################################
# Nmin summiert über 90-120cm
###########################################################

if (calc_soilnmin == 1) {

    print("Q-Plot Nmin summiert über 90-120cm")

    filename = paste(path, "-nmin90-120cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,2),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    modell_nmin_sum = modell_nmin_90_120

    max_y = nmin_0_30_max
    plot(modell_datum, modell_nmin_sum, 
         col="red", 
         #main="Soil Nmin 0-30cm", 
         xlab="Datum", 
         ylab="Soil Nmin [kg N / ha]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve,
         xaxt="n"
    )


    # grid
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)


    #fertilizer
    #abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
}

###########################################################
# Wassergehalt 0-30cm
###########################################################

if (calc_soilmoisture == 1) {

    print("Q-Plot SoilMoisture 0-30cm")
    filename = paste(path, "-wasser0-30cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y=wasser_max
    plot(modell_datum, 
        modell_moisture_0_30,
        col="blue",
        #main="Bodenwassergehalt 0-30cm",
        xlab="Datum", 
        ylab="Soil moisture [Vol-%]",
         ylim=c(0,max_y), 
         type="l", 
         lwd=lwd_curve
    )
    abline(h=fc[1], col="darkgrey")
    abline(h=pwp[1], col="darkgrey")
    if ( compare_with_measured_values==1) {
        points(moisture30_datum, moisture30, col="black")
    }
    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
    text(legend_date2,fc[1], labels="FK", col="darkgrey")
    text(legend_date2,pwp[1], labels="PWP", col="darkgrey")
    par(xpd=FALSE)

}

if (calc_wasser_v4 == 1) {

    filename = paste(path, "-wasser30cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y=wasser_max
    plot(modell_datum, 
        modell_moisture30,
        col="blue",
        #main="Bodenwassergehalt 0-30cm",
        xlab="Datum", 
        ylab="Bodenwassergehalt [Vol-%]",
         ylim=c(0,max_y), 
         type="l", 
         lwd=lwd_curve
    )
    abline(h=fc[1], col="darkgrey")
    abline(h=pwp[1], col="darkgrey")
    lines(moisture30_datum, moisture30, col="black")
    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
    text(legend_date2,fc[1], labels="FK", col="darkgrey")
    text(legend_date2,pwp[1], labels="PWP", col="darkgrey")
    par(xpd=FALSE)

}


###########################################################
# Wassergehalt 30-60cm
###########################################################

if (calc_soilmoisture == 1) {

    filename = paste(path, "-wasser30-60cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y=wasser_max
    plot(modell_datum, 
        modell_moisture_30_60,
        col="blue",
        main="Bodenwassergehalt 30-60cm",
        xlab="Datum", 
        ylab="Soil moisture [Vol-%]",
         ylim=c(0,max_y), 
         type="l", 
         lwd=lwd_curve
    )
    abline(h=fc[2], col="darkgrey")
    abline(h=pwp[2], col="darkgrey")
    if ( compare_with_measured_values==1) {
        points(moisture60_datum, moisture60, col="black")
    }

    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
    text(legend_date2,fc[2], labels="FK", col="darkgrey")
    text(legend_date2,pwp[2], labels="PWP", col="darkgrey")
    par(xpd=FALSE)
}

if (calc_wasser_v4 == 1) {

    filename = paste(path, "-wasser60cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y=wasser_max
    plot(modell_datum, 
        modell_moisture_30_60,
        col="blue",
        #main="Bodenwassergehalt 60cm",
        xlab="Datum", 
        ylab="Bodenwassergehalt [Vol-%]",
         ylim=c(0,max_y), 
         type="l", 
         lwd=lwd_curve
    )
    abline(h=fc[2], col="darkgrey")
    abline(h=pwp[2], col="darkgrey")
    lines(moisture60_datum, moisture60, col="black")
    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
    text(legend_date2,fc[2], labels="FK", col="darkgrey")
    text(legend_date2,pwp[2], labels="PWP", col="darkgrey")
    par(xpd=FALSE)
}

###########################################################
# Wassergehalt 60-90cm
###########################################################

if (calc_soilmoisture == 1) {
    filename = paste(path, "-wasser60-90cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y=wasser_max
    plot(modell_datum, 
        modell_moisture_60_90,
        col="blue",
        main="Bodenwassergehalt 60-90cm",
        xlab="Datum", 
        ylab="Soil moisture [Vol-%]",
         ylim=c(0,max_y), 
         type="l", 
         lwd=lwd_curve
    )
    abline(h=fc[3], col="darkgrey")
    abline(h=pwp[3], col="darkgrey")
    if ( compare_with_measured_values==1) {
        points(moisture90_datum, moisture90, col="black")
    }
    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
    text(legend_date2,fc[3], labels="FK", col="darkgrey")
    text(legend_date2,pwp[3], labels="PWP", col="darkgrey")
    par(xpd=FALSE)

}


if (calc_wasser_v4 == 1) {
    filename = paste(path, "-wasser90cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,3,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )

    max_y=wasser_max
    plot(modell_datum, 
        modell_moisture90,
        col="blue",
        #main="Bodenwassergehalt 60-90cm",
        xlab="Datum", 
        ylab="Bodenwassergehalt [Vol-%]",
         ylim=c(0,max_y), 
         type="l", 
         lwd=lwd_curve
    )
    abline(h=fc[3], col="darkgrey")
    abline(h=pwp[3], col="darkgrey")
    lines(moisture90_datum, moisture90, col="black")
    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
    text(legend_date2,fc[3], labels="FK", col="darkgrey")
    text(legend_date2,pwp[3], labels="PWP", col="darkgrey")
    par(xpd=FALSE)

}
###########################################################
# Wassergehalt 0-90cm
###########################################################

if (calc_soilmoisture == 1) {

    print("Q-Plot moisture 0-90cm")

    filename = paste(path, "-wasser0-90cm.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,1,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )


  
    max_y=35
    plot(modell_datum, 
        sum_moisture_modell_values,
        col="#5b7dd4",
        #main="Bodenwassergehalt 0-90cm",
        xlab="Datum", 
        ylab="Wassergehalt [Vol-%]",
         ylim=c(20,max_y), 
         type="l", 
         lwd=lwd_curve
    )
#    abline(h=fc[3], col="darkgrey")
#    abline(h=pwp[3], col="darkgrey")
    if ( compare_with_measured_values==1) {
        points(sum_moisture_datum, sum_moisture , col="black")
    }
    # x-Achse
    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
#    text(legend_date2,fc[3], labels="FC", col="darkgrey")
#    text(legend_date2,pwp[3], labels="PWP", col="darkgrey")
    par(xpd=FALSE)

}

###########################################################
# Nleaching
###########################################################

max_y=1.5

    print("N-Leaching")

    filename = paste(path, "-nleach.png", sep="")
    png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 

    # plot Einstellungen
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=lwd_general,      # Linienstärke
      mar=c(4.5,4,1,3),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
    )


max_y = 1.5
plot(modell_datum, 
    modell_nleaching,
    col="#c85a2e",
    #main="Bodenwassergehalt 0-90cm",
    xlab="Datum", 
    ylab="N-Austrag [kg N ha-1]",
     ylim=c(0,max_y), 
     type="l", 
     lwd=lwd_curve
)



###########################################################
# Wasserhaushalt
###########################################################

location = paste(toupper(substr(location,1,1)), substr(location,2,nchar(location)), sep="")
modell_moisture_0_90 = sum_moisture_modell_values


filename = paste(path, "-wasserhaushalt.png", sep="")
png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 
px = c(modell_datum[1], modell_datum, modell_datum[length(modell_moisture_0_90)])

col_bodenwasserhaushalt="steelblue3"
col_fruchtfolge = "#deeede"
col_ETa = "firebrick"
col_gwrech = "darkorange"

# plot Einstellungen
par(
  bty="l",    # Box in Form eines "L"
  cex.main=cex_main, # Schriftgröße der Plot-Überschriften
  lwd=lwd_general,      # Linienstärke
  mar=c(4.5,3.5,3,3.5),  # Rahmen-Abstände (unten, links, oben, rechts)
  xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
)

if (location=="Dornburg") {
# Ertrag als Fläche
plot(modell_datum, modell_yield/1000.0, 
     col=col_fruchtfolge, 
     type="l", 
     lwd=lwd_grid,
     yaxt="n",
     ylab="",
     xlab="",
     ylim=c((-1)*max(modell_yield/1000.0), max(modell_yield/1000.0))
)
} else {
# Ertrag als Fläche
    plot(modell_datum, modell_yield/1000.0, 
     col=col_fruchtfolge, 
     type="l", 
     lwd=lwd_grid,
     xaxt="n",
     yaxt="n",
    ylab="",
    xlab="",
    ylim=c((-1)*max(modell_yield/1000.0), max(modell_yield/1000.0))
)
}


py = c(0, modell_yield/1000.0,0)
polygon(px,py, col=col_fruchtfolge, border="#cceecc", lwd=1)
par(new=TRUE)

max_y=50
plot(modell_datum, 
    modell_moisture_0_90*(-1),
    col=col_bodenwasserhaushalt,
    main="",  #paste("Wasserhaushalt (",location, " FF ", ff, " Anlage ", anlage, ")", sep="")
    xlab="", 
    ylab="",
    yaxt="n",
    xaxt="n",
     ylim=c(max_y*(-1),max_y), 
     type="l", 
     lwd=lwd_grid
)

# wassergehalt 0-90  als blaues Polygon
py = c(0, modell_moisture_0_90*(-1),0)
polygon(px,py, col=col_bodenwasserhaushalt, border=NULL, density=30, lwd=lwd_grid)

mtext("Bodenwassergehalt 0-90cm [Vol-%]",side=2, line=2, cex=cex_axis*0.8)
axis(2, cex=cex_axis*0.8) # linke y achse zeichnen


par(new=TRUE)

max_y=20
# ETa als rote Kurve
plot(modell_datum, 
    modell_ETa,
    col=col_ETa,
    main="",
    yaxt="n",
    xaxt="n",
    ylim=c(max_y*(-1),max_y), 
    ylab="",
    xlab="",
    type="l", 
    lwd=lwd_grid
)

py=py = c(0,modell_ETa,0)
polygon(px, py, col=col_ETa, border=NULL, density=30, angle=315, lwd=lwd_grid)

# GW Recharge

py = c(0,modell_recharge * (-1),0)
polygon(px,py, col=col_gwrech, border=NA, lwd=lwd_grid)

if (location=="Dornburg") {

} else {
    axis(1, at=quartals, cex=cex_axis*0.8, labels=FALSE) # x-Achse zeichnen
    axis(1, at=years, cex=cex_axis*0.8, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
}

mtext("ETakt und Sickerwasser in [mm]",side=4, line=2, cex=cex_axis*0.8, lwd=2)
axis(4, cex=cex_axis*0.8, lwd=2) # rechte y achse zeichnen

par(xpd=TRUE)
legend_date3=ISOdate(legend_year-4,1,1)
legend(
    legend_date3, -40, 
    ncol=2, 
    legend=c("Ertrag", "ETakt", "Sickerwasser", "Bodenwasser 0-90cm"), 
    fill=c(col_fruchtfolge,  col_ETa, col_gwrech,col_bodenwasserhaushalt),
    density=c(NA, 25, NA, 25),
    angle=c(NA,315,NA,45),
    cex=cex_axis*0.7,
    box.lwd=0,
    box.col="white",
    border=c(col_fruchtfolge,  col_ETa, col_gwrech,col_bodenwasserhaushalt),
)


##############################################################################
# 1 Kultur, 2 Kultur Mais Vergleich
##############################################################################
start_date = ISOdate(legend_year-4,11,1)
end_date = ISOdate(legend_year-3,11,1)
print(start_date)
print(end_date)
datum_indizes = which((modell_datum>=start_date) & (modell_datum<=end_date) )

location = paste(toupper(substr(location,1,1)), substr(location,2,nchar(location)), sep="")
modell_moisture_0_90 = (modell_moisture_0_30 + modell_moisture_30_60 + modell_moisture_60_90) / 3

filename = paste(path, "-mais-1-2-wasserhaushalt.png", sep="")
png(filename=filename, pointsize=14, res=300, units="cm", width=w, height=h) 
px = c(modell_datum[datum_indizes][1], modell_datum[datum_indizes], modell_datum[datum_indizes][length(datum_indizes)])

col_bodenwasserhaushalt="steelblue3"
col_fruchtfolge = "#deeede"
col_ETa = "firebrick"
col_gwrech = "darkorange"

# plot Einstellungen
par(
  bty="l",    # Box in Form eines "L"
  cex.main=cex_main, # Schriftgröße der Plot-Überschriften
  lwd=lwd_general,      # Linienstärke
  mar=c(4.5,3.5,3,3.5),  # Rahmen-Abstände (unten, links, oben, rechts)
  xpd=FALSE    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
)


plot(modell_datum[datum_indizes], modell_yield[datum_indizes]/1000.0, 
     col=col_fruchtfolge, 
     type="l", 
     lwd=lwd_grid,
     yaxt="n",
    ylab="",
    xlab="",
    ylim=c((-1)*max(modell_yield[datum_indizes]/1000.0), max(modell_yield[datum_indizes]/1000.0))
)



py = c(0, modell_yield[datum_indizes]/1000.0,0)
polygon(px,py, col=col_fruchtfolge, border="#cceecc", lwd=1)
par(new=TRUE)

max_y=50
plot(modell_datum[datum_indizes], 
    modell_moisture_0_90[datum_indizes]*(-1),
    col=col_bodenwasserhaushalt,
    main="",  #paste("Wasserhaushalt (",location, " FF ", ff, " Anlage ", anlage, ")", sep="")
    xlab="", 
    ylab="",
    yaxt="n",
    xaxt="n",
     ylim=c(max_y*(-1),max_y), 
     type="l", 
     lwd=lwd_grid
)

# wassergehalt 0-90  als blaues Polygon
py = c(0, modell_moisture_0_90[datum_indizes]*(-1),0)
polygon(px,py, col=col_bodenwasserhaushalt, border=NULL, density=30, lwd=lwd_grid)

mtext("Bodenwassergehalt 0-90cm [Vol-%]",side=2, line=2, cex=cex_axis*0.8)
axis(2, cex=cex_axis*0.8) # linke y achse zeichnen


par(new=TRUE)

max_y=20
# ETa als rote Kurve
plot(modell_datum[datum_indizes], 
    modell_ETa[datum_indizes],
    col=col_ETa,
    main="",
    yaxt="n",
    xaxt="n",
    ylim=c(max_y*(-1),max_y), 
    ylab="",
    xlab="",
    type="l", 
    lwd=lwd_grid
)

py=py = c(0,modell_ETa[datum_indizes],0)
polygon(px, py, col=col_ETa, border=NULL, density=30, angle=315, lwd=lwd_grid)

# GW Recharge

py = c(0,modell_recharge[datum_indizes] * (-1),0)
polygon(px,py, col=col_gwrech, border=NA, lwd=lwd_grid)


mtext("ETakt und Sickerwasser in [mm]",side=4, line=2, cex=cex_axis*0.8, lwd=2)
axis(4, cex=cex_axis*0.8, lwd=2) # rechte y achse zeichnen

par(xpd=TRUE)
legend(
    start_date, -40, 
    ncol=2, 
    legend=c("Ertrag", "ETakt", "Sickerwasser", "Bodenwasser 0-90cm"), 
    fill=c(col_fruchtfolge,  col_ETa, col_gwrech,col_bodenwasserhaushalt),
    density=c(NA, 25, NA, 25),
    angle=c(NA,315,NA,45),
    cex=cex_axis*0.7,
    box.lwd=0,
    box.col="white",
    border=c(col_fruchtfolge,  col_ETa, col_gwrech,col_bodenwasserhaushalt),
)

#############################################################################
#############################################################################
# Poster
#############################################################################
#############################################################################

filename = paste(path, "-poster.png", sep="")
png(filename=filename, pointsize=20, res=300, units="cm", width=22, height=18) 
lwd_curve = 3

# plot Einstellungen
par(
  bty="l",    # Box in Form eines "L"
  cex.main=cex_main, # Schriftgröße der Plot-Überschriften
  lwd=lwd_general,      # Linienstärke
  mar=c(2,4,2,2.5),  # Rahmen-Abstände (unten, links, oben, rechts)
  xpd=FALSE,    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
  mfrow=c(4,1)
)

max_y = 150
plot(modell_datum, modell_yield/100.0, 
     col="#42a46b", 
#     main="Yield", 
     xlab="Datum", 
     ylab="Ertrag [dt ha-1]", 
     ylim=c(0,max_y),
     type="l", 
     lwd=lwd_curve #,
     #xaxt="n"

)

# grid
if (show_grid == 1) {
    grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
}
#abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(avg_yielddatum,avg_messertrag/1000.0, col="black")
    }

#fertilizer
#abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

# x-Achse
#axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
#axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen


#############################################################################

#if (calc_nconc == 1) {
#    max_y = 0.2
#    plot(modell_datum, modell_yield_n, 
#         col="red", 
#         #main="Yield N concentration", 
#         xlab="Datum", 
#         ylab="N Konzentration [kg N kg-1]", 
#         ylim=c(0,max_y),
#         type="l", 
#         lwd=lwd_curve,
#         #xaxt="n",
#        cex=0.8
#    )
#
#    # grid
#    if (show_grid == 1) {
#        grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
##    }
#    #abline(v=half_years, col=color_grid, lwd=lwd_grid)
#    if ( compare_with_measured_values==1) {
#        # messpunkte
#        points(mean_yield_n_datum,mean_yield_n, col="black")
#        #points(n_zeiternte_datum,n_zeiternte, col="black")
#    }


#    #fertilizer
#    abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)
#
#    # x-Achse
#    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
#    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
#}

#############################################################################

if (calc_soilnmin == 1) {
    
    max_y = 200
    plot(modell_datum,sum_nmin_modell_values, 
         col="#c85a2e", 
         #main="Soil Nmin 0-90cm", 
         xlab="Datum", 
         ylab="Nmin [kg N ha-1]", 
         ylim=c(0,max_y),
         type="l", 
         lwd=lwd_curve#,
#         xaxt="n"
    )


    # grid
    if (show_grid == 1) {
        grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    }
    #abline(v=half_years, col=color_grid, lwd=lwd_grid)

    if ( compare_with_measured_values==1) {
        # messpunkte
        points(nmin30_datum,nmin30, col="black")
    }

    #fertilizer
#    abline(v=as.POSIXct(fertilizer_datum), col=color_fertilizer, lwd=lwd_fertilizer)

    # x-Achse
#    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
#    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen
}

#############################################################################

#if (calc_soilmoisture == 1) {
#
#    max_y=35
#    plot(modell_datum, 
#        sum_moisture_modell_values,
#        col="red",
#        #main="Bodenwassergehalt 0-90cm",
#        xlab="Datum", 
#        ylab="Soil moisture [Vol-%]",
#         ylim=c(0,max_y), 
#         type="l", 
#         lwd=lwd_curve
#    )
#    if (show_grid == 1) {
#        grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
#    }

    #abline(h=fc[3], col="darkgrey")
    #abline(h=pwp[3], col="darkgrey")
#    if ( compare_with_measured_values==1) {
#        points(sum_moisture_datum, sum_moisture, col="black")
#    }
    # x-Achse
#    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
#    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    #par(xpd=TRUE)
    #text(legend_date2,fc[3], labels="FC", col="darkgrey")
    #text(legend_date2,pwp[3], labels="PWP", col="darkgrey")
    #par(xpd=FALSE)
#}

#############################################################################

max_y=10
plot(modell_datum, 
    modell_recharge,
    col="#5b7dd4",
    #main="Bodenwassergehalt 0-90cm",
    xlab="Datum", 
    ylab="Sickerwasser [mm]",
     ylim=c(0,max_y), 
     type="l", 
     lwd=lwd_curve
)


max_y=2
plot(modell_datum, 
    modell_nleaching,
    col="#c85a2e",
    #main="Bodenwassergehalt 0-90cm",
    xlab="Datum", 
    ylab="N-Austrag [kg N ha-1]",
     ylim=c(0,max_y), 
     type="l", 
     lwd=lwd_curve
)


if (calc_wasser_v4 == 1) {




    max_y=35
    plot(modell_datum, 
        modell_moisture30,
        col="red",
        #main="Bodenwassergehalt 0-90cm",
        xlab="Datum", 
        ylab="Bodenwasser [Vol-%]",
         ylim=c(0,max_y), 
         type="l", 
         lwd=lwd_curve #,
         #xaxt="n"
    )
    if (show_grid == 1) {
        grid(nx=NA, ny=NULL, lty=1, col=color_grid, lwd=lwd_grid) #nx=(length(years)*2)
    }
    print(pwp[1])
    par(xpd=FALSE)
    abline(h=20.5, col="darkgrey", lwd=1)
    abline(h=6, col="darkgrey", lwd=1)
    lines(moisture30_datum, moisture30, col="black")
    if ( compare_with_measured_values==1) {
        points(moisture30_datum_grav, moisture30_grav, col="black")
    }
    # x-Achse
#    axis(1, at=quartals, cex=cex_axis, col=color_grid, labels=FALSE) # x-Achse zeichnen
#    axis(1, at=years, cex=cex_axis, col=color_axis, labels=labels, lwd=lwd_axis) # x-Achse zeichnen

    par(xpd=TRUE)
    text(ISOdate(2011,04,01),fc[1], labels="FK", col="darkgrey",cex=0.8)
    text(ISOdate(2011,04,01),pwp[1], labels="PWP", col="darkgrey", cex=0.8)
    par(xpd=FALSE)


#  ----------------
    filename = paste(path, "-fdr_analyse.png", sep="")
    png(filename=filename, pointsize=20, res=300, units="cm", width=2*w, height=25) 

    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=1,      # Linienstärke
      mar=c(4,4,2,11),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE,    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
      mfrow=c(1,1)
    )

    
    fdr_values = moisture30
    precip = rmout$Precip    
    modell_values = modell_moisture_30_values

    end1 = length(modell_values)-2
    end2 = length(modell_values)-1

    diff_datum = moisture30_datum[1:end1]    
    precip = get_values_at_dates(diff_datum, modell_datum, precip,1)    

    diff_modell = modell_values[2:end2] - modell_values[1:end1]
    diff_fdr = fdr_values[2:end2] - fdr_values[1:end1]

    
    barplot(precip, col="grey",xaxt="n", yaxt="n", border=NA)

    par(new=TRUE)

    plot(diff_datum,  diff_modell,  col="red", xlab="Datum", 
        ylab="Differenzwassergehalt Modell",
         type="l", 
         lwd=1,
         ylim=c(-20,20),
        main="Tagesdifferenzwerte"
    )
    lines(diff_datum, diff_fdr, col="black")
    lines(diff_datum, abs(diff_fdr-diff_modell)+15, col="green")
    lines(diff_datum, diff_modell, col="red")


    par(xpd=TRUE)
    legend(ISOdate(2011,03,01),20, c("Modell", "FDR", "Differenz(Modell-FDR)", "Niederschlag"), pch=c("-","-","-","-"), col=c("red","black","green","grey"))
    par(xpd=FALSE)


    # scatter plots

    filename = paste(path, "-fdr_analyse-2.png", sep="")
    png(filename=filename, pointsize=20, res=300, units="cm", width=w, height=25) 
    par(
      bty="l",    # Box in Form eines "L"
      cex.main=cex_main, # Schriftgröße der Plot-Überschriften
      lwd=1,      # Linienstärke
      mar=c(4,4,2,2.5),  # Rahmen-Abstände (unten, links, oben, rechts)
      xpd=FALSE,    # Außerhalb des Rahmen Zeichnen (z.B. Legende)
      mfrow=c(2,1)
    )

    plot(diff_modell,diff_fdr, pch=20, col="black",xlab="Modell", ylab="FDR", lwd=1)
    regmodel = lm(diff_fdr~diff_modell)
    rsquared = summary(regmodel)[[8]]
    abline(lm(diff_fdr~diff_modell), col="red")
    text(2,-2, labels=paste("R²=",round(rsquared,2),sep=""), col="black")



    plot(modell_moisture_30_values,moisture30, pch=20, col="black",xlab="Modell", ylab="FDR", xlim=c(0,40), ylim=c(0,40))
    regmodel = lm(moisture30~modell_moisture_30_values)
    rsquared = summary(regmodel)[[8]]
    abline(lm(moisture30~modell_moisture_30_values), col="red")
    text(30,2, labels=paste("R²=",round(rsquared,2),sep=""), col="black")

}
