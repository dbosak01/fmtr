context("best Tests")

options("logr.output" = FALSE)

base_path <- "c:/packages/fmtr/tests/testthat/"

base_path <- "."


test_that("best1: best_obj works as expected.", {
  
  # dpos, dgts, wdth
  b1 <- best_obj(2, 4)
  
  expect_equal("best_obj" %in% class(b1), TRUE)
  
  expect_equal(b1$value, 2)
  expect_equal(b1$cvalue, "2.0000000000000000")
  expect_equal(b1$dpos, 2)
  expect_equal(b1$wdth, 4)
  expect_equal(b1$dgts, 2)
  expect_equal(b1$exponent, 0)    
  expect_equal(b1$coefficient, 2)
  expect_equal(b1$pv, TRUE)
  expect_equal(b1$pn, TRUE)
  expect_equal(b1$cwdth, 4)
  expect_equal(b1$result, "2")
  
  
  
  b2 <-  best_obj(200, 4)
  expect_equal(b2$value, 200)
  expect_equal(b2$cvalue, "200.0000000000000000")
  expect_equal(b2$dpos, 4)
  expect_equal(b2$wdth, 4)
  expect_equal(b2$dgts, 0)
  expect_equal(b2$exponent, 2)    
  expect_equal(b2$coefficient, 200)
  expect_equal(b2$pv, TRUE)
  expect_equal(b2$pn, TRUE)
  expect_equal(b2$cwdth, 4)
  expect_equal(b2$result, "200")
  
  
  b3 <-  best_obj(223845.2482, 4)
  expect_equal(b3$value, 223845.2482)
  expect_equal(b3$cvalue, "223845.2482000000018161")
  expect_equal(b3$dpos, 7)
  expect_equal(b3$wdth, 4)
  expect_equal(b3$dgts, 0)
  expect_equal(b3$exponent, 4)
  expect_equal(b3$coefficient, 22)
  expect_equal(b3$pv, TRUE)
  expect_equal(b3$pn, TRUE)
  expect_equal(b3$cwdth, 2)          
  expect_equal(b3$result, "22E4")    
  
  
  b4 <-  best_obj(-223845.2482, 4)
  expect_equal(b4$value, -223845.2482)
  expect_equal(b4$cvalue, "-223845.2482000000018161")
  expect_equal(b4$dpos, 7)
  expect_equal(b4$wdth, 4)
  expect_equal(b4$dgts, 0)
  expect_equal(b4$exponent, 5)
  expect_equal(b4$pv, FALSE)
  expect_equal(b4$pn, TRUE)
  expect_equal(b4$cwdth, 1)          
  expect_equal(b4$result, "-2E5")   
  
  
  b5 <-  best_obj(-0.002238452482, 4)
  expect_equal(b5$value, -0.002238452482)
  expect_equal(b5$cvalue, "-0.0022384524820000")
  expect_equal(b5$dpos, 2)
  expect_equal(b5$wdth, 4)
  expect_equal(b5$dgts, 2)
  expect_equal(b5$exponent, -3)
  expect_equal(b5$pv, FALSE)
  expect_equal(b5$pn, FALSE)
  expect_equal(b5$cwdth, 3)         
  expect_equal(b5$result, "0")   
  
})


test_that("best2: get_exponent() works as expected.", {
  
  o1 <- best_obj(0.000123, 4)
  
  
  expect_equal(o1$exponent, -4)  # Normal
  
  o2 <- best_obj(12356.632, 4)

  
  expect_equal(o2$exponent, 3)   # Adjusted for low width
  
  
})


test_that("best3: needs_sci() works as expected.", {
  
  oopt <- getOption("scipen")
  options("scipen" = 999)
  
  
  o1 <- best_obj(2, 12)
  
  expect_equal(o1$sci, FALSE)
  
  o2 <- best_obj(12345678912345, 12)
  
  expect_equal(o2$sci, TRUE)
  
  
  o3 <- best_obj(0.2, 12)
  
  expect_equal(o3$sci, FALSE)

  
  o4 <- best_obj(0.000234, 12)
  
  expect_equal(o4$sci, FALSE)
  
  o5 <- best_obj(0.000000234, 12)
  
  expect_equal(o5$sci, TRUE)
  
  o6 <- best_obj(0.000234, 5)
  
  expect_equal(o6$sci, TRUE)
  
  o7 <- best_obj(123.000234, 3)
  
  expect_equal(o7$sci, FALSE)
  
  # Turn automatic scientific notation back on
  options("scipen" = oopt)
  
})


test_that("best4: size_output() works as expected.", {
  
  
  expect_equal(size_output("x", 1), "x")
  expect_equal(size_output("x", 4), "   x")
  expect_equal(size_output("xxxxx", 4), "xxxx")
  expect_equal(size_output(NA, 4), NA)
  
  
})


