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
  
  expect_error(formats(df1) <- list(mpd = "%.1f"))

  df1
  
  fdata(df1) 
  
  formats(df1)
  expect_equal(formats(df1)$mpg, "%.0f")
  
  formats(df1) <- NULL
  
  formats(df1)
  
  expect_equal(length(formats(df1)), 0)
  expect_equal(is.null(formats(df1)$mpg), TRUE)
  
})

