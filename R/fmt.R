
# Format Definition -------------------------------------------------------


#' @title
#' Create a user-defined format
#' 
#' @description 
#' The \code{value} function creates a user-defined format. 
#' 
#' @details 
#' The \code{value} function creates a user defined format object, in a manner
#' similar to a SAS® format.  The \code{value} function accepts 
#' one or more \code{condition} arguments that define the format.  The 
#' conditions map an R expression to a label.  
#' 
#' The format object is an S3 class of type "fmt". When the object is created,
#' the \strong{levels} attribute of the object will be set with a vector 
#' of values
#' assigned to the \strong{labels} property of the \code{condition} arguments.  
#' These labels may be accessed either from the \code{levels} function or the 
#' \code{labels} function.
#' 
#' The format object may be applied to a vector using the \code{fapply}
#' function.  See \code{\link{fapply}} for further details.
#'
#' @param ... One or more conditions.
#' @return The new format object.
#' @seealso \code{\link{condition}} to define a condition,
#' \code{\link{levels}} or \code{labels} to access the labels, and 
#' \code{\link{fapply}} to apply the format to a vector.
#' @export
#' @examples 
#' ## Example 1: Character to Character Mapping ##
#' # Set up vector
#' v1 <- c("A", "B", "C", "B")
#' 
#' # Define format
#' fmt1 <- value(condition(x == "A", "Label A"),
#'               condition(x == "B", "Label B"), 
#'               condition(TRUE, "Other"))
#'               
#' # Apply format to vector
#' fapply(v1, fmt1)
#' 
#' 
#' ## Example 2: Character to Integer Mapping ##
#' fmt2 <- value(condition(x == "A", 1),
#'               condition(x == "B", 2),
#'               condition(TRUE, 3))
#' 
#' # Apply format to vector
#' fapply(v1, fmt2)
#' 
#' 
#' ## Example 3: Categorization of Continuous Variable ##
#' # Set up vector
#' v2 <- c(1, 6, 11, 7)
#' 
#' # Define format
#' fmt3 <- value(condition(x < 5, "Low"),
#'               condition(x >= 5 & x < 10, "High"), 
#'               condition(TRUE, "Out of range"))
#'               
#' # Apply format to vector
#' fapply(v2, fmt3)
value <- function(...) {
  
  if (...length() == 0)
    stop("At least one condition is required.")
  
  # Create new structure of class "fmt"
  x <- structure(list(...), class = c("fmt"))    
  
  # Assign labels to the levels attribute
  attr(x, "levels") <- labels(x)

  return(x)

}

#' @title
#' Define a condition for a user-defined format
#' 
#' @description 
#' The \code{condition} function creates a condition for a user-defined format. 
#' 
#' @details 
#' The \code{condition} function creates a condition as part of a format 
#' definition.  The format is defined using the \code{\link{value}} 
#' function.  The condition is defined as an expression/label pair.  The 
#' expression parameter can be any valid R expression.   The label parameter
#' can be any valid literal.  Conditions are evaluated in the order they 
#' are assigned.  A default condition is created by assigning the expression
#' parameter to TRUE.
#' 
#' The condition object is an S3 class of type "fmt_cond". The condition 
#' labels can be extracted from the format using the \code{labels} function.
#' 
#' The format object may be applied to a vector using the \code{fapply}
#' function.  See \code{link{fapply}} for further details.
#'
#' @param expr A valid R expression.  The value in the expression is identified
#' by the variable 'x', i.e.  x == 'A' or x > 3 & x < 6.  The expression 
#' should not be quoted.
#' @param label A label to be assigned if the expression is TRUE.  The label 
#' can any valid literal value.  Typically, the label will be a character 
#' string.  However, the label parameter does not restrict the data type.
#' Meaning, the label could also be a number, date, or other R object type.
#' @return The new condition object.
#' @seealso \code{\link{fdata}} to apply formatting to a data frame,
#' \code{\link{value}} to define a format,
#' \code{\link{levels}} or \code{\link{labels.fmt}} to access the labels, and 
#' \code{\link{fapply}} to apply the format to a vector.
#' @export
#' @examples 
#' # Set up vector
#' v1 <- c("A", "B", "C", "B")
#' 
#' # Define format
#' fmt1 <- value(condition(x == "A", "Label A"),
#'               condition(x == "B", "Label B"), 
#'               condition(TRUE, "Other"))
#'               
#' # Apply format to vector
#' v2 <- fapply(v1, fmt1)
#' v2
condition <- function(expr, label) {
  
  y <- structure(list(), class = c("fmt_cnd"))    
  
  y$expression <- substitute(expr)
  y$label <- label
  
  return(y)
  
}
  

