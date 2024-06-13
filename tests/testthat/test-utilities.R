context("utilities Tests")

dev <- FALSE

test_that("utils1: log_output() function works as expected.", {

  if (dev) {
    res <- log_output()
    
    expect_equal(res, TRUE)
    
    
    options("logr.output" = TRUE)
    
    res <- log_output()
    
    expect_equal(res, TRUE)
    
    
    options("logr.output" = FALSE)
    
    res <- log_output()
    
    expect_equal(res, FALSE)
    
    
    
    options("logr.output" = NULL)
    
    res <- log_output()
    
    expect_equal(res, TRUE)
  
  } else {
    
    res <- log_output()
    
    expect_equal(res, FALSE)
    
  }
  
})


test_that("utils2: get_quarter() works as expected.", {
  
  
  v1 <- as.Date(c("2000-01-15", "2025-03-15", "2000-04-15", "2025-06-15", 
                  "2000-07-15", "2025-09-15", "2000-10-15", "2025-12-15", 
                  "2025-12-32", "2000-20-59"))
  
  expect_equal("Date" %in% class(v1), TRUE)

  
  res <- get_quarter(v1)
  
  expect_equal(all(res[1:8] == c(1, 1, 2, 2, 3, 3, 4, 4)), TRUE)  
  expect_equal("numeric" %in% class(res), TRUE)
  
})


test_that("utils3: replace_quarter() works as expected.", {
  
  
  v1 <- as.Date(c("2000-01-15", "2025-03-15", "2000-04-15", "2025-06-15", 
                  "2000-07-15", "2025-09-15", "2000-10-15", "2025-12-15", 
                  "2025-12-32", "2000-20-59"))
  
  val <- format(v1, "%Y-%Q")
  q <- get_quarter(v1)
  ptn <- "Q"
  repl <- paste0("Q", q) 
  
  
  res <- replace_quarter(val, ptn, repl)
  
  res
  
  expect_equal(all(res[1:8] == c("2000-Q1", "2025-Q1", "2000-Q2", "2025-Q2", "2000-Q3",
                          "2025-Q3", "2000-Q4", "2025-Q4")), TRUE)  
  
  expect_equal(all(is.na(res[9:10]) == c(TRUE, TRUE)), TRUE) 

  val <- format(v1, "%Y-%q")
  q <- get_quarter(v1)
  ptn <- "q"
  repl <- paste0("q", q)
  
  res2 <- replace_quarter(val, ptn, repl)
  
  res2
  
  expect_equal(all(res2[1:8] == c("2000-q1", "2025-q1", "2000-q2", "2025-q2", "2000-q3",
                          "2025-q3", "2000-q4", "2025-q4")), TRUE) 
  
  expect_equal(all(is.na(res2[9:10]) == c(TRUE, TRUE)), TRUE) 
  
})


