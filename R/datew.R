

#' @noRd
format_datew <- function(date, wdth){
  
  
  
  if (5 > wdth | wdth > 11){
    
    stop("Width specified for format DATE is invalid. Please specify a value between 5 and 11.")
  
  } else {
    
      if ("numeric" %in% class(date) ){
        
        date = as.Date(date, origin = "1970-01-01")
        
      }
      
      if (wdth == 5){
        
        ret <- toupper(format(date,  format = "%d%b"))
        
      }else if(wdth == 6){
        
        ret <- toupper(paste0(" ", format(date, format = "%d%b")))
        
      }else if (wdth == 7){
        
        ret <- toupper(format(date,  format = "%d%b%y"))
        
      }else if (wdth == 8){
        
        ret <- toupper(paste0(" ", format(date, format = "%d%b%y")))
        
      }else if (wdth == 9){
        
        ret <- toupper(format(date, format = "%d%b%Y"))
        
      }else if (wdth == 10){
        
        ret <- toupper(paste0(" ", format(date, format = "%d%b%Y")))
        
      }else if (wdth == 11){
        
        ret <- toupper(format(date, format = "%d-%b-%Y"))
        
      }

    
  }
  
  return(ret)
}






