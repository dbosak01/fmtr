
#' @title
#' Get or set justification for data frame columns
#' 
#' @description 
#' The \code{justification} function extracts all assigned justify
#' attributes from a 
#' data frame, and returns them in a named list. The function also
#' assigns justify attributes from a named list.
#' 
#' @details 
#' If justification values are assigned to the "justify" 
#' attributes of the data frame
#' columns, the \code{justification} function will extract those values.  The 
#' function will return the justification values in a named list, 
#' where the names
#' correspond to the name of the column that the justification was assigned to.
#' If a column does not have a justify attribute assigned, that column
#' will not be included in the list. 
#' 
#' When used on the receiving side of an assignment, the function will assign
#' justification to a data frame.  The justification values 
#' should be in a named list, where
#' each name corresponds to the name of the data frame column to assign
#' values to.
#' 
#' Finally, if you wish to clear out the justification attributes, assign
#' a NULL value to the \code{justification} function.
#'     
#' @param x A data frame or tibble.
#' @return A named list of justification values. 
#' @seealso \code{\link{fdata}} to display formatted data, 
#' \code{\link{value}} to create user-defined formats, and 
#' \code{\link{fapply}} to apply formatting to a vector.
#' @export
#' @aliases justification<-
#' @examples 
#' # Take subset of data
#' df1 <- mtcars[1:10, c("mpg", "cyl") ]
#' 
#' # Print current state
#' print(df1)
#' 
#' # Assign justification
#' justification(df1) <- list(mpg = "left", cyl = "right")
#' widths(df1) <- list(mpg = 12, cyl = 10)
#' 
#' fdata(df1)
#' 
#' # Display justification
#' justification(df1)
#' widths(df1)
#' 
#' # Clear justification
#' justification(df1) <- NULL
#' 
#' # Confirm justifications are cleared
#' justification(df1)
justification <- function(x) {
  
  ret <- list()
  
  for (nm in names(x)) {
    
    if (!is.null(attr(x[[nm]], "justify", exact = TRUE))) {
      ret[[nm]] <- attr(x[[nm]], "justify", exact = TRUE)
    }
    
  }
  
  return(ret)
  
}

#' @aliases justification
#' @rdname  justification
#' @param x A data frame or tibble
#' @param value A named list of justification values. 
#' @export 
`justification<-` <- function(x, value) {
  
  
  
  if (all(is.null(value))) {
    
    for (nm in names(x)) {
      
      attr(x[[nm]], "justify") <- NULL
    }
    
    
  } else {
  
    for (nm in names(value)) {
      
      if (!is.null(x[[nm]])) 
        attr(x[[nm]], "justify") <- value[[nm]]
      
    }
  }
  
  return(x)
  
}


