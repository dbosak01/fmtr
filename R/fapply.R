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
#'   \item{\strong{Formatting string:}}{ A single string will be interpreted as 
#' a formatting string.  See the \link{FormattingStrings} documentation for 
#' further details.}
#'   \item{\strong{Named vector:}}{ A named vector can serve as a lookup list or 
#'   decode 
#' for a vector.  You can use a named vector to perform simple 
#' lookups on character vectors.}
#'   \item{\strong{Format object:}}{ A format object may be created using the 
#' \code{\link{value}} function.  The format object is included in the 
#' \strong{fmtr} package, and is specially designed for data categorization.}  
#'   \item{\strong{Vectorized formatting function:}}{ A vectorized function 
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
#' @export
#' @examples 
#' ## Example 1: Formatting string ##
#' v1 <- c(1.235, 8.363, 5.954, 2.465)
#' 
#' # Apply string format.
#' fapply(v1, "%.1f")
#' 
#' 
#' ## Example 2: Named vector ##
#' # Set up vector
#' v2 <- c("A", "B", "C", "B")
#' 
#' # Set up named vector for formatting
#' fmt2 <- c(A = "Vector Label A", B = "Vector Label B", C = "Vector Label C")
#' 
#' # Apply format to vector
#' fapply(v2, fmt2)
#' 
#' 
#' ## Example 3: User-defined format ##
#' # Define format
#' fmt3 <- value(condition(x == "A", "Format Label A"),
#'               condition(x == "B", "Format Label B"), 
#'               condition(TRUE, "Format Other"))
#'               
#' # Apply format to vector
#' fapply(v2, fmt3)
#' 
#' 
#' ## Example 4: Formatting function ##
#' # Set up vectorized function
#' fmt4 <- Vectorize(function(x) {
#' 
#'   if (x %in% c("A", "B"))
#'     ret <- paste("Function Label", x)
#'   else
#'     ret <- "Function Other" 
#'     
#'   return(ret)
#' })
#' 
#' # Apply format to vector
#' fapply(v2, fmt4)
#' 
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
#' 
#' 
#' ## Example 6: Formatting List - Column Type ##
#' # Set up data
#' v5 <- c(Sys.Date(), Sys.Date() + 30, Sys.Date() + 60)
#' v5
#' 
#' # Create formatting list
#' lst <- flist("%B", "This month is: %s", type = "column")
#' 
#' # Apply formatting list to vector
#' fapply(v5, lst)
fapply <- function(x, format = NULL, width = NULL, justify = NULL) {
  

  
  # Get attribute values if available
  if (is.null(format) & is.null(attr(x, "format")) == FALSE) 
    format <- attr(x, "format")
  if (is.null(width) & is.null(attr(x, "width")) == FALSE)
    width <- attr(x, "width")
  if (is.null(justify) & is.null(attr(x, "justify")) == FALSE)
    justify <- attr(x, "justify")
  
  # Parameter checks - Date values messing up this check
  # if (!is.vector(x) & !is.factor(x) & !is.list(x)) {
  #   
  #   stop("Invalid value for parameter x.  Must be a vector, factor, or list.") 
  # }
  
  if (!is.null(format)) {

    if (!any(class(format) %in% c("NULL", "character", "fmt", 
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
    if (length(format) == 1)
      ret <- format_vector(x, format)
    else {
      
      # For named vectors, perform lookup
      ret <- lookup(x, format)
      names(ret) <- NULL  # Names not needed and mess up stuff
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


#' @noRd
eval_conditions <- function(x, conds) {
  
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
format_vector <- function(x, fmt) {
 
  
  if (any(class(x) %in% c("Date", "POSIXt"))) {
  
    # For dates, call format
    ret <- format(x, format = fmt)
  
  } else if (any(class(x) %in% c("numeric", "character", "integer"))) {
    
    # For numerics, call sprintf
    ret <- sprintf(fmt, x)
   
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
    
    if (length(vect) %% length(lst) != 0 )
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
  else if (lst$simplify == FALSE & class(ret) != "list")
    ret <- as.list(ret)

  return(ret)
  
}



# Testing -----------------------------------------------------------------

