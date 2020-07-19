context("format Tests")



test_that("format() function works as expected with named vector.", {
  
  res <- c(A = "Label A", B = "Label B", C = "Other", B = "Label B")
  
  fb <- data.frame(id = 100:103, 
                   catc = c("A", "B", "C", "B"), 
                   catn = c(1, 2, 3, 2)) 
  
  
  attr(fb$catc, "format") <- c(A = "Label A", B = "Label B", C = "Other")

  
  fmt_fb <- format(fb)
  
  
  expect_equal(all(fmt_fb$catc == res), TRUE)
  

})



test_that("format() function works as expected with fmt object.", {
  
  res <- c("Label A", "Label B", "Other", "Label B")
  
  fb <- data.frame(id = 100:103, 
               catc = c("A", "B", "C", "B"), 
               catn = c(1, 2, 3, 2)) 
  
  
  attr(fb$catc, "format") <- 
    value(condition(x == "A", "Label A"),
          condition(x == "B", "Label B"),
          condition(TRUE, "Other"))

  fmt_fb <- format(fb)
  
  expect_equal(all(fmt_fb$catc == res), TRUE)
  
})



test_that("format() function works as expected with vectorized function.", {
  
  res <- c("Label A", "Label B", "Other", "Label B")
  
  fb <- data.frame(id = 100:103, 
               catc = c("A", "B", "C", "B"), 
               catn = c(1, 2, 3, 2)) 
  
  attr(fb$catc, "format") <- Vectorize(function(x) {
    
    if (x == "A") 
      ret <- "Label A"
    else if (x == "B")
      ret <- "Label B"
    else 
      ret <- "Other"
    
    return(ret)
    
  })
  
  
  fmt_fb <- format(fb)

  
  expect_equal(all(fmt_fb$catc == res), TRUE)
  
  
})


# 
# test_that("format.fbl() function works as expected with list of formats.", {
#   
#   res <- c("Label A", "Label B", "Other", "Label B")
#   
#   df <- data.frame(id = 100:103, 
#                    catc = c("A", "B", "C", "B"), 
#                    catn = c(1, 2, 3, 2)) 
#   
#   
#   vect_decode <- c(A = "Label A", B = "Label B")
#   
#   
#   
#   fmt_decode <- create_format(condition(x == "A", "Label A"),
#                               condition(x == "B", "Label B"),
#                               condition(TRUE, "Other"))
#   
#   fmt_function <- Vectorize(function(x) {
#     
#     if (x == "A") 
#       ret <- "Label A"
#     else if (x == "B")
#       ret <- "Label B"
#     else 
#       ret <- "Other"
#     
#     return(ret)
#     
#   })
#   
#   
# })
