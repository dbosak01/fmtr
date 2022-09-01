context("widths() function Tests")


test_that("utils1: log_output() function works as expected.", {


  res <- log_output()
  
  expect_equal(res, FALSE)
  
  
  options("logr.output" = TRUE)
  
  res <- log_output()
  
  expect_equal(res, TRUE)
  
  
  options("logr.output" = FALSE)
  
  res <- log_output()
  
  expect_equal(res, FALSE)
  
  
  
  options("logr.output" = NULL)
  
  res <- log_output()
  
  expect_equal(res, FALSE)
  
})