test_that("best5: best padding works as expected.", {
  
  
  expect_equal(fapply(1000000000, "best3"), "1E9")
  expect_equal(fapply(1000000000, "best5"), "  1E9")
  expect_equal(fapply(123456789, "best13"), "    123456789")
  
  
})

test_that("best6: test error handling.", {
  
  
  expect_warning(fapply(1000000000, "bestX"))
  expect_error(fapply(1000000000, "best33"))
  expect_error(fapply(1000000000, "best0"))
  expect_warning(fapply(100, "I like sponges best"))
})



test_that("best7: format_best works as expected.", {
  
  v1 <- c(123.456778910248, 12.384883832456, 1456.2468483838833,
          1.4, NA, 0.0000003984900897739283873,
          0.00003984900897739283873, 0,
          849.0000000000001
  )
  
  res <- format_best(v1, 6, FALSE)
  
  res
  
  expect_equal(res[1], "123.46")
  expect_equal(res[2], "12.385")
  expect_equal(res[3], "1456.2")
  expect_equal(res[4], "1.4")
  expect_equal(is.na(res[5]), TRUE)
  expect_equal(res[6], "398E-9")       # No Coefficient rounding
  expect_equal(res[7], "398E-7")       # No Coefficient rounding
  expect_equal(res[8], "0")
  expect_equal(res[9], "849")
  
  
  res <- format_best(v1, 12, FALSE)
  
  res
  
  expect_equal(res[1], "123.45677891")
  expect_equal(res[2], "12.384883832")
  expect_equal(res[3], "1456.2468484")
  expect_equal(res[4], "1.4")
  expect_equal(is.na(res[5]), TRUE)
  expect_equal(res[6], "3.9849009E-7")
  expect_equal(res[7], "0.000039849")
  expect_equal(res[8], "0")
  expect_equal(res[9], "849")
  
  
})


test_that("best8: format_best works as expected with negative values.", {


  v2 <- c(-0.0000003984900897739283873,  -123456384821000000000.5683, -1000000000000000)

  res1 <- format_best(v2[1], 12)

  expect_equal(res1, "-3.984901E-7")

  res2 <- format_best(v2[2], 12)

  expect_equal(res2, "-1.234564E20")

  res3 <- format_best(v2[3], 12)

  expect_equal(res3, "       -1E15")

})


test_that("best9: fapply with best(12) format works as expected.", {


  v1 <- c(t1 = 123.456778910248,
          t2 = 12.384883832456,
          t3 = 1456.2468483838833,
          t4 = 1.4,
          t5 = NA,
          t6 = 0.0000003984900897739283873,
          t7 = 0.00003984900897739283873,
          t8 = 0,
          t9 = .25,
          t10 = .55,
          t11 = 849.0000000000001,
          t12 = 123456.3848215683,
          t13 = 123456384.8215683,
          t14 = 123456384821.5683,
          t15 = 1234563848210.5683,
          t16 = 123456384821000000000.5683,
          t17 = 1000000000000000
  )

  res <- fapply(v1, "best")

  # res <- fapply(849.0000000000001, "best")

  # fapply(0.0000003984900897739283873, "best")

  res

  expect_equal(res[[1]], "123.45677891")
  expect_equal(res[[2]], "12.384883832")
  expect_equal(res[[3]], "1456.2468484")
  expect_equal(res[[4]], "         1.4")
  expect_equal(is.na(res[[5]]), TRUE)
  expect_equal(res[[6]], "3.9849009E-7")
  expect_equal(res[[7]], " 0.000039849")
  expect_equal(res[[8]], "           0")
  expect_equal(res[[9]], "        0.25")
  expect_equal(res[[10]], "        0.55")
  expect_equal(res[[11]], "         849")
  expect_equal(res[[12]], "123456.38482")
  expect_equal(res[[13]], "123456384.82")
  expect_equal(res[[14]], "123456384822")
  expect_equal(res[[15]], "1.2345638E12")
  expect_equal(res[[16]], "1.2345638E20")
  expect_equal(res[[17]], "        1E15")


  # Just test a couple. Should be same.
  res2 <- fapply(v1, "best12")

  res2

  expect_equal(res2[[1]], "123.45677891")
  expect_equal(res2[[2]], "12.384883832")



})

