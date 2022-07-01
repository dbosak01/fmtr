
#' @title
#' Get or set descriptions for data frame columns
#' 
#' @description 
#' The \code{descriptions} function extracts all assigned description
#' attributes from a 
#' data frame, and returns them in a named list. The function also
#' assigns description attributes from a named list.
#' 
#' @details 
#' If descriptions are assigned to the "description" 
#' attributes of the data frame
#' columns, the \code{descriptions} function will extract those values.  The 
#' function will return the description values in a named list, 
#' where the names
#' correspond to the name of the column that the description was assigned to.
#' If a column does not have a description attribute assigned, that column
#' will not be included in the list. 
#' 
#' When used on the receiving side of an assignment, the function will assign
#' descriptions to a data frame.  The description values 
#' should be in a named list, where
#' each name corresponds to the name of the data frame column to assign
#' values to.
#' 
#' Finally, if you wish to clear out the description attributes, assign
#' a NULL value to the \code{descriptions} function.    
#' @param x A data frame or tibble.
#' @return A named list of description values. 
#' @seealso \code{\link{fdata}} to display formatted data, 
#' \code{\link{value}} to create user-defined formats, and 
#' \code{\link{fapply}} to apply formatting to a vector.
#' @export
#' @aliases descriptions<-
#' @examples 
#' # Take subset of data
#' df1 <- mtcars[1:10, c("mpg", "cyl") ]
#' 
#' # Print current state
#' print(df1)
#' 
#' # Assign descriptions
#' descriptions(df1) <- list(mpg = "Miles per Gallon", cyl = "Cylinders")
#' 
#' # Display descriptions
#' descriptions(df1)
#' 
#' # Clear descriptions
#' descriptions(df1) <- NULL
#' 
#' # Confirm descriptions are cleared
#' descriptions(df1)
descriptions <- function(x) {
  
  ret <- list()
  
  for (nm in names(x)) {
    
    if (!is.null(attr(x[[nm]], "description", exact = TRUE))) {
      ret[[nm]] <- attr(x[[nm]], "description", exact = TRUE)
    }
    
  }
  
  return(ret)
  
}

#' @aliases descriptions
#' @rdname  descriptions
#' @param x A data frame or tibble
#' @param value A named list of description values. 
#' @export 
`descriptions<-` <- function(x, value) {
  
  if (all(is.null(value))) {
    
    for (nm in names(x)) {
      
      attr(x[[nm]], "description") <- NULL
    }
    
    
  } else {
    
    for (nm in names(value)) {
      
      if (!is.null(x[[nm]])) 
        attr(x[[nm]], "description") <- value[[nm]]
      
    }
  }
  
  return(x)
  
}


