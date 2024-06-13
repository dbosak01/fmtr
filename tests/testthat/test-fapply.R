context("fapply Tests")

options("logr.output" = FALSE)

test_that("fapply1: fapply() function works as expected with vectors.", {
  
  
  
  t <- c("A", "B", "B", "UNK", "A")
  n <- c(1L, 2L, 3L, 10L, 11838L)
  f <- c(1.2, 2, 3.377, 10.388, 1138.3)
  d <- c("2020-05-02", "2020-08", "2020-10-17")
  d <- as.Date(d)
  
  l <- c(A = "Var A", B = "Var B", UNK = "Unknown")
  
  
  
  expect_equal(fapply(t, width = 5), c("A    ","B    ",
                                   "B    ","UNK  ","A    "))
  expect_equal(fapply(n, width = 5), c("    1","    2","    3","   10","11838"))
  expect_equal(fapply(f, width = 9), c("    1.200", "    2.000",
                                       "    3.377","   10.388"," 1138.300"))
  expect_equal(fapply(t, l), c("Var A", "Var B", "Var B", "Unknown", "Var A"))
  fapply(d, width = 15)  
  
  format(f, width = 9)
  
  
  fapply(t, justify = "right")
  fapply(n, justify = "center")
  fapply(f, justify = "left")
  fapply(d, justify = "center")
  
  
  fapply(t, width = 10, justify = "right")
  fapply(n, width = 10, justify = "center")
  fapply(f, width = 10, justify = "left")
  fapply(d, width = 15, justify = "left")
  
  
  fapply(t, format = "My Stuff: %s")
  fapply(n, format = "%+6d")
  fapply(f, format = "%6.1f%%")
  fapply(d, format = "%d%b%Y")
  
  fapply(t, width = 10, justify = "right", format = "My Stuff: %s")
  fapply(n, width = 10, justify = "center", format = "%+d")
  fapply(f, width = 10, justify = "left", format = "%.1f%%")
  fapply(d, width = 15, justify = "right", format = "%d%b%Y")
  
})

test_that("fapply2: fapply() function works as expected with vector input formats.", {
  
  
  
  d <- c("A", "B", "B", "UNK", "A")
  f <- c("A"= "Abba", "B" = "Babba")
  
  # lookup(d, f)
  # 

  expect_equal(fapply(d, f), c("Abba", "Babba", "Babba", "UNK", "Abba"))
  expect_equal(lkup(d, f), c("Abba", "Babba", "Babba", "UNK", "Abba"))
  
})

test_that("fapply3: fapply() function works as expected with flist", {
  

   ## Formatting List - Row Type ##
   v1 <- list(2841.258, "H", as.Date("2020-06-19"), 1382.8865,
              "L", as.Date("2020-04-24"))

   
   # Create formatting list
   lst <- flist(type = "row",
           type1 = function(x) format(x, digits = 2, nsmall = 1, 
                                     big.mark=","),
           type2 = value(condition(x == "H", "High"),
                        condition(x == "L", "Low"),
                        condition(TRUE, "NA")),
           type3 = "%d%b%Y")
   
   # Apply formatting list to vector
   fmtd <- fapply(v1, lst)
   
   res <- c("2,841.3", "High", "19Jun2020", "1,382.9", "Low", "24Apr2020")
   expect_equal(fmtd, res)
   
   ## Formatting List - Row Type with lookup ##
   v2 <- list(2841.258, "H", as.Date("2020-06-19"),
              "L", as.Date("2020-04-24"), 1382.8865)
   v3 <- c("type1", "type2", "type3", "type2", "type3", "type1")
   
   # Create formatting list
   lst <- flist(type = "row", lookup = v3,
                type1 = function(x) format(x, digits = 2, nsmall = 1, 
                                           big.mark=","),
                type2 = value(condition(x == "H", "High"),
                              condition(x == "L", "Low"),
                              condition(TRUE, "NA")),
                type3 = "%d%b%Y")
   
   # Apply formatting list to vector
   fmtd <- fapply(v2, lst)
   
   res <- c("2,841.3", "High", "19Jun2020", "Low", "24Apr2020", "1,382.9")
   expect_equal(fmtd, res)
   
   
   
   ## Formatting List - Column Type ##
   v3 <- as.Date(c("2020-08-23", "2020-09-15", "2020-10-05"))
   
   
   # Create formatting list
   lst <- flist("%B", "Month: %s", type="column")
   
   # Apply formatting list to vector
   fmtd2 <- fapply(v3, lst)
   
   res <- c("Month: August", "Month: September", "Month: October")
   
   expect_equal(fmtd2, res)
})


