# Format Application ------------------------------------------------------


#' @title
#' Apply formatting to a vector
#' 
#' @description 
#' The \code{fapply} function applies formatting to a vector. 
#' @details 
#' The \code{fapply} function accepts several types of formats:  formatting
#' strings, named vectors,
#' vectorized functions, or user-defined formats.  It also 
#' accepts a formatting list, composed of any of the previous types.  
#' The function will first determine the type of format, and then apply 
#' the format in the appropriate way.  Results are returned as a vector.
#' 
#' The function also has parameters for width and justification.
#' 
#' Parameters may also be passed as attributes on the vector.  See 
#' the \code{\link{fattr}} function for additional information on setting
#' formatting attributes. 
#' 
#' @section Types of Formats:
#' The \code{fapply} function will process any of the following types of
#' formats:
#' \itemize{
#'   \item{\strong{Formatting string:} A single string will be interpreted as 
#' a formatting string.  See the \link{FormattingStrings} documentation for 
#' further details.}
#'   \item{\strong{Named vector:} A named vector can serve as a lookup list or 
#'   decode 
#' for a vector.  You can use a named vector to perform simple 
#' lookups on character vectors.}
#'   \item{\strong{Format object:} A format object may be created using the 
#' \code{\link{value}} function.  The format object is included in the 
#' \strong{fmtr} package, and is specially designed for data categorization.}  
#'   \item{\strong{Vectorized formatting function:} A vectorized function 
#'   provides
#' the most flexibility and power over your formatting.  You can use 
#' an existing formatting function from any package, or create 
#' your own vectorized formatting function using \code{\link[base]{Vectorize}}.}
#' }
#' 
#' \code{fapply} will also accept a formatting list, which can contain any 
#' number of formats from the above list.  To create a formatting list, 
#' see the \code{\link{flist}} function.
#' @param x A vector, factor, or list to apply the format to.
#' @param format A format to be applied.
#' @param width The desired character width of the formatted vector.  Default
#' value is NULL, meaning the vector will be variable width.
#' @param justify Whether to justify the return vector.  Valid values are 
#' 'left', 'right', 'center', 'centre', or 'none'. 
#' @return A vector of formatted values.
#' @seealso \code{\link{fcat}} to create a format catalog,
#' \code{\link{value}} to define a format, 
#' \code{\link{fattr}} to easily set the formatting attributes of a vector, 
#' and \code{\link{flist}} to define a formatting list.  Also see 
#' \code{\link{fdata}} to apply formats to an entire data frame, and 
#' \link{FormattingStrings} for how to define a formatting string.
#' @import common
#' @export
#' @examples 
#' ## Example 1: Formatting string ##
#' v1 <- c(1.235, 8.363, 5.954, 2.465)
#' 
#' # Apply string format.
#' fapply(v1, "%.1f")
#' # [1] "1.2" "8.4" "6.0" "2.5"
#' 
#' ## Example 2: Named vector ##
#' # Set up vector
#' v2 <- c("A", "B", "C", "B")
#' 
#' # Set up named vector for formatting
#' fmt2 <- c(A = "Label A", B = "Label B", C = "Label C")
#' 
#' # Apply format to vector
#' fapply(v2, fmt2)
#' # [1] "Label A" "Label B" "Label C" "Label B"
#' 
#' ## Example 3: User-defined format ##
#' # Define format
#' fmt3 <- value(condition(x == "A", "Label A"),
#'               condition(x == "B", "Label B"), 
#'               condition(TRUE, "Other"))
#'               
#' # Apply format to vector
#' fapply(v2, fmt3)
#' # [1] "Label A" "Label B" "Other"   "Label B"
#' 
#' ## Example 4: Formatting function ##
#' # Set up vectorized function
#' fmt4 <- Vectorize(function(x) {
#' 
#'   if (x %in% c("A", "B"))
#'     ret <- paste("Label", x)
#'   else
#'     ret <- "Other" 
#'     
#'   return(ret)
#' })
#' 
#' # Apply format to vector
#' fapply(v2, fmt4)
#' # [1] "Label A" "Label B" "Other"   "Label B"
#' 
#' ## Example 5: Formatting List - Row Type ##
#' # Set up data
#' # Notice each row has a different data type
#' v3 <- list(2841.258, "H", Sys.Date(),
#'            "L", Sys.Date() + 60, 1382.8865)
#' v4 <- c("int", "char", "date", "char", "date", "int")
#' 
#' # Create formatting list
#' lst <- flist(type = "row", lookup = v4,
#'        int = function(x) format(x, digits = 2, nsmall = 1, 
#'                                   big.mark=","),
#'        char = value(condition(x == "H", "High"),
#'                      condition(x == "L", "Low"),
#'                      condition(TRUE, "NA")),
#'        date = "%d%b%Y")
#' 
#' # Apply formatting list to vector
#' fapply(v3, lst)
#' # [1] "2,841.3"   "High"      "06Jan2024" "Low"       "06Mar2024" "1,382.9"  
#' 
#' ## Example 6: Formatting List - Column Type ##
#' # Set up data
#' v5 <- c(Sys.Date(), Sys.Date() + 30, Sys.Date() + 60)
#' v5
#' # [1] "2024-01-06" "2024-02-05" "2024-03-06"
#' 
#' # Create formatting list
#' lst <- flist("%B", "This month is: %s", type = "column")
#' 
#' # Apply formatting list to vector
#' fapply(v5, lst)
#' # [1] "This month is: January"  "This month is: February" "This month is: March" 
#' 
#' # Example 7: Conditional Formatting
#' # Data vector
#' v6 <- c(8.38371, 1.46938, 3.28783, NA, 0.98632)
#' 
#' # User-defined format
#' fmt5 <- value(condition(is.na(x), "Missing"),
#'               condition(x < 1, "Low"), 
#'               condition(x > 5, "High"),
#'               condition(TRUE, "%.2f"))
#' 
#' # Apply format to data vector
#' fapply(v6, fmt5)
#' # [1] "High"    "1.47"    "3.29"    "Missing" "Low" 
fapply <- function(x, format = NULL, width = NULL, justify = NULL) {
  
  # Get attribute values if available
  if (is.null(format) & is.null(attr(x, "format", exact = TRUE)) == FALSE) 
    format <- attr(x, "format", exact = TRUE)
  if (is.null(width) & is.null(attr(x, "width", exact = TRUE)) == FALSE)
    width <- attr(x, "width", exact = TRUE)
  if (is.null(justify) & is.null(attr(x, "justify", exact = TRUE)) == FALSE)
    justify <- attr(x, "justify", exact = TRUE)
  
  # Parameter checks - Date values messing up this check
  # if (!is.vector(x) & !is.factor(x) & !is.list(x)) {
  #   
  #   stop("Invalid value for parameter x.  Must be a vector, factor, or list.") 
  # }
  
  if (!is.null(format)) {

    if (!any(class(format) %in% c("NULL", "character", "fmt", "numeric", "integer", 
                                 "fmt_lst", "function")))
      stop(paste0("class of format parameter value is invalid: ", 
                  class(format)))
  }
  
  if (!is.null(width)) {

    
    if (is.numeric(width) == FALSE) 
      stop("width parameter must be numeric.")
    
    if (width <= 0)
      stop("width parameter must be a positive integer.")
    
  }
  
  if (!is.null(justify)) {

    
    if (!justify %in% c("left", "right", "center", "centre", "none"))
      stop(paste("justify parameter is invalid. Valid values are 'left',",
                 "'right', 'center', 'centre', or 'none'."))
    
  }
  
  ret <- NULL
  
  # Perform different operations depending on type of format
  if (is.vector(format) & is.list(format) == FALSE) {
   
    # If format is a single string, call format_vector to deal with it
    if (length(format) == 1 & length(names(format)) == 0)
      ret <- format_vector(x, format)
    else {
      
      
      if (length(names(format)) == 0) {
        stop("Vector formats are required to be named.")
      } else {
        
        # For named vectors, perform lookup
        if (all(class(format) == "character"))
          ret <- lkup(x, format)
        else 
          ret <- format[x]
        
        names(ret) <- NULL  # Names not needed and mess up stuff
      
      }
    }
    
  }
  else if (is.function(format)) {
    
    # For format function, execute it as is
    ret <- do.call(format, list(x))
    names(ret) <- NULL  # Names not needed and mess up stuff
    
  } else if (is.format(format)) {
    
    # For format class, apply to vector using eval_conditions function  
    ret <- mapply(eval_conditions, x, MoreArgs = list(conds = format))
    names(ret) <- NULL  # Names not needed and mess up stuff
    
    if (!is.null(attr(format, "as.factor"))) {
      if (attr(format, "as.factor") == TRUE) {
         ret <- factor(ret, levels = labels(format), ordered = TRUE)
         
      }
    }
    
  } else if (is.flist(format)) {
    
    # For flist class, call row or column functions as appropriate
    if (format$type == "row")
      ret <- flist_row_apply(format, x)
    else 
      ret <- flist_column_apply(format, x)
    
  } else if (is.null(format)) {
    
    # if no format, do nothing
    ret <- x    
  
  } else 
    stop(paste0("format parameter must be a vector, function, ", 
                "user-defined format, or list."))
  
  # Justify and set width once other formatting is complete 
  ret <- justify_vector(ret, width, justify)
  
  return(ret)
  
}