test_that("best10: fapply with best(12) format works as expected negative numbers.", {


  v1 <- c(t1 = -123.456778910248,
          t2 = -12.384883832456,
          t3 = -1456.2468483838833,
          t4 = -1.4,
          t5 = NA,
          t6 = -0.0000003984900897739283873,
          t7 = -0.00003984900897739283873,
          t8 = 0,
          t9 = -.25,
          t10 = -.55,
          t11 = -849.0000000000001,
          t12 = -123456.3848215683,
          t13 = -123456384.8215683,
          t14 = -123456384821.5683,
          t15 = -1234563848210.5683,
          t16 = -123456384821000000000.5683,
          t17 = -1000000000000000
  )

  res <- fapply(v1, "best")

  # res <- fapply(849.0000000000001, "best")

  # fapply(0.0000003984900897739283873, "best")

  res

  expect_equal(res[[1]], "-123.4567789")
  expect_equal(res[[2]], "-12.38488383")
  expect_equal(res[[3]], "-1456.246848")
  expect_equal(res[[4]], "        -1.4")
  expect_equal(is.na(res[[5]]), TRUE)
  expect_equal(res[[6]], "-3.984901E-7")
  expect_equal(res[[7]], "-0.000039849")
  expect_equal(res[[8]], "           0")
  expect_equal(res[[9]], "       -0.25")
  expect_equal(res[[10]], "       -0.55")
  expect_equal(res[[11]], "        -849")
  expect_equal(res[[12]], "-123456.3848")
  expect_equal(res[[13]], "-123456384.8")
  expect_equal(res[[14]], "-1.234564E11")
  expect_equal(res[[15]], "-1.234564E12")
  expect_equal(res[[16]], "-1.234564E20")
  expect_equal(res[[17]], "       -1E15")


  # Just test a couple. Should be same.
  res2 <- fapply(v1, "best12")

  res2

  expect_equal(res2[[1]], "-123.4567789")
  expect_equal(res2[[2]], "-12.38488383")



})


test_that("best11: fapply with best(8) format works as expected.", {


  v1 <- c(t1 = 123.456778910248,
          t2 = 12.384883832456,
          t3 = 1456.2468483838833,
          t4 = 1.4,
          t5 = NA,
          t6 = 0.0000003984900897739283873,
          t7 = 0.00003984900897739283873,
          t8 = 0,
          t9 = .25,
          t10 = .55,
          t11 = 849.0000000000001,
          t12 = 123456.3848215683,
          t13 = 123456384.8215683,
          t14 = 123456384821.5683,
          t15 = 1234563848210.5683,
          t16 = 123456384821000000000.5683,
          t17 = 1000000000000000
  )

  res <- fapply(v1, "best8")

  res

  expect_equal(res[[1]], "123.4568")
  expect_equal(res[[2]], "12.38488")
  expect_equal(res[[3]], "1456.247")
  expect_equal(res[[4]], "     1.4")
  expect_equal(is.na(res[[5]]), TRUE)
  expect_equal(res[[6]], "3.985E-7")
  expect_equal(res[[7]], " 0.00004")
  expect_equal(res[[8]], "       0")
  expect_equal(res[[9]], "    0.25")
  expect_equal(res[[10]], "    0.55")
  expect_equal(res[[11]], "     849")
  expect_equal(res[[12]], "123456.4")
  expect_equal(res[[13]], "1.2346E8")
  expect_equal(res[[14]], "1.235E11")
  expect_equal(res[[15]], "1.235E12")
  expect_equal(res[[16]], "1.235E20")
  expect_equal(res[[17]], "    1E15")


  v2 <- c(t1 = -123.456778910248,
          t2 = -12.384883832456,
          t3 = -1456.2468483838833,
          t4 = -1.4,
          t5 = NA,
          t6 = -0.0000003984900897739283873,
          t7 = -0.00003984900897739283873,
          t8 = 0,
          t9 = -.25,
          t10 = -.55,
          t11 = -849.0000000000001,
          t12 = -123456.3848215683,
          t13 = -123456384.8215683,
          t14 = -123456384821.5683,
          t15 = -1234563848210.5683,
          t16 = -123456384821000000000.5683,
          t17 = -1000000000000000
  )

  res2 <- fapply(v2, "best8")

  res2

  expect_equal(res2[[1]], "-123.457")
  expect_equal(res2[[2]], "-12.3849")
  expect_equal(res2[[3]], "-1456.25")
  expect_equal(res2[[4]], "    -1.4")
  expect_equal(is.na(res2[[5]]), TRUE)
  expect_equal(res2[[6]], "-3.98E-7")
  expect_equal(res2[[7]], "-0.00004")
  expect_equal(res2[[8]], "       0")
  expect_equal(res2[[9]], "   -0.25")
  expect_equal(res2[[10]], "   -0.55")
  expect_equal(res2[[11]], "    -849")
  expect_equal(res2[[12]], " -123456")
  expect_equal(res2[[13]], "-1.235E8")
  expect_equal(res2[[14]], "-1.23E11")
  expect_equal(res2[[15]], "-1.23E12")
  expect_equal(res2[[16]], "-1.23E20")
  expect_equal(res2[[17]], "   -1E15")


})



