context("Fibble Tests")

test_that("fibble() function works as expected.", {
  
  
  f1 <- fibble(mtcars)
  
  
  expect_equal(nrow(f1), 32)
  
})
