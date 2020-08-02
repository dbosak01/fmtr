

#' @title
#' Get or set formats for a data frame 
#' 
#' @description 
#' The \code{formats} function extracts all assigned formats from a 
#' data frame, and returns them in a named list. The function also
#' assigns formats from a named list.
#' 
#' @details 
#' If formats are assigned to the "format" attributes of the data frame
#' columns, the \code{formats} function will extract those formats.  The 
#' function will return the formats in a named list, where the names
#' correspond to the name of the column that the format was assigned to.
#' If a column does not have a format attribute assigned, that column
#' will not be included in the list. 
#' 
#' When used on the receiving side of an assignment, the function will assign
#' formats to a data frame.  The formats should be in a named list, where
#' each name corresponds to the data frame column to assign the format to.
#'     
#' @param x A data frame or tibble.
#' @return A named list of formats. 
#' @seealso \code{\link{fdata}} to display formatted data, 
#' \code{\link{value}} to create user-defined formats, and 
#' \code{\link{fapply}} to apply formats to a vector. Also see
#' \link{FormattingStrings} for documentation on formatting strings.
#' @export
#' @aliases formats<-
#' @examples 
#' # Take subset of data
#' df1 <- mtcars[1:10, c("mpg", "cyl") ]
#' 
#' # Print current state
#' print(df1)
#' 
#' # Assign formats
#' attr(df1$mpg, "format") <- value(condition(x >= 20, "High"),
#'                                  condition(x < 20, "Low"))
#' attr(df1$cyl, "format") <- function(x) format(x, nsmall = 1)
#' 
#' # Display formatted data
#' format(df1)
#' 
#' # Extract format list
#' lst <- formats(df1)
#' 
#' # Alter format list and reassign
#' lst$mpg <- value(condition(x >= 22, "High"),
#'                  condition(x < 22, "Low"))
#' lst$cyl <- function(x) format(x, nsmall = 2)
#' formats(df1) <-  lst
#' 
#' # Display formatted data
#' format(df1)
formats <- function(x) {
  
  ret <- list()
  
  for (nm in names(x)) {
    
    if (!is.null(attr(x[[nm]], "format"))) {
      ret[[nm]] <- attr(x[[nm]], "format")
    }
    
  }
  
  return(ret)
  
}

#' @aliases formats
#' @rdname  formats
#' @param x A data frame or tibble
#' @param value A named list of formats 
#' @export 
`formats<-` <- function(x, value) {
  
  
  for (nm in names(value)) {
    
    if (is.null(x[[nm]])) 
      stop(paste("Name not found:", nm))
    else
      attr(x[[nm]], "format") <- value[[nm]]
    
  }
  
  return(x)
  
}


