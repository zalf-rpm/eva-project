####################################################################
# Calculates mean bias error between predicted and observed data
####################################################################
calc_mbe <- function(p,o) 
{
  if (length(p) == 0 || length(o) == 0) {
    return(-1)
  } 
	# p = predicted or modelled data
	# o = observed, measured data
	n = length(p)
	mbe = (cumsum(p-o)[n]) / n
    return(mbe)      # z wird zurückgemeldet
}

####################################################################
# Calculates mean absolute error between predicted and observed data
####################################################################
calc_mae <- function(p,o)
{
  if (length(p) == 0 || length(o) == 0) {
    return(-1)
  }
  
	# p = predicted or modelled data
	# o = observed, measured data
	n = length(p)
	mae = (cumsum(abs(p-o))[n]) / n
	return (mae)
}

####################################################################
# Calculates modelling efficiency between predicted and observed data
####################################################################
calc_ef <- function(p,o)
{
  if (length(p) == 0 || length(o) == 0) {
    return(-1)
  }
  
	# p = predicted or modelled data
	# o = observed, measured data
	n = length(p)
	x = cumsum((p-o)^2)[n]
	y = cumsum((o-mean(o))^2)[n]
	ef = 1-(x/y)
	return (ef)
}

####################################################################
# Calculates index of agreement between predicted and observed data
####################################################################
calc_ioa <- function(p,o)
{
	# p = predicted or modelled data
	# o = observed, measured data
	if (length(p) == 0 || length(o) == 0) {
    return(-1)
  }
  
	n = length(p)
	x = cumsum((p-o)^2)[n]
	
	y1 = abs(p-mean(o))
	y2=abs(o-mean(o))
	y= cumsum((y1+y2)^2)[n]
	ioa = 1-(x/y)
	return (ioa)
}

####################################################################
# Calculates root mean squared error between predicted and observed data
####################################################################
calc_rsme <- function(p,o)
{
	# p = predicted or modelled data
	# o = observed, measured data
	if (length(p) == 0 || length(o) == 0) {
    return(-1)
  }
	n = length(p)
	sme = (cumsum((p-o)^2)[n]) / n
	rsme = sqrt(sme)
	return (rsme)
}


####################################################################
# Calculates mean squared error between predicted and observed data
####################################################################
calc_mse <- function(p,o)
{
  # p = predicted or modelled data
  # o = observed, measured data
  n = length(p)
  mse = (cumsum((p-o)^2)[n]) / n  
  return (mse)
}

####################################################################
# Calculates root mean squared error between predicted and observed data
####################################################################
calc_nmae <- function(p,o)
{
  if (length(p) == 0 || length(o) == 0) {
    return(-1)
  }
  
  # p = predicted or modelled data
  # o = observed, measured data  
  mae=calc_mae(p,o)
  mean_o = mean(o)
  mean_p = mean(p)
  
  if (mean_o==0) {
    return(-1)
  }
  nmae = mae/max(mean_o, mean_p)

  return (nmae)
}


####################################################################
# Returns values where dates of datum exist also in datum_daten
# Usually used to return only modell data for dates were mess data exist
####################################################################
get_values_at_dates <- function(datum,datum_daten, daten, days=0) {

	# get length of vector but only for elements that are not NA
	# conversion into a time series has the effect, that length
	# did not work, in this case, time series contains more elements
	# than the original, but these elements have been NA
	n = length(is.na(datum) == FALSE)
	result = vector (n, mode="numeric")
	for (i in 1:n) {
	  index = which (datum_daten == datum[i])	  
	  if (length(index)>0) {	  
		  result[i] = daten[which (datum_daten == datum[i]) - days]
	  }
	}
	return(result)
}

####################################################################
# Removes all values that are zero
####################################################################
remove_zero_values <- function(vector, data) {
	index = which(vector!=0)
	data = data[index]	
	return(data)
}

####################################################################
# Returns developmental stage for a given bbch value
####################################################################
getDevStageOfBBCH <- function(bbch, id_pg) 
{   
  print(paste("BBCH: ", bbch, "   ", id_pg))
    id = substr(id_pg,8,10)
    
    if (id==141) { 
      dev_stage = c(9, 30, 50, 60, 70, 90, 99)    # maize
    } else if (id==175 | id==176 | id==172 ) {
      dev_stage = c(9, 40, 60, 70, 90, 99)        # w. triticale, w. weizen, w. roggen
    } else if (id==041) { 
      dev_stage = c(9, 16, 60, 69, 89, 99)        # oil raddish    
    } else if (id==160 ){                                   
      dev_stage = c(9, 29, 49, 59, 69, 79, 99)    # sudan gras, futterhirse
    } else if (id==124 ){                         # hafer
      dev_stage = c(9, 16, 60, 69, 89, 99)              
    } else {
      dev_stage = c(9, 40, 60, 70, 90, 99)        # sonst
    }
    
    
    n = length(dev_stage)
    for (i in 1:n) {
        if (bbch<dev_stage[i]) {
            return(i)
        }
    }
    return(-1)
}

#####################################
# Calcs mean squared error
#####################################
calc_mse <- function(p,o)  {
    if (length(p) == 0 || length(o) == 0) {
     return(NA)
    }
    n = length(o)
    mse = (cumsum((p-o)^2)[n]) / n
    return(mse)
}



#####################################
# Calcs systematic part of MSE
#####################################
calc_mses <- function(p,o)  {
    
    if (length(p) == 0 || length(o) == 0) {
      return(0)
    }

    n = length(o)
    linreg = lm(p~o)

    coeff = linreg[[1]]
    a = coeff[1]
    b = coeff[2]

    o0 = a + b*o

    mses = (cumsum((o-o0)^2)[n]) / n
    
    return (mses)
}


#####################################
# Calcs systematic part of MSE
#####################################
calc_nmses <- function(p,o)  {
    
    if (length(p) == 0 || length(o) == 0) {
      return(1)
    }

    mse = calc_mse(p,o)
    mses = calc_mses(p,o)

    return(mses/mse)
}


#####################################
# Calcs R2 (by AKP 06/02/14)
#####################################
calc_rsquare <- function(p,o) {

    if (length(p) == 0 || length(o) == 0) {
      return(9999)
    }
    
    n = length(o)
    mean_o = mean(o)
    mean_p = mean(p)
    rzaehler = (cumsum((o-mean_o)*(p-mean_p))[n])/n
    rnenner = (sqrt((cumsum((o-mean_o)^2)[n])/n)) * (sqrt((cumsum((p-mean_p)^2)[n])/n))
    rcoeff = rzaehler / rnenner
    rsquare = rcoeff^2
    
    return (rsquare)
}

