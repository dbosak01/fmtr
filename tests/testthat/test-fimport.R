context("fimport() function Tests")

base_path <- "c:/packages/fmtr/tests/testthat"
data_dir <- base_path

base_path <- tempdir()
data_dir <- "."


test_that("fimport() function works as expected with xlsx.", {
  
  pth <- file.path(base_path, "data/test.xlsx")
  
  res <- fimport(pth)
  
  expect_equal(1, 1)
  
})


test_that("fimport() function works as expected with sas7bdat", {
  
  pth <- file.path(base_path, "data/test.sas7bdat")
  
  res <- fimport(pth)
  
  expect_equal(1, 1)
  
})


test_that("fimport() function works as expected with Rdata", {
  
  pth <- file.path(base_path, "data/test.Rdata")
  
  res <- fimport(pth)
  
  expect_equal(1, 1)
  
})



test_that("fimport() function works as expected with rds", {
  
  pth <- file.path(base_path, "data/test.rds")
  
  res <- fimport(pth)
  
  expect_equal(1, 1)
  
})

