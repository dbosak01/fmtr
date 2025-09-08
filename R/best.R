
# Best Formatting ---------------------------------------------------------



# This function accepts vectors and all functions are vectorized 
#' @import common
format_best <- function(x, width = 12, resize = TRUE) {
  
  # browser()
  if (!width %in% 1:32) {
    
      stop(paste0("'best' width must be between 1 and 32."))
  }
  
  # Turn off automatic scientific notation
  oopt <- getOption("scipen")
  odgts <- getOption("digits")
  options("scipen" = 999, digits = 22)
  
  # Perform formatting
  ret <- best_roundup(x, width)
  
  # Turn automatic scientific notation back on
  options("scipen" = oopt, digits = odgts)
  
  # Resize if needed
  if (resize) {
    ret <- size_output(ret, width)
  }
  
  return(ret)
  
}


# Vectorized function to perform best rounding
# Don't need to worry about padding here.
# Will be done after this function runs.
# Just produce the right numbers.
best_roundup <- Vectorize(function(x, wdth) {
  
  # browser() 
  
  # Categorize inputs
  if (is.na(x)) {
    
    ret <- NA
  } else if (x == 0) {
    
    ret <- "0"
    
  } else {
    
    # Deal with actual number
    obj <- best_obj(x, wdth)
                    
    ret <- obj$result              
  }
  
  return(ret)
  
},  USE.NAMES = FALSE, SIMPLIFY = TRUE)
    


# Best Object -------------------------------------------------------------


best_obj <- function(x, wdth) {
  
  b <- structure(list(), class = c("best_obj", "list"))
  
  # Original numeric value
  b$value <- x
  
  # Character value
  b$cvalue <- trimws(sprintf("%32.16f", x))
  
  # Find decimal point
  dpos <- as.integer(regexpr(".", b$cvalue, fixed = TRUE))
  
  # Decimal position
  b$dpos <- ifelse(dpos == -1, 0, dpos)
  
  # Requested width
  b$wdth <- wdth

  
  # Positive value flag
  if (x < 0) {
    b$pv <- FALSE 
  } else if (x > 0) {
    b$pv <- TRUE 
  } else {
    b$pv <- NA 
  }
  
  # Positive notation flag
  if (abs(x) <= 1) {
    b$pn <- FALSE
  } else {
    
    b$pn <- TRUE
  }
  
  # browser()
  
  # Exponent first pass
  b$exponent <- get_exponent(b)
  
  # Coefficient width
  if (b$pv) {
    b$cwdth <- wdth
  } else {
    b$cwdth <- wdth - 1 
    b$dpos <- b$dpos - 1
  }
  
  # Determine whether the value needs scientific notation
  b$sci <- needs_sci(b)
  
  if (b$sci) {
    # Subtract the following:
    # - 1 for E
    # - Width of exponent
    b$cwdth <- b$cwdth - 1 - nchar(b$exponent)
  }
  
  # Adjust for small widths
  if (wdth <= 7) {
    b$exponent <- adj_wdths(b)
    b$exponent <- round_small_widths(b)
  }
  
  # Adjust for trailing zeros
  b$exponent <- remove_trailing_zeros(b)
  
  # Remove leading zero flag
  b$rmlz <- get_rmlz(b)
  
  # browser()
  
  # No digits left for coefficient
  if (b$cwdth <= 0) {
    
    b$dgts <- b$wdth - b$dpos
    
    if (b$dgts < 0)
      b$dgts <- 0
    
    vl <- as.character(roundup(x, b$dgts))
    
    if (b$rmlz) {
      vl <- sub("0.", ".", vl, fixed = TRUE)
    }
    
    if (nchar(vl) <= b$wdth) {
      b$result <- vl
    } else {
      b$result <- paste0(rep("*", b$wdth), collapse = "")
    }
      
  } else {
  
    # Deal with scientific notation separately
    if (b$sci) {
  
      # browser()
      
      if (b$cwdth <= 0) {
        
        b$result <- paste0(rep("*", b$wdth), collapse = "")
        
      } else {
      
        # Calculate decimal points
        b$dgts <- b$cwdth - 2 # One integer and decimal
        
        if (b$dgts < 0)
          b$dgts <- 0
        
        # Coefficient first pass
        b$coefficient <- roundup(x / (10 ^ b$exponent), b$dgts)
        
        # Adjustments to coefficient & exponent
        if (nchar(abs(b$coefficient)) > b$cwdth & b$dgts > 0) {
          b$coefficient <- roundup(x / (10 ^ b$exponent), 0)
        }
          
        # Trim trailing zeros
        # Round up close values for small widths
        # Remove decimals for small widths
        # Remove leading zero for small widths
        
        
        # Final result
        b$result <- paste0(b$coefficient, "E", b$exponent)
      
      }
      
    } else {
      
      # browser()
      
      # Requested digits (cwdth - dpos)
      b$dgts <- b$cwdth - b$dpos
      
      # Zero digits is minimum
      if (b$dgts < 0)
        b$dgts <- 0
      
      # Give extra digit if zero will be removed
      if (b$rmlz) 
        b$dgts <- b$dgts + 1
      
      # Just round the result
      b$coefficient <- roundup(x, b$dgts)
      
      # Adjustments to coefficient & exponent
      

      # Final result
      b$result <- as.character(b$coefficient)
      
      # Remove leading zero
      if (b$rmlz) {
        b$result <- sub("0.", ".", b$result, fixed = TRUE)
      }
      
      # SAS is insane
      if (!b$pv & b$wdth %in% c(2, 5) & b$result == "0") {
        b$result <- "-0"
      }
      
    }
  }
  
  return(b)
  
}

