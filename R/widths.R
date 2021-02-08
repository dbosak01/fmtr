
#' @title
#' Get or set column widths for a data frame 
#' 
#' @description 
#' The \code{widths} function extracts all assigned widths from a 
#' data frame, and returns them in a named list. The function also
#' assigns widths from a named list.
#' 
#' @details 
#' If widths are assigned to the "width" attributes of the data frame
#' columns, the \code{widths} function will extract those widths.  The 
#' function will return the widths in a named list, where the names
#' correspond to the name of the column that the width was assigned to.
#' If a column does not have a width attribute assigned, that column
#' will not be included in the list. 
#' 
#' When used on the receiving side of an assignment, the function will assign
#' widths to a data frame.  The widths should be in a named list, where
#' each name corresponds to the data frame column to assign the width to.
#'     
#' @param x A data frame or tibble.
#' @return A named list of widths. The widths must be positive integers
#' greater than zero. 
#' @seealso \code{\link{fdata}} to display formatted data, 
#' \code{\link{value}} to create user-defined formats, and 
#' \code{\link{fapply}} to apply formats to a vector.
#' @export
#' @aliases widths<-
#' @examples 
#' # Take subset of data
#' df1 <- mtcars[1:10, c("mpg", "cyl") ]
#' 
#' # Print current state
#' print(df1)
#' 
#' # Assign widths
#' widths(df1) <- list(mpg = 12, cyl = 10) 
#' 
#' # Display formatted data
#' fdata(df1)
#' 
#' # View assigned widths
#' widths(df1)
widths <- function(x) {
  
  ret <- list()
  
  for (nm in names(x)) {
    
    if (!is.null(attr(x[[nm]], "width"))) {
      ret[[nm]] <- attr(x[[nm]], "width")
    }
    
  }
  
  return(ret)
  
}

#' @aliases widths
#' @rdname  widths
#' @param x A data frame or tibble
#' @param value A named list of widths.  The widths must be positive integers
#' greater than zero. 
#' @export 
`widths<-` <- function(x, value) {
  
  
  for (nm in names(value)) {
    
    if (is.null(x[[nm]])) 
      stop(paste("Name not found:", nm))
    else
      attr(x[[nm]], "width") <- value[[nm]]
    
  }
  
  return(x)
  
}