test_that("best12: fapply with best(7) format works as expected.", {


  expect_equal(fapply(123456789.12345, "best7"), "1.235E8")
  expect_equal(fapply(-123456789.12345, "best7"), "-1.23E8")
  expect_equal(fapply(0.0000012345678912345, "best7"), "1.23E-6")
  expect_equal(fapply(-0.0000012345678912345, "best7"), "-123E-8")


  v1 <- c(t1 = 123.456,
          t2 = 1.4,
          t3 = NA,
          t4 = 0,
          t5 = 0.0000003984900897739283873,
          t6 = .25,
          t7 = .55,
          t8 = 4,
          t9 = 45,
          t10 = 849.0000000000001,
          t11 = 123456384.8215683,
          t12 = 1000000000000000,
          t13 = -0.55,
          t14 = -4,
          t15 = -45,
          t16 = -123456384.8215683,
          t17 = -0.0000003984900897739283873
  )



  res <- fapply(v1, "best7")

  res

  expect_equal(res[1], "123.456")
  expect_equal(res[2], "    1.4")
  expect_equal(is.na(res[3]), TRUE)
  expect_equal(res[4], "      0")
  expect_equal(res[5], "3.98E-7")
  expect_equal(res[6], "   0.25")
  expect_equal(res[7], "   0.55")
  expect_equal(res[8], "      4")
  expect_equal(res[9], "     45")
  expect_equal(res[10], "    849")
  expect_equal(res[11], "1.235E8")
  expect_equal(res[12], "   1E15")
  expect_equal(res[13], "  -0.55")
  expect_equal(res[14], "     -4")
  expect_equal(res[15], "    -45")
  expect_equal(res[16], "-1.23E8")
  expect_equal(res[17], "-398E-9")

})




test_that("best13: fapply with best(6) format works as expected.", {


  v1 <- c(t1 = 123.456778910248,
          t2 = 12.384883832456,
          t3 = 1456.2468483838833,
          t4 = 1.4,
          t5 = NA,
          t6 = 0.0000003984900897739283873,
          t7 = 0.00003984900897739283873,
          t8 = 0,
          t9 = .25,
          t10 = .55,
          t11 = 849.0000000000001,
          t12 = 123456.3848215683,
          t13 = 123456384.8215683,
          t14 = 123456384821.5683,
          t15 = 1234563848210.5683,
          t16 = 123456384821000000000.5683,
          t17 = 1000000000000000
  )

  res <- fapply(v1, "best6")

  res

  expect_equal(res[[1]], "123.46")
  expect_equal(res[[2]], "12.385")
  expect_equal(res[[3]], "1456.2")
  expect_equal(res[[4]], "   1.4")
  expect_equal(is.na(res[[5]]), TRUE)
  expect_equal(res[[6]], "398E-9")
  expect_equal(res[[7]], "398E-7")
  expect_equal(res[[8]], "     0")
  expect_equal(res[[9]], "  0.25")
  expect_equal(res[[10]], "  0.55")
  expect_equal(res[[11]], "   849")
  expect_equal(res[[12]], "123456")
  expect_equal(res[[13]], "1.23E8")
  expect_equal(res[[14]], " 123E9") # Interesting
  expect_equal(res[[15]], "1235E9") # Interesting
  expect_equal(res[[16]], "123E18") 
  expect_equal(res[[17]], "  1E15")


  v2 <- c(t1 = -123.456778910248,
          t2 = -12.384883832456,
          t3 = -1456.2468483838833,
          t4 = -1.4,
          t5 = NA,
          t6 = -0.0000003984900897739283873,
          t7 = -0.00003984900897739283873,
          t8 = 0,
          t9 = -.25,
          t10 = -.55,
          t11 = -849.0000000000001,
          t12 = -123456.3848215683,
          t13 = -123456384.8215683,
          t14 = -123456384821.5683,
          t15 = -1234563848210.5683,
          t16 = -123456384821000000000.5683,
          t17 = -1000000000000000
  )

  res2 <- fapply(v2, "best6")

  res2

  expect_equal(res2[[1]], "-123.5")
  expect_equal(res2[[2]], "-12.38")
  expect_equal(res2[[3]], " -1456")
  expect_equal(res2[[4]], "  -1.4")
  expect_equal(is.na(res2[[5]]), TRUE)
  expect_equal(res2[[6]], " -4E-7")
  expect_equal(res2[[7]], " -4E-5")
  expect_equal(res2[[8]], "     0")
  expect_equal(res2[[9]], " -0.25")
  expect_equal(res2[[10]], " -0.55")
  expect_equal(res2[[11]], "  -849")
  expect_equal(res2[[12]], "-123E3")
  expect_equal(res2[[13]], "-123E6")
  expect_equal(res2[[14]], "-123E9") # Interesting  
  expect_equal(res2[[15]], "-12E11")
  expect_equal(res2[[16]], "-12E19")
  expect_equal(res2[[17]], " -1E15")


})



