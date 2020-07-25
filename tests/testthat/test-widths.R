context("widths() function Tests")


test_that("widths() function works as expected.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  
  # Assign widths
  widths(df1) <-   list(mpg = 12, 
                        cyl = 10)
  
  
  # Extract format list
  lst <- widths(df1)
  
  expect_equal(length(lst), 2)
  
  
  format(df1) 
  
  
})

