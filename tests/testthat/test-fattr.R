context("fattr() function Tests")



test_that("fattr() function works as expected as function.", {
  
  
  a <- c(1.336, 2.526, 3.825)
  
  a <- fattr(a, format = "%.1f", width = 10, justify = "left")

  a
  
  expect_equal(attr(a, "format"), "%.1f")
  expect_equal(attr(a, "width"), 10)
  expect_equal(attr(a, "justify"), "left")
  expect_equal(length(attributes(a)), 3)
  

})



test_that("fattr() function works as expected as assignment.", {
  
  
  a <- c(1.3, 2.5, 3.8)
  
  fattr(a) <- list(format = "%.1f", width = 10, justify = "left")
  
  a
  
  expect_equal(attr(a, "format"), "%.1f")
  expect_equal(attr(a, "width"), 10)
  expect_equal(attr(a, "justify"), "left")
  expect_equal(length(attributes(a)), 3)
  
})



test_that("fattr() function parameter checks work as expected.", {
  
  
  a <- c(1.3, 2.5, 3.8)
  

  expect_error(fattr(a, width = "10"))
  
  expect_error(fattr(a, width = -2))
  
  expect_error(fattr(a, format = 39))
  
  expect_error(fattr(a, justify = "test"))

  
})


test_that("fattr() assignment parameter checks work as expected.", {
  
  
  a <- c(1.3, 2.5, 3.8)
  
  
  expect_error(fattr(a) <- list(width = "10"))
  
  expect_error(fattr(a) <- list(width = -2))
  
  expect_error(fattr(a) <- list(format = 39))
  
  expect_error(fattr(a) <- list(justify = "test"))
  
  
})