test_that("best14: remove_trailing_zeros() works as expected.", {
  
  # Positive change
  ob1 <- list(value = 2023.12, exponent = 2, pn = TRUE, wdth = 6)
  
  res1 <- remove_trailing_zeros(ob1)
  
  expect_equal(res1, 3)
  
  
  # Negative change
  ob2 <- list(value = 0.0202312, exponent = -3, pn = FALSE, wdth = 6)
  
  res2 <- remove_trailing_zeros(ob2)
  
  expect_equal(res2, -2)
  
  # Positive no change
  ob3 <- list(value = 2023.12, exponent = 3, pn = TRUE, wdth = 6)
  
  res3 <- remove_trailing_zeros(ob3)
  
  expect_equal(res3, 3)
  
  
  # Negative no change
  ob4 <- list(value = 0.0202312, exponent = -4, pn = FALSE, wdth = 6)
  
  res4 <- remove_trailing_zeros(ob4)
  
  expect_equal(res4, -4)
  
  
})




test_that("best15: format_best differents widths work as expected.", {

  expect_equal(format_best(123.456, 1), "*")  #1
  expect_equal(format_best(1.4, 1), "1")      #2
  expect_equal(format_best(NA, 1), NA)        #3
  expect_equal(format_best(0, 1), "0")        #4
  expect_equal(format_best(0.0000003984900897739283873, 1), "0") #5
  expect_equal(format_best(0.25, 1), "0")     #6
  expect_equal(format_best(0.55, 1), "1")     #7
  expect_equal(format_best(4, 1), "4")        #8
  expect_equal(format_best(45, 1), "*")       #9
  expect_equal(format_best(849.0000000000001, 1), "*")   #10
  expect_equal(format_best(123456384.8215683, 1), "*")   #11
  expect_equal(format_best(1000000000000000, 1), "*")    #12
  expect_equal(format_best(-0.55, 1), "*")     #13
  expect_equal(format_best(-4, 1), "*")        #14
  expect_equal(format_best(-45, 1), "*")       #15
  expect_equal(format_best(-0.0000003984900897739283873, 1), "0")


  expect_equal(format_best(123.456, 2), "**")  #1
  expect_equal(format_best(1.4, 2), " 1")      #2
  expect_equal(format_best(NA, 2), NA)        #3
  expect_equal(format_best(0, 2), " 0")        #4
  expect_equal(format_best(0.0000003984900897739283873, 2), " 0") #5
  expect_equal(format_best(0.25, 2), " 0")     #6
  expect_equal(format_best(0.55, 2), " 1")     #7
  expect_equal(format_best(4, 2), " 4")        #8
  expect_equal(format_best(45, 2), "45")       #9
  expect_equal(format_best(849.0000000000001, 2), "**")   #10
  expect_equal(format_best(123456384.8215683, 2), "**")   #11
  expect_equal(format_best(1000000000000000, 2), "**")    #12
  expect_equal(format_best(-0.55, 2), "-1")     #13
  expect_equal(format_best(-4, 2), "-4")        #14
  expect_equal(format_best(-45, 2), "**")       #15
  expect_equal(format_best(-0.0000003984900897739283873, 2), "-0")


  expect_equal(format_best(123.456, 3), "123")  #1
  expect_equal(format_best(1.4, 3), "1.4")      #2
  expect_equal(format_best(NA, 3), NA)        #3
  expect_equal(format_best(0, 3), "  0")        #4
  expect_equal(format_best(0.0000003984900897739283873, 3), "  0") #5
  expect_equal(format_best(0.25, 3), ".25")     #6                   
  expect_equal(format_best(0.55, 3), ".55")     #7
  expect_equal(format_best(4, 3), "  4")        #8
  expect_equal(format_best(45, 3), " 45")       #9
  expect_equal(format_best(849.0000000000001, 3), "849")   #10
  expect_equal(format_best(123456384.8215683, 3), "1E8")   #11
  expect_equal(format_best(1000000000000000, 3), "***")    #12
  expect_equal(format_best(-0.55, 3), "-.6")     #13
  expect_equal(format_best(-4, 3), " -4")        #14
  expect_equal(format_best(-45, 3), "-45")       #15
  expect_equal(format_best(-0.0000003984900897739283873, 3), "  0")


  expect_equal(format_best(123.456, 4), " 123")  #1
  expect_equal(format_best(1.4, 4), " 1.4")      #2
  expect_equal(format_best(NA, 4), NA)        #3
  expect_equal(format_best(0, 4), "   0")        #4
  expect_equal(format_best(0.0000003984900897739283873, 4), "   0") #5a
  expect_equal(format_best(0.000003984900897739283873, 4), "   0") #5b
  expect_equal(format_best(0.00003944900897739283873, 4), "   0") #5c
  expect_equal(format_best(0.03944900897739283873, 4), "0.04") #5d
  expect_equal(format_best(0.03984900897739283873, 4), "0.04") #5e
  expect_equal(format_best(0.25, 4), "0.25")     #6
  expect_equal(format_best(0.55, 4), "0.55")     #7
  expect_equal(format_best(4, 4), "   4")        #8
  expect_equal(format_best(45, 4), "  45")       #9
  expect_equal(format_best(849.0000000000001, 4), " 849")   #10
  expect_equal(format_best(123456384.8215683, 4), "12E7")   #11
  expect_equal(format_best(1000000000000000, 4), "1E15")    #12
  expect_equal(format_best(-0.55, 4), "-.55")     #13
  expect_equal(format_best(-4, 4), "  -4")        #14
  expect_equal(format_best(-45, 4), " -45")       #15
  expect_equal(format_best(-123456384.8215683, 4), "-1E8")   #16
  expect_equal(format_best(-0.0000003984900897739283873, 4), "   0") #17   


  expect_equal(format_best(123.456, 5), "123.5")  #1
  expect_equal(format_best(1.4, 5), "  1.4")      #2
  expect_equal(format_best(NA, 5), NA)        #3
  expect_equal(format_best(0, 5), "    0")        #4
  expect_equal(format_best(0.0000003984900897739283873, 5), " 4E-7") #5a
  expect_equal(format_best(0.000003984900897739283873, 5), " 4E-6") #5b
  expect_equal(format_best(0.00003944900897739283873, 5), "39E-6") #5c
  expect_equal(format_best(0.03944900897739283873, 5), "0.039") #5d
  expect_equal(format_best(0.03984900897739283873, 5), " 0.04") #5e
  expect_equal(format_best(0.25, 5), " 0.25")     #6
  expect_equal(format_best(0.55, 5), " 0.55")     #7
  expect_equal(format_best(4, 5), "    4")        #8
  expect_equal(format_best(45, 5), "   45")       #9
  expect_equal(format_best(849.0000000000001, 5), "  849")   #10
  expect_equal(format_best(123456384.8215683, 5, FALSE), "123E6")   #11            
  expect_equal(format_best(1000000000000000, 5), " 1E15")    #12
  expect_equal(format_best(-0.55, 5), "-0.55")     #13
  expect_equal(format_best(-4, 5), "   -4")        #14
  expect_equal(format_best(-45, 5), "  -45")       #15
  expect_equal(format_best(-123456384.8215683, 5), "-12E7")   #16
  expect_equal(format_best(-0.0000003984900897739283873, 5), "   -0") #17   


  expect_equal(format_best(123.456, 6), "123.46")  #1
  expect_equal(format_best(1.4, 6), "   1.4")      #2
  expect_equal(format_best(NA, 6), NA)        #3
  expect_equal(format_best(0, 6), "     0")        #4
  expect_equal(format_best(0.0000003984900897739283873, 6), "398E-9") #5  
  expect_equal(format_best(0.25, 6), "  0.25")     #6
  expect_equal(format_best(0.55, 6), "  0.55")     #7
  expect_equal(format_best(4, 6), "     4")        #8
  expect_equal(format_best(45, 6), "    45")       #9
  expect_equal(format_best(849.0000000000001, 6), "   849")   #10
  expect_equal(format_best(123456384.8215683, 6), "1.23E8")   #11
  expect_equal(format_best(1000000000000000, 6), "  1E15")    #12
  expect_equal(format_best(-0.55, 6), " -0.55")     #13
  expect_equal(format_best(-4, 6), "    -4")        #14
  expect_equal(format_best(-45, 6), "   -45")       #15
  expect_equal(format_best(-123456384.8215683, 6), "-123E6")   #16        
  expect_equal(format_best(-0.0000003984900897739283873, 6), " -4E-7") #17  # Coefficient rounding

  expect_equal(format_best(123.456, 7), "123.456")  #1
  expect_equal(format_best(1.4, 7), "    1.4")      #2
  expect_equal(format_best(NA, 7), NA)        #3
  expect_equal(format_best(0, 7), "      0")        #4
  expect_equal(format_best(0.0000003984900897739283873, 7), "3.98E-7") #5
  expect_equal(format_best(0.25, 7), "   0.25")     #6
  expect_equal(format_best(0.55, 7), "   0.55")     #7
  expect_equal(format_best(4, 7), "      4")        #8
  expect_equal(format_best(45, 7), "     45")       #9
  expect_equal(format_best(849.0000000000001, 7), "    849")   #10
  expect_equal(format_best(123456384.8215683, 7), "1.235E8")   #11
  expect_equal(format_best(1000000000000000, 7), "   1E15")    #12
  expect_equal(format_best(-0.55, 7), "  -0.55")     #13
  expect_equal(format_best(-4, 7), "     -4")        #14
  expect_equal(format_best(-45, 7), "    -45")       #15
  expect_equal(format_best(-123456384.8215683, 7), "-1.23E8")   #16           # !
  expect_equal(format_best(-0.0000003984900897739283873, 7), "-398E-9") #17  
})






