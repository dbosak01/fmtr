#' 
#' # Best Formatting ---------------------------------------------------------
#' 
#' 
#' 
#' # This function accepts vectors and all functions are vectorized 
#' #' @import common
#' format_best_back <- function(x, width = 12) {
#'   
#'   # browser()
#'   if (!width %in% 1:32) {
#'     
#'     stop(paste0("'best' width must be between 1 and 32."))
#'   }
#'   
#'   # Convert to character
#'   chr <- sprintf("%f", x)
#'   
#'   # Find decimal point
#'   dpos <- regexpr(".", chr, fixed = TRUE)
#'   
#'   # If no decimal found, set to zero
#'   if (dpos[[1]] == -1)
#'     dpos <- 0
#'   
#'   # Get desired decimal places
#'   dgts <- width - dpos 
#'   
#'   # Turn off automatic scientific notation
#'   oopt <- getOption("scipen")
#'   options("scipen" = 999)
#'   
#'   # Perform formatting
#'   ret <- best_roundup(x, dgts, width)
#'   
#'   # Turn automatic scientific notation back on
#'   options("scipen" = oopt)
#'   
#'   # Resize if needed
#'   ret <- size_output(ret, width)
#'   
#'   
#'   return(ret)
#'   
#' }
#' 
#' # Ensure output value is the right width
#' #' @noRd
#' size_output_back <- Vectorize(function(x, wdth) {
#'   
#'   # browser()
#'   if (is.na(x)) { 
#'     ret <- x
#'   } else {
#'     
#'     # Get string size
#'     ln <- nchar(x)
#'     
#'     # Evaluate
#'     if (ln > wdth) {
#'       
#'       # ret <- as.character(as.numeric(substr(x, 1, wdth)))
#'       ret <- substr(x, 1, wdth)
#'       
#'       if (grepl("\\.$", ret)[1]) {
#'         # browser()
#'         ret <- substr(paste0(" ", ret), 1, wdth) 
#'       }
#'       
#'     } else if (ln < wdth) {
#'       
#'       fcd <- paste0("%", wdth, "s")
#'       
#'       ret <- sprintf(fcd, x)
#'       
#'     } else {
#'       
#'       ret <- x 
#'     }
#'   }
#'   
#'   return(ret)
#'   
#' }, USE.NAMES = FALSE, SIMPLIFY = TRUE)
#' 
#' best_roundup_back <- Vectorize(function(x, dgts, wdth) {
#'   
#'   # browser() 
#'   
#'   # Test integer portion
#'   if (is.na(x)) {
#'     
#'     mtst <- NA
#'   } else if (x == 0) {
#'     
#'     mtst <- 1
#'   } else if (x > 0 & x < 1) {
#'     
#'     mtst <- suppressWarnings(as.integer(x * (10 ^ 5)))  # Cutoff for sci. Needs to adjust.
#'   } else if (x < 0 & x > -1) {
#'     
#'     mtst <- suppressWarnings(as.integer(x * (10 ^ 5)))
#'     
#'   } else {
#'     
#'     mtst <- x
#'   }
#'   
#'   # Get lower limit
#'   # lmt <- 1
#'   # if (dgts < -1 & wdth < 4) {
#'   #   if (x < 0) {
#'   #     lmt <- 3
#'   #   } else {
#'   #     lmt <- 2 
#'   #   }
#'   # }
#'   
#'   # print(mtst)
#'   if (is.na(mtst)) {
#'     
#'     ret <- NA
#'   } else {
#'     
#'     if (abs(mtst) > 0) {
#'       
#'       # print(paste0("x: ", x))
#'       # print(paste0("mtst: ", mtst))
#'       # print(paste0("comp: ", 1 * (10 ^ 5)))
#'       # print(paste0("dgts: ", dgts))
#'       # print(paste0("wdth: ", wdth))
#'       
#'       # cw <- nchar(as.character(x))
#'       # print(paste0("cw: ", cw))
#'       
#'       
#'       
#'       if (dgts < -1 | dgts > wdth) {    # mtst > 1 * (10 * 5)
#'         
#'         if (wdth <= 7) {
#'           # ret <- paste0(rep("*", wdth), collapse = "")
#'           ret <- mod_sci(x, wdth, dgts)
#'         } else {
#'           # Go to scientific notation
#'           ret <- sas_sci(x, wdth)
#'         }
#'         
#'       } else {
#'         
#'         if (dgts > 0)
#'           ret <- as.character(roundup(x, dgts))
#'         else {
#'           # browser()
#'           ret <- as.character(roundup(x, abs(dgts + 1)))
#'         }
#'       }
#'       
#'     } else {
#'       
#'       if (wdth <= 7) {
#'         # ret <- paste0(rep("*", wdth), collapse = "")
#'         ret <- mod_sci(x, wdth, dgts)
#'       } else {
#'         # Go to scientific notation
#'         ret <- sas_sci(x, wdth)
#'       }
#'     }
#'   }
#'   
#'   return(ret)
#'   
#' },  USE.NAMES = FALSE, SIMPLIFY = TRUE)
#' 
#' 
#' # Modified scientific notation used for small widths
#' mod_sci_back <- function(x, wdth, dgts = NULL) {
#'   
#'   # browser()
#'   if (is.na(x)) {
#'     ret <- NA
#'     
#'   } else if (x == 0) {
#'     
#'     ret <- as.character(0)
#'   } else {
#'     
#'     # Default offset if nothing else works
#'     offst <- 0
#'     
#'     # Convert to character
#'     chr <- sprintf("%f", x)
#'     
#'     # Find decimal point
#'     dpos <- regexpr(".", chr, fixed = TRUE)
#'     
#'     # If no decimal found, set to zero
#'     if (dpos[[1]] == -1)
#'       dpos <- 0
#'     
#'     
#'     # Positive notation flag
#'     if (abs(x) <= 1) {
#'       pn <- FALSE
#'     } else {
#'       
#'       pn <- TRUE
#'     }
#'     
#'     # Positive value flag
#'     if (x < 0) {
#'       pv <- FALSE
#'     } else {
#'       
#'       pv <- TRUE
#'     }
#'     
#'     if (wdth == 1) {
#'       
#'       if (pv) {
#'         
#'         vl <- as.character(roundup(x, 0))
#'         
#'         if (nchar(vl) <= 1) {
#'           ret <- vl
#'         } else {
#'           ret <- "*"
#'         }
#'         
#'       } else {
#'         
#'         ret <- "*" 
#'       }
#'       
#'       
#'     } else if (wdth == 2) {
#'       
#'       
#'       vl <- as.character(roundup(x, 0))
#'       
#'       if (nchar(vl) <= 2) {
#'         ret <- vl
#'       } else {
#'         ret <- "**"
#'       }
#'       
#'       
#'     } else if (wdth == 3) {
#'       
#'       # browser()
#'       
#'       offst <- get_offset(x, 3)
#'       # print(paste0("offst: ", offst))
#'       
#'       if (pn & pv & offst > 2) {
#'         ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#'         
#'         if (ln <= 2) {
#'           vl <- roundup(x / (10 ^ abs(offst)), 0) # No decimals
#'           ret <- paste0(vl, "E", as.character(offst))
#'         } else {
#'           ret <- "***"
#'         }
#'       } else if (offst <= 2) {
#'         
#'         if (pv) {
#'           if (offst >= 0) {
#'             rnd <- 2 - offst
#'           } else if (offst >= -2) {
#'             rnd <- 2
#'           } else {
#'             rnd <- 0 
#'           }
#'           vl <- as.character(roundup(x, rnd))
#'         } else {
#'           
#'           if (offst >= 0 & offst < 2) {
#'             rnd <- 1 - offst
#'           } else if (offst >= -2) {
#'             rnd <- 1
#'           } else {
#'             rnd <- 0 
#'           }
#'           
#'           vl <- as.character(roundup(x, rnd))
#'         }
#'         
#'         if (nchar(vl) == 4) {
#'           vl <- sub("0.", ".", vl, fixed = TRUE)
#'         }
#'         
#'         if (nchar(vl) <= 3) {
#'           ret <- vl
#'         } else {
#'           ret <- "***"
#'         }
#'         
#'       } else {
#'         
#'         ret <- "***"
#'         
#'       }
#'       
#'     } else if (wdth == 4) {
#'       
#'       # browser()
#'       
#'       offst <- get_offset(x, wdth)
#'       # print(paste0("offst: ", offst))
#'       
#'       strs <- paste0(rep("*", wdth), collapse = "")
#'       
#'       if (pn & offst > 3) {
#'         ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#'         
#'         if (ln <= (wdth - 1)) {
#'           vl <- roundup(x / (10 ^ abs(offst)), 0) # No decimals
#'           ret <- paste0(vl, "E", as.character(offst))
#'         } else {
#'           ret <- strs
#'         }
#'       } else if (offst <= 3) {
#'         
#'         
#'         mtst <- suppressWarnings(as.integer(x))
#'         rnd <- 0
#'         
#'         if (pv) {
#'           if (mtst == 0) {
#'             
#'             rnd <- 3 
#'           } else {
#'             
#'             if (dpos <= wdth - 2) {   # Decimal and 1 value
#'               rnd <- wdth - dpos
#'             }
#'           }
#'           
#'         } else {
#'           
#'           if (mtst == 0) {
#'             rnd <- 2
#'           } else {
#'             if (dpos <= wdth - 3) {   # Decimal, 1 value, and sign
#'               rnd <- wdth - dpos 
#'             }
#'           }
#'         }
#'         
#'         vl <- as.character(roundup(x, rnd))
#'         
#'         if (nchar(vl) > 3) {
#'           vl <- sub("0.", ".", vl, fixed = TRUE)
#'         }
#'         
#'         if (nchar(vl) <= wdth) {
#'           ret <- vl
#'         } else {
#'           ret <- strs
#'         }
#'         
#'       } else {
#'         
#'         ret <- strs
#'         
#'       }
#'       
#'       
#'     } else if (wdth == 5) {
#'       
#'       # browser()
#'       
#'       if (pn == FALSE) {
#'         
#'         offst <- get_offset(x, 4)  # Sometimes reduced?
#'         # offst <- get_offset(x, wdth)
#'         
#'       } else {
#'         
#'         offst <- get_offset(x, wdth)
#'         
#'       }
#'       
#'       # print(paste0("offst: ", offst))
#'       
#'       strs <- paste0(rep("*", wdth), collapse = "")
#'       
#'       if (abs(offst) > 4) {
#'         ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#'         
#'         if (ln <= (wdth - 1)) {
#'           vl <- roundup(x / (10 ^ offst), 0) # No decimals
#'           ret <- paste0(vl, "E", as.character(offst))
#'         } else {
#'           ret <- strs
#'         }
#'       } else if (abs(offst) <= 4) {
#'         
#'         
#'         mtst <- suppressWarnings(as.integer(x))
#'         rnd <- 0
#'         
#'         if (pv) {
#'           if (mtst == 0) {
#'             
#'             rnd <- 3 
#'           } else {
#'             
#'             #if (dpos <= wdth - 2) {   # Decimal and 1 value
#'             rnd <- wdth - dpos
#'             # }
#'           }
#'           
#'         } else {
#'           
#'           if (mtst == 0) {
#'             rnd <- 2
#'           } else {
#'             # if (dpos <= wdth - 3) {   # Decimal, 1 value, and sign
#'             rnd <- wdth - dpos 
#'             #  }
#'           }
#'         }
#'         
#'         vl <- as.character(roundup(x, rnd))
#'         
#'         
#'         # if (nchar(vl) > 3) {
#'         #   vl <- sub("0.", ".", vl, fixed = TRUE)
#'         # }
#'         
#'         if (nchar(vl) <= wdth) {
#'           ret <- vl
#'         } else {
#'           ret <- strs
#'         }
#'         
#'       } else {
#'         
#'         ret <- strs
#'         
#'       }
#'       
#'       
#'     } else if (wdth == 6) {
#'       
#'       # browser()
#'       
#'       if (pv & pn) {
#'         
#'         ret <- sas_sci(x, wdth)
#'         
#'       } else {
#'         
#'         offst <- get_offset(x, wdth)
#'         
#'         # print(paste0("offst: ", offst))
#'         
#'         strs <- paste0(rep("*", wdth), collapse = "")
#'         
#'         if (abs(offst) >= 5) {
#'           ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#'           
#'           if (ln <= (wdth - 1)) {
#'             vl <- roundup(x / (10 ^ offst), 0) # No decimals
#'             ret <- paste0(vl, "E", as.character(offst))
#'           } else {
#'             ret <- strs
#'           }
#'         } else if (abs(offst) < 5) {
#'           
#'           
#'           mtst <- suppressWarnings(as.integer(x))
#'           rnd <- 0
#'           
#'           if (pv) {
#'             if (mtst == 0) {
#'               
#'               rnd <- 3 
#'             } else {
#'               
#'               #if (dpos <= wdth - 2) {   # Decimal and 1 value
#'               rnd <- wdth - dpos
#'               # }
#'             }
#'             
#'           } else {
#'             
#'             if (mtst == 0) {
#'               rnd <- 2
#'             } else {
#'               # if (dpos <= wdth - 3) {   # Decimal, 1 value, and sign
#'               rnd <- wdth - dpos 
#'               #  }
#'             }
#'           }
#'           
#'           vl <- as.character(roundup(x, rnd))
#'           
#'           
#'           # if (nchar(vl) > 3) {
#'           #   vl <- sub("0.", ".", vl, fixed = TRUE)
#'           # }
#'           
#'           if (nchar(vl) <= wdth) {
#'             ret <- vl
#'           } else {
#'             ret <- strs
#'           }
#'           
#'         } else {
#'           
#'           ret <- strs
#'           
#'         }
#'       }
#'       
#'     } else if (wdth == 7) {
#'       
#'       # browser()
#'       
#'       if (pv | pn) {
#'         
#'         ret <- sas_sci(x, wdth)
#'         
#'       } else {
#'         
#'         offst <- get_offset(x, wdth)
#'         
#'         # print(paste0("offst: ", offst))
#'         
#'         strs <- paste0(rep("*", wdth), collapse = "")
#'         
#'         if (abs(offst) >= 6) {
#'           ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#'           
#'           if (ln <= (wdth - 1)) {
#'             vl <- roundup(x / (10 ^ offst), 0) # No decimals
#'             ret <- paste0(vl, "E", as.character(offst))
#'           } else {
#'             ret <- strs
#'           }
#'         } else if (abs(offst) < 6) {
#'           
#'           
#'           mtst <- suppressWarnings(as.integer(x))
#'           rnd <- 0
#'           
#'           if (pv) {
#'             if (mtst == 0) {
#'               
#'               rnd <- 3 
#'             } else {
#'               
#'               #if (dpos <= wdth - 2) {   # Decimal and 1 value
#'               rnd <- wdth - dpos
#'               # }
#'             }
#'             
#'           } else {
#'             
#'             if (mtst == 0) {
#'               rnd <- 2
#'             } else {
#'               # if (dpos <= wdth - 3) {   # Decimal, 1 value, and sign
#'               rnd <- wdth - dpos 
#'               #  }
#'             }
#'           }
#'           
#'           vl <- as.character(roundup(x, rnd))
#'           
#'           
#'           # if (nchar(vl) > 3) {
#'           #   vl <- sub("0.", ".", vl, fixed = TRUE)
#'           # }
#'           
#'           if (nchar(vl) <= wdth) {
#'             ret <- vl
#'           } else {
#'             ret <- strs
#'           }
#'           
#'         } else {
#'           
#'           ret <- strs
#'           
#'         }
#'       }
#'     }
#'     
#'   }
#'   
#'   
#'   
#'   return(ret)
#' }
#' 
#' pad_left_back <- function(vl, wdth) {
#'   
#'   ln <- nchar(vl) 
#'   
#'   if (ln < wdth) {
#'     
#'     ret <- paste0(spaces(wdth - ln), vl) 
#'     
#'   } else {
#'     
#'     ret <- vl 
#'   }
#'   
#'   return(ret)
#'   
#' }
#' 
#' # Determines the E offset for modified scientific notation.
#' # It is based on the original number and desired width. 
#' # Width is necessary because the modified scientific notation can
#' # change depending on the width.  So 12345 is 1E4 at width 3, and 
#' # 12E3 at width 4.
#' get_offset_back <- function(x, wdth) {
#'   
#'   # browser()
#'   
#'   offst <- 0
#'   ng <- x < 0  # negative number
#'   pn <- ifelse(abs(x) <= 1, FALSE, TRUE) # Positive notation
#'   
#'   # Initial target range
#'   br <- 1 * (10 ^ (wdth - 3))   # bottom width
#'   tr <- 1 * (10 ^ (wdth - 2))   # top width
#'   
#'   # Adjustments for negative values and negative notation.
#'   # These adjustments allow for extra sign characters.
#'   if (ng) {
#'     if (pn) {
#'       # offst <- offst + 1
#'       br <- br / 10
#'       tr <- tr / 10
#'     } else {
#'       # offst <- offst + 2
#'       br <- br / 100
#'       tr <- tr / 100
#'     }
#'   } else {
#'     if (!pn) {
#'       # offst <- offst + 1 
#'       br <- br / 10
#'       tr <- tr / 10
#'     }
#'   } 
#'   
#'   if (!is.na(x)) {
#'     # Test the numeric portion
#'     for (idx in seq(0, 22)) {
#'       
#'       if (pn) {
#'         mtst <- suppressWarnings(as.integer(x / (10 ^ idx)))  # Positive
#'       } else {
#'         mtst <- suppressWarnings(as.integer(x * (10 ^ idx)))  # Negative
#'       }
#'       
#'       # Adjust top and bottom range when reaches 10
#'       if (idx == 10) {
#'         br <- br / 10
#'         tr <- tr / 10
#'       }
#'       
#'       # If NA, does not fit in an integer.  Try again.
#'       if (!is.na(mtst)) {  
#'         # Next, check whether numeric value is within sci range
#'         # This index will be used as the offset
#'         if (abs(mtst) >= br & abs(mtst) < tr) { 
#'           offst <- idx * ifelse(pn, 1, -1)
#'           break
#'         }
#'       }
#'     }
#'   }
#'   
#'   # browser()
#'   
#'   # Test base value
#'   vl <- roundup(x / (10 ^ offst), 0)
#'   
#'   if (vl > 0) {
#'     toffst <- offst
#'     
#'     
#'     while (vl %% 10 == 0) {
#'       if (pn) {
#'         toffst <- toffst + 1
#'       } else {
#'         toffst <- toffst - 1
#'       }
#'       vl <- roundup(x / (10 ^ toffst), 0)
#'       
#'       if (abs(offst) > 22) {
#'         toffst <- offst
#'         break
#'         
#'       }
#'     }
#'     
#'     offst <- toffst
#'   }
#'   
#'   return(offst)
#'   
#' }
#' 
#' 
#' 
#' sas_sci_back <- function(x, wdth) {
#'   #browser()
#'   
#'   # Default offset if nothing else works
#'   offst <- 0
#'   
#'   # Positive or negative notation flag
#'   pn <- 1  
#'   
#'   if (!is.na(x)) {
#'     # Test the numeric portion
#'     for (idx in seq(0, 22)) {
#'       
#'       if (abs(x) <= 1) {
#'         mtst <- suppressWarnings(as.integer(x * (10 ^ idx)))  # Negative
#'         pn <- -1
#'       } else {
#'         mtst <- suppressWarnings(as.integer(x / (10 ^ idx)))  # Positive
#'         pn <- 1
#'       }
#'       
#'       # If NA, does not fit in an integer.  Try again.
#'       if (!is.na(mtst)) {  
#'         # Next, check whether numeric value is within sci range
#'         # This index will be used as the offset
#'         if (abs(mtst) > 0 & abs(mtst) < 10) { 
#'           offst <- idx * pn
#'           break
#'         }
#'       }
#'     }
#'   }
#'   
#'   if (is.na(x)) {  # Return NA as NA
#'     
#'     ret <- NA
#'     
#'   } else {
#'     
#'     if (offst > 0) {       # Positive scientific notation
#'       
#'       # Get length of E portion.  Can be 2 or 3 digits.
#'       ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#'       
#'       # Add extra for negative numbers
#'       neg <- ifelse(x >= 0, 0, 1)
#'       
#'       # Round numeric portion
#'       vl <- roundup(x / (10 ^ abs(offst)), wdth - (ln + neg + 2)) # 2 is integer and decimal
#'       
#'       # Length of numeric portion
#'       np <- nchar(as.character(vl)) - ln 
#'       
#'       # print(paste0("ln: ", ln))
#'       # print(paste0("neg: ", neg))
#'       # print(paste0("wdth: ", wdth))
#'       # print(paste0("vl: ", vl))
#'       
#'       # Combine numeric portion and E portion
#'       ret <- paste0(vl, "E", as.character(offst))
#'       
#'     } else if (offst < 0) { # Negative scientific notation
#'       
#'       # Get length of E portion.  Can be 3 or 4 digits.
#'       ln <- nchar(as.character(offst)) + 1 # +1 is "E"
#'       
#'       # Add extra for negative numbers
#'       neg <- ifelse(x >= 0, 0, 1)
#'       
#'       # Round numeric portion
#'       vl <- roundup(x * (10 ^ abs(offst)), wdth - (ln + neg + 2)) # 2 is integer and decimal
#'       
#'       # print(paste0("ln: ", ln))
#'       # print(paste0("neg: ", neg))
#'       # print(paste0("wdth: ", wdth))
#'       # print(paste0("vl: ", vl))
#'       
#'       # Combine numeric portion and E portion
#'       ret <- paste0(vl, "E", as.character(offst))
#'       
#'     } else { # No scientific notation
#'       
#'       # Just round it and let it go
#'       ret <- roundup(x, wdth) 
#'     }
#'   }
#'   
#'   return(ret)
#' }
#' 
#' 
#' 
#' sas_sci_back2 <- function(x, dgts) {
#'   browser()
#'   
#'   d2 <- 1
#'   
#'   for (idx in seq(1, 22)) {
#'     mtst <- as.integer(x * (10 ^ idx))
#'     if (is.na(mtst)) {
#'       d2 <- 1
#'       break
#'     } else {
#'       if (mtst > 0) {
#'         d2 <- idx
#'         break
#'       }
#'     }
#'   }
#'   
#'   if (is.na(x)) {
#'     ret <- NA
#'     
#'   } else {
#'     ln <- nchar(as.character(d2)) + 2 # +2 is "E-"
#'     
#'     vl <- roundup(x * (10 ^ d2), dgts - ln)
#'     
#'     ret <- paste0(vl, "E-", d2)
#'   }
#'   
#'   return(ret)
#' }