test_that("fapply4: fapply() with vector formats work as expected.", {
  
  catc = c("A", "B", "C", "B")
  catn = c(1, 2, 3, 2) 
  
  v1 <- c(A= "Alpha", B = "Bravo", C = "Charlie")
  
  res1 <- fapply(catc, v1)
  
  expect_equal(class(res1), "character")
  
  v2 <- c(A= 1, B = 2, C = 3)
  
  res2 <- fapply(catc, v2)
  
  expect_equal(class(res2), "numeric")
  
  
  v3 <- c(A= 1L, B = 2L, C = 3L)
  
  res3 <- fapply(catc, v3)
  
  expect_equal(class(res3), "integer")
  
  
  
})

test_that("fapply5: fapply() returns a character vector instead of a factor", {
  
  # Create vector
  a <- c(1.3243, 5.9783, 2.3848)
  
  # Assign format attributes
  a <- fattr(a, format = "%.1f", width = 10, justify = "center")
  
  # Apply format attributes
  f1 <- fapply(a)
  
  expect_equal(class(f1), "character")
  
  
})

test_that("fapply6: fapply() parameter checks work as expected", {
  
  
  v <- c(1, 2, 3)
  
  expect_error(fapply(v, format = Sys.Date()))
  expect_error(fapply(v, width = "5"))
  expect_error(fapply(v, width = -1))
  expect_error(fapply(v, justify = "fork"))
  expect_error(fapply(v, v))
  
  
})


test_that("fapply7: fapply2() works as expected.", {
  
  # Create vector
  a <- c(1.3243, 5.9783, 2.3848)
  b <- c(4.284, 3.383, 1.848)
  
  # Check basic fapply2
  f1 <- fapply2(a, b, "%1.1f", "(%1.2f)", sep = " ")
  
  expect_equal(f1[1], "1.3 (4.28)")
  
  # Check width
  f2 <- fapply2(a, b, "%1.1f", "(%1.2f)", sep = " ", width = 13)
  
  expect_equal(f2[1], "1.3 (4.28)   ")
  
  # Check width and justify
  f3 <- fapply2(a, b, "%1.1f", "(%1.2f)", sep = " ", width = 13, 
                justify = "right")
  
  expect_equal(f3[1], "   1.3 (4.28)")
  
  # Check if formatting attributes work
  fattr(a) <- list(format = "%1.1f")
  fattr(b) <- list(format = "(%1.2f)")
  
  f4 <- fapply2(a, b, sep = " ")
  
  expect_equal(f4[1], "1.3 (4.28)")
  
  
})

test_that("fapply8: fapply() works with numeric formats in label.", {
 
  v1 <- c(1.3948234, 2.393745, 3.33775, .000001, NA)
  
  fmt <- value(condition(x < .0001, "<.0001"),
               condition(TRUE, "%.4f"))
  
  res <- fapply(v1, fmt)
  
  res 
  
  expect_equal(res, c("1.3948", "2.3937", "3.3378", "<.0001", NA))
  
  
  
  
})

test_that("fapply9: fapply() works with date formats in label.", {
  
  v1 <- c(as.Date("2000-01-01"), as.Date("1999-01-01"), 
          as.Date("2000-02-23"), NA)
  
  fmt <- value(condition(as.integer(format(x, "%Y")) < 2000, "Too old"),
               condition(TRUE, "%B %m %Y"))
  
  res <- fapply(v1, fmt)
  
  res 
  
  expect_equal(res, c("January 01 2000", "Too old", "February 02 2000", NA))
  
})

