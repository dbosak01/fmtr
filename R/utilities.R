

# Log something to the log, if the logr is installed
#' @noRd
log_logr <- function(x) {
  
  if (length(find.package('logr', quiet=TRUE)) > 0) {
    if (utils::packageVersion("logr") >= "1.2.0") {
      logr::log_hook(x)
    }
  }
}


# Check if logr.output option is set or not
log_output <- function() {
 
  ret <- TRUE
  tmp <- options("logr.output")
  if (!is.null(tmp$logr.output)) {
    
    ret <- tmp$logr.output
    
  }
  
  return(ret)
}


get_quarter <- Vectorize(function(x) {

  yr <- format(x, "%Y")
  
  if (is.na(yr)) {
    
    ret <- NA
    
  } else {
    
    if (x >= as.Date(paste0(yr, "-01-01")) & 
        x < as.Date(paste0(yr, "-04-01"))) {
      
      ret <- 1
      
    } else if (x >= as.Date(paste0(yr, "-04-01")) & 
               x < as.Date(paste0(yr, "-07-01"))) {
      
      ret <- 2
      
    } else if (x >= as.Date(paste0(yr, "-07-01")) & 
               x < as.Date(paste0(yr, "-10-01"))) {
      ret <- 3
      
    } else if (x >= as.Date(paste0(yr, "-10-01")) & 
               x <= as.Date(paste0(yr, "-12-31"))) {
      
      ret <- 4 
      
    } else {
      
      ret <- NA 
    }
  }
  
  
  return(ret)
  
}, USE.NAMES = FALSE, SIMPLIFY = TRUE)


replace_quarter <- Vectorize(function(val, ptn, repl) {
  

  ret <- gsub(ptn, repl, val,  fixed = TRUE, 
          ignore.case = FALSE)
  
  return(ret)
  
  
}, USE.NAMES = FALSE, SIMPLIFY = TRUE)