# Utilities ---------------------------------------------------------------



# Ensure output value is the right width
#' @noRd
size_output <- Vectorize(function(x, wdth) {
  
  # browser()
  if (is.na(x)) { 
    ret <- x
  } else {
    
    # Get string size
    ln <- nchar(x)
    
    # Evaluate
    if (ln > wdth) {
      
      # Force size
      ret <- substr(x, 1, wdth)
      
      # Check for trailing decimal
      if (grepl("\\.$", ret)[1]) {
        # browser()
        ret <- substr(paste0(" ", ret), 1, wdth) 
      }
      
    } else if (ln < wdth) {
      
      # Construct format code
      fcd <- paste0("%", wdth, "s")
      
      # Pad with spaces if needed
      ret <- sprintf(fcd, x)
      
    } else {
     
      # Do nothing
      ret <- x 
    }
  }
  
  return(ret)
  
}, USE.NAMES = FALSE, SIMPLIFY = TRUE)



needs_sci <- function(obj) {
  
  ret <- FALSE
  
  if (obj$pn) {
    
    # If integer portion is greater than the effective width
    if ((obj$dpos - 1) > obj$cwdth) {
      ret <- TRUE
    }
    
    
  } else {
    
    # print(obj$exponent)
    # print(obj$cwdth)
    
    # Excluded 4 and below
    if (obj$wdth > 4 ) {
      
      # If exponent is greater than 5
      # Or exponent + integer + decimal is greater than available width
      if (abs(obj$exponent) > 5 | (abs(obj$exponent) + 2) > obj$cwdth) {
        ret <- TRUE 
      }
    }
    
    # Width-specific adjustments
    if (obj$wdth == 5 & !obj$pv) {
      ret <- FALSE 
    }
    
  }
  
  return(ret)

}




# Determines the exponent for scientific notation.
get_exponent <- function(obj) {
  
  # browser()
  
  if (obj$pn) {
    
    if (obj$pv) {
      ret <- obj$dpos - 2
    } else {
      ret <- obj$dpos - 3
    }
    

     
  } else {
    
    nz <- as.integer(regexpr("[1-9]", obj$cvalue))
    
    if (nz == -1) {
      ret <- 0
      
    } else {
      
      ret <- (nz - obj$dpos) * -1
    }
    

  }
  
  return(ret)
  
}

