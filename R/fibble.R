

# Fibble Definition -------------------------------------------------------



fibble <- function(...) {
  
  if (...length() == 1 && any(class(...) == "data.frame")) { 
    
      x <- structure(..., class = c("fbl", class(...)))    

  } else {
    x <- structure(data.frame(...), class = c("fbl", "data.frame"))
  }
  
  return(x)
  
}

format.data.frame()
format.tb

# Utilities ---------------------------------------------------------------


as.fibble <- function(...) {
  
  if (...length() == 1 && any(class(...) == "data.frame")) { 
    
    x <- structure(..., class = c("fbl", class(...)))    
    
  } else {
    stop(paste("Cannot convert to a fibble.", 
               "Object must be inherited from a data.frame"))
  }
  
  return(x)
  
}


is.fibble <- function(x) {
  
  if (any(class(x) == "fbl"))
      ret <- TRUE
  else 
      ret <- FALSE
      
  return(ret)
}


formats <- function(x) {
  
  
  
}

# Print and Format Functions ----------------------------------------------


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

format.tbl_df <- function(x) {
  
  
 return(format.fbl(x)) 
}


format.data.frame <- function(x, ...) {
  
  print("here")
  
  fbl <- format.fbl(x)
  
  df <- base::format.data.frame(fbl, ...)
  
  return(df)
  
}


format.fbl <- function(x) {
  
  ret <- list()
  for (nm in names(x)) {

    if (is.null(attr(x[[nm]], "format")) == FALSE) {
      
      fmt <- attr(x[[nm]], "format")
      
      if (is.vector(fmt))
        ret[[length(ret) + 1]] <- fmt[x[[nm]]] 
      else if (is.function(fmt))
        ret[[length(ret) + 1]] <- do.call(fmt, list(x[[nm]]))
      else if (is.format(fmt))
        ret[[length(ret) + 1]] <- apply_format(fmt, x[[nm]])
      
    } else {
      
      ret[[length(ret) + 1]] <- x[[nm]]
    }
    
  }
  
  names(ret) <- names(x)
  ret <- as.data.frame(ret)
  rownames(ret) <- rownames(x)
  
  cls <- class(x)
  class(ret) <- cls[2:length(cls)]
  
  return(ret)
  
}






# Testing -----------------------------------------------------------------


f1 <- as.fibble(mtcars[1:10, ])

is.fibble(f1)

is.fibble(mtcars)
is.fibble(c(1, 2, 3))


print(f1)


fmt1 <- create_format(condition(x >= 20, "H"),
                      condition(x < 20, "L"))

fmt2 <- c(H = "High", L = "Low")

is.format(fmt1)
f1$mpgc <- apply_format(fmt1, f1$mpg)


attr(f1$mpg, "format") <- fmt1
attr(f1$mpgc, "format") <- fmt2

attributes(f1$mpg)

is.format(attr(f1$mpg, "format"))

is.null(attr(f1[["mpg"]], "format"))

is.null(attr(x[[nm]], "format"))

format(f1)

library(tibble)
f2 <- tibble(mtcars)

class(tibble(mtcars))


attr(f2$mpg, "format") <- fmt1
format(f2)


format(1:10)
format(1:10, trim = TRUE)

zz <- data.frame(col1= c("aaaaa", "b"), col2 = c(1, 2))
format(zz)
format(zz, justify = "left")

## use of nsmall
format(13.7)
format(13.7, nsmall = 3)
format(c(6.0, 13.1), digits = 2)
format(c(6.0, 13.1), digits = 2, nsmall = 1)

tbl1 <- mtcars[1:10, ]

attr(tbl1, "format") <- fmt2 

format(tbl1)

