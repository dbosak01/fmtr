
# Format Definition -------------------------------------------------------



create_format <- function(...) {
  
  x <- structure(list(...), class = c("fmt"))    
  
  attr(x, "levels") <- labels(x)

  return(x)

}


condition <- function(expr, label) {
  
  y <- structure(list(), class = c("fmt_cnd"))    
  
  y$expression <- substitute(expr)
  y$label <- label
  
  return(y)
  
}
  

# Utilities ---------------------------------------------------------------

labels.fmt <- function(x) {
  
  ret <- NULL
  
  for (i in seq_along(x)) {
    
    ret[length(ret) + 1] <- x[[i]][["label"]]
    
  }
  
  return(ret)
  
}


is.format <- function(x) {
 
  ret <- FALSE
  if (class(x) == "fmt")
    ret <- TRUE
  
  return(ret)
}

# Format Application ------------------------------------------------------

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


apply_format <- function(fmt, vect) {
  
  
  ret <- NULL
  
  
  
  ret <- mapply(eval_conditions, vect, MoreArgs = list(conds = fmt))
  
  
  
  return(ret)
  
}



# Testing -----------------------------------------------------------------



# v1 <- c("A", "B", "C", "B")
# 
# fmt1 <- create_format(condition(x == "A", "Label A"),
#                       condition(x == "B", "Label B"),
#                       condition(TRUE, "Other"))
# 
# fmt1
# apply_format(fmt1, v1)

# 
# 
# 
# v2 <- c(1, 2, 3, 2)
# 
# fmt2 <- create_format(condition(x == 1, "Label A"),
#                       condition(x == 2, "Label B"), 
#                       condition(TRUE, "Other"))
# 
# 
# apply_format(fmt2, v2)
# 
# 
# fmt3 <- create_format(condition(x <= 1, "Label A"),
#                       condition(x > 1 & x <= 2, "Label B"), 
#                       condition(TRUE, "Other"))
# 
# 
# apply_format(fmt3, v2)
# 
# 
# fmt4 <- create_format(condition(x == "A", 1),
#                       condition(x == "B", 2),
#                       condition(TRUE, 3))
# 
# apply_format(fmt4, v1)


