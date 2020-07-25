context("formats() function Tests")




test_that("formats() function works as expected.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  # Assign formats
  formats(df1) <- list(mpg = "%.0f", 
                       cyl = "%.1f")
  
  
  # Extract format list
  lst <- formats(df1)
  
  expect_equal(length(lst), 2)
  

  format(df1) 
  
  
})

