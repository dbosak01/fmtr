context("fibble Tests")

test_that("fibble() function works as expected.", {
  
  
  f1 <- fibble(mtcars)
  
  # Rows should not change
  expect_equal(nrow(f1), 32)
  
  # Class contains "fbl"
  expect_equal(any(class(f1), "fbl"))
  
})



test_that("as.fibble() function works as expected.", {
  
  
  f1 <- as.fibble(mtcars)
  
  # Rows should not change
  expect_equal(nrow(f1), 32)
  
  # Class contains "fbl"
  expect_equal(any(class(f1), "fbl"))

})


test_that("is.fibble() function works as expected", {
  
  f1 <- as.fibble(mtcars)

  expect_equal(is.fibble(f1), TRUE)

  expect_equal(is.fibble(mtcars), FALSE)

  expect_equal(is.fibble(c(1, 2, 3)), FALSE)
  
  
})


test_that("print.fbl) function works as expected without error.", {
  
  fb <- fibble(mtcars[1:5, ])
  
  ret <- print(fb)
  
  expect_equal(class(ret)[1], "fbl")
  
  
  
})


test_that("format.fbl() function works as expected with named vector.", {
  
  res <- c("Label A", "Label B", "Other", "Label B")
  
  fb <- fibble(id = 100:103, 
               catc = c("A", "B", "C", "B"), 
               catn = c(1, 2, 3, 2)) 
  
  # class(fb)
  
  vect_decode <- c(A = "Label A", B = "Label B")
  attr(fb, "format") <- vect_decode
  attributes(fb)
  
  fmt_fb <- format(fb)
  fmt_fb
  
  fmt_fb$catc
  res
  
  expect_equal(fmt_fb$catc, res)
  

})



test_that("format.fbl() function works as expected with fmt object.", {
  
  res <- c("Label A", "Label B", "Other", "Label B")
  
  fb <- fibble(id = 100:103, 
               catc = c("A", "B", "C", "B"), 
               catn = c(1, 2, 3, 2)) 
  
  
  fmt_decode <- create_format(condition(x == "A", "Label A"),
                              condition(x == "B", "Label B"),
                              condition(TRUE, "Other"))

  attr(fb, "format") <- fmt_decode
  
  
  fmt_fb <- format(fb)
  
  expect_equal(fmt_fb$catc, res)
  
})



test_that("format.fbl() function works as expected with vectorized function.", {
  
  res <- c("Label A", "Label B", "Other", "Label B")
  
  fb <- fibble(id = 100:103, 
               catc = c("A", "B", "C", "B"), 
               catn = c(1, 2, 3, 2)) 
  
  fmt_function <- Vectorize(function(x) {
    
    if (x == "A") 
      ret <- "Label A"
    else if (x == "B")
      ret <- "Label B"
    else 
      ret <- "Other"
    
    return(ret)
    
  })
  
  
  attr(fb, "format") <- fmt_decode
  
  
  fmt_fb <- format(fb)
  
  expect_equal(fmt_fb$catc, res)
  
  
})



test_that("format.fbl() function works as expected with list of formats.", {
  
  res <- c("Label A", "Label B", "Other", "Label B")
  
  df <- data.frame(id = 100:103, 
                   catc = c("A", "B", "C", "B"), 
                   catn = c(1, 2, 3, 2)) 
  
  
  vect_decode <- c(A = "Label A", B = "Label B")
  
  
  
  fmt_decode <- create_format(condition(x == "A", "Label A"),
                              condition(x == "B", "Label B"),
                              condition(TRUE, "Other"))
  
  fmt_function <- Vectorize(function(x) {
    
    if (x == "A") 
      ret <- "Label A"
    else if (x == "B")
      ret <- "Label B"
    else 
      ret <- "Other"
    
    return(ret)
    
  })
  
  
})