# Utilities ---------------------------------------------------------------

#' @title
#' Extract labels from a user-defined format
#' 
#' @description 
#' The \code{labels} function creates a vector of labels associated with 
#' a user-defined format. 
#' 
#' @details 
#' The \code{condition} function creates a condition as part of a format 
#' definition.  Each condition has a label as part of its definition.
#' The \code{labels} function extracts the labels from the conditions and
#' returns them as a vector.  While the labels will typically be of type
#' character, the can be of any data type. See the \code{link{condition}}
#' function help for further details.  
#'
#' @param object A user-defined format of class "fmt".
#' @param ... Following arguments.
#' @return A vector of label values.
#' @seealso \code{\link{value}} to define a format,
#' \code{\link{condition}} to define the conditions for a format, and 
#' \code{\link{fapply}} to apply the format to a vector.
#' @export
#' @examples 
#' 
#' # Define format
#' fmt1 <- value(condition(x == "A", "Label A"),
#'               condition(x == "B", "Label B"), 
#'               condition(TRUE, "Other"))
#'               
#' # Extract labels
#' labels(fmt1)
labels.fmt <- function(object, ...) {
  
  ret <- NULL
  
  for (i in seq_along(object)) {
    
    ret[length(ret) + 1] <- object[[i]][["label"]]
    
  }
  
  return(ret)
  
}

#' @title
#' Determine whether an object is a user-defined format
#' 
#' @description 
#' The \code{is.format} can be used to determine if an object is a 
#' user-defined format of class "fmt". 
#' 
#' @details 
#' The \code{is.format} function returns TRUE if the object passed is a 
#' user-defined format.  User-defined formats are defined using the \code{value}
#' function. See the \code{link{value}}
#' function help for further details.  
#'
#' @param x A user-defined format of class "fmt".
#' @return A logical value or TRUE or FALSE.
#' @seealso \code{\link{value}} to define a format,
#' \code{\link{condition}} to define the conditions for a format, and 
#' \code{\link{fapply}} to apply the format to a vector.
#' @export
#' @examples 
#' 
#' # Define format
#' fmt1 <- value(condition(x == "A", "Label A"),
#'               condition(x == "B", "Label B"), 
#'               condition(TRUE, "Other"))
#'               
#' # Check for format
#' is.format(fmt1)
#' is.format("A")
is.format <- function(x) {
 
  ret <- FALSE
  if (any(class(x) == "fmt"))
    ret <- TRUE
  
  return(ret)
}





# Testing -----------------------------------------------------------------



# v1 <- c("A", "B", "C", "B")
# 
# fmt1 <- value(condition(x == "A", "Label A"),
#               condition(x == "B", "Label B"),
#               condition(TRUE, "Other"))
# 
# fmt1
# fapply(fmt1, v1)

#
# 
# 
# v2 <- c(1, 2, 3, 2)
# 
# fmt2 <- value(condition(x == 1, "Label A"),
#               condition(x == 2, "Label B"), 
#               condition(TRUE, "Other"))
# 
# 
# fapply(fmt2, v2)
# 
# 
# fmt3 <- value(condition(x <= 1, "Label A"),
#               condition(x > 1 & x <= 2, "Label B"), 
#               condition(TRUE, "Other"))
# 
# 
# fapply(fmt3, v2)
# 
# 
# fmt4 <- value(condition(x == "A", 1),
#               condition(x == "B", 2),
#               condition(TRUE, 3))
# 
# fapply(fmt4, v1)


