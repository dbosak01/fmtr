# context("best Tests")
# 
# options("logr.output" = FALSE)
# 
# 
# 
# test_that("best1: sas_sci works as expected with positive values.", {
#   
#   
#   v2 <- c(0.0000003984900897739283873,  123456384821000000000.5683, 1000000000000000)
#   
#   res1 <- sas_sci(v2[1], 12)
#   
#   expect_equal(res1, "3.9849009E-7")
#   
#   res2 <- sas_sci(v2[2], 12)
#   
#   expect_equal(res2, "1.2345638E20")
#   
#   res3 <- sas_sci(v2[3], 12)
#   
#   expect_equal(res3, "1E15")
#   
#   
# })
# 
# test_that("best2: sas_sci works as expected with negative values.", {
#   
#   
#   v2 <- c(-0.0000003984900897739283873, -123456384821000000000.5683, -1000000000000000)
#   
#   res1 <- sas_sci(v2[1], 12)
#   
#   expect_equal(res1, "-3.984901E-7")
#   
#   res2 <- sas_sci(v2[2], 12)
#   
#   expect_equal(res2, "-1.234564E20")
#   
#   res3 <- sas_sci(v2[3], 12)
#   
#   expect_equal(res3, "-1E15")
#   
# })
# 
# 
# test_that("best3: get_offset() works as expected.", {
#   
#   v1 <- c(0.000123, 12356.632, 1000000000, 1000000000000000)
#   
#   r1 <- get_offset(v1[1], 3)
#   
#   expect_equal(r1, 0)
#   
#   r2 <- get_offset(v1[2], 3)
#   
#   expect_equal(r2, 4)
#   
#   r3 <- get_offset(v1[3], 3)
#   
#   expect_equal(r3, 9)
#   
#   r4 <- get_offset(v1[4], 4)
#   
#   expect_equal(r4, 15)
#   
#   r5 <- get_offset(v1[3], 5)
#   
#   expect_equal(r3, 9)
#   
#   r6 <- get_offset(v1[4], 5)
#   
#   expect_equal(r4, 15)
#   
# })
# 
# 
# 
# test_that("best4: mod_sci works as expected with positive values.", {
#   
#   
#   v2 <- c(123456789.12345,  0.00000012345678912345, 1000000000000000)
#   
#   res1 <- mod_sci(v2[1], 3)
#   
#   expect_equal(res1, "1E8")
#   
#   res1 <- mod_sci(v2[1], 4)
#   
#   expect_equal(res1, "12E7")
#   
#   res1 <- mod_sci(v2[1], 5)
#   
#   expect_equal(res1, "123E6")
#   
#   
#   res1 <- mod_sci(v2[2], 3)
#   
#   expect_equal(res1, "0")
#   
#   res1 <- mod_sci(v2[2], 4)
#   
#   expect_equal(res1, "0")
#   
#   res1 <- mod_sci(v2[2], 5)
#   
#   expect_equal(res1, "12E-8")     # Problem
#   
#   
#   res1 <- mod_sci(v2[2], 6)
#   
#   expect_equal(res1, "123E-9")
#   
#   
#   res1 <- mod_sci(v2[3], 4)
#   
#   expect_equal(res1, "1E15")
#   
#   res1 <- mod_sci(v2[3], 5)
#   
#   expect_equal(res1, "1E15")
#   
# })
# 
# test_that("best5: mod_sci works as expected with negative values.", {
#   
#   
#   v2 <- c(-0.0000003984900897739283873,  -123456384821000000000.5683, -1000000000000000)
#   
#   res1 <- sas_sci(v2[1], 12)
#   
#   expect_equal(res1, "-3.984901E-7")
#   
#   res2 <- sas_sci(v2[2], 12)
#   
#   expect_equal(res2, "-1.234564E20")
#   
#   res3 <- sas_sci(v2[3], 12)
#   
#   expect_equal(res3, "-1E15")
#   
# })
# 
# test_that("best6: mod_sci widths works as expected.", {
#   
#   expect_equal(mod_sci(123.456, 1), "*")  #1
#   expect_equal(mod_sci(1.4, 1), "1")      #2
#   expect_equal(mod_sci(NA, 1), NA)        #3
#   expect_equal(mod_sci(0, 1), "0")        #4
#   expect_equal(mod_sci(0.0000003984900897739283873, 1), "0") #5
#   expect_equal(mod_sci(0.25, 1), "0")     #6
#   expect_equal(mod_sci(0.55, 1), "1")     #7
#   expect_equal(mod_sci(4, 1), "4")        #8
#   expect_equal(mod_sci(45, 1), "*")       #9
#   expect_equal(mod_sci(849.0000000000001, 1), "*")   #10
#   expect_equal(mod_sci(123456384.8215683, 1), "*")   #11
#   expect_equal(mod_sci(1000000000000000, 1), "*")    #12
#   expect_equal(mod_sci(-0.55, 1), "*")     #13
#   expect_equal(mod_sci(-4, 1), "*")        #14
#   expect_equal(mod_sci(-45, 1), "*")       #15
#   
#   
#   expect_equal(mod_sci(123.456, 2), "**")  #1
#   expect_equal(mod_sci(1.4, 2), "1")      #2
#   expect_equal(mod_sci(NA, 2), NA)        #3
#   expect_equal(mod_sci(0, 2), "0")        #4
#   expect_equal(mod_sci(0.0000003984900897739283873, 2), "0") #5
#   expect_equal(mod_sci(0.25, 2), "0")     #6
#   expect_equal(mod_sci(0.55, 2), "1")     #7
#   expect_equal(mod_sci(4, 2), "4")        #8
#   expect_equal(mod_sci(45, 2), "45")       #9
#   expect_equal(mod_sci(849.0000000000001, 2), "**")   #10
#   expect_equal(mod_sci(123456384.8215683, 2), "**")   #11
#   expect_equal(mod_sci(1000000000000000, 2), "**")    #12
#   expect_equal(mod_sci(-0.55, 2), "-1")     #13
#   expect_equal(mod_sci(-4, 2), "-4")        #14
#   expect_equal(mod_sci(-45, 2), "**")       #15
#   
#   
#   expect_equal(mod_sci(123.456, 3), "123")  #1
#   expect_equal(mod_sci(1.4, 3), "1.4")      #2
#   expect_equal(mod_sci(NA, 3), NA)        #3
#   expect_equal(mod_sci(0, 3), "0")        #4
#   expect_equal(mod_sci(0.0000003984900897739283873, 3), "0") #5
#   expect_equal(mod_sci(0.25, 3), ".25")     #6                   # !
#   expect_equal(mod_sci(0.55, 3), ".55")     #7
#   expect_equal(mod_sci(4, 3), "4")        #8
#   expect_equal(mod_sci(45, 3), "45")       #9
#   expect_equal(mod_sci(849.0000000000001, 3), "849")   #10
#   expect_equal(mod_sci(123456384.8215683, 3), "1E8")   #11
#   expect_equal(mod_sci(1000000000000000, 3), "***")    #12
#   expect_equal(mod_sci(-0.55, 3), "-.6")     #13               
#   expect_equal(mod_sci(-4, 3), "-4")        #14
#   expect_equal(mod_sci(-45, 3), "-45")       #15
#   
#   
#   expect_equal(mod_sci(123.456, 4), "123")  #1
#   expect_equal(mod_sci(1.4, 4), "1.4")      #2
#   expect_equal(mod_sci(NA, 4), NA)        #3
#   expect_equal(mod_sci(0, 4), "0")        #4
#   expect_equal(mod_sci(0.0000003984900897739283873, 4), "0") #5a
#   expect_equal(mod_sci(0.000003984900897739283873, 4), "0") #5b
#   expect_equal(mod_sci(0.00003944900897739283873, 4), "0") #5c
#   expect_equal(mod_sci(0.03944900897739283873, 4), "0.04") #5d
#   expect_equal(mod_sci(0.03984900897739283873, 4), "0.04") #5e
#   expect_equal(mod_sci(0.25, 4), "0.25")     #6
#   expect_equal(mod_sci(0.55, 4), "0.55")     #7
#   expect_equal(mod_sci(4, 4), "4")        #8
#   expect_equal(mod_sci(45, 4), "45")       #9
#   expect_equal(mod_sci(849.0000000000001, 4), "849")   #10
#   expect_equal(mod_sci(123456384.8215683, 4), "12E7")   #11
#   expect_equal(mod_sci(1000000000000000, 4), "1E15")    #12
#   expect_equal(mod_sci(-0.55, 4), "-.55")     #13
#   expect_equal(mod_sci(-4, 4), "-4")        #14
#   expect_equal(mod_sci(-45, 4), "-45")       #15
#   expect_equal(mod_sci(-123456384.8215683, 4), "-1E8")   #16
#   expect_equal(mod_sci(-0.0000003984900897739283873, 4), "0") #17   # !
#   
#   
#   expect_equal(mod_sci(123.456, 5), "123.5")  #1
#   expect_equal(mod_sci(1.4, 5), "1.4")      #2
#   expect_equal(mod_sci(NA, 5), NA)        #3
#   expect_equal(mod_sci(0, 5), "0")        #4
#   expect_equal(mod_sci(0.0000003984900897739283873, 5), "4E-7") #5a
#   expect_equal(mod_sci(0.000003984900897739283873, 5), "4E-6") #5b
#   expect_equal(mod_sci(0.00003944900897739283873, 5), "39E-6") #5c
#   expect_equal(mod_sci(0.03944900897739283873, 5), "0.039") #5d
#   expect_equal(mod_sci(0.03984900897739283873, 5), "0.04") #5e
#   expect_equal(mod_sci(0.25, 5), "0.25")     #6
#   expect_equal(mod_sci(0.55, 5), "0.55")     #7
#   expect_equal(mod_sci(4, 5), "4")        #8
#   expect_equal(mod_sci(45, 5), "45")       #9
#   expect_equal(mod_sci(849.0000000000001, 5), "849")   #10
#   expect_equal(mod_sci(123456384.8215683, 5), "123E6")   #11
#   expect_equal(mod_sci(1000000000000000, 5), "1E15")    #12          
#   expect_equal(mod_sci(-0.55, 5), "-0.55")     #13
#   expect_equal(mod_sci(-4, 5), "-4")        #14
#   expect_equal(mod_sci(-45, 5), "-45")       #15
#   expect_equal(mod_sci(-123456384.8215683, 5), "-12E7")   #16
#   expect_equal(mod_sci(-0.0000003984900897739283873, 5), "-0") #17   # !
#   
#   
#   expect_equal(fapply(123.456, "best6"), "123.46")  #1
#   expect_equal(fapply(1.4, "best6"), "1.4")      #2
#   expect_equal(mod_sci(NA, 6), NA)        #3
#   expect_equal(mod_sci(0, 6), "0")        #4
#   expect_equal(mod_sci(0.0000003984900897739283873, 6), "398E-9") #5
#   expect_equal(mod_sci(0.25, 6), "0.25")     #6
#   expect_equal(mod_sci(0.55, 6), "0.55")     #7
#   expect_equal(fapply(4, "best6"), "4")        #8
#   expect_equal(fapply(45, "best6"), "45")       #9
#   expect_equal(fapply(849.0000000000001, "best6"), "849")   #10
#   expect_equal(mod_sci(123456384.8215683, 6), "1.23E8")   #11
#   expect_equal(mod_sci(1000000000000000, 6), "1E15")    #12
#   expect_equal(mod_sci(-0.55, 6), "-0.55")     #13
#   expect_equal(mod_sci(-4, 6), "-4")        #14
#   expect_equal(mod_sci(-45, 6), "-45")       #15
#   expect_equal(mod_sci(-123456384.8215683, 6), "-123E6")   #16
#   expect_equal(mod_sci(-0.0000003984900897739283873, 6), "-4E-7") #17
#   
#   expect_equal(fapply(123.456, "best7"), "123.456")  #1
#   expect_equal(fapply(1.4, "best7"), "1.4")      #2
#   expect_equal(mod_sci(NA, 7), NA)        #3
#   expect_equal(mod_sci(0, 7), "0")        #4
#   expect_equal(mod_sci(0.0000003984900897739283873, 7), "3.98E-7") #5   
#   expect_equal(fapply(0.25, "best7"), "0.25")     #6
#   expect_equal(fapply(0.55, "best7"), "0.55")     #7
#   expect_equal(fapply(4, "best7"), "4")        #8
#   expect_equal(fapply(45, "best7"), "45")       #9
#   expect_equal(fapply(849.0000000000001, "best7"), "849")   #10
#   expect_equal(mod_sci(123456384.8215683, 7), "1.235E8")   #11
#   expect_equal(mod_sci(1000000000000000, 7), "1E15")    #12
#   expect_equal(mod_sci(-0.55, 7), "-0.55")     #13
#   expect_equal(fapply(-4, "best7"), "-4")        #14
#   expect_equal(fapply(-45, "best7"), "-45")       #15
#   expect_equal(mod_sci(-123456384.8215683, 7), "-1.23E8")   #16
#   expect_equal(mod_sci(-0.0000003984900897739283873, 7), "-398E-9") #17
# })
# 
# 
# 
# test_that("best7: format_best works as expected.", {
#   
#   v1 <- c(123.456778910248, 12.384883832456, 1456.2468483838833,
#           1.4, NA, 0.0000003984900897739283873,
#           0.00003984900897739283873, 0,
#           849.0000000000001
#   )
#   
#   res <- format_best(v1, 6)
#   
#   res
#   
#   expect_equal(res[1], "123.46")
#   expect_equal(res[2], "12.385")
#   expect_equal(res[3], "1456.2")
#   expect_equal(res[4], "1.4")
#   expect_equal(is.na(res[5]), TRUE)
#   
#   
#   res <- format_best(v1, 12)
#   
#   res
#   
#   expect_equal(res[1], "123.45677891")
#   expect_equal(res[2], "12.384883832")
#   expect_equal(res[3], "1456.2468484")
#   expect_equal(res[4], "1.4")
#   expect_equal(is.na(res[5]), TRUE)
#   expect_equal(res[6], "3.9849009E-7")
#   expect_equal(res[7], "0.000039849")
#   expect_equal(res[8], "0")
#   expect_equal(res[9], "849")
#   
#   
# })
# 
# 
# test_that("best8: fapply with best(12) format works as expected.", {
#   
#   
#   v1 <- c(t1 = 123.456778910248, 
#           t2 = 12.384883832456, 
#           t3 = 1456.2468483838833,
#           t4 = 1.4, 
#           t5 = NA, 
#           t6 = 0.0000003984900897739283873,
#           t7 = 0.00003984900897739283873, 
#           t8 = 0,
#           t9 = .25,
#           t10 = .55,
#           t11 = 849.0000000000001, 
#           t12 = 123456.3848215683, 
#           t13 = 123456384.8215683,
#           t14 = 123456384821.5683, 
#           t15 = 1234563848210.5683,
#           t16 = 123456384821000000000.5683,
#           t17 = 1000000000000000
#   )
#   
#   res <- fapply(v1, "best")
#   
#   # res <- fapply(849.0000000000001, "best")
#   
#   # fapply(0.0000003984900897739283873, "best")
#   
#   res
#   
#   expect_equal(res[[1]], "123.45677891")
#   expect_equal(res[[2]], "12.384883832")
#   expect_equal(res[[3]], "1456.2468484")
#   expect_equal(res[[4]], "1.4")
#   expect_equal(is.na(res[[5]]), TRUE)
#   expect_equal(res[[6]], "3.9849009E-7")
#   expect_equal(res[[7]], "0.000039849")
#   expect_equal(res[[8]], "0")
#   expect_equal(res[[9]], "0.25")
#   expect_equal(res[[10]], "0.55")
#   expect_equal(res[[11]], "849")
#   expect_equal(res[[12]], "123456.38482")
#   expect_equal(res[[13]], "123456384.82")
#   expect_equal(res[[14]], "123456384822")
#   expect_equal(res[[15]], "1.2345638E12")
#   expect_equal(res[[16]], "1.2345638E20")
#   expect_equal(res[[17]], "1E15")
#   
#   
#   # Just test a couple. Should be same.
#   res2 <- fapply(v1, "best12")
#   
#   res2
#   
#   expect_equal(res2[[1]], "123.45677891")
#   expect_equal(res2[[2]], "12.384883832")
#   
#   
#   
# })
# 
# test_that("best9: fapply with best(12) format works as expected negative numbers.", {
#   
#   
#   v1 <- c(t1 = -123.456778910248, 
#           t2 = -12.384883832456, 
#           t3 = -1456.2468483838833,
#           t4 = -1.4, 
#           t5 = NA, 
#           t6 = -0.0000003984900897739283873,
#           t7 = -0.00003984900897739283873, 
#           t8 = 0,
#           t9 = -.25,
#           t10 = -.55,
#           t11 = -849.0000000000001, 
#           t12 = -123456.3848215683, 
#           t13 = -123456384.8215683,
#           t14 = -123456384821.5683, 
#           t15 = -1234563848210.5683,
#           t16 = -123456384821000000000.5683,
#           t17 = -1000000000000000
#   )
#   
#   res <- fapply(v1, "best")
#   
#   # res <- fapply(849.0000000000001, "best")
#   
#   # fapply(0.0000003984900897739283873, "best")
#   
#   res
#   
#   expect_equal(res[[1]], "-123.4567789")
#   expect_equal(res[[2]], "-12.38488383")
#   expect_equal(res[[3]], "-1456.246848")
#   expect_equal(res[[4]], "-1.4")
#   expect_equal(is.na(res[[5]]), TRUE)
#   expect_equal(res[[6]], "-3.984901E-7")
#   expect_equal(res[[7]], "-0.000039849")
#   expect_equal(res[[8]], "0")
#   expect_equal(res[[9]], "-0.25")
#   expect_equal(res[[10]], "-0.55")
#   expect_equal(res[[11]], "-849")
#   expect_equal(res[[12]], "-123456.3848")
#   expect_equal(res[[13]], "-123456384.8")
#   expect_equal(res[[14]], "-1.234564E11")
#   expect_equal(res[[15]], "-1.234564E12")
#   expect_equal(res[[16]], "-1.234564E20")
#   expect_equal(res[[17]], "-1E15")
#   
#   
#   # Just test a couple. Should be same.
#   res2 <- fapply(v1, "best12")
#   
#   res2
#   
#   expect_equal(res2[[1]], "-123.4567789")
#   expect_equal(res2[[2]], "-12.38488383")
#   
#   
#   
# })
# 
# test_that("best10: fapply with best(8) format works as expected.", {
#   
#   
#   v1 <- c(t1 = 123.456778910248, 
#           t2 = 12.384883832456, 
#           t3 = 1456.2468483838833,
#           t4 = 1.4, 
#           t5 = NA, 
#           t6 = 0.0000003984900897739283873,
#           t7 = 0.00003984900897739283873, 
#           t8 = 0,
#           t9 = .25,
#           t10 = .55,
#           t11 = 849.0000000000001, 
#           t12 = 123456.3848215683, 
#           t13 = 123456384.8215683,
#           t14 = 123456384821.5683, 
#           t15 = 1234563848210.5683,
#           t16 = 123456384821000000000.5683,
#           t17 = 1000000000000000
#   )
#   
#   res <- fapply(v1, "best8")
#   
#   res
#   
#   expect_equal(res[[1]], "123.4568")
#   expect_equal(res[[2]], "12.38488")
#   expect_equal(res[[3]], "1456.247")
#   expect_equal(res[[4]], "1.4")
#   expect_equal(is.na(res[[5]]), TRUE)
#   expect_equal(res[[6]], "3.985E-7")
#   expect_equal(res[[7]], "0.00004")
#   expect_equal(res[[8]], "0")
#   expect_equal(res[[9]], "0.25")
#   expect_equal(res[[10]], "0.55")
#   expect_equal(res[[11]], "849")
#   expect_equal(res[[12]], "123456.4")
#   expect_equal(res[[13]], "1.2346E8")
#   expect_equal(res[[14]], "1.235E11")
#   expect_equal(res[[15]], "1.235E12")
#   expect_equal(res[[16]], "1.235E20")
#   expect_equal(res[[17]], "1E15")
#   
#   
#   v2 <- c(t1 = -123.456778910248, 
#           t2 = -12.384883832456, 
#           t3 = -1456.2468483838833,
#           t4 = -1.4, 
#           t5 = NA, 
#           t6 = -0.0000003984900897739283873,
#           t7 = -0.00003984900897739283873, 
#           t8 = 0,
#           t9 = -.25,
#           t10 = -.55,
#           t11 = -849.0000000000001, 
#           t12 = -123456.3848215683, 
#           t13 = -123456384.8215683,
#           t14 = -123456384821.5683, 
#           t15 = -1234563848210.5683,
#           t16 = -123456384821000000000.5683,
#           t17 = -1000000000000000
#   )
#   
#   res2 <- fapply(v2, "best8")
#   
#   res2
#   
#   expect_equal(res2[[1]], "-123.457")
#   expect_equal(res2[[2]], "-12.3849")
#   expect_equal(res2[[3]], "-1456.25")
#   expect_equal(res2[[4]], "-1.4")
#   expect_equal(is.na(res2[[5]]), TRUE)
#   expect_equal(res2[[6]], "-3.98E-7")
#   expect_equal(res2[[7]], "-0.00004")
#   expect_equal(res2[[8]], "0")
#   expect_equal(res2[[9]], "-0.25")
#   expect_equal(res2[[10]], "-0.55")
#   expect_equal(res2[[11]], "-849")
#   expect_equal(res2[[12]], "-123456")
#   expect_equal(res2[[13]], "-1.235E8")
#   expect_equal(res2[[14]], "-1.23E11")
#   expect_equal(res2[[15]], "-1.23E12")
#   expect_equal(res2[[16]], "-1.23E20")
#   expect_equal(res2[[17]], "-1E15")
#   
#   
# })
# 
# 
# test_that("best11: fapply with best(6) format works as expected.", {
#   
#   
#   v1 <- c(t1 = 123.456778910248, 
#           t2 = 12.384883832456, 
#           t3 = 1456.2468483838833,
#           t4 = 1.4, 
#           t5 = NA, 
#           t6 = 0.0000003984900897739283873,
#           t7 = 0.00003984900897739283873, 
#           t8 = 0,
#           t9 = .25,
#           t10 = .55,
#           t11 = 849.0000000000001, 
#           t12 = 123456.3848215683, 
#           t13 = 123456384.8215683,
#           t14 = 123456384821.5683, 
#           t15 = 1234563848210.5683,
#           t16 = 123456384821000000000.5683,
#           t17 = 1000000000000000
#   )
#   
#   res <- fapply(v1, "best6")
#   
#   res
#   
#   expect_equal(res[[1]], "123.46")
#   expect_equal(res[[2]], "12.385")
#   expect_equal(res[[3]], "1456.2")
#   expect_equal(res[[4]], "   1.4")
#   expect_equal(is.na(res[[5]]), TRUE)
#   expect_equal(res[[6]], "398E-9")
#   expect_equal(res[[7]], "398E-7")
#   expect_equal(res[[8]], "     0")
#   expect_equal(res[[9]], "  0.25")
#   expect_equal(res[[10]], "  0.55")
#   expect_equal(res[[11]], "   849")
#   expect_equal(res[[12]], "123456")
#   expect_equal(res[[13]], "1.23E8")
#   expect_equal(res[[14]], " 123E9")
#   expect_equal(res[[15]], "1235E9")
#   expect_equal(res[[16]], "123E18")
#   expect_equal(res[[17]], "  1E15")
#   
#   
#   v2 <- c(t1 = -123.456778910248, 
#           t2 = -12.384883832456, 
#           t3 = -1456.2468483838833,
#           t4 = -1.4, 
#           t5 = NA, 
#           t6 = -0.0000003984900897739283873,
#           t7 = -0.00003984900897739283873, 
#           t8 = 0,
#           t9 = -.25,
#           t10 = -.55,
#           t11 = -849.0000000000001, 
#           t12 = -123456.3848215683, 
#           t13 = -123456384.8215683,
#           t14 = -123456384821.5683, 
#           t15 = -1234563848210.5683,
#           t16 = -123456384821000000000.5683,
#           t17 = -1000000000000000
#   )
#   
#   res2 <- fapply(v2, "best6")
#   
#   res2
#   
#   expect_equal(res2[[1]], "-123.5")
#   expect_equal(res2[[2]], "-12.38")
#   expect_equal(res2[[3]], " -1456")
#   expect_equal(res2[[4]], "  -1.4")
#   expect_equal(is.na(res2[[5]]), TRUE)
#   expect_equal(res2[[6]], " -4E-7")
#   expect_equal(res2[[7]], " -4E-5")
#   expect_equal(res2[[8]], "     0")
#   expect_equal(res2[[9]], " -0.25")
#   expect_equal(res2[[10]], " -0.55")
#   expect_equal(res2[[11]], "  -849")
#   expect_equal(res2[[12]], "-123E3")
#   expect_equal(res2[[13]], "-123E6")
#   expect_equal(res2[[14]], "-123E9")
#   expect_equal(res2[[15]], "-12E11")
#   expect_equal(res2[[16]], "-12E19")
#   expect_equal(res2[[17]], " -1E15")
#   
#   
# })
# 
# 
# 
# test_that("best12: full range of best works as expected.", {
#   
#   # Assign value to format
#   v1 <- 123456789.12345
#   
#   # Initialize vectors
#   tst <- c()
#   vls <- c()
#   
#   # Apply formats dynamically
#   for (nm in 1:12) {
#     
#     tst <- append(tst, paste0("best", nm))
#     vls <- append(vls, fapply(v1, paste0("best", nm)))
#     
#   }
#   
#   # Create data frame
#   res <- data.frame(Test = tst, Value = vls)
#   
#   # View result
#   res
#   # Test        Value
#   # 1   best1            *
#   # 2   best2           **
#   # 3   best3          1E8
#   # 4   best4         12E7
#   # 5   best5        123E6
#   # 6   best6       1.23E8
#   # 7   best7      1.235E8
#   # 8   best8     1.2346E8
#   # 9   best9    123456789
#   # 10 best10    123456789
#   # 11 best11  123456789.1
#   # 12 best12 123456789.12
#   
#   
#   expect_equal(vls[1], "*")
#   expect_equal(vls[2], "**")
#   expect_equal(vls[3], "1E8")
#   expect_equal(vls[4], "12E7")
#   expect_equal(vls[5], "123E6")
#   expect_equal(vls[6], "1.23E8")
#   expect_equal(vls[7], "1.235E8")
#   expect_equal(vls[8], "1.2346E8")
#   expect_equal(vls[9], "123456789")
#   expect_equal(vls[10], " 123456789")
#   expect_equal(vls[11], "123456789.1")
#   expect_equal(vls[12], "123456789.12")
#   
#   
#   v1 <- -123456789.12345
#   
#   tst <- c()
#   vls <- c()
#   
#   for (nm in 1:12) {
#     
#     tst <- append(tst, paste0("t", nm))
#     vls <- append(vls, fapply(v1, paste0("best", nm)))
#     
#   }
#   
#   res <- data.frame(Test = tst, Value = vls)
#   
#   res
#   
#   expect_equal(vls[1], "*")
#   expect_equal(vls[2], "**")
#   expect_equal(vls[3], "***")
#   expect_equal(vls[4], "-1E8")
#   expect_equal(vls[5], "-12E7")
#   expect_equal(vls[6], "-123E6")
#   expect_equal(vls[7], "-1.23E8")
#   expect_equal(vls[8], "-1.235E8")
#   expect_equal(vls[9], "-1.2346E8")
#   expect_equal(vls[10], "-123456789")
#   expect_equal(vls[11], " -123456789")
#   expect_equal(vls[12], "-123456789.1")
#   
# })
# 
# 
# test_that("best13: fapply with best(7) format works as expected.", {
#   
#   
#   expect_equal(fapply(123456789.12345, "best7"), "1.235E8")
#   expect_equal(fapply(-123456789.12345, "best7"), "-1.23E8")
#   expect_equal(fapply(0.0000012345678912345, "best7"), "1.23E-6")
#   expect_equal(fapply(-0.0000012345678912345, "best7"), "-123E-8")
#   
#   
#   v1 <- c(t1 = 123.456, 
#           t2 = 1.4, 
#           t3 = NA, 
#           t4 = 0,
#           t5 = 0.0000003984900897739283873,
#           t6 = .25,
#           t7 = .55,
#           t8 = 4,
#           t9 = 45,
#           t10 = 849.0000000000001, 
#           t11 = 123456384.8215683,
#           t12 = 1000000000000000,
#           t13 = -0.55, 
#           t14 = -4,
#           t15 = -45,
#           t16 = -123456384.8215683,
#           t17 = -0.0000003984900897739283873
#   )
#   
#   
#   
#   res <- fapply(v1, "best7")
#   
#   res
#   
#   expect_equal(res[1], "123.456")
#   expect_equal(res[2], "    1.4")
#   expect_equal(is.na(res[3]), TRUE)
#   expect_equal(res[4], "      0")
#   expect_equal(res[5], "3.98E-7")
#   expect_equal(res[6], "   0.25")
#   expect_equal(res[7], "   0.55")
#   expect_equal(res[8], "      4")
#   expect_equal(res[9], "     45")
#   expect_equal(res[10], "    849")
#   expect_equal(res[11], "1.235E8")
#   expect_equal(res[12], "   1E15")
#   expect_equal(res[13], "  -0.55")
#   expect_equal(res[14], "     -4")
#   expect_equal(res[15], "    -45")
#   expect_equal(res[16], "-1.23E8")
#   expect_equal(res[17], "-398E-9")
#   
# })
# 
# 
# test_that("best14: size_output() works as expected.", {
#   
#   
#   expect_equal(size_output("x", 1), "x")
#   expect_equal(size_output("x", 4), "   x")
#   expect_equal(size_output("xxxxx", 4), "xxxx")
#   expect_equal(size_output(NA, 4), NA)
#   
#   
# })
# 
# 
# test_that("best15: best padding works as expected.", {
#   
#   
#   expect_equal(fapply(1000000000, "best3"), "1E9")
#   expect_equal(fapply(1000000000, "best5"), "  1E9")
#   expect_equal(fapply(123456789, "best13"), "    123456789")
#   
#   
# })
# 
# test_that("best16: test error handling.", {
#   
#   
#   expect_warning(fapply(1000000000, "bestX"))
#   expect_error(fapply(1000000000, "best33"))
#   expect_error(fapply(1000000000, "best0"))
# })


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


