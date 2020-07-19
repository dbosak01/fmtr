
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
#' function.  See \code{link{fapply}} for further details.
#'
#' @param ... One or more conditions.
#' @return The new format object.
#' @seealso \code{\link{condition}} to define a condition,
#' \code{\link{levels}} or \code{labels} to access the labels, and 
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
#' fapply(fmt1, v1)
#' 
#' fmt2 <- value(condition(x == "A", 1),
#'               condition(x == "B", 2),
#'               condition(TRUE, 3))
#' 
#' fapply(fmt2, v1)
#' 
#' #' # Set up vector
#' v2 <- c(1, 6, 11, 7)
#' 
#' # Define format
#' fmt3 <- value(condition(x < 5, "Low"),
#'               condition(x >= 5 & x < 10, "High"), 
#'               condition(TRUE, "Out of range"))
#'               
#' # Apply format to vector
#' fapply(fmt3, v2)
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
#' Define a condition for a format
#' 
#' @description 
#' The \code{condition} function creates a condition for a user-defined format. 
#' 
#' @details 
#' The \code{condition} function creates a condition as part of a format 
#' definition.  The format defined using the \code{\link{value}}, 
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
#' @seealso \code{\link{value}} to define a format,
#' \code{\link{levels}} or \code{labels} to access the labels, and 
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
#' v2 <- fapply(fmt1, v1)
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

# Format Application ------------------------------------------------------

#' @noRd
eval_conditions <- function(x, conds) {
  
  ret <- NULL
  for(cond in conds) {
    if (eval(cond[["expression"]])) {
      ret <- cond[["label"]]
      break()
    }
  }
  
  return(ret)
}

#' @title
#' Apply a format to a vector
#' 
#' @description 
#' The \code{fapply} function can be used to apply a format to a vector. 
#' 
#' @details 
#' The \code{fapply} function accepts several types of formats:  named vectors,
#' vectorized functions, user-defined formats, or a list of formats.
#' The function will first determine the type of format, and then apply 
#' the format in the appropriate way.  Results are returned as a vector.
#'
#' @param fmt A format to be applied.
#' @param vect A vector to apply the format to.
#' @param lookup An optional lookup vector. This parameter is used when the
#' format is a list.  If specified, the function will first lookup which 
#' format to apply, and then apply it to the vector value.
#' @return A vector of formatted values.
#' @seealso \code{\link{value}} to define a format,
#' \code{\link{condition}} to define the conditions for a format.
#' @export
#' @examples 
#' ## Example 1: Named vector ##
#' # Set up vector
#' v1 <- c("A", "B", "C", "B")
#' 
#' # Set up named vector for formatting
#' fmt1 <- c(A = "Vector Label A", B = "Vector Label B", C = "Vector Label C")
#' 
#' # Apply format to vector
#' fapply(fmt1, v1)
#' 
#' ## Example 2: User-defined format ##
#' # Define format
#' fmt2 <- value(condition(x == "A", "Format Label A"),
#'               condition(x == "B", "Format Label B"), 
#'               condition(TRUE, "Format Other"))
#'               
#' # Apply format to vector
#' fapply(fmt2, v1)
#' 
#' ## Example 3: Formatting function ##
#' # Set up vectorized function
#' fmt3 <- Vectorize(function(x) {
#' 
#'   if (x == "A")
#'     ret <- "Function Label A"
#'   else if (x == "B")
#'     ret <- "Function Label B"
#'   else
#'     ret <- "Function Other" 
#'     
#'   return(ret)
#' })
#' 
#' # Apply format to vector
#' fapply(fmt3, v1)
#' 
#' ## Example 4: Formatting List ##
#' # Set up data
#' # Notice each row has a different data type
#' v2 <- list(1.258, "H", as.Date("2020-06-19"),
#'            "L", as.Date("2020-04-24"), 2.8865)
#' v3 <- c("type1", "type2", "type3", "type2", "type3", "type1")
#' 
#' # Create formatting list
#' lst <- list()
#' lst$type1 <- function(x) format(x, digits = 2, nsmall = 1)
#' lst$type2 <- value(condition(x == "H", "High"),
#'                    condition(x == "L", "Low"),
#'                    condition(TRUE, "NA"))
#' lst$type3 <- function(x) format(x, format = "%y-%m")
#' 
#' # Apply formatting list to vector
#' fapply(lst, v2, v3)
fapply <- function(fmt, vect, lookup = NULL) {
  
  ret <- NULL

  if (is.vector(fmt) & is.list(fmt) == FALSE)
    ret <- fmt[vect] 
  else if (is.function(fmt))
    ret <- do.call(fmt, list(vect))
  else if (is.format(fmt)) 
    ret <- mapply(eval_conditions, vect, MoreArgs = list(conds = fmt))
  else if (is.list(fmt))
    ret <- flapply(fmt, vect, lookup)
  else 
    stop(paste0("format parameter must be a vector, function, ", 
         "user-defined format, or list."))
  

  return(ret)
  
}


#' @noRd
flapply <- function(lst, vect, lookup = NULL, return_list = TRUE) {

 print(lookup)  
  
 if (return_list == TRUE)
   ret <- list()
 else 
   ret <- c()
 
 fmts <- list()
 
 if (!is.null(lookup)) {
   
   fmts <- lst[lookup]
   
 } else {
   
   fmts <- rep(lst, length.out = length(vect))
 }
 
 for (i in seq_along(vect)) {
   ret[[i]] <- fapply(fmts[[i]], vect[[i]][1])
 }
 
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


