context("flist Tests")


test_that("flist() function works as expected.", {
 
  fl <- flist(f1 = "%.1f",
              f2 = "%d%b%Y",
              type = "row",
              lookup = c(1, 2),
              simplify = FALSE)
  
  fl
  
  expect_equal(fl$formats$f1, "%.1f")
  expect_equal(fl$formats$f2, "%d%b%Y")
  expect_equal(fl$type, "row")
  expect_equal(fl$simplify, FALSE)
  expect_equal("fmt_lst" %in% class(fl), TRUE)
  
})

test_that("flist works as expected for row type with lookup.", {
  
  # flist lookup
  a <- list("A", 1.263, "B", as.Date("2020-07-21"), 
            5.8732, as.Date("2020-10-17"))
  b <- c("f1", "f2", "f1", "f3", "f2", "f3")
  
  fl <- flist(f1 = c(A = "Label A", B = "Label B"),
              f2 = "%.1f",
              f3 = "%d%b%Y",
              type = "row",
              lookup = b)
  a <- fattr(a, format = fl)
  
  r <- fapply(a)
  r

  expect_equal(class(r), "character")
  expect_equal(length(r), 6)
  expect_equal(r[[1]], "Label A")
  expect_equal(r[[2]], "1.3")
  expect_equal(r[[4]], "21Jul2020")
  
})



test_that("flist works as expected for row type ordered,", {
  
  # flist type row
  a <- list("A", 1.263, as.Date("2020-07-21"), 
            "B", 5.8732, as.Date("2020-10-17"), 
            "B")
  fmt1 <- c(A = "Label A", B = "Label B")
  fmt2 <- "%.1f"
  fmt3 <- "%d%b%Y"
  
  fl <- flist(fmt1, fmt2, fmt3,
              type = "row")
  a <- fattr(a, format = fl)

  r <- fapply(a)
  r
  
  expect_equal(class(r), "character")
  
  res <- c("Label A", "1.3", "21Jul2020", "Label B", 
           "5.9", "17Oct2020", "Label B")
  expect_equal(r, res) 
  
  
})

test_that("flist works as expected for column type.", {
  
  
  # flist type col
  b <- c(1.2356, 8.345, 4.5422)
  
  fl2 <- flist(function(x) round(x, 2), "$%f", function(x) substr(x, 1, 5))
  b <- fattr(b, format = fl2)
  r <- fapply(b)
  r

  expect_equal(r, c("$1.24", "$8.35", "$4.54"))

})


test_that("flist works as expected for column type and simplify false.", {
  
  
  # flist type col
  b <- c(1.2356, 8.345, 4.5422)
  
  fl2 <- flist(function(x) round(x, 2), "$%f", 
               function(x) substr(x, 1, 5), simplify = FALSE)
  b <- fattr(b, format = fl2)
  r <- fapply(b)
  r
  
  expect_equal(r, list("$1.24", "$8.35", "$4.54"))
  
})


test_that("as.flist and is.flist work as expected.", {
  
  lst <- list("%d%b%Y", "%.1f")
  flst <- as.flist(lst)
  expect_equal(is.flist(flst), TRUE)
  expect_equal(is.flist("A"), FALSE)
  
})


test_that("as.data.frame.flist works as expected.", {
  
  
  fl2 <- flist(fmt1 = function(x) round(x, 2), 
               fmt2 = "$%f", 
               fmt3 = function(x) substr(x, 1, 5),
               fmt4 = value(condition(x == 1, "Label 1"),
                            condition(TRUE, "Label 2")))
  fl2
  dat <- as.data.frame(fl2)
  dat
  
  expect_equal(nrow(dat), 5)
  
})

test_that("another test for as.data.frame.flist works as expected.", {
  
  df <- read.table(header = TRUE, text = '
       Name Type Expression Label Order
        ALB    S       %.1f   NA      NA
        ALP    S       %.0f   NA      NA
        ALT    S       %.0f   NA      NA
        AST    S       %.0f   NA      NA
       BASO    S       %.2f   NA      NA
       BILI    S       %.1f   NA      NA
        BUN    S       %.0f   NA      NA')
  
  fl <- as.flist(df)
  
  expect_equal("fmt_lst" %in% class(fl), TRUE)
  expect_equal(length(fl$formats), 7) 
  
  
})

test_that("as.data.frame.flist works as expected with no names.", {
  
  
  # flist type col
  
  fl2 <- flist(function(x) round(x, 2), 
               "$%f", 
               function(x) substr(x, 1, 5),
               value(condition(x == 1, "Label 1"),
                            condition(TRUE, "Label 2")))
  fl2
  dat <- as.data.frame(fl2)
  dat
  
  expect_equal(nrow(dat), 5)
  
})



test_that("as.fcat.fmt_lst() works as expected.", {
  
  # flist lookup
  a <- list("A", 1.263, "B", as.Date("2020-07-21"), 
            5.8732, as.Date("2020-10-17"))
  b <- c("f1", "f2", "f1", "f3", "f2", "f3")
  
  fl <- flist(f1 = c(A = "Label A", B = "Label B"),
              f2 = "%.1f",
              f3 = "%d%b%Y",
              type = "row",
              lookup = b)
  
  expect_equal("fmt_lst" %in% class(fl), TRUE)
  
  ct <- as.fcat.fmt_lst(fl)
  
  expect_equal("fmt_lst" %in% class(ct), FALSE)
  expect_equal("fcat" %in% class(ct), TRUE)
  
  fl2 <- as.flist(ct, type = "row", lookup = b)
  
  expect_equal("fmt_lst" %in% class(fl2), TRUE)
  expect_equal("fcat" %in% class(fl2), FALSE)
  

  r <- fapply(a, fl2)
  r
  
  expect_equal(class(r), "character")
  expect_equal(length(r), 6)
  expect_equal(r[[1]], "Label A")
  expect_equal(r[[2]], "1.3")
  expect_equal(r[[4]], "21Jul2020")
  
})

