
#' @title
#' Get or set labels for a data frame 
#' 
#' @description 
#' The \code{labels} function extracts all assigned labels from a 
#' data frame, and returns them in a named list. The function also
#' assigns labels from a named list.  This function is a data frame-specific
#' implementation of the Base R \code{labels} function.
#' 
#' @details 
#' If labels are assigned to the "label" attributes of the data frame
#' columns, the \code{labels} function will extract those labels.  The 
#' function will return the labels in a named list, where the names
#' correspond to the name of the column that the label was assigned to.
#' If a column does not have a label attribute assigned, that column
#' will not be included in the list. 
#' 
#' When used on the receiving side of an assignment, the function will assign
#' labels to a data frame.  The labels should be in a named list, where
#' each name corresponds to the data frame column to assign the label to.
#'  
#' Finally, if you wish to clear out the label attributes, assign
#' a NULL value to the \code{labels} function.   
#' @param object A data frame or tibble.
#' @param ... Follow-on parameters.  Required for generic function.
#' @return A named list of labels. The labels must be quoted strings. 
#' @seealso \code{\link{fdata}} to display formatted data, 
#' \code{\link{value}} to create user-defined formats, and 
#' \code{\link{fapply}} to apply formats to a vector.
#' @export
#' @aliases labels<-
#' @examples 
#' # Take subset of data
#' df1 <- mtcars[1:10, c("mpg", "cyl") ]
#' 
#' # Assign labels
#' labels(df1) <- list(mpg = "Mile Per Gallon", cyl = "Cylinders") 
#' 
#' # Examine attributes
#' str(df1)
#' 
#' # View assigned labels
#' labels(df1)
#' 
#' # Clear labels
#' labels(df1) <- NULL
#' 
#' # Display Cleared Labels
#' labels(df1)
labels.data.frame <- function(object, ...) {
  
  ret <- list()
  
  for (nm in names(object)) {
    
    if (!is.null(attr(object[[nm]], "label"))) {
      ret[[nm]] <- attr(object[[nm]], "label")
    }
    
  }
  
  return(ret)
  
}


#' @aliases labels.data.frame
#' @rdname  labels.data.frame
#' @param x A data frame or tibble
#' @param value A named list of labels  The labels must be quoted strings.
#' @export 
`labels<-` <- function(x, value) {
  
  if (!"data.frame" %in% class(x))
    stop("Class list must contain 'data.frame'.")
  
  
  
  if (all(is.null(value))) {
    
    for (nm in names(x)) {
      
      attr(x[[nm]], "label") <- NULL
    }
    
    
  } else {
  
    for (nm in names(value)) {
      
      if (is.null(x[[nm]])) 
        stop(paste("Name not found:", nm))
      else
        attr(x[[nm]], "label") <- value[[nm]]
      
    }
    
  }
  
  return(x)
  
}


