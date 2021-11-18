context("justification() function Tests")




test_that("justification() function works as expected.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  # Assign formats
  justification(df1) <- list(mpg = "right", 
                             cyl = "center")
  
  # Extract format list
  lst <- justification(df1)
  
  expect_equal(length(lst), 2)
  
  # No error now
  justification(df1) <- list(mpd = "right")
  
  
  justification(df1)
  
  justification(df1) <- NULL
  expect_equal(length(justification(df1)), 0)
  
})
