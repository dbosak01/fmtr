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
#' @param vect A vector to apply the format to.
#' @param format A format to be applied.
#' @param width The desired character width of the formatted vector.  Default
#' value is NULL, meaning the vector will be variable width.
#' @param justify Whether to justify the return vector.  Valid values are 
#' 'left', 'right', 'center', 'centre', or 'none'. 
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
fapply <- function(vect, format = NULL, width = NULL, justify = NULL) {
  
  ret <- NULL
  
  # Get attribute value if available
  if (is.null(format) & is.null(attr(vect, "format")) == FALSE) 
    format <- attr(vect, "format")
    
  if (is.null(width) & is.null(attr(vect, "width")) == FALSE)
    width <- attr(vect, "width")
  
  if (is.null(justify) & is.null(attr(vect, "justify")) == FALSE)
    justify <- attr(vect, "justify")
  
  
  if (is.vector(format) & is.list(format) == FALSE) {
   
    if (length(format) == 1)
      ret <- format_vector(vect, format)
    else
      ret <- format[vect] 
    
  }
  else if (is.function(format))
    ret <- do.call(format, list(vect))
  else if (is.format(format)) 
    ret <- mapply(eval_conditions, vect, MoreArgs = list(conds = format))
  else if (is.flist(format))
    if (fmt$type == "row")
      ret <- flist_row_apply(format, vect, lookup)
    else 
      ret <- flist_column_apply(format, vect)
  else if (is.null(format))
      ret <- vect
  else 
    stop(paste0("format parameter must be a vector, function, ", 
                "user-defined format, or list."))
  

  ret <- justify_vector(ret, width, justify)
  
  return(ret)
  
}


format_vector <- function(x, fmt) {
 
  if (any(class(x) %in% c("Date", "POSIXt")))
    ret <- format(x, format = fmt)
  else if (any(class(x) %in% c("numeric", "character", "integer"))) {
    
   ret <- sprintf(fmt, x)
   
  }
  
  return(ret)
  
}

#' @noRd
justify_vector <- function(x, width = NULL, justify = NULL) {
  
  
  if (is.null(width) & is.null(justify)) {
    
    ret <- x
    
  } else {
    
    jst <- justify
    if (is.null(justify) == FALSE) {
      if (justify == "center")
        jst <- "centre"
    }

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

#' @noRd
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


# Format attributes -------------------------------------------------------



fattr <- function(x, format = NULL, width = NULL, justify = NULL) {
  
  attr(x, "format") <- format
  attr(x, "width") <- width
  attr(x, "justify") <- justify
  
  return(x)
  
}

"fattr<-" <- function(x, value) {
  
  attr(x, "format") <- value[["format"]]
  attr(x, "width") <- value[["width"]]
  attr(x, "justify") <- value[["justify"]]
  
  return(x)
  
}

# Testing -----------------------------------------------------------------



t <- c("A", "B", "B", "UNK", "A")
n <- c(1L, 2L, 3L, 10L, 11838L)
f <- c(1.2, 2, 3.3577, 10.39488, 11838.3)
d <- c("2020-05-02", "2020-08", "2020-10-17")
d <- as.Date(d)
d
l <- c(A = "Var A", B = "Var B", UNK = "Unknown")


fapply(t, width = 10)
fapply(n, width = 10)
fapply(f, width = 10)
fapply(d, width = 15)  


fapply(t, justify = "right")
fapply(n, justify = "center")
fapply(f, justify = "left")
fapply(d, justify = "center")


fapply(t, width = 10, justify = "right")
fapply(n, width = 10, justify = "center")
fapply(f, width = 10, justify = "left")
fapply(d, width = 15, justify = "left")


fapply(t, fmt = "My Stuff: %s")
fapply(n, fmt = "%+6d")
fapply(f, fmt = "%6.1f%%")
fapply(d, fmt = "%d%b%Y")

fapply(t, width = 10, justify = "right", fmt = "My Stuff: %s")
fapply(n, width = 10, justify = "center", fmt = "%+d")
fapply(f, width = 10, justify = "left", fmt = "%.1f%%")
fapply(d, width = 15, justify = "right", fmt = "%d%b%Y")

t1 <- fattr(t, "My stuff: %s", width = 10, justify = "right")
fapply(t1)

fapply(c(4, 3, 2, 1.2))
fapply(c("My", "Crazy", "Testing"))
fapply(as.Date(c("2020-06-21", "2020-09-18", NA)), width = 15, format = "%d%b%Y")
