


formatable <- function(...) {
  
  if (...length() == 1 && any(class(...) == "tbl_df")) { 
    
      x <- structure(..., class = c("fmt_tbl", class(...)))    

  } else {
    x <- structure(data.frame(...), class = c("fmt_tbl", "data.frame"))
  }
  
  return(x)
  
}



print.fmt_tbl <- function(x, ...) {
  
  cat(paste0("\033[0;47m", "<Formatable>", "\033[0m\n"))
  
  # Remove fmt_tbl class
  cls <- class(x)
  class(x) <- cls[2:length(cls)]
  
  # Then print as normal
  print(tmp, ...)  

  # Restore fmt_tbl class
  class(x) <- cls
  
  invisible(x)
  
}
