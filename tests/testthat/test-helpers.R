context("Helper Function Tests")



test_that("fmt_range() function works as expected.", {
  
  
  v <- c(1, 5, 10, 13, 6, 3, NA)
  
  
  res1 <- fmt_range(v)
  res2 <- fmt_range(v, sep = "to")
  res3 <- fmt_range(v, sep = "to", format = "%.1f")
  
  expect_equal(res1, "1 - 13")
  expect_equal(res2, "1 to 13")
  expect_equal(res3, "1.0 to 13.0")
  
})



test_that("fmt_n() function works as expected.", {
  
  v <- c(1, 5, 10, 13, 6, 3, NA)
  
  res1 <- fmt_n(v)
  
  expect_equal(res1, "6")
  
})



test_that("fmt_quantile_range() function works as expected.", {
  
  v <- c(1, 5, 10, 13, 6, 3, NA)
  
  res1 <- fmt_quantile_range(v)
  res2 <- fmt_quantile_range(v, format = "%.2f")
  res3 <- fmt_quantile_range(v, format = "%.2f", sep = "to")
  res4 <- fmt_quantile_range(v, upper = .8, lower = .2)
  
  expect_equal(res1, "3.5 - 9.0")
  expect_equal(res2, "3.50 - 9.00")
  expect_equal(res3, "3.50 to 9.00")
  expect_equal(res4, "3.0 - 10.0") 
  
})



test_that("fmt_median() function works as expected.", {
  
  
  sample(seq(from = 0, to = 10, by = .1), 10)
  
  v <- c(1, 5, 10, 13, 6, 3, NA)
  
  res1 <- fmt_median(v)
  res2 <- fmt_median(v, format = "%.2f")
  
  expect_equal(res1, "5.5")
  expect_equal(res2, "5.50")
  
})
  

test_that("fmt_cnt_pct() function works as expected.", {
  
  v <- c(1, 5, 0, 13, 6, 3, NA)
  
  res1 <- fmt_cnt_pct(v)
  res2 <- fmt_cnt_pct(v, 110)
  res3 <- fmt_cnt_pct(v, 110, format = "%6.2f")
  
  expect_equal(res1[1], "1 ( 16.7%)")
  expect_equal(res1[3], "0 (  0.0%)")
  expect_equal(is.na(res1[7]), TRUE)
  expect_equal(res2[1], "1 (< 1.0%)")
  expect_equal(res3[1], "1 (< 1.00%)")
  
  
})


test_that("fmt_mean_sd() function works as expected.", {
  
  v <- c(1, 5, 10, 13, 6, 3, NA)
  
  res1 <- fmt_mean_sd(v)
  res2 <- fmt_mean_sd(v, format = "%.2f")
  res3 <- fmt_mean_sd(v, format = "%.2f", sd_format = "%.1f")
  
  expect_equal(res1, "6.3 (4.5)")
  expect_equal(res2, "6.33 (4.46)")
  expect_equal(res3, "6.33 (4.5)")
  
  
  
})
  
