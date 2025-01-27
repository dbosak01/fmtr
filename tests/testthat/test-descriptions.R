context("descriptions() function Tests")




test_that("descriptions() function works as expected.", {
  
  df1 <- mtcars[1:10, c("mpg", "cyl") ]
  
  df1
  # Assign formats
  descriptions(df1) <- list(mpg = "Miles per gallon", 
                             cyl = "Cylinders")

  
  # Extract format list
  lst <- descriptions(df1)
  
  expect_equal(length(lst), 2)
  
  # No error now
  descriptions(df1) <- list(mpd = "Hello")
  
  
  #str(df1) 
  
  descriptions(df1)
  
  descriptions(df1) <- NULL
  expect_equal(length(descriptions(df1)), 0)
  
  
})



test_that("descriptions() function verbose option works as expected.", {
  
  dat = mtcars
  
  expect_error(descriptions(dat, verbose = TRUE) <- list(mpg = "Hello", mpg = "Goodbye"))
  
  expect_message(descriptions(dat, verbose = TRUE) <- list(mpg = "Hello", amp = "Goodbye"))
  
  ## preliminary metadata copy-pasted from ?mtcars. Some mistakes present (see below)
  mtcars.metadata <-  c(mpg = "Miles/(US) gallon",
                        cyl = "Number of cylinders",
                        disp = "Displacement (cu.in.)",
                        hp = "Gross horsepower",
                        wt = "Rear axle ratio",
                        qseq = "1/4 mile time",
                        vs = "Engine (0 = V-shaped, 1 = straight)",
                        amp = "Transmission (0 = automatic, 1 = manual)",
                        gear = "Number of forward gears",
                        carb = "Number of carburetors")
  
  descriptions(dat, verbose = TRUE) <- as.list(mtcars.metadata)
  descriptions(dat)
  
  ## oops! We missed some descriptions. The feedback from 
  ## descriptions_verbose helps us see what happened:
  ## missed "drat" and mistyped "qsec" as "qsec". Looks like we put 
  ## the metadata for "drat" into the 
  ## "wt" column, so we need to overwrite that.
  descriptions(dat, verbose = TRUE) <- list(wt = "Weigh (100 lbs)",
                                            cyl = "Num f Cylin.",
                                    drat = "Rear axe ratio",
                                    qsec = "1/4 mie time",
                                    am = "Transmission (0 = automatic, 1 = manual)"
  )
  
  res <- descriptions(dat)
  
  
  expect_equal(length(res), 11)
  
})