#' @title
#' Apply formatting to two vectors
#' @description 
#' The \code{fapply2} function applies formatting to two different vectors, and 
#' combines them into a single vector.  This function is useful in cases
#' where your data is in two different variables, and you would like them
#' displayed as a single column for reporting purposes. For example, if you
#' wish to create one column to display mean and standard deviation.
#' @details 
#' The \code{fapply2} function works nearly the same as \code{\link{fapply}}.
#' The difference is it has parameters for two vectors and formats instead of one.  
#' The output of the function
#' is a single vector. The function essentially calls \code{\link{fapply}} 
#' on each vector and pastes them together afterwards.
#' 
#' There is an additional \code{sep} parameter so you can
#' define a separator between the two formatted values. 
#' The \code{width} and \code{justify} parameters
#' will apply to the single vector result.  The function will also
#' pick up format attributes on the supplied vectors.  
#' 
#' The \code{fapply2} function accepts any of the format types 
#' that \code{\link{fapply}} accepts.
#' See \code{\link{fapply}} for additional information on the types
#' of formats that can be applied.
#' 
#' Parameters may also be passed as attributes on the vector.  See 
#' the \code{\link{fattr}} function for additional information on setting
#' formatting attributes. 
#' 
#' @param x1 A vector, factor, or list to apply the format1 to.
#' @param x2 A second vector, factor, or list to which format2 will be applied.
#' @param format1 A format to be applied to the first input.
#' @param format2 A format to be applied to the second input.
#' @param sep A separator to use between the two formatted values.  Default
#' is a single blank space (" ").
#' @param width The desired character width of the formatted vector.  Default
#' value is NULL, meaning the vector will be variable width.
#' @param justify Whether to justify the return vector.  Valid values are 
#' 'left', 'right', 'center', 'centre', or 'none'. 
#' @return A vector of formatted values.
#' @seealso \code{\link{fapply}} to format a single input,
#' \code{\link{fcat}} to create a format catalog,
#' \code{\link{value}} to define a format, 
#' \code{\link{fattr}} to easily set the formatting attributes of a vector, 
#' and \code{\link{flist}} to define a formatting list.  Also see 
#' \code{\link{fdata}} to apply formats to an entire data frame, and 
#' \link{FormattingStrings} for how to define a formatting string.
#' @export
#' @examples 
#' # Create sample data
#' dt <- c(2.1, 5, 6, 9, 2, 7, 3)
#' 
#' # Calculate mean and standard deviation
#' v1 <- mean(dt)
#' v2 <- sd(dt)
#' 
#' # Apply formats and combine
#' fapply2(v1, v2, "%.1f", "(%.2f)")
#' # [1] "4.9 (2.66)"
fapply2 <- function(x1, x2, format1 = NULL, format2 = NULL, sep = " ",
                    width = NULL, justify = NULL) {
  
  
  res1 <- fapply(x1, format1)
  res2 <- fapply(x2, format2)
  
  ret <- paste0(res1, sep, res2)
  
  if (!is.null(width) | !is.null(justify))
    ret <- justify_vector(ret, width, justify)
  
  
  return(ret)
}


