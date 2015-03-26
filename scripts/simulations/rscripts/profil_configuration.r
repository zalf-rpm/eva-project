fc=c(0,0,0)
pwp=c(0,0,0)

if (profil == 1) {

  # dornburg ##################
  bd_dichte30=1.48
  bd_dichte60=1.52
  bd_dichte90=1.39 
  
  bodart = c("Ut4", "Ut4", "Tu3")
  
  
  fc[1] = 0.331        
  fc[2] = 0.328
  #fc[3] = 0.3765  # Tu3
  fc[3] = 0.2955  # Uls
  
  pwp[1] = 0.17
  pwp[2] = 0.15  
  #pwp[3] = 0.2455  # Tu3
  pwp[3] = 0.115    # Uls    
    
} else if (profil == 5) {

  # dornburg ##################
  bd_dichte30=1.5 # geschätzt
  bd_dichte60=1.5 # geschätzt
  bd_dichte90=1.5 # geschätzt
  
  bodart = c("Ut4", "Tu3", "Tu4")
    
} else if (profil == 6) {

  # dornburg ##################
  bd_dichte30=1.5 # geschätzt
  bd_dichte60=1.5 # geschätzt
  bd_dichte90=1.5 # geschätzt 
  
  bodart = c("Ut4", "Tu3", "Tu4")
    
} else if (profil == 11) {

  # trossin ###################    
  bd_dichte30=1.34
  bd_dichte60=1.77
  bd_dichte90=1.57
  
  bodart = c("Su3", "Su3", "Ss")  
  fc[1] = 0.256       
  fc[2] = 0.212
  fc[3] = 0.12   
  pwp[1] = 0.07
  pwp[2] = 0.07  
  pwp[3] = 0.03 
  
} else if (profil == 12) {

  # trossin ###################    
  bd_dichte30=1.71
  bd_dichte60=1.69
  bd_dichte90=1.63
  
  bodart = c("Su3", "Su3", "Su3")  
  fc[1] = 0.23       
  fc[2] = 0.23
  fc[3] = 0.227   
  pwp[1] = 0.07
  pwp[2] = 0.07  
  pwp[3] = 0.06 
  
} else if (profil == 13) {

  # trossin ###################    
  bd_dichte30=1.76
  bd_dichte60=1.72
  bd_dichte90=1.76
  
  bodart = c("Su3", "Ss", "Su2")
  fc[1] = 0.22  
  fc[2] = 0.16
  fc[3] = 0.16   
  pwp[1] = 0.06
  pwp[2] = 0.04  
  pwp[3] = 0.04 
  
} else if (profil == 14) {

  # trossin ###################    
  bd_dichte30=1.76
  bd_dichte60=1.78
  bd_dichte90=1.65
  
  bodart = c("Su3", "Su3", "Ss")
  fc[1] = 0.214  
  fc[2] = 0.212
  fc[3] = 0.12  
  pwp[1] = 0.07
  pwp[2] = 0.07  
  pwp[3] = 0.03   
  
} else if (profil == 15) {

  # trossin ###################    
  bd_dichte30=1.63
  bd_dichte60=1.89
  bd_dichte90=1.69
  
  bodart = c("Su3", "Su3", "Su2")
  fc[1] = 0.227  
  fc[2] = 0.201
  fc[3] = 0.181  
  pwp[1] = 0.07
  pwp[2] = 0.07  
  pwp[3] = 0.05 
  
} else if (profil == 16) {

  # trossin ###################    
  bd_dichte30=1.72
  bd_dichte60=1.71
  bd_dichte90=1.55
  
  bodart = c("Su3", "Su3", "Sl3")
  fc[1] = 0.218  
  fc[2] = 0.22
  fc[3] = 0.15 
  pwp[1] = 0.07
  pwp[2] = 0.07  
  pwp[3] = 0.05 
  
} else if (profil == 21) {

  # ascha #####################
  bd_dichte30=1.5
  bd_dichte60=1.8
  bd_dichte90=1.7   
  bodart = c("Ls3", "Ls3", "Lts")  
  fc[1] = 0.33        
  fc[2] = 0.29
  fc[3] = 0.3   
  pwp[1] = 0.16
  pwp[2] = 0.16  
  pwp[3] = 0.19 
     
} else if (profil == 22) {
  
  # ascha #####################
  bd_dichte30=1.7
  bd_dichte60=1.75
  bd_dichte90=1.7  
  bodart = c("Sl4", "Ls3", "Ls4")  
  fc[1] = 0.28        
  fc[2] = 0.26
  fc[3] = 0.27   
  pwp[1] = 0.13
  pwp[2] = 0.13  
  pwp[3] = 0.15 
  
} else if (profil == 23) {

  # ascha #####################
  bd_dichte30=1.4
  bd_dichte60=1.6
  bd_dichte90=1.6   
  bodart = c("Sl4", "Sl4", "Sl4")  
  fc[1] = 0.33        
  fc[2] = 0.25
  fc[3] = 0.25   
  pwp[1] = 0.13
  pwp[2] = 0.13  
  pwp[3] = 0.13 
  
} else if (profil == 24) {

  # ascha #####################
  bd_dichte30=1.4
  bd_dichte60=1.7
  bd_dichte90=1.6   
  bodart = c("Sl4", "Sl4", "Ls4")  
  fc[1] = 0.33      
  fc[2] = 0.25
  fc[3] = 0.27 
  pwp[1] = 0.13
  pwp[2] = 0.13  
  pwp[3] = 0.15 
  
} else if (profil == 25) {

  # ascha #####################
  bd_dichte30=1.7
  bd_dichte60=1.8
  bd_dichte90=1.7
  bodart = c("Sl4", "Sl4", "Sl4")  
  fc[1] = 0.28      
  fc[2] = 0.23
  fc[3] = 0.25   
  pwp[1] = 0.13
  pwp[2] = 0.13  
  pwp[3] = 0.13 
  
} else if (profil == 26) {

  # ascha #####################
  bd_dichte30=1.6   
  bd_dichte60=1.7
  bd_dichte90=1.7
  bodart = c("Sl4", "Sl4", "Sl4")  
  fc[1] = 0.3        
  fc[2] = 0.25
  fc[3] = 0.25   
  pwp[1] = 0.13
  pwp[2] = 0.13  
  pwp[3] = 0.13  
  
} else if (profil == 27) {

  # ascha #####################
  bd_dichte30=1.4   
  bd_dichte60=1.6
  bd_dichte90=1.6
  bodart = c("Sl4", "Ls4", "Ls4")  
  fc[1] = 0.33        
  fc[2] = 0.27
  fc[3] = 0.27   
  pwp[1] = 0.12
  pwp[2] = 0.15  
  pwp[3] = 0.14  
  
} else if (profil == 41) {
  
  # ettlingen #################
  bd_dichte30=1.6
  bd_dichte60=1.7
  bd_dichte90=1.7
  
} else if (profil == 42) {

  # ettlingen #################         
  bd_dichte30=1.4
  bd_dichte60=1.5
  bd_dichte90=1.5
  
} else if (profil == 43) {

  # ettlingen #################         
  bd_dichte30=1.5
  bd_dichte60=1.6
  bd_dichte90=1.7
  
} else if (profil == 44) {

  # ettlingen #################         
  bd_dichte30=1.5
  bd_dichte60=1.8
  bd_dichte90=1.6
  
} else if (profil == 45) {

  # ettlingen #################       
  bd_dichte30=1.5
  bd_dichte60=1.6
  bd_dichte90=1.6
  
} else if (profil == 46) {

  # ettlingen #################       
  bd_dichte30=1.4
  bd_dichte60=1.6
  bd_dichte90=1.6  
  
} else if (profil == 51) {
  
  # gueterfelde ##############
  bd_dichte30=1.716
  bd_dichte60=1.75
  bd_dichte90=1.73
  
  bodart = c("", "", "")  
  fc[1] = 0  
  fc[2] = 0
  fc[3] = 0
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0
  
} else if (profil == 52) {

  # gueterfelde ##############
  bd_dichte30=1.786
  bd_dichte60=1.81
  bd_dichte90=1.9
  
  bodart = c("Su2", "Su2", "Sl4")  
  fc[1] = 0  
  fc[2] = 0
  fc[3] = 0
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0
    
      
} else if (profil == 53) {

  # gueterfelde ##############
  bd_dichte30=1.61
  bd_dichte60=1.77
  bd_dichte90=1.85
  
  bodart = c("", "", "")  
  fc[1] = 0  
  fc[2] = 0
  fc[3] = 0
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0
  
  
} else if (profil == 54) {

  # gueterfelde ##############
  bd_dichte30=1.75
  bd_dichte60=1.914
  bd_dichte90=1.792
  
  bodart = c("", "", "")  
  fc[1] = 0  
  fc[2] = 0
  fc[3] = 0
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0
  
} else if (profil == 67) {  
  
  # guelzow  ##############
  bd_dichte30=1.69   
  bd_dichte60=1.68
  bd_dichte90=1.87
  bodart = c("Sl3", "Ls4", "Ls3")  
  fc[1] = 0        
  fc[2] = 0
  fc[3] = 0   
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0  
  
} else if (profil == 68) {  
  
  # guelzow  ##############
  bd_dichte30=1.79   
  bd_dichte60=1.72
  bd_dichte90=1.87
  bodart = c("Sl2", "Lt2", "Sl4")  
  fc[1] = 0.1855        
  fc[2] = 0.28
  fc[3] = 0.223
  pwp[1] = 0.08
  pwp[2] = 0.2  
  pwp[3] = 0.13
    
    
} else if (profil == 69) {  
  
  # guelzow  ##############
  bd_dichte30=1.6   
  bd_dichte60=1.80
  bd_dichte90=1.75
  bodart = c("Sl2", "Sl2", "Ls4")  
  fc[1] = 0        
  fc[2] = 0
  fc[3] = 0   
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0


} else if (profil == 70) {  
  
  # guelzow  ##############
  bd_dichte30=1.57   
  bd_dichte60=1.75
  bd_dichte90=1.78
  bodart = c("Sl2", "Su2", "Sl4")  
  fc[1] = 0        
  fc[2] = 0
  fc[3] = 0   
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0
  
  
} else if (profil == 71) {  
  
  # guelzow  ##############
  bd_dichte30=1.8  
  bd_dichte60=1.78
  bd_dichte90=1.97
  bodart = c("Sl2", "Sl4", "Sl4")  
  fc[1] = 0        
  fc[2] = 0
  fc[3] = 0   
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0  
  
} else if (profil == 72) {  
  
  # guelzow  ##############
  bd_dichte30=1.75   
  bd_dichte60=1.73
  bd_dichte90=1.89
  bodart = c("Sl3", "Ls4", "Sl3")  
  fc[1] = 0        
  fc[2] = 0
  fc[3] = 0   
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0  

} else if (profil == 73) {  
  
  # guelzow  ##############
  bd_dichte30=1.71  
  bd_dichte60=1.72
  bd_dichte90=1.73
  bodart = c("Sl3", "Sl4", "Sl4")  
  fc[1] = 0        
  fc[2] = 0
  fc[3] = 0   
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0
  
} else if (profil == 74) {  
  
  # guelzow  ##############
  bd_dichte30=1.7   
  bd_dichte60=1.79
  bd_dichte90=1.84
  bodart = c("Sl3", "Sl4", "")  
  fc[1] = 0        
  fc[2] = 0
  fc[3] = 0   
  pwp[1] = 0
  pwp[2] = 0  
  pwp[3] = 0
  
} else if (profil == 81) {

  # werlte ####################
  bd_dichte30=1.5
  bd_dichte60=1.7
  bd_dichte90=1.85
  
  bodart = c("Su2", "Ss", "Su2")
  
  
  fc[1] = 0.2        
  fc[2] = 0.175
  fc[3] = 0.18
  
  pwp[1] = 0.05
  pwp[2] = 0.04
  pwp[3] = 0.04 
  
} else if (profil == 82) {

  # werlte ####################
  bd_dichte30=1.5
  bd_dichte60=1.6
  bd_dichte90=1.9
  
  fc[1] = 0.2        
  fc[2] = 0.21
  fc[3] = 0.24
  
  pwp[1] = 0.05
  pwp[2] = 0.08
  pwp[3] = 0.12 
  
} else if (profil == 83) {

  # werlte ####################
  bd_dichte30=1.5
  bd_dichte60=1.6
  bd_dichte90=1.7
  
  fc[1] = 0.2        
  fc[2] = 0.15
  fc[3] = 0.2
  
  pwp[1] = 0.05
  pwp[2] = 0.03
  pwp[3] = 0.08 
  
} else if (profil == 84) {

  # werlte ####################
  bd_dichte30=1.5
  bd_dichte60=1.6
  bd_dichte90=2.0
  
  fc[1] = 0.2        
  fc[2] = 0.18
  fc[3] = 0.17
  
  pwp[1] = 0.05
  pwp[2] = 0.04
  pwp[3] = 0.06
    
} else if (profil == 85) {

  # werlte ####################
  bd_dichte30=1.6
  bd_dichte60=1.7
  bd_dichte90=1.9
  
  fc[1] = 0.19        
  fc[2] = 0.2
  fc[3] = 0.21
  
  pwp[1] = 0.05
  pwp[2] = 0.08
  pwp[3] = 0.1
  
} else {


  bd_dichte30=1.6
  bd_dichte60=1.6
  bd_dichte90=1.6
  
  fc[1] = 0.0     
  fc[2] = 0.0
  fc[3] = 0.0
  
  pwp[1] = 0.0
  pwp[2] = 0.0
  pwp[3] = 0.0 

}



# Ausnahmen wegen V4 Simulation
if (standort == 59) {

  if (anlage ==1 | anlage == 3) {
    bd_dichte30=1.45
    bd_dichte60=1.65
    bd_dichte90=1.65
  } else {
    bd_dichte30=1.65
    bd_dichte60=1.65
    bd_dichte90=1.65
  
  }

  if (profil == 19) {

    fc[1] = 0.205
    fc[2] = 0.205
    fc[3] = 0.205
    pwp[1] = 0.05
    pwp[2] = 0.05
    pwp[3] = 0.05

  } else {

    fc[1] = -1        
    fc[2] = -1
    fc[3] = -1

    pwp[1] = -1
    pwp[2] = -1
    pwp[3] = -1  
  }
}

