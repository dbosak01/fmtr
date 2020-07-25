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
  
  # Get attribute values if available
  if (is.null(format) & is.null(attr(vect, "format")) == FALSE) 
    format <- attr(vect, "format")
  if (is.null(width) & is.null(attr(vect, "width")) == FALSE)
    width <- attr(vect, "width")
  if (is.null(justify) & is.null(attr(vect, "justify")) == FALSE)
    justify <- attr(vect, "justify")
  
  # Perform different operations depending on type of format
  if (is.vector(format) & is.list(format) == FALSE) {
   
    if (length(format) == 1)
      ret <- format_vector(vect, format)
    else {
      ret <- format[vect] 
      names(ret) <- NULL
    }
    
  }
  else if (is.function(format))
    ret <- do.call(format, list(vect))
  else if (is.format(format)) 
    ret <- mapply(eval_conditions, vect, MoreArgs = list(conds = format))
  else if (is.flist(format)) {
    print("Process Flist")
    if (format$type == "row")
      ret <- flist_row_apply(format, vect)
    else 
      ret <- flist_column_apply(format, vect)
  } else if (is.null(format))
      ret <- vect
  else 
    stop(paste0("format parameter must be a vector, function, ", 
                "user-defined format, or list."))
  
  
  ret <- justify_vector(ret, width, justify)
  
  return(ret)
  
}


format_vector <- function(x, fmt) {
 
  print(paste("Vector:", x))
  print(paste("Format:", fmt))
  print(paste("Class:", class(x)))
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
    
    
    print("Sammy")
    
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
  
  print("Here1")
  
  ret <- c()
  
  print(paste("Ret:", class(ret)))
  
  fmts <- list()
  
  if (!is.null(lst$lookup)) {
    
    print("Here2")
    fmts <- lst$formats[lst$lookup]
    print(fmts)
    
  } else {
    
    print("Here2a")
    fmts <- rep(lst$formats, length.out = length(vect))
    print(fmts)
  }
  
  print("Here3")
  for (i in seq_along(vect)) {
    ret[[i]] <- fapply(vect[[i]][1], fmts[[i]])
  }
  
  if (lst$return_type == "vector")
    ret <- unlist(ret)
  
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
    print(fmts)
    
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


# flist lookup
a <- list("A", 1.263, "B", as.Date("2020-07-21"), 5.8732, as.Date("2020-10-17"))
b <- c("f1", "f2", "f1", "f3", "f2", "f3")

fl <- flist(f1 = c(A = "Label A", B = "Label B"),
            f2 = "%.1f",
            f3 = "%d%b%Y",
            type = "row",
            lookup = b)
a <- fattr(a, format = fl)

fl

r <- fapply(a)
r
class(r)


# flist type row
a <- list("A", 1.263, as.Date("2020-07-21"), "B", 5.8732, as.Date("2020-10-17"))
fmt1 <- c(A = "Label A", B = "Label B")
fmt2 <- "%.1f"
fmt3 <- "%d%b%Y"
  
fl <- flist(fmt1, fmt2, fmt3,
            type = "row")
a <- fattr(a, format = fl)

fl

r <- fapply(a,  justify = "right")
r
class(r)



# flist type col
b <- c(1.2356, 8.345, 4.5422)

fl2 <- flist(function(x) round(x, 2), "$%f")
b <- fattr(b, format = fl2)
fapply(b)

