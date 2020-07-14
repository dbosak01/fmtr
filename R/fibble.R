


fibble <- function(...) {
  
  if (...length() == 1 && any(class(...) == "data.frame")) { 
    
      x <- structure(..., class = c("fbl", class(...)))    

  } else {
    x <- structure(data.frame(...), class = c("fbl", "data.frame"))
  }
  
  return(x)
  
}



print.fbl <- function(x, ...) {
  
  cat(paste0("\033[0;90m", "# (fibble)", "\033[0m\n"))
  
  # Remove fbl class
  cls <- class(x)
  class(x) <- cls[2:length(cls)]
  
  # Then print as normal
  print(x, ...)  

  # Restore fbl class
  class(x) <- cls
  
  invisible(x)
  
}



format.fbl <- function(x) {
  
  #print("Fribble")
  
  ret <- list()
  for (nm in names(x)) {

    if (is.null(attr(x[[nm]], "format")) == FALSE) {
      
      fmt <- attr(x[[nm]], "format")
      
      if (is.vector(fmt))
        ret[[length(ret) + 1]] <- fmt[x[[nm]]] 
      else if (is.function(fmt))
        ret[[length(ret) + 1]] <- do.call(fmt, list(x[[nm]]))
      
    } else {
      
      ret[[length(ret) + 1]] <- x[[nm]]
    }
    
  }
  
  names(ret) <- names(x)
  
  return(as.data.frame(ret))
  
}

