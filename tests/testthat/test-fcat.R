context("Format Catalog Tests")


test_that("fcat() function works as expected", {
  
  
  c1 <- fcat(lblA = value(condition(x == "A", "Label A"),
                          condition(x == "B", "Label B"),
                          condition(TRUE, "Other")),
             lblB = value(condition(x == "C", "Label C"),
                          condition(x == "D", "Label D"),
                          condition(TRUE, "Other"))
  )
  
  
  expect_equal(class(c1)[1], "fcat")
  expect_equal(length(c1), 2)
  expect_equal(names(c1)[1], "lblA")
  
})

test_that("as.data.frame.fcat() function works as expected", {
  
  
  c1 <- fcat(lblA = value(condition(x == "A", "Label A", order = 2),
                          condition(x == "B", "Label B", order = 1),
                          condition(TRUE, "Other", order = 3)),
             lblB = value(condition(x == "C", "Label C"),
                          condition(x == "D", "Label D"),
                          condition(TRUE, "Other")),
             lblC = "%d%b%Y",
             lblD = function(x) format(x, big.mark = ","),
             lblE = c(A = "Label A", B = "Label B")
  )
  

  dat <- as.data.frame(c1)
  
  
  expect_equal(nrow(dat), 9)
  expect_equal(dat[1, 1], "lblA")
  expect_equal(dat[4, 1], "lblB")
  expect_equal(dat[7, 1], "lblC")
  expect_equal(dat[7, 2], "S")
  
})

test_that("as.fcat.data.frame() function works as expected", {
  
  
  c1 <- fcat(lblA = value(condition(x == "A", "Label A", order = 2),
                          condition(x == "B", "Label B", order = 1),
                          condition(TRUE, "Other", order = 3)),
             lblB = value(condition(x == "C", "Label C"),
                          condition(x == "D", "Label D"),
                          condition(TRUE, "Other")),
             lblC = "%d%b%Y",
             lblD = function(x) format(x, big.mark = ","),
             lblE = c(A = "Label A", B = "Label B")
  )
  
  
  dat <- as.data.frame(c1)
  dat
  
  c2 <- as.fcat(dat)
  
  
  expect_equal(length(c2), 5)
  expect_equal(c2[["lblC"]], "%d%b%Y")
  expect_equal(fapply("B", c2$lblA), "Label B")
  expect_equal(fapply("B", c2$lblB), "Other")
  expect_equal(fapply(as.Date("2020-10-05"), c2$lblC), "05Oct2020")
  expect_equal(fapply(1000, c2$lblD), "1,000")
  expect_equal(fapply("B", c2$lblE), "Label B")
  
  
})


test_that("write.fcat and read.fcat functions work as expected.", {
  
  
  fp <- tempdir()
  
  c1 <- fcat(lblA = value(condition(x == "A", "Label A"),
                          condition(x == "B", "Label B"),
                          condition(TRUE, "Other")),
             lblB = value(condition(x == "C", "Label C"),
                          condition(x == "D", "Label D"),
                          condition(TRUE, "Other"))
  )
  
  pth <- write.fcat(c1, fp)
  
  c2 <- read.fcat(pth)
  
  dat <- as.data.frame(c2)

  
  expect_equal(nrow(dat), 6)
  expect_equal(dat[1, 1], "lblA")
  expect_equal(dat[4, 1], "lblB")
  
})

test_that("is.fcat function work as expected.", {
  
  c1 <- fcat(num_fmt  = "%.1f",
             label_fmt = value(condition(x == "A", "Label A"),
                               condition(x == "B", "Label B"),
                               condition(TRUE, "Other")),
             date_fmt = "%d%b%Y")
  
  
  expect_equal(is.fcat(c1), TRUE)
  
})

test_that("fcat can be used for formatting vectors.", {
  
  c1 <- fcat(num_fmt  = "%.1f",
             label_fmt = value(condition(x == "A", "Label A"),
                               condition(x == "B", "Label B"),
                               condition(TRUE, "Other")),
             date_fmt = "%d%b%Y")
  
  res <- c("Label A", "Label B", "Other")
  
  
  expect_equal(fapply(2, c1$num_fmt), "2.0")
  expect_equal(fapply(c("A", "B", "C"), c1$label_fmt), res)
  expect_equal(fapply(as.Date("2020-05-16"), c1$date_fmt), "16May2020")
  
})