test_that("fapply10: fapply() works as expected with single item vector lookup.", {
  
  
  
  t <- c("A", "B", "B", NA, "A")

  fmt <- c("A" = "Group A")
  
  re <- c("Group A","B",
          "B", NA,"Group A")
  
  res <- fapply(t, fmt)
  
  expect_equal(res, re)
})

test_that("fapply11: format_quarter() works as expected.", {
  
  
  v1 <- as.Date(c("2000-01-15", "2025-03-15", "2000-04-15", "2025-06-15", 
                  "2000-07-15", "2025-09-15", "2000-10-15", "2025-12-15", 
                  "2025-12-32", "2000-20-59"))

  f1 <- format(v1, "%Y-%q")  
  
  res <- format_quarter(v1, f1, "%Y-%q")
  
  res
  
  expect_equal(all(res[1:8] == c("2000-1", "2025-1", "2000-2", "2025-2", "2000-3", "2025-3",
                          "2000-4", "2025-4")), TRUE)
  
  f2 <- format(v1, "%Y-%Q")  
  
  res2 <- format_quarter(v1, f2, "%Y-%Q")
  
  res2
  
  expect_equal(all(res2[1:8] == c("2000-Q1", "2025-Q1", "2000-Q2", "2025-Q2", "2000-Q3", 
                           "2025-Q3", "2000-Q4", "2025-Q4")), TRUE)

})

test_that("fapply12: fapply with quarter works as expected.", {
  
  
  v1 <- as.Date(c("2000-01-15", "2025-03-15", "2000-04-15", "2025-06-15", 
                  "2000-07-15", "2025-09-15", "2000-10-15", "2025-12-15", 
                  "2025-12-32", "2000-20-59"))
  
  res1 <- fapply(v1, "%y-%q")
  
  print(res1)
  
  expect_equal(all(res1[1:8] == c("00-1", "25-1", "00-2","25-2", "00-3", "25-3", "00-4",
                          "25-4")), TRUE)
  
  
  res2 <- fapply(v1, "%Y-%Q")
  
  res2
  
  print(res2)
  
  expect_equal(all(res2[1:8] == c("2000-Q1", "2025-Q1", "2000-Q2","2025-Q2", "2000-Q3", 
                          "2025-Q3", 
                          "2000-Q4",
                          "2025-Q4")), TRUE)
  
  
  res3 <- fapply(v1, "%q")
  
  res3
  
  print(res3)
  
  expect_equal(all(res3[1:8] == c("1", "1", "2","2", "3", "3", "4",
                           "4")), TRUE)
  
  res4 <- fapply(Sys.time(), "%Q")
  
  res4
  
  print(res4)
  
  # No error
  expect_equal(TRUE, TRUE)
  
})

# fapply(Sys.Date(), "%Y-%Q-%d")

# fapply(Sys.Date(), "%Y-%q-%d")


test_that("fapply13: fapply with quarter and date works as expected.", {
  
  
  v1 <- as.Date(c("2000-01-15", "2025-03-15", "2000-04-15", "2025-06-15", 
                  "2000-07-15", "2025-09-15", "2000-10-15", "2025-12-15", 
                  "2025-12-32", "2000-20-59"))
  
  res1 <- fapply(v1, "%y-%q-%d")
  
  
  
  expect_equal(all(res1[1:8] == c("00-1-15", "25-1-15", "00-2-15","25-2-15", "00-3-15", 
                           "25-3-15", "00-4-15", "25-4-15")), TRUE)
  
  
  res2 <- fapply(v1, "%Y-%Q-%d")
  
  format(v1, format = "%Y-%Q-%d")
  
  res2
  
  expect_equal(all(res2[1:8] == c("2000-Q1-15", "2025-Q1-15", "2000-Q2-15","2025-Q2-15", "2000-Q3-15", 
                           "2025-Q3-15", 
                           "2000-Q4-15",
                           "2025-Q4-15")), TRUE)
  
  
})
