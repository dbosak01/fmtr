## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  v1 <- c("A", "B", "C", "B")
#  v1
#  
#  # [1] "A" "B" "C" "B"
#  
#  fmt1 <- value(condition(x == "A", "Label A"),
#                condition(x == "B", "Label B"),
#                condition(TRUE, "Other"))
#  
#  fapply(v1, fmt1)
#  
#  # "Label A" "Label B"   "Other" "Label B"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  v1 <- c(1.367, 8.356, 4.583, 2.873)
#  
#  fapply(v1, "%.1f%%")
#  
#  [1] "1.4%" "8.4%" "4.6%" "2.9%"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  v1 <- c("A", "B", "C", "B")
#  
#  fmt1 <- c(A = "Label A", B = "Label B", C= "Label C")
#  
#  fapply(v1, fmt1)
#  
#  # "Label A" "Label B" "Label C" "Label B"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  v1 <- c("A", "B", NA, "C")
#  
#  fmt2 <- value(condition(is.na(x), "Missing"),
#                condition(x == "A", "Label A"),
#                condition(x == "B", "Label B"),
#                condition(TRUE, "Other"))
#  
#  fapply(v1, fmt2)
#  
#  # "Label A" "Label B"   "Missing" "Other"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  v2 <- c(18.3987, 15.45852, 8.9835, 11.246246, 25.3858, NA)
#  
#  fmt3 <- value(condition(is.na(x), "Missing"),
#                condition(x < 10, "Low"),
#                condition(x > 20, "High"),
#                condition(TRUE, "%.2f"))
#  
#  fapply(v2, fmt3)
#  
#  # [1] "18.40"   "15.46"   "Low"     "11.25"   "High"    "Missing"

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  v1 <- c("A", "B", NA, "C")
#  
#  fmt2 <- Vectorize(function(x) {
#  
#      if (is.na(x))
#        ret <- "Missing"
#      else if (x %in% c("A", "B"))
#        ret <- paste("Label", x)
#      else
#        ret <- "Other"
#  
#      return(ret)
#  
#    })
#  
#  fapply(v1, fmt2)
#  
#  # "Label A" "Label B"   "Missing" "Other"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Set up data
#  v1 <- c("num", "char", "date", "char", "date", "num")
#  v2 <- list(1.258, "H", as.Date("2020-06-19"),
#             "L", as.Date("2020-04-24"), 2.8865)
#  
#  df <- data.frame(type = v1, values = I(v2))
#  df
#  
#  #    type     values
#  # 1   num      1.258
#  # 2  char          H
#  # 3  date 2020-06-19
#  # 4  char          L
#  # 5  date 2020-04-24
#  # 6   num     2.8865
#  
#  # Set up formatting list
#  lst <- flist(type = "row", lookup = v1,
#               num = "%.1f",
#               char = value(condition(x == "H", "High"),
#                            condition(x == "L", "Low"),
#                            condition(TRUE, "NA")),
#               date = "%y-%m")
#  
#  # Assign formatting list to values column
#  attr(df$values, "format") <- lst
#  
#  
#  # Apply formatting
#  fdata(df)
#  
#  #   type values
#  # 1  num    1.3
#  # 2 char   High
#  # 3 date  20-06
#  # 4 char    Low
#  # 5 date  20-04
#  # 6  num    2.9
#  
#  