# Utilities ---------------------------------------------------------------



#' @noRd
eval_conditions <- function(x, conds) {
  
  # Default to the value itself
  ret <- x
  
  # Check all conditions
  for(cond in conds) {
    tmp <- eval(cond[["expression"]])
    if (!is.na(tmp) & !is.null(tmp)) {
      if (tmp) {
        ret <- format_vector(x, cond[["label"]], udfmt = TRUE)
        break()
      }
    }
  }
  
  return(ret)
}


eval_conditions_back <- function(x, conds) {
  
  # Default to the value itself
  ret <- x
  
  # Check all conditions
  for(cond in conds) {
    tmp <- eval(cond[["expression"]])
    if (!is.na(tmp) & !is.null(tmp)) {
      if (tmp) {
        ret <- cond[["label"]]
        break()
      }
    }
  }
  
  return(ret)
}

#' @noRd
format_vector <- function(x, fmt, udfmt = FALSE) {
 
  if ("character" %in% class(fmt)) {
    if (any(class(x) %in% c("Date", "POSIXt"))) {
    
      # For dates, call format
      if (udfmt == TRUE) {
        
        ret <- tryCatch({suppressWarnings(format(x, format = fmt))},
                        error = function(cond) {fmt})
        
      } else {
        ret <- format(x, format = fmt)
      }
      
      xin <- x
      if (!"Date" %in% class(x))
        xin <- as.Date(x)
      
      ret <- format_quarter(xin, ret, fmt)
    
    } else if (any(class(x) %in% c("numeric", "character", "integer"))) {
      
  
        # For numerics, call sprintf
        if (udfmt == TRUE) {
          ret <- tryCatch({suppressWarnings(sprintf(fmt, x))},
                        error = function(cond) {fmt})
        } else {
          
          ret <- sprintf(fmt, x)
        }
        
        # Find NA strings
        nas <- ret == "NA"
        
        # Turn NA strings back into real NA
        ret <- replace(ret, nas, NA)
    } else {
      ret <- fmt
    }
  } else if ("function" %in% class(fmt)) {
    
    ret <- fmt(x)
    
  } else if (any(class(fmt) %in% c("Date", "POSIXt"))) {
    
    ret <- as.Date(fmt) 
  } else {
    
    ret <- fmt 
  }
  
  return(ret)
  
}


