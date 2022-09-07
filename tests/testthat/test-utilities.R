context("utilities Tests")

dev <- FALSE

test_that("utils1: log_output() function works as expected.", {

  if (dev) {
    res <- log_output()
    
    expect_equal(res, TRUE)
    
    
    options("logr.output" = TRUE)
    
    res <- log_output()
    
    expect_equal(res, TRUE)
    
    
    options("logr.output" = FALSE)
    
    res <- log_output()
    
    expect_equal(res, FALSE)
    
    
    
    options("logr.output" = NULL)
    
    res <- log_output()
    
    expect_equal(res, TRUE)
  
  } else {
    
    res <- log_output()
    
    expect_equal(res, FALSE)
    
  }
  
})