# Width-specific adjustments to exponent
adj_wdths <- function(obj) {
  
  ret <- obj$exponent
  
  if (obj$pn) {
    

    if (obj$wdth == 4 & nchar(ret) == 1 & obj$pv) {
      ret <- ret - 1
    }
    if (obj$wdth == 5 & nchar(ret) == 1 & obj$pv) {
      ret <- ret - 2
    }
    if (obj$wdth == 5 & nchar(ret) == 1 & !obj$pv) {
      ret <- ret - 1
    }
    
    if (obj$wdth == 6) {
      if (!obj$pv) {
        ret <- ret - (obj$cwdth - 1)  
      }
      
      if (nchar(ret) == 2) {
        
        ret <- remove_decimal(ret, obj)
        
      }
    }
    
    
  } else {
    
    if (obj$wdth == 5 & nchar(ret) == 2 & obj$pv) {
      ret <- ret - 1
    }
    
    if (obj$wdth == 6) {
      ret <- ret - (obj$cwdth - 1)  
    }
    
    if (obj$wdth == 7 & !obj$pv) {
      ret <- ret - (obj$cwdth - 1)  
    }
    
  }
  
  return(ret)
  
}

remove_decimal <- function(ret, obj) {
  
  
  # browser()
  
  # Test integer value
  vl <- roundup(obj$value / (10 ^ ret), 0)
  
  # Get number of integer digits
  nc <- nchar(vl)
  
  # If number of characters is less than the available width
  if (nc < obj$cwdth) {
    if (obj$cwdth - nc > 0) {
      ret <- ret - (obj$cwdth - nc)  # Use full width
    }
  }
  
  # Reduction to 9 will add additional digit to cwidth
  if (ret == 10) {
    
    ret <- ret - 1 
  }
  
  return(ret)
  
}

# Remove leading zero for some situations
get_rmlz <- function(obj) {
 
  ret <- FALSE
  
  if (obj$wdth == 3 & (!obj$pv | !obj$pn) ) {
    ret <- TRUE
    
  } 
  
  if (obj$wdth == 4 & (!obj$pv & !obj$pn)) {
    ret <- TRUE 
  }
  
  return(ret)
  
}

# Remove trailing zeros by adjusting exponent
remove_trailing_zeros <- function(obj) {
  
  # browser()
  
  x <- obj$value
  offst <- obj$exponent
  tdgts <- c
  
  # Test base value
  vl <- roundup(x / (10 ^ offst), 0)
  # vl <- as.integer(x / (10 ^ offst), 0)

  # if (vl > 0) {  ?
    toffst <- offst


    while (vl %% 10 == 0) {
      if (obj$pn) {
        toffst <- toffst + 1
      } else {
        toffst <- toffst + 1  # - 1 Need to make it smaller?
      }
      vl <- roundup(x / (10 ^ toffst), 0)
      # vl <- as.integer(x / (10 ^ toffst), 0)

      if (abs(offst) > 22) {
        toffst <- offst
        break

      }
      
      if (obj$wdth > 5) {
        vl2 <- as.integer(x / (10 ^ toffst), 0)
        
        if (vl2 == 0 & toffst > offst) {
          
          toffst <- toffst - 1 
          break
        }
      }
    }

    offst <- toffst
  # }
  
  return(offst)
  
}


