

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
