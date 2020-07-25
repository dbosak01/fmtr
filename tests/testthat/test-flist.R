context("flist Tests")


test_that("flist() function works as expected.", {
 
  fl <- flist(f1 = "%.1f",
              f2 = "%d%b%Y",
              type = "row",
              lookup = c(1, 2),
              return_type = "list")
  
  fl
  
  expect_equal(fl$formats$f1, "%.1f")
  expect_equal(fl$formats$f2, "%d%b%Y")
  expect_equal(fl$type, "row")
  expect_equal(fl$return_type, "list")
  expect_equal(class(fl), "fmt_lst")
  
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
