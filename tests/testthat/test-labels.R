context("labels() function Tests")


test_that("labels() function works as expected for data frames.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  
  # Assign widths
  labels(df1) <- list(mpg = "Miles Per Gallon", 
                      cyl = "Cylinders")

  
  # Extract format list
  lst <- labels.data.frame(df1)
  
  expect_equal(length(lst), 2)
  expect_equal(lst, list(mpg = "Miles Per Gallon", cyl = "Cylinders"))
  
  
  labels(df1)
  
  labels(df1) <- NULL
  expect_equal(length(labels(df1)), 0)
  
})


test_that("labels() function works as expected for tibbles.", {
  
  df1 <- as_tibble(mtcars[1:10, c("mpg", "cyl") ])
  
  df1
  
  # Assign widths
  labels(df1) <- list(mpg = "Miles Per Gallon", 
                      cyl = "Cylinders")
  
  
  # Extract format list
  lst <- labels(df1)
  
  expect_equal(length(lst), 2)
  expect_equal(lst, list(mpg = "Miles Per Gallon", cyl = "Cylinders"))
  

})


test_that("labels() parameter checks work as expected.", {
  
  s <- "hello"
  
  expect_error(labels(s) <- list(a = "One"))
  
  dat <- mtcars
  
  names(dat) <- NULL
  
  # No error generated now
  labels(dat) <- list(a = "One")
  
  
})
