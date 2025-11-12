format_datew <- function(date, wdth){
  
  
  
  if (5 > wdth | wdth > 11){
    
    stop( paste0( "Width specified for format DATE is invalid,  width should be between 5 and 11" ) )
  
  }else{
    
      if (class(date) == "numeric"){
        
        date = as.Date(date)
        
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






