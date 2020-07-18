context("Format Tests")


test_that("create_format() function sets class and levels as expected", {
  
  
  res <- c("Label A", "Label B", "Other")
  
  
  fmt1 <- create_format(condition(x == "A", "Label A"),
                        condition(x == "B", "Label B"), 
                        condition(TRUE, "Other"))
  
  
  expect_equal(class(fmt1), "fmt")
  expect_equal(levels(fmt1), res)
  
})



test_that("create_format() function works as expected.", {
  
  
  res <- c("Label A", "Label B", "Other", "Label B")
  
  v1 <- c("A", "B", "C", "B")
  
  fmt1 <- create_format(condition(x == "A", "Label A"),
                        condition(x == "B", "Label B"), 
                        condition(TRUE, "Other"))
  
  
  a1 <- apply_format(fmt1, v1)
  expect_equal(a1, res)
  
  
  v2 <- c(1, 2, 3, 2)
  
  fmt2 <- create_format(condition(x == 1, "Label A"),
                        condition(x == 2, "Label B"), 
                        condition(TRUE, "Other"))
  
  
  a2 <- apply_format(fmt2, v2)
  expect_equal(a2, res)
  
  
  fmt3 <- create_format(condition(x <= 1, "Label A"),
                        condition(x > 1 & x <= 2, "Label B"), 
                        condition(TRUE, "Other"))
  
  
  a3 <- apply_format(fmt3, v2)
  expect_equal(a3, res)
  
  
  fmt4 <- create_format(condition(x == "A", 1),
                        condition(x == "B", 2),
                        condition(TRUE, 3))
  
  a4 <- apply_format(fmt4, v1)
  expect_equal(a4, c(1, 2, 3, 2))
  
  
})

test_that("labels() function works as expected", {
  
  
  res <- c("Label A", "Label B", "Other")
  
  
  fmt1 <- create_format(condition(x == "A", "Label A"),
                        condition(x == "B", "Label B"), 
                        condition(TRUE, "Other"))
  
  
  lbls <- labels(fmt1)

  expect_equal(lbls, res)
  
})





