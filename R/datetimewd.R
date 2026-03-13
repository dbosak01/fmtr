#' @noRd
format_datetimewd <- function(x, w, d = 0){
  options(digits.secs = 6)
  shown_numeric_msg <- FALSE
  shown_posix_warn  <- FALSE
  
  vectorize<-function(x1){
    
    if (is.na(x1)) {
      return(NA_character_)
    }
    # ---- Validate DATETIMEw.d parameters ----
    if (!w %in% 7:40) {
      
      stop(paste0("'DATETIMEw.d' width must be between 7 and 40."))
    }
    if (!d %in% 0:39) {
      
      stop(paste0("'DATETIMEw.d' number of digits must be between 0 and 39."))
    }
    if (w <= d){
      stop(paste0("'DATETIMEw.d' number of digits must be less than the width"))
    }
  
    if ("POSIXt" %in% class(x1)){
      
      datetimen <- as.numeric(x1)
      decimals <- datetimen%%1
      datetime_int <- floor(datetimen)
      
      tz <- attr(x1, "tzone")
      if (length(tz) == 0 || identical(tz, "")) {
        timezone <- "UTC"
        if (!shown_posix_warn) {
          warning("No timezone is assigned to POSIXt object, UTC will be used by default\n", call. = FALSE)
          shown_posix_warn <<- TRUE
        }
      } else {
        timezone <- tz[1]
      }
    }
    
    if ("numeric" %in% class(x1)){
      decimals <-  x1%%1
      datetime_int <- floor(x1)
      timezone = "utc"
      
      if (!shown_numeric_msg) {
        
        cat("UTC timezone will be used by default for numeric input\n\n")
        shown_numeric_msg <<- TRUE
      }
      
    }
    
    #number will be rounded by d first
    if (decimals == 0){
      decimal_r <- 0
    }else{
      decimal_r <- round(decimals, d)
    }
    
    if (decimal_r == 1) {
      datetime_int <- datetime_int + 1
      decimal_r <- 0
    }
    
    datetime_pos <- as.POSIXct(datetime_int, timezone)
    
    #break down the datetime
    date7 <-  fmtr::fapply(datetime_pos,"date7")
    date9 <-  fmtr::fapply(datetime_pos,"date9")
    hh <- format(datetime_pos,"%H")
    mm <- format(datetime_pos,"%M")
    ss <- format(datetime_pos,"%S")
    hms <- format(datetime_pos, "%H:%M:%S")
    # w = 1 ~ 17, no decimals will be displayed
    
    if (w %in% c(7, 8)){
      ret <- date7
    } else if (w == 9){
      ret <- date9
    } else if (w %in% c(10, 11)){
      ret <- paste0(date7, ":", hh)
    } else if (w == 12){
      ret <- paste0("  ", date7, ":", hh)
    } else if (w %in% c(13, 14)){
      ret <- paste0(date7, ":", hh, ":", mm)
    } else if (w == 15){
      ret <- paste0("  ", date7, ":", hh, ":", mm)
    } else if (w == 16){
      ret <- paste0(date7, ":", hms)
    } else if (w == 17){
      if (d < 1){
        ret <- paste0(date7, ":", hms)
      }else {
        ret <- paste0(date7, ":", hms, ".")
      }
    }
    
    if (w < 18) {
      return(ret)
    }
    
    # for w >= 18
    
    #max decimal length
    max_length <- w - 17
    if (d <= max_length){
      real_d_length <- d
    }else{
      real_d_length <- max_length
    }
    
    dateL <- w - (real_d_length + as.numeric(d != 0)) - (8 + 1)
    
    if (dateL < 9 || w == 18) {
      dmy <- date7
      totalL <- 7 + 1 +8 + as.numeric(d != 0) + real_d_length
      
    } else{
      dmy <- date9
      totalL <- 9 + 1 +8 + as.numeric(d != 0) + real_d_length
      
    }
    
    if (w > totalL + 1){
      spacen <- w - totalL
    } else{
      spacen <- 0
    }
    
    datetime_int_f <- paste0(strrep(" ", spacen), dmy, ":",hms)
    
    if (d == 0){
      ret <- datetime_int_f
      return(ret)
    }else if(decimal_r == 0){
      ret <- paste0(datetime_int_f, ".", strrep("0", real_d_length))
      return(ret)
    }
    
    decimal_r1 <- substring(as.character(decimal_r), first = 2)
    if (d <= max_length){
      decimal_f <- decimal_r1
    }else{
      decimal_f <- substr(decimal_r1, 1, max_length + 1) 
    }
    
    combine <- paste0(datetime_int_f, decimal_f)
    
    if (nchar(decimal_f) - 1 < real_d_length){
      pad0 <- real_d_length - (nchar(decimal_f) - 1)
      ret <- paste0(combine, strrep("0", pad0))
    }else{
      ret <- combine
    }
    
  }
  # Vectorized wrapper
  vapply(x, vectorize, FUN.VALUE = character(1))
}
