context("justification() function Tests")




test_that("justification() function works as expected.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  # Assign formats
  justification(df1) <- list(mpg = "right", 
                             cyl = "center")
  widths(df1) <-   list(mpg = 12, 
                   cyl = 10)
  
  # Extract format list
  lst <- justification(df1)
  
  expect_equal(length(lst), 2)
  
  
  expect_error(justification(df1) <- list(mpd = "right"))
  
  
  format(df1) 
  
})