test_that("fcat printing works as expected.", {
  
  c1 <- fcat(num_fmt  = "%.1f",
             label_fmt = value(condition(x == "A", "Label A"),
                               condition(x == "B", "Label B"),
                               condition(TRUE, "Other")),
             date_fmt = "%d%b%Y")
  
  expect_output(print(c1, verbose = TRUE))
  expect_output(print(c1))
  
})


test_that("fcat can be applied to a data frame with formats function.", {
  
  c1 <- fcat(AGE  = "%.1f",
             CATEGORY = value(condition(x == "A", "Label A"),
                               condition(x == "B", "Label B"),
                               condition(TRUE, "Other")),
             BDATE = "%d%b%Y")
  
  dat <- data.frame(NAME = c("Fred", "Sally", "Sven"),
                    AGE = c(25.356, 84.345, 56.346),
                    CATEGORY = c("A", "B", "C"),
                    BDATE = c(as.Date("1995-04-24"), 
                              as.Date("1940-02-11"), 
                              as.Date("1964-11-12")))
  
  formats(dat) <- c1
  
  fdat <- fdata(dat)
  
  expect_equal(fdat[1, "AGE"], "25.4")
  expect_equal(fdat[2, "CATEGORY"], "Label B")
  expect_equal(fdat[1, "AGE"], "25.4")
  
})



test_that("print.fcat works as expected.", {
  
  c1 <- fcat(AGE  = "%.1f",
             CATEGORY = value(condition(x == "A", "Label A"),
                              condition(x == "B", "Label B"),
                              condition(TRUE, "Other")),
             BDATE = "%d%b%Y")
  
  #print(c1)
  c1
  #print(c1, verbose = TRUE)
  
  expect_equal(TRUE, TRUE)
  
})


test_that("as.fcat.fmt_lst works as expected.", {
  
  f1 <- flist(AGE  = "%.1f",
             CATEGORY = value(condition(x == "A", "Label A"),
                              condition(x == "B", "Label B"),
                              condition(TRUE, "Other")),
             BDATE = "%d%b%Y")
  
  c1 <- as.fcat(f1)
  c1
  
  expect_equal(is.fcat(c1), TRUE)
  

})

test_that("as.fcat.list works as expected.", {
  
  l1 <- list(AGE  = "%.1f",
              CATEGORY = value(condition(x == "A", "Label A"),
                               condition(x == "B", "Label B"),
                               condition(TRUE, "Other")),
              BDATE = "%d%b%Y")
  
  c1 <- as.fcat(l1)
  c1
  
  expect_equal(is.fcat(c1), TRUE)
  
  
})


test_that("as.fcat.tbl_df works as expected.", {
  
  c1 <- fcat(AGE  = "%.1f",
             CATEGORY = value(condition(x == "A", "Label A"),
                              condition(x == "B", "Label B"),
                              condition(TRUE, "Other")),
             BDATE = "%d%b%Y")
  
  df <- as.data.frame(c1)
  
  tb <- tibble::as_tibble(df)
  
  c2 <- as.fcat(tb)
  c2
  
  expect_equal(is.fcat(c2), TRUE)
  
  
})

test_that("row_limit parameter works as expected", {
  
  
  c1 <- fcat(lblA = value(condition(x == "A", "Label A", order = 2),
                          condition(x == "B", "Label B", order = 1),
                          condition(TRUE, "Other", order = 3)),
             lblB = value(condition(x == "C", "Label C"),
                          condition(x == "D", "Label D"),
                          condition(TRUE, "Other")),
             lblC = "%d%b%Y",
             lblD = function(x) format(x, big.mark = ","),
             lblE = c(A = "Label A", B = "Label B")
  )
  
  if (FALSE) {
    print(c1)
    print(c1, row_limit = NULL)
    print(c1, row_limit = 3)
    print(c1, row_limit = 7)
  }

  expect_equal(TRUE, TRUE)
  
  
})