# For some small widths, round up coefficient by adjusting exponent
round_small_widths <- function(obj) {
  
  
  # browser()
  
  x <- obj$value
  offst <- obj$exponent
  
  if (obj$wdth %in% c(6) & !obj$pv & !obj$pn ) {
    
    # Test base value
    vl <- roundup(x / (10 ^ offst), 0)
    
    # if (vl > 0) {  ?
    toffst <- offst
    vlc <- as.character(vl)
    
    nc <- nchar(vl)
    
    if (nc > 1) {
    
      for (idx in seq(nc, 2, -1)) {
        
        dgt <- substr(vlc, idx, idx)
        
        if (dgt >= "5") {
          toffst <- toffst + 1
        }
        
        if (abs(toffst) > 22) {
          toffst <- offst
          break
        }
      }
    }
    
    offst <- toffst
  }
  
  return(offst)
  
}

# vl <- roundup(x / (10 ^ offst), 0)
# 
# if (vl > 0) {
#   toffst <- offst
#   
#   
#   while (vl %% 10 == 0) {
#     if (pn) {
#       toffst <- toffst + 1
#     } else {
#       toffst <- toffst - 1
#     }
#     vl <- roundup(x / (10 ^ toffst), 0)
#     
#     if (abs(offst) > 22) {
#       toffst <- offst
#       break
#       
#     }
#   }
#   
#   offst <- toffst
# }



# 
# 
# sas_sci <- function(x, wdth) {
#   #browser()
#   
#   # Default offset if nothing else works
#   offst <- 0
#   
#   # Positive or negative notation flag
#   pn <- 1  
#   
#   if (!is.na(x)) {
#     # Test the numeric portion
#     for (idx in seq(0, 22)) {
#       
#       if (abs(x) <= 1) {
#         mtst <- suppressWarnings(as.integer(x * (10 ^ idx)))  # Negative
#         pn <- -1
#       } else {
#         mtst <- suppressWarnings(as.integer(x / (10 ^ idx)))  # Positive
#         pn <- 1
#       }
#       
#       # If NA, does not fit in an integer.  Try again.
#       if (!is.na(mtst)) {  
#         # Next, check whether numeric value is within sci range
#         # This index will be used as the offset
#         if (abs(mtst) > 0 & abs(mtst) < 10) { 
#           offst <- idx * pn
#           break
#         }
#       }
#     }
#   }
#   
#   if (is.na(x)) {  # Return NA as NA
#     
#     ret <- NA
#     
#   } else {
#     
#     if (offst > 0) {       # Positive scientific notation
#       
#       # Get length of E portion.  Can be 2 or 3 digits.
#       ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#       
#       # Add extra for negative numbers
#       neg <- ifelse(x >= 0, 0, 1)
#       
#       # Round numeric portion
#       vl <- roundup(x / (10 ^ abs(offst)), wdth - (ln + neg + 2)) # 2 is integer and decimal
#       
#       # Length of numeric portion
#       np <- nchar(as.character(vl)) - ln 
#       
#       # print(paste0("ln: ", ln))
#       # print(paste0("neg: ", neg))
#       # print(paste0("wdth: ", wdth))
#       # print(paste0("vl: ", vl))
#       
#       # Combine numeric portion and E portion
#       ret <- paste0(vl, "E", as.character(offst))
#       
#     } else if (offst < 0) { # Negative scientific notation
#       
#       # Get length of E portion.  Can be 3 or 4 digits.
#       ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#       
#       # Add extra for negative numbers
#       neg <- ifelse(x >= 0, 0, 1)
#       
#       # Round numeric portion
#       vl <- roundup(x * (10 ^ abs(offst)), wdth - (ln + neg + 2)) # 2 is integer and decimal
#       
#       # print(paste0("ln: ", ln))
#       # print(paste0("neg: ", neg))
#       # print(paste0("wdth: ", wdth))
#       # print(paste0("vl: ", vl))
#       
#       # Combine numeric portion and E portion
#       ret <- paste0(vl, "E", as.character(offst))
#       
#     } else { # No scientific notation
#       
#       # Just round it and let it go
#       ret <- roundup(x, wdth) 
#     }
#   }
#   
#   return(ret)
# }