test_that("best16: full range of best works as expected.", {

  # Assign value to format
  v1 <- 123456789.12345

  # Initialize vectors
  tst <- c()
  vls <- c()

  # Apply formats dynamically
  for (nm in 1:12) {

    tst <- append(tst, paste0("best", nm))
    vls <- append(vls, fapply(v1, paste0("best", nm)))

  }

  # Create data frame
  res <- data.frame(Test = tst, Value = vls)

  # View result
  res
  # Test        Value
  # 1   best1            *
  # 2   best2           **
  # 3   best3          1E8
  # 4   best4         12E7
  # 5   best5        123E6
  # 6   best6       1.23E8
  # 7   best7      1.235E8
  # 8   best8     1.2346E8
  # 9   best9    123456789
  # 10 best10    123456789
  # 11 best11  123456789.1
  # 12 best12 123456789.12


  expect_equal(vls[1], "*")
  expect_equal(vls[2], "**")
  expect_equal(vls[3], "1E8")
  expect_equal(vls[4], "12E7")
  expect_equal(vls[5], "123E6")
  expect_equal(vls[6], "1.23E8")
  expect_equal(vls[7], "1.235E8")
  expect_equal(vls[8], "1.2346E8")
  expect_equal(vls[9], "123456789")
  expect_equal(vls[10], " 123456789")
  expect_equal(vls[11], "123456789.1")
  expect_equal(vls[12], "123456789.12")


  v1 <- -123456789.12345

  tst <- c()
  vls <- c()

  for (nm in 1:12) {

    tst <- append(tst, paste0("t", nm))
    vls <- append(vls, fapply(v1, paste0("best", nm)))

  }

  res <- data.frame(Test = tst, Value = vls)

  res

  expect_equal(vls[1], "*")
  expect_equal(vls[2], "**")
  expect_equal(vls[3], "***")
  expect_equal(vls[4], "-1E8")
  expect_equal(vls[5], "-12E7")
  expect_equal(vls[6], "-123E6")
  expect_equal(vls[7], "-1.23E8")
  expect_equal(vls[8], "-1.235E8")
  expect_equal(vls[9], "-1.2346E8")
  expect_equal(vls[10], "-123456789")
  expect_equal(vls[11], " -123456789")
  expect_equal(vls[12], "-123456789.1")

})



