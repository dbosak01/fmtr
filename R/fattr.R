
# Format attributes -------------------------------------------------------


#' @title Set formatting attributes
#' @description Assign formatting attributes to a vector 
#' @details 
#' The \code{fattr} function is a convenience function for assigning 
#' formatting attributes to a vector.  The function accepts parameters
#' for format, width, and justify.  Any formatting attributes assigned 
#' to a vector can be applied using \code{\link{fapply}} or
#' \code{\link{fdata}}.
#' @param x The vector to assign attributes to.
#' @param format The format to assign to the format attribute.  Format 
#' can be a formatting string, a named vector decode, a vectorized
#' formatting function, or a formatting list. 
#' @param width The desired width of the formatted output. 
#' @param justify Justification of the output vector. Valid values are 
#' 'none', 'left', 'right', 'center', or 'centre'. 
#' @param keep Whether to keep any existing formatting settings and 
#' transfer to the new vector.  Default value is TRUE.
#' @return The vector with formatting attributes applied.
#' @seealso \code{\link{fdata}} to apply formats to a data frame, 
#'  \code{\link{fapply}} to apply formats to a vector.  See
#' \link{FormattingStrings} for documentation on formatting strings.
#' @export
#' @examples
#' # Create vector
#' a <- c(1.3243, 5.9783, 2.3848)
#' 
#' # Assign format attributes
#' a <- fattr(a, format = "%.1f", width = 10, justify = "right")
#' 
#' # Apply format attributes
#' fapply(a)
fattr <- function(x, format = NULL, width = NULL, justify = NULL, keep = TRUE) {
  
  if (!class(format) %in% c("NULL", "character", "fmt", 
                            "fmt_lst", "function"))
      stop(paste0("class of format parameter value is invalid:", 
                  class(format)))
  
  if (is.null(width) == FALSE) {
   if (is.numeric(width) == FALSE) 
     stop("width parameter must be numeric.")
    
   if (width <= 0)
     stop("width parameter must be a positive integer")
    
  }
  
  if (is.null(justify) == FALSE) {
   
    if (!justify %in% c("left", "right", "center", "centre", "none"))
      stop(paste("justify parameter is invalid. Valid values are 'left',",
                 "'right', 'center', 'centre', or 'none'."))
  }
  
  if (!(is.null(format) & keep == TRUE))
    attr(x, "format") <- format
  if (!(is.null(width) & keep == TRUE))
    attr(x, "width") <- width
  if (!(is.null(justify) & keep == TRUE))
    attr(x, "justify") <- justify
  
  return(x)
  
}


#' @title Set formatting attributes
#' @description Assign formatting attributes to a vector 
#' @details 
#' The \code{fattr} function is a convenience function for assigning 
#' formatting attributes to a vector.  The function accepts a named list of
#' formatting attributes.  Valid names are 'format', 'width', and 'justify'.
#' See \code{\link{fattr}} for additional details.  
#' @param x The vector to assign attributes to.
#' @param value A named vector of attribute values.
#' @seealso \code{\link{fdata}} to apply formats to a data frame, 
#'  \code{\link{fapply}} to apply formats to a vector.
#' @export
#' @examples
#' # Create vector
#' a <- c(1.3243, 5.9783, 2.3848)
#' 
#' # Assign format attributes
#' fattr(a) <- list(format = "%.1f")
#' 
#' # Apply format attributes
#' fapply(a)
"fattr<-" <- function(x, value) {
  
  if (!is.null(value[["format"]])) {
    
    format <- value[["format"]]
    if (!class(format) %in% c("NULL", "character", "fmt",
                              "fmt_lst", "function"))
      stop(paste0("class of format parameter value is invalid: ", 
                  class(format)))
  }
  
  
  if (!is.null(value[["width"]])) {
    
    width <- value[["width"]]
    
    if (is.numeric(width) == FALSE) 
      stop("width parameter must be numeric.")
    
    if (width <= 0)
      stop("width parameter must be a positive integer.")
     
  }
  
  
  if (!is.null(value[["justify"]])) {
    justify <- value[["justify"]]
      

    if (!justify %in% c("left", "right", "center", "centre", "none"))
      stop(paste("justify parameter is invalid. Valid values are 'left',",
                 "'right', 'center', 'centre', or 'none'."))
    
  }
  
  attr(x, "format") <- value[["format"]]
  attr(x, "width") <- value[["width"]]
  attr(x, "justify") <- value[["justify"]]
  
  return(x)
  
}


