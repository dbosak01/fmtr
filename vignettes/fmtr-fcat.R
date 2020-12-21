## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Create format catalog
#  c1 <- fcat(num_fmt  = "%.1f",
#             label_fmt = value(condition(x == "A", "Label A"),
#                               condition(x == "B", "Label B"),
#                               condition(TRUE, "Other")),
#             date_fmt = "%d%b%Y")
#  
#  # Use formats in the catalog
#  fapply(2, c1$num_fmt)
#  fapply(c("A", "B", "C", "B"), c1$label_fmt)
#  fapply(Sys.Date(), c1$date_fmt)
#  
#  # Convert to a data frame
#  dat <- as.data.frame(c1)
#  dat
#  
#  # Save format catalog for later use
#  write.fcat(c1, tempdir())
#  