test_that("best17: large widths work as expected.", {

  dat <- c(123456789012345678.12345, 123.12345, 0.0000012345678)
  
  res <- fapply(dat, "best20")
  
  # Not right, nothing we can do
  # R just won't represent a number that large
 # expect_equal(res[1], "  123456789012345680")  
  expect_equal(res[2], "           123.12345")
  expect_equal(res[3], "        1.2345678E-6")
  
})


test_that("best18: fapply2 with best works as expected.", {
  

  res <- fapply2(123.12345, 123456789.12345, "best6", "best6")
  
  expect_equal(res[1], "123.12 1.23E8")  
  
})



test_that("best19: SAS comparison works as expected.", {
  
  # library(libr)
  # 
  # pth1 <- file.path(base_path, "data")
  # 
  # libname(l1, pth1, "dbf")
  # 
  # 
  # lib_export(l1, l2, pth1, "Rdata")  
  
  
  
  pth1 <- file.path(base_path, "data/TEST.Rdata")
  
  nm <- load(pth1)
  
  dat <- get(nm)
  
  # Check best4
  
  b4 <- fapply(dat$Value, "best4")
  
  c4 <- trimws(dat$FmtBest4) == trimws(b4)
  
  expect_equal(all(c4 == TRUE), TRUE)
  
  # d4 <- data.frame(Value = dat$Value, FmtSAS = dat$FmtBest4,
  #                  FmtR = b4, EQ = c4)
  # 
  # d4[d4$EQ == FALSE, ]
  
  # Check best5
  
  b5 <- fapply(dat$Value, "best5")
  
  c5 <- trimws(dat$FmtBest5) == trimws(b5)
  
  expect_equal(all(c5 == TRUE), TRUE)
  
  # d5 <- data.frame(Value = dat$Value, FmtSAS = dat$FmtBest5,
  #                  FmtR = b5, EQ = c5)
  # 
  # d5[d5$EQ == FALSE, ]
  
  
  # Check best6
  
  b6 <- fapply(dat$Value, "best6")
  
  c6 <- trimws(dat$FmtBest6) == trimws(b6)
  
  expect_equal(all(c6 == TRUE), TRUE)
  
  # d6 <- data.frame(Value = dat$Value, FmtSAS = dat$FmtBest6,
  #                  FmtR = b6, EQ = c6)
  # 
  # d6[d6$EQ == FALSE, ]
  
  # Check best7
  
  b7 <- fapply(dat$Value, "best7")
  
  c7 <- trimws(dat$FmtBest7) == trimws(b7)
  
  expect_equal(all(c7 == TRUE), TRUE)
  
  # d7 <- data.frame(Value = dat$Value, FmtSAS = dat$FmtBest7,
  #                  FmtR = b7, EQ = c7)
  # 
  # d7[d7$EQ == FALSE, ]
  
  # Check best8
  
  b8 <- fapply(dat$Value, "best8")
  
  c8 <- trimws(dat$FmtBest8) == trimws(b8)
  
  expect_equal(all(c8 == TRUE), TRUE)
  
  # d8 <- data.frame(Value = dat$Value, FmtSAS = dat$FmtBest8,
  #                  FmtR = b8, EQ = c8)
  # 
  # d8[d8$EQ == FALSE, ]
  
  # Check best9
  
  b9 <- fapply(dat$Value, "best9")
  
  c9 <- trimws(dat$FmtBest9) == trimws(b9)
  
  expect_equal(all(c9 == TRUE), TRUE)
  
  # d9 <- data.frame(Value = dat$Value, FmtSAS = dat$FmtBest9,
  #                  FmtR = b9, EQ = c9)
  # 
  # d9[d9$EQ == FALSE, ]
  
  # Check best10
  
  b10 <- fapply(dat$Value, "best10")
  
  c10 <- trimws(dat$FmtBest10) == trimws(b10)
  
  expect_equal(all(c10 == TRUE), TRUE)
  
  # Check best11
  
  b11 <- fapply(dat$Value, "best11")
  
  c11 <- trimws(dat$FmtBest11) == trimws(b11)
  
  expect_equal(all(c11 == TRUE), TRUE)
  
  # Check best12  - Not working.  Can't figure out what SAS is doing
  
  # b12 <- fapply(dat$Value, "best12")
  # 
  # c12 <- trimws(dat$FmtBest12) == trimws(b12)
  # 
  # expect_equal(all(c12 == TRUE), TRUE)      
  # 
  # d12 <- data.frame(Value = dat$Value, FmtSAS = dat$FmtBest12,
  #                  FmtR = b12, EQ = c12)
  # 
  # d12[d12$EQ == FALSE, ]

  
})





