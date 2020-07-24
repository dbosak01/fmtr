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
fapply <- function(fmt, vect) {
  
  ret <- NULL
  
  if (is.vector(fmt) & is.list(fmt) == FALSE)
    ret <- fmt[vect] 
  else if (is.function(fmt))
    ret <- do.call(fmt, list(vect))
  else if (is.format(fmt)) 
    ret <- mapply(eval_conditions, vect, MoreArgs = list(conds = fmt))
  else if (is.flist(fmt))
    if (fmt$type == "row")
      ret <- flist_row_apply(fmt, vect, lookup)
    else 
      ret <- flist_column_apply(fmt, vect)
  else 
    stop(paste0("format parameter must be a vector, function, ", 
                "user-defined format, or list."))
  
  
  return(ret)
  
}


#' @noRd
flist_row_apply <- function(lst, vect) {
  
  print(lookup)  
  
  if (lst$return_type == "list")
    ret <- list()
  else 
    ret <- c()
  
  fmts <- list()
  
  if (!is.null(lst$lookup)) {
    
    fmts <- lst[lst$lookup]
    
  } else {
    
    
    fmts <- rep(lst, length.out = length(vect))
  }
  
  for (i in seq_along(vect)) {
    ret[[i]] <- fapply(fmts[[i]], vect[[i]][1])
  }
  
  return(ret)
  
}

flist_column_apply <- function(lst, vect) {
  
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


