## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Set up data frame
#  df <- mtcars[1:10, c("mpg", "cyl")]
#  df
#  
#  # Define and assign formats
#  attr(df$mpg, "format") <- value(condition(x >= 20, "High"),
#                                  condition(x < 20, "Low"))
#  
#  attr(df$cyl, "format") <- function(x) format(x, nsmall = 1)
#  
#  # Apply formatting
#  fdata(df)
#  

