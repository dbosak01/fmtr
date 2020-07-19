context("Format Tests")


test_that("value() function sets class and levels as expected", {
  
  
  res <- c("Label A", "Label B", "Other")
  
  
  fmt1 <- value(condition(x == "A", "Label A"),
                condition(x == "B", "Label B"), 
                condition(TRUE, "Other"))
  
  
  expect_equal(class(fmt1), "fmt")
  expect_equal(levels(fmt1), res)
  
})



test_that("a format object can be applied to a vector.", {
  
  
  res <- c(A = "Label A", B = "Label B", C = "Other", B = "Label B")
  
  v1 <- c("A", "B", "C", "B")
  
  fmt1 <- value(condition(x == "A", "Label A"),
                condition(x == "B", "Label B"), 
                condition(TRUE, "Other"))
  
  
  a1 <- fapply(fmt1, v1)
  expect_equal(all(a1 == res), TRUE)
  
  
  v2 <- c(1, 2, 3, 2)
  
  fmt2 <- value(condition(x == 1, "Label A"),
                condition(x == 2, "Label B"), 
                condition(TRUE, "Other"))
  
  
  a2 <- fapply(fmt2, v2)
  expect_equal(all(a2 == res), TRUE)
  
  
  fmt3 <- value(condition(x <= 1, "Label A"),
                condition(x > 1 & x <= 2, "Label B"), 
                condition(TRUE, "Other"))
  
  
  a3 <- fapply(fmt3, v2)
  expect_equal(all(a3 == res), TRUE)
  
  
  fmt4 <- value(condition(x == "A", 1),
                condition(x == "B", 2),
                condition(TRUE, 3))
  
  a4 <- fapply(fmt4, v1)
  expect_equal(all(a4 == c(1, 2, 3, 2)), TRUE)
  
  
})

test_that("labels() function works as expected", {
  
  
  res <- c("Label A", "Label B", "Other")
  
  
  fmt1 <- value(condition(x == "A", "Label A"),
                condition(x == "B", "Label B"), 
                condition(TRUE, "Other"))
  
  
  lbls <- labels(fmt1)

  expect_equal(lbls, res)
  
})





