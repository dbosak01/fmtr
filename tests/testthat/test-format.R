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

test_that("formats() function works as expected.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]


  # Assign formats
  attr(df1$mpg, "format") <- value(condition(x >= 20, "High"),
                                   condition(x < 20, "Low"))
  attr(df1$cyl, "format") <- function(x) format(x, nsmall = 1)


  # Extract format list
  lst <- formats(df1)
  
  expect_equal(length(lst), 2)

  # Alter format list and reassign
  lst$mpg <- value(condition(x >= 22, "High"),
                   condition(x < 22, "Low"))
  lst$cyl <- function(x) format(x, nsmall = 2)
  formats(df1) <-  lst
  
  
})



test_that("format() function works as expected with list of formats.", {

  
  v1 <- c("type1", "type2", "type3", "type2", "type3", "type1")
  v2 <- list(1.258, "H", as.Date("2020-06-19"),
             "L", as.Date("2020-04-24"), 2.8865)
  
  df <- data.frame(type = v1, values = I(v2))
  
  
  lst <- list()
  lst$type1 <- function(x) format(x, digits = 2, nsmall = 1)
  lst$type2 <- value(condition(x == "H", "High"),
                     condition(x == "L", "Low"),
                     condition(TRUE, "NA"))
  lst$type3 <- function(x) format(x, format = "%y-%m")
  
  
  attr(df$values, "format") <- lst
  attr(df$values, "format_lookup") <- "type"
  
  format_dataframe(df)
  
  lst2 <- list()
  lst2[[1]] <- lst$type1
  lst2[[2]] <- lst$type2
  lst2[[3]] <- lst$type3
  lst2[[4]] <- lst$type2
  lst2[[5]] <- lst$type3
  lst2[[6]] <- lst$type1
  
  
  attr(df$values, "format") <- lst2
  attr(df$values, "format_lookup") <- NULL
  
  format_dataframe(df)


})





