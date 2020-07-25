context("fapply Tests")



test_that("fapply() function works as expected with vectors.", {
  
  
  
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
  
  
  fapply(t, fmt = "My Stuff: %s")
  fapply(n, fmt = "%+6d")
  fapply(f, fmt = "%6.1f%%")
  fapply(d, fmt = "%d%b%Y")
  
  fapply(t, width = 10, justify = "right", fmt = "My Stuff: %s")
  fapply(n, width = 10, justify = "center", fmt = "%+d")
  fapply(f, width = 10, justify = "left", fmt = "%.1f%%")
  fapply(d, width = 15, justify = "right", fmt = "%d%b%Y")
  
  
  # t1 <- fattr(t, "My stuff: %s", width = 10, justify = "right")
  # fapply(t1)
  # 
  # fapply(c(4, 3, 2, 1.2))
  # fapply(c("My", "Crazy", "Testing"))
  # fapply(as.Date(c("2020-06-21", "2020-09-18", NA)), 
  #                  width = 15, format = "%d%b%Y")
  # 
  # fapply(f, format = function(x) trimws(format(x, big.mark = ",
  #                                     ", digits = 1, nsmall = 1)))
  # 
  # 

  
  
})



test_that("fapply() function works as expected with flist", {
  

  
  # No missing values
  subjid <- 100:104
  name <- c("Pinkett, Jacqulyn", "al-Harron, Ibtisaama", "el-Hammoud, Kabeera",
            "Tao, Tia", "Maldonado, Estevan")
  sex <- factor(c("M", "F", "F", "M", "UNK"),
                levels =  c("M", "F", "UNK"))
  age <- c(41.3, 53.9567, 43.2, 39.734, 47)
  arm <- c(rep("A", 3), rep("B", 2))
  
  name <- fattr(name, justify = "left")
  sex <- fattr(sex, format = c(M = "Male", F = "Female"))
  age <- fattr(age, format = "%6.1f", justify = "left")
  arm <- fattr(arm, format = "Arm: %s")
  
  
  # Create data frame
  df <- data.frame(subjid, name, sex, age, arm)
  df
  
  
  
  fapply(df$sex)
  fapply(df$age)
  fapply(df$arm)
  format(df)
  
  s <- df$sex
  
  attributes(s)[[1]]
  
  p <- factor(c("C", "D", "C", "D"), levels = c("C", "D"))
  attr(p, "format") <- c(C = "Cat C", D = "Cat D")
  p
  
  q <- c("C", "D", "C", "D")
  cat_fmt <- c(C = "Cat C", D = "Cat D")
  attr(q, "format") <- cat_fmt
  q
  fapply(q)
  x <- cat_fmt[q]
  names(x) <- NULL
  x
  
  
  attr(p, "format") <- function(x) ifelse(x == "C", "Label C", "Label D")
  
  fapply(p)
  base::format(df$sex)  

  format(df$age)  
  fapply(df$age)
})
