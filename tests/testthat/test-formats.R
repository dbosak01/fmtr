context("formats() function Tests")




test_that("formats() function works as expected.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  # Assign formats
  formats(df1) <- list(mpg = "%.0f", 
                       cyl = "%.1f")
  
  
  # Extract format list
  lst <- formats(df1)
  
  expect_equal(length(lst), 2)
  
  # No error
  formats(df1) <- list(mpd = "%.1f")

  df1
  
  fdata(df1) 
  
  formats(df1)
  expect_equal(formats(df1)$mpg, "%.0f")
  
  formats(df1) <- NULL
  
  formats(df1)
  
  expect_equal(length(formats(df1)), 0)
  expect_equal(is.null(formats(df1)$mpg), TRUE)
  
})


test_that("formats can be applied from format catalog to entire data frame", {
  
  fmts <- fcat(AGECAT = value(condition(x >= 18 & x <= 24, "18 to 24"),
                              condition(x >= 25 & x <= 44, "25 to 44"),
                              condition(x >= 45 & x <= 64, "45 to 64"),
                              condition(x >= 65, ">= 65"),
                              condition(TRUE, "Other")),
               SEX = value(condition(is.na(x), "Missing"),
                           condition(x == "M", "Male"),
                           condition(x == "F", "Female"),
                           condition(TRUE, "Other")),
               VAR = c("AGE" = "Age", 
                       "AGECAT" = "Age Group", 
                       "SEX" = "Sex")) 
  
  # Create sample data frame
  dat <- read.table(header = TRUE, text = '
    SUBJECT  AGECAT SEX
    101       35      F
    102       19      F
    103       57      M
    ')
  
  formats(dat) <- fmts
  
  dat2 <- fdata(dat)
  
  
  expect_equal(dat2[1, "AGECAT"], "25 to 44")
  expect_equal(dat2[1, "SEX"], "Female")
  
})



test_that("formats(), fapply and fdata can deal with format.sas attribute.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  
  attr(df1$mpg, "format.sas") <- "something"
  
  # Assign formats
  expect_equal(length(formats(df1)), 0)
  
  v2 <- fapply(df1$mpg)
  
  expect_equal(v2[1] == "something", FALSE)
  
  
  df2 <- fdata(df1)
  
  expect_equal(df2$mpg[1] == "something", FALSE)

  
})


          
