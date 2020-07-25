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




test_that("format() function works as expected with list of formats.", {

  
  v1 <- c("type1", "type2", "type3", "type2", "type3", "type1")
  v2 <- list(1.258, "H", as.Date("2020-06-19"),
             "L", as.Date("2020-04-24"), 2.8865)
  
  df <- data.frame(type = v1, values = I(v2))
  df
  
  lst <- flist(type  = "row", lookup = v1,
               type1 = "%.1f",
               type2 = value(condition(x == "H", "High"),
                              condition(x == "L", "Low"),
                              condition(TRUE, "NA")),
               type3 = "%y-%m")
  
  
  attr(df$values, "format") <- lst
  df$values
  
  ret <- format_data(df)
  ret
  
  
  expect_equal(ret[[1, 2]], "1.3")
  expect_equal(ret[[2, 2]], "High")
  expect_equal(ret[[3, 2]], "20-06")

})