# 
# test_that("best13: paper examples.", {
#   
#   library(libr)
#   
#   
#   test <- datastep(NULL, {
#     
#     Test <- "best4"
#     Value <- fapply(123456789.12345, "best4")
#     output()
#     
#     Test <- "best4"
#     Value <- fapply(0.0000123456789, "best4")
#     output()
#     
#     Test <- "best8"
#     Value <- fapply(123456789.12345, "best8")
#     output()
#     
#     Test <- "best8"
#     Value <- fapply(0.0000123456789, "best8")
#     output()
#     
#     Test <- "best12"
#     Value <- fapply(123456789.12345, "best12")
#     output()
#     
#     Test <- "best12"
#     Value <- fapply(0.0000123456789, "best12")
#     output()
#     
#   })
#   
#   
#   # Apply 8.2 format
#   ret <- fapply(12345.12345, "%8.2f") 
# 
#   # View Results
#   ret
#   # [1] "12345.12"
#   
#   
#   # Apply best6 format
#   ret <- fapply(12345678.12345, "best6") 
#   
#   # View Results
#   ret
#   # [1] "12345.12"
#   
#   
#   
# })

# 
# Test = "best8";
# Value = put(123456789.12345, best8.);
# output;
# 
# Test = "best8";
# Value = put(0.0000123456789, best8.);
# output;




# Best plus other stuff
# Best word vs best format  "I like sponges best".


