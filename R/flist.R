


flist <- function(..., type = "column", lookup = NULL, return_type = "vector") {
  
  if (!type %in% c("column", "row"))
    stop (paste("Invalid value for type parameter.", 
                "Value values are 'column' or 'row'"))
  
  if (!return_type %in% c("vector", "list"))
    stop (paste("Invalid value for return_type parameter.", 
                "Valid values are 'vector' or 'list'."))
  
  if (is.null(lookup) == FALSE & type == "column")
    stop (paste("Lookup parameter only allowed on type 'row'."))
  
  # Create new structure of class "fmt_lst"
  x <- structure(list(), class = c("fmt_lst"))
  
  x$formats <- list(...)
  x$type <- type
  x$lookup <- lookup
  x$return_type <- return_type
  
  
  return(x)
  
}


is.flist <- function(x) {
 
  if (any(class(x) == "fmt_lst"))
    ret <- TRUE
  else
    ret <- FALSE
  
  return(ret)
}


# Testing -----------------------------------------------------------------
# 
# # Simple use case
# id <- 100:109
# col1 <- sample(rep(c("A", "B", "C"), 5), 10)
# col2 <- sample(seq(0, 100, by = .001), 10)
# 
# 
# df <- data.frame(id, col1, col2)
# df
# 
# 
# col1_fmt <- c(A = "Placebo", B = "Drug", C = "Other")
# col2_fmt <- Vectorize(function(x) if (x > 88) "High" else if (x < 12) "Low" else x)
#   
# 
# 
# 
# formats(df) <- list(col1 = col1_fmt, col2 = col2_fmt)
# formats(df)
# 
# format(df)
# 
# col1_fmt2 <- function(x) format(x, justify = "left") 
# col2_fmt2 <- function(x) format(x, justify = "left")
# 
# col1_flist <- flist(col1_fmt, col1_fmt2)
# col2_flist <- flist(col2_fmt, col2_fmt2)
# 
# is.flist(col1_fmt)
# 
# formats(df) <- list(col1_flist, col2_flist)
# 
# col1_flist