#' @noRd
justify_vector <- function(x, width = NULL, justify = NULL) {
  
  
  if (is.null(width) & is.null(justify)) {
    
    # If no justification requested, just return the vector
    ret <- x
    
  } else {
    
    # Convert American Spelling to Kiwi spelling
    jst <- justify
    if (is.null(justify) == FALSE) {
      if (justify == "center")
        jst <- "centre"
    }

    # Convert to character if necessary so justification will work
    if (is.null(justify) == FALSE & any(class(x) %in% c("integer", "numeric"))){
      ret <- format(as.character(x), width = width, justify = jst)
    } else if (any(class(x) %in% c("Date", "POSIXt")))
      ret <- format(as.character(x), width = width, justify = jst)
    else
      ret <- format(x, width = width, justify = jst)
  }

  return(ret)
}


#' @noRd
flist_row_apply <- function(lst, vect) {
  
  # Intitialize 
  ret <- c()
  fmts <- list()
  
  # Lookup vs. Order type
  if (!is.null(lst$lookup)) {
    
    fmts <- lst$formats[lst$lookup]

    
  } else {
    
    if (length(vect) %% length(lst$formats) != 0 )
      message("NOTE: format list is not a multiple of input vector")

    fmts <- rep(lst$formats, length.out = length(vect))

  }
  
  # Apply format list to vector values
  for (i in seq_along(vect)) {
    ret[[i]] <- fapply(vect[[i]][1], fmts[[i]])
  }
  
  # Unlist if requested
  if (lst$simplify == TRUE)
    ret <- unlist(ret)
  
  return(ret)
  
}

#' @noRd
flist_column_apply <- function(lst, vect) {
  
  # Initialize
  ret <- vect
  fmts <- lst$formats

  # Apply formats to vector in order
  for (i in seq_along(fmts)) {
    ret <- fapply(ret, fmts[[i]])
  }

  # Unlist if requested  
  if(lst$simplify == TRUE)
    ret <- unlist(ret)
  else if (lst$simplify == FALSE & typeof(ret) != "list")
    ret <- as.list(ret)

  return(ret)
  
}


format_quarter <- function(x, val, fmt) {
  
  q1 <- grepl("%Q", fmt, ignore.case = FALSE, fixed = TRUE)
  q2 <- grepl("%q", fmt, ignore.case = FALSE, fixed = TRUE)


  
  if (q1 | q2) {
    
    ret <- val
    q <- get_quarter(x)

    
    if (q1) {
      
      ptn <- "Q"
      repl <- paste0("Q", q) 
      
      ret <- replace_quarter(ret, ptn, repl)
      
    } 
    
    if (q2) {
      
      ptn <- "q"
      
      # Can't replace with just a number.  Quirk of gsub.
      repl <- paste0("q", q) 

      ret <- replace_quarter(ret, ptn, repl)
      
      # Now remove "q" after the fact.
      ret <- gsub("q", "", ret, fixed = TRUE, ignore.case = FALSE)
      
    }
    
  } else {
    
    ret <- val
  }
  
  return(ret)
}






# Testing -----------------------------------------------------------------

