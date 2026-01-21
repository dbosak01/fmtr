context("Time Tests")

options("logr.output" = FALSE)

Sys.setenv("LANGUAGE" = "EN")

test_that("timewd1: test error handling.", {
  
  time <- 3600
  
  expect_error(fapply(time, "time1"))
  expect_error(fapply(time, "time21"))
  expect_error(fapply(time, "time10.11"))
  expect_warning(fapply(time, "timex")) 
  
})

test_that("timewd2: format_timewd() work as expected.", {

  v1 <- c(
    -3600,
    -1,
    -0.01,
    0,
    1,
    59,
    60,
    3599,
    3600,
    32399.9949,
    32399.995,
    86399.9949,
    86399.995,
    90000
  )
  v2 <- c(
    " 0:00:00",
    " 0:00:01",
    " 0:00:59",
    " 0:01:00",
    " 0:59:59",
    " 1:00:00",
    "8:59:59.9949",
    "8:59:59.995",
    "23:59:59.9949",
    "23:59:59.995"
  )
  time_num <- v1

  time_pos = strptime(v2, format="%H:%M:%OS")
  time_hms = hms::as_hms(v1)
  time_difftime = as.difftime(v1, units = "secs")

  # ---- TIME8. (no decimals) ----
  res1 <- format_timewd(time_num, 8)

  expect_equal(res1[1], "-1:00:00")
  expect_equal(res1[2], "-0:00:01")
  expect_equal(res1[3], "-0:00:00")
  expect_equal(res1[4], " 0:00:00")
  expect_equal(res1[5], " 0:00:01")
  expect_equal(res1[6], " 0:00:59")
  expect_equal(res1[7], " 0:01:00")
  expect_equal(res1[8], " 0:59:59")
  expect_equal(res1[9], " 1:00:00")
  expect_equal(res1[10], " 9:00:00")
  expect_equal(res1[11], " 9:00:00")
  expect_equal(res1[12], "24:00:00")
  expect_equal(res1[13], "24:00:00")
  expect_equal(res1[14], "25:00:00")

  res2 <- format_timewd(time_pos, 10, 3)


  expect_equal(res2[1], "0:00:00.00")
  expect_equal(res2[2], "0:00:01.00")
  expect_equal(res2[3], "0:00:59.00")
  expect_equal(res2[4], "0:01:00.00")
  expect_equal(res2[5], "0:59:59.00")
  expect_equal(res2[6], "1:00:00.00")
  expect_equal(res2[7], "8:59:59.99")
  expect_equal(res2[8], "9:00:00.00")
  expect_equal(res2[9], "24:00:00.0")
  expect_equal(res2[10], "24:00:00.0")


  # ---- TIME12.2 (2 decimals) ----
  res3 <- format_timewd(time_num, 12, 2)


  expect_equal(res3[1], " -1:00:00.00")
  expect_equal(res3[2], " -0:00:01.00")
  expect_equal(res3[3], " -0:00:00.01")
  expect_equal(res3[4], "  0:00:00.00")
  expect_equal(res3[5], "  0:00:01.00")
  expect_equal(res3[6], "  0:00:59.00")
  expect_equal(res3[7], "  0:01:00.00")
  expect_equal(res3[8], "  0:59:59.00")
  expect_equal(res3[9], "  1:00:00.00")
  expect_equal(res3[10], "  8:59:59.99")
  expect_equal(res3[11], "  9:00:00.00")
  expect_equal(res3[12], " 23:59:59.99")
  expect_equal(res3[13], " 24:00:00.00")
  expect_equal(res3[14], " 25:00:00.00")


  res4 <- format_timewd(time_pos, 15, 10)

  expect_equal(res4[1],  "0:00:00.0000000")
  expect_equal(res4[2],  "0:00:01.0000000")
  expect_equal(res4[3],  "0:00:59.0000000")
  expect_equal(res4[4],  "0:01:00.0000000")
  expect_equal(res4[5],  "0:59:59.0000000")
  expect_equal(res4[6],  "1:00:00.0000000")
  expect_equal(res4[7], "8:59:59.9949000")
  expect_equal(res4[8], "8:59:59.9950000")
  expect_equal(res4[9], "23:59:59.994900")
  expect_equal(res4[10], "23:59:59.995000")

  #tests for hms objects
  
  res5 <- format_timewd(time_hms, 8)
  
  expect_equal(res5[1], "-1:00:00")
  expect_equal(res5[2], "-0:00:01")
  expect_equal(res5[3], "-0:00:00")
  expect_equal(res5[4], " 0:00:00")
  expect_equal(res5[5], " 0:00:01")
  expect_equal(res5[6], " 0:00:59")
  expect_equal(res5[7], " 0:01:00")
  expect_equal(res5[8], " 0:59:59")
  expect_equal(res5[9], " 1:00:00")
  expect_equal(res5[10], " 9:00:00")
  expect_equal(res5[11], " 9:00:00")
  expect_equal(res5[12], "24:00:00")
  expect_equal(res5[13], "24:00:00")
  expect_equal(res5[14], "25:00:00")
  
  res6 <- format_timewd(time_hms, 12, 2)
  
  expect_equal(res6[1], " -1:00:00.00")
  expect_equal(res6[2], " -0:00:01.00")
  expect_equal(res6[3], " -0:00:00.01")
  expect_equal(res6[4], "  0:00:00.00")
  expect_equal(res6[5], "  0:00:01.00")
  expect_equal(res6[6], "  0:00:59.00")
  expect_equal(res6[7], "  0:01:00.00")
  expect_equal(res6[8], "  0:59:59.00")
  expect_equal(res6[9], "  1:00:00.00")
  expect_equal(res6[10], "  8:59:59.99")
  expect_equal(res6[11], "  9:00:00.00")
  expect_equal(res6[12], " 23:59:59.99")
  expect_equal(res6[13], " 24:00:00.00")
  expect_equal(res6[14], " 25:00:00.00")
  
  #tests for difftime objects
  
  res7 <- format_timewd(time_difftime, 8)
  
  expect_equal(res7[1], "-1:00:00")
  expect_equal(res7[2], "-0:00:01")
  expect_equal(res7[3], "-0:00:00")
  expect_equal(res7[4], " 0:00:00")
  expect_equal(res7[5], " 0:00:01")
  expect_equal(res7[6], " 0:00:59")
  expect_equal(res7[7], " 0:01:00")
  expect_equal(res7[8], " 0:59:59")
  expect_equal(res7[9], " 1:00:00")
  expect_equal(res7[10], " 9:00:00")
  expect_equal(res7[11], " 9:00:00")
  expect_equal(res7[12], "24:00:00")
  expect_equal(res7[13], "24:00:00")
  expect_equal(res7[14], "25:00:00")
  
  res8 <- format_timewd(time_difftime, 12, 2)
  
  expect_equal(res8[1], " -1:00:00.00")
  expect_equal(res8[2], " -0:00:01.00")
  expect_equal(res8[3], " -0:00:00.01")
  expect_equal(res8[4], "  0:00:00.00")
  expect_equal(res8[5], "  0:00:01.00")
  expect_equal(res8[6], "  0:00:59.00")
  expect_equal(res8[7], "  0:01:00.00")
  expect_equal(res8[8], "  0:59:59.00")
  expect_equal(res8[9], "  1:00:00.00")
  expect_equal(res8[10], "  8:59:59.99")
  expect_equal(res8[11], "  9:00:00.00")
  expect_equal(res8[12], " 23:59:59.99")
  expect_equal(res8[13], " 24:00:00.00")
  expect_equal(res8[14], " 25:00:00.00")

})

test_that("timewd3: as_character_time() work as expected ", {

  v1 <- c(3600,
          3790.12345,
          32399.995,
          35999.995,
          86399.9949,
          90000)

  res1 <- as_character_time(v1)

  expect_equal(res1[1], "1:00:00")
  expect_equal(res1[2], "1:03:10")
  expect_equal(res1[3], "8:59:59")
  expect_equal(res1[4], "9:59:59")
  expect_equal(res1[5], "23:59:59")
  expect_equal(res1[6], "25:00:00")

})

test_that("timewd4: noround_digit() work as expected", {

  v1 <- c(0.123456,
          0.91,
          0.9991,
          0.9949,
          0.995,
          0.999)



  expect_equal(noround_digit(v1[1]), 1)
  expect_equal(noround_digit(v1[2]), 1)
  expect_equal(noround_digit(v1[3]), 3)
  expect_equal(noround_digit(v1[4]), 2)
  expect_equal(noround_digit(v1[5]), 3)
  expect_equal(noround_digit(v1[6]), 3)

})

test_that("timewd5: fapply() with time2. to time2.1 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
          )

  res1 <- fapply(v1, "time2.")
  res2 <- fapply(v1, "time2.1" )

  expect_equal(res1[1], " 1")
  expect_equal(res1[2], " 1")
  expect_equal(res1[3], " 9")
  expect_equal(res1[4], "10")
  expect_equal(res1[5], "24")
  expect_equal(res1[6], "**")
  expect_equal(res1[7], "**")

  expect_equal(res2[1], " 1")
  expect_equal(res2[2], " 1")
  expect_equal(res2[3], " 9")
  expect_equal(res2[4], "10")
  expect_equal(res2[5], "24")
  expect_equal(res2[6], "**")
  expect_equal(res2[7], "**")

})
test_that("timewd6: fapply() with time3. to time3.2 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
  )

  res1 <- fapply(v1, "time3.")
  res2 <- fapply(v1, "time3.1")
  res3 <- fapply(v1, "time3.2")

  expect_equal(res1[1], "  1")
  expect_equal(res1[2], "  1")
  expect_equal(res1[3], "  9")
  expect_equal(res1[4], " 10")
  expect_equal(res1[5], " 24")
  expect_equal(res1[6], "119")
  expect_equal(res1[7], "-24")

  expect_equal(res2[1], "  1")
  expect_equal(res2[2], "  1")
  expect_equal(res2[3], "  9")
  expect_equal(res2[4], " 10")
  expect_equal(res2[5], " 24")
  expect_equal(res2[6], "119")
  expect_equal(res2[7], "-24")

  expect_equal(res3[1], "  1")
  expect_equal(res3[2], "  1")
  expect_equal(res3[3], "  9")
  expect_equal(res3[4], " 10")
  expect_equal(res3[5], " 24")
  expect_equal(res3[6], "119")
  expect_equal(res3[7], "-24")

})

test_that("timewd7: fapply() with time4. to time4.3 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
  )

  res1 <- fapply(v1, "time4.")
  res2 <- fapply(v1, "time4.1")
  res3 <- fapply(v1, "time4.2")
  res4 <- fapply(v1, "time4.3")

  # time4.
  expect_equal(res1[1], "1:00")
  expect_equal(res1[2], "1:03")
  expect_equal(res1[3], "9:00")
  expect_equal(res1[4], "  10")
  expect_equal(res1[5], "  24")
  expect_equal(res1[6], " 119")
  expect_equal(res1[7], " -24")

  # time4.1
  expect_equal(res2[1], "1:00")
  expect_equal(res2[2], "1:03")
  expect_equal(res2[3], "9:00")
  expect_equal(res2[4], "  10")
  expect_equal(res2[5], "  24")
  expect_equal(res2[6], " 119")
  expect_equal(res2[7], " -24")

  # time4.2
  expect_equal(res3[1], "1:00")
  expect_equal(res3[2], "1:03")
  expect_equal(res3[3], "9:00")
  expect_equal(res3[4], "  10")
  expect_equal(res3[5], "  24")
  expect_equal(res3[6], " 119")
  expect_equal(res3[7], " -24")

  # time4.3
  expect_equal(res4[1], "1:00")
  expect_equal(res4[2], "1:03")
  expect_equal(res4[3], "9:00")
  expect_equal(res4[4], "  10")
  expect_equal(res4[5], "  24")
  expect_equal(res4[6], " 119")
  expect_equal(res4[7], " -24")

})

test_that("timewd8: fapply() with time5. to time5.4 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
  )

  res1 <- fapply(v1, "time5.")
  res2 <- fapply(v1, "time5.1")
  res3 <- fapply(v1, "time5.2")
  res4 <- fapply(v1, "time5.3")
  res5 <- fapply(v1, "time5.4")

  # time5.
  expect_equal(res1[1], " 1:00")
  expect_equal(res1[2], " 1:03")
  expect_equal(res1[3], " 9:00")
  expect_equal(res1[4], "10:00")
  expect_equal(res1[5], "24:00")
  expect_equal(res1[6], "  119")
  expect_equal(res1[7], "  -24")

  # time5.1
  expect_equal(res2[1], " 1:00")
  expect_equal(res2[2], " 1:03")
  expect_equal(res2[3], " 9:00")
  expect_equal(res2[4], "10:00")
  expect_equal(res2[5], "24:00")
  expect_equal(res2[6], "  119")
  expect_equal(res2[7], "  -24")

  # time5.2
  expect_equal(res3[1], " 1:00")
  expect_equal(res3[2], " 1:03")
  expect_equal(res3[3], " 9:00")
  expect_equal(res3[4], "10:00")
  expect_equal(res3[5], "24:00")
  expect_equal(res3[6], "  119")
  expect_equal(res3[7], "  -24")

  # time5.3
  expect_equal(res4[1], " 1:00")
  expect_equal(res4[2], " 1:03")
  expect_equal(res4[3], " 9:00")
  expect_equal(res4[4], "10:00")
  expect_equal(res4[5], "24:00")
  expect_equal(res4[6], "  119")
  expect_equal(res4[7], "  -24")

  # time5.4
  expect_equal(res5[1], " 1:00")
  expect_equal(res5[2], " 1:03")
  expect_equal(res5[3], " 9:00")
  expect_equal(res5[4], "10:00")
  expect_equal(res5[5], "24:00")
  expect_equal(res5[6], "  119")
  expect_equal(res5[7], "  -24")
})

test_that("timewd9: fapply() with time6. to time6.5 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
  )

  res1 <- fapply(v1, "time6.")
  res2 <- fapply(v1, "time6.1")
  res3 <- fapply(v1, "time6.2")
  res4 <- fapply(v1, "time6.3")
  res5 <- fapply(v1, "time6.4")
  res6 <- fapply(v1, "time6.5")

  # time6.
  expect_equal(res1[1], "  1:00")
  expect_equal(res1[2], "  1:03")
  expect_equal(res1[3], "  9:00")
  expect_equal(res1[4], " 10:00")
  expect_equal(res1[5], " 24:00")
  expect_equal(res1[6], "119:26")
  expect_equal(res1[7], "-24:00")

  # time6.1
  expect_equal(res2[1], "  1:00")
  expect_equal(res2[2], "  1:03")
  expect_equal(res2[3], "  9:00")
  expect_equal(res2[4], " 10:00")
  expect_equal(res2[5], " 24:00")
  expect_equal(res2[6], "119:26")
  expect_equal(res2[7], "-24:00")

  # time6.2
  expect_equal(res3[1], "  1:00")
  expect_equal(res3[2], "  1:03")
  expect_equal(res3[3], "  9:00")
  expect_equal(res3[4], " 10:00")
  expect_equal(res3[5], " 24:00")
  expect_equal(res3[6], "119:26")
  expect_equal(res3[7], "-24:00")

  # time6.3
  expect_equal(res4[1], "  1:00")
  expect_equal(res4[2], "  1:03")
  expect_equal(res4[3], "  9:00")
  expect_equal(res4[4], " 10:00")
  expect_equal(res4[5], " 24:00")
  expect_equal(res4[6], "119:26")
  expect_equal(res4[7], "-24:00")

  # time6.4
  expect_equal(res5[1], "  1:00")
  expect_equal(res5[2], "  1:03")
  expect_equal(res5[3], "  9:00")
  expect_equal(res5[4], " 10:00")
  expect_equal(res5[5], " 24:00")
  expect_equal(res5[6], "119:26")
  expect_equal(res5[7], "-24:00")

  # time6.5
  expect_equal(res6[1], "  1:00")
  expect_equal(res6[2], "  1:03")
  expect_equal(res6[3], "  9:00")
  expect_equal(res6[4], " 10:00")
  expect_equal(res6[5], " 24:00")
  expect_equal(res6[6], "119:26")
  expect_equal(res6[7], "-24:00")

})

test_that("timewd10: fapply() with time7. to time7.6 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
  )

  res1 <- fapply(v1, "time7.")
  res2 <- fapply(v1, "time7.1")
  res3 <- fapply(v1, "time7.2")
  res4 <- fapply(v1, "time7.3")
  res5 <- fapply(v1, "time7.4")
  res6 <- fapply(v1, "time7.5")
  res7 <- fapply(v1, "time7.6")

  # time7.
  expect_equal(res1[1], "1:00:00")
  expect_equal(res1[2], "1:03:10")
  expect_equal(res1[3], "9:00:01")
  expect_equal(res1[4], "  10:00")
  expect_equal(res1[5], "  24:00")
  expect_equal(res1[6], " 119:26")
  expect_equal(res1[7], " -24:00")

  # time7.1
  expect_equal(res2[1], "1:00:00")
  expect_equal(res2[2], "1:03:10")
  expect_equal(res2[3], "9:00:01")
  expect_equal(res2[4], "  10:00")
  expect_equal(res2[5], "  24:00")
  expect_equal(res2[6], " 119:26")
  expect_equal(res2[7], " -24:00")

  # time7.2
  expect_equal(res3[1], "1:00:00")
  expect_equal(res3[2], "1:03:10")
  expect_equal(res3[3], "9:00:01")
  expect_equal(res3[4], "  10:00")
  expect_equal(res3[5], "  24:00")
  expect_equal(res3[6], " 119:26")
  expect_equal(res3[7], " -24:00")

  # time7.3
  expect_equal(res4[1], "1:00:00")
  expect_equal(res4[2], "1:03:10")
  expect_equal(res4[3], "9:00:01")
  expect_equal(res4[4], "  10:00")
  expect_equal(res4[5], "  24:00")
  expect_equal(res4[6], " 119:26")
  expect_equal(res4[7], " -24:00")

  # time7.4
  expect_equal(res5[1], "1:00:00")
  expect_equal(res5[2], "1:03:10")
  expect_equal(res5[3], "9:00:01")
  expect_equal(res5[4], "  10:00")
  expect_equal(res5[5], "  24:00")
  expect_equal(res5[6], " 119:26")
  expect_equal(res5[7], " -24:00")

  # time7.5
  expect_equal(res6[1], "1:00:00")
  expect_equal(res6[2], "1:03:10")
  expect_equal(res6[3], "9:00:01")
  expect_equal(res6[4], "  10:00")
  expect_equal(res6[5], "  24:00")
  expect_equal(res6[6], " 119:26")
  expect_equal(res6[7], " -24:00")

  # time7.6
  expect_equal(res7[1], "1:00:00")
  expect_equal(res7[2], "1:03:10")
  expect_equal(res7[3], "9:00:01")
  expect_equal(res7[4], "  10:00")
  expect_equal(res7[5], "  24:00")
  expect_equal(res7[6], " 119:26")
  expect_equal(res7[7], " -24:00")

})

test_that("timewd11: fapply() with time8. to time8.7 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
  )

  res1 <- fapply(v1, "time8.")
  res2 <- fapply(v1, "time8.1")
  res3 <- fapply(v1, "time8.2")
  res4 <- fapply(v1, "time8.3")
  res5 <- fapply(v1, "time8.4")
  res6 <- fapply(v1, "time8.5")
  res7 <- fapply(v1, "time8.6")
  res8 <- fapply(v1, "time8.7")

  # time8.
  expect_equal(res1[1], " 1:00:00")
  expect_equal(res1[2], " 1:03:10")
  expect_equal(res1[3], " 9:00:01")
  expect_equal(res1[4], "10:00:00")
  expect_equal(res1[5], "24:00:00")
  expect_equal(res1[6], "  119:26")
  expect_equal(res1[7], "  -24:00")

  # time8.1
  expect_equal(res2[1], " 1:00:00")
  expect_equal(res2[2], " 1:03:10")
  expect_equal(res2[3], " 9:00:01")
  expect_equal(res2[4], "10:00:00")
  expect_equal(res2[5], "24:00:00")
  expect_equal(res2[6], "  119:26")
  expect_equal(res2[7], "  -24:00")

  # time8.2
  expect_equal(res3[1], " 1:00:00")
  expect_equal(res3[2], " 1:03:10")
  expect_equal(res3[3], " 9:00:01")
  expect_equal(res3[4], "10:00:00")
  expect_equal(res3[5], "24:00:00")
  expect_equal(res3[6], "  119:26")
  expect_equal(res3[7], "  -24:00")

  # time8.3
  expect_equal(res4[1], " 1:00:00")
  expect_equal(res4[2], " 1:03:10")
  expect_equal(res4[3], " 9:00:01")
  expect_equal(res4[4], "10:00:00")
  expect_equal(res4[5], "24:00:00")
  expect_equal(res4[6], "  119:26")
  expect_equal(res4[7], "  -24:00")

  # time8.4
  expect_equal(res5[1], " 1:00:00")
  expect_equal(res5[2], " 1:03:10")
  expect_equal(res5[3], " 9:00:01")
  expect_equal(res5[4], "10:00:00")
  expect_equal(res5[5], "24:00:00")
  expect_equal(res5[6], "  119:26")
  expect_equal(res5[7], "  -24:00")

  # time8.5
  expect_equal(res6[1], " 1:00:00")
  expect_equal(res6[2], " 1:03:10")
  expect_equal(res6[3], " 9:00:01")
  expect_equal(res6[4], "10:00:00")
  expect_equal(res6[5], "24:00:00")
  expect_equal(res6[6], "  119:26")
  expect_equal(res6[7], "  -24:00")

  # time8.6
  expect_equal(res7[1], " 1:00:00")
  expect_equal(res7[2], " 1:03:10")
  expect_equal(res7[3], " 9:00:01")
  expect_equal(res7[4], "10:00:00")
  expect_equal(res7[5], "24:00:00")
  expect_equal(res7[6], "  119:26")
  expect_equal(res7[7], "  -24:00")

  # time8.7
  expect_equal(res8[1], " 1:00:00")
  expect_equal(res8[2], " 1:03:10")
  expect_equal(res8[3], " 9:00:01")
  expect_equal(res8[4], "10:00:00")
  expect_equal(res8[5], "24:00:00")
  expect_equal(res8[6], "  119:26")
  expect_equal(res8[7], "  -24:00")

})

test_that("timewd12: fapply() with time9. to time9.8 work as expected", {

  v1 <- c(3600,
          3790.12345,
          32401.005,
          35999.995,
          86400,
          430000,
          -86400
  )

  res1 <- fapply(v1, "time9.")
  res2 <- fapply(v1, "time9.1")
  res3 <- fapply(v1, "time9.2")
  res4 <- fapply(v1, "time9.3")
  res5 <- fapply(v1, "time9.4")
  res6 <- fapply(v1, "time9.5")
  res7 <- fapply(v1, "time9.6")
  res8 <- fapply(v1, "time9.7")
  res9 <- fapply(v1, "time9.8")

  # time9.
  expect_equal(res1[1], "  1:00:00")
  expect_equal(res1[2], "  1:03:10")
  expect_equal(res1[3], "  9:00:01")
  expect_equal(res1[4], " 10:00:00")
  expect_equal(res1[5], " 24:00:00")
  expect_equal(res1[6], "119:26:40")
  expect_equal(res1[7], "-24:00:00")

  # time9.1
  expect_equal(res2[1], "1:00:00.0")
  expect_equal(res2[2], "1:03:10.1")
  expect_equal(res2[3], "9:00:01.0")
  expect_equal(res2[4], " 10:00:00")
  expect_equal(res2[5], " 24:00:00")
  expect_equal(res2[6], "119:26:40")
  expect_equal(res2[7], "-24:00:00")

  # time9.2
  expect_equal(res3[1], "1:00:00.0")
  expect_equal(res3[2], "1:03:10.1")
  expect_equal(res3[3], "9:00:01.0")
  expect_equal(res3[4], " 10:00:00")
  expect_equal(res3[5], " 24:00:00")
  expect_equal(res3[6], "119:26:40")
  expect_equal(res3[7], "-24:00:00")

  # time9.3
  expect_equal(res4[1], "1:00:00.0")
  expect_equal(res4[2], "1:03:10.1")
  expect_equal(res4[3], "9:00:01.0")
  expect_equal(res4[4], " 10:00:00")
  expect_equal(res4[5], " 24:00:00")
  expect_equal(res4[6], "119:26:40")
  expect_equal(res4[7], "-24:00:00")

  # time9.4
  expect_equal(res5[1], "1:00:00.0")
  expect_equal(res5[2], "1:03:10.1")
  expect_equal(res5[3], "9:00:01.0")
  expect_equal(res5[4], " 10:00:00")
  expect_equal(res5[5], " 24:00:00")
  expect_equal(res5[6], "119:26:40")
  expect_equal(res5[7], "-24:00:00")

  # time9.5
  expect_equal(res6[1], "1:00:00.0")
  expect_equal(res6[2], "1:03:10.1")
  expect_equal(res6[3], "9:00:01.0")
  expect_equal(res6[4], " 10:00:00")
  expect_equal(res6[5], " 24:00:00")
  expect_equal(res6[6], "119:26:40")
  expect_equal(res6[7], "-24:00:00")

  # time9.6
  expect_equal(res7[1], "1:00:00.0")
  expect_equal(res7[2], "1:03:10.1")
  expect_equal(res7[3], "9:00:01.0")
  expect_equal(res7[4], " 10:00:00")
  expect_equal(res7[5], " 24:00:00")
  expect_equal(res7[6], "119:26:40")
  expect_equal(res7[7], "-24:00:00")

  # time9.7
  expect_equal(res8[1], "1:00:00.0")
  expect_equal(res8[2], "1:03:10.1")
  expect_equal(res8[3], "9:00:01.0")
  expect_equal(res8[4], " 10:00:00")
  expect_equal(res8[5], " 24:00:00")
  expect_equal(res8[6], "119:26:40")
  expect_equal(res8[7], "-24:00:00")

  # time9.8
  expect_equal(res9[1], "1:00:00.0")
  expect_equal(res9[2], "1:03:10.1")
  expect_equal(res9[3], "9:00:01.0")
  expect_equal(res9[4], " 10:00:00")
  expect_equal(res9[5], " 24:00:00")
  expect_equal(res9[6], "119:26:40")
  expect_equal(res9[7], "-24:00:00")

})

test_that("timewd13: fapply() with time10. to time10.9 work as expected", {

  v1 <- c(-3600.12345,
          -86400,
          0,
          32400,
          32400.98765432101234,
          32401.005,
          32401.990005,
          35999.9949,
          35999.995,
          85400,
          430000,
          5000000
  )

  res1  <- fapply(v1, "time10.")
  res2  <- fapply(v1, "time10.1")
  res3  <- fapply(v1, "time10.2")
  res4  <- fapply(v1, "time10.3")
  res5  <- fapply(v1, "time10.4")
  res6  <- fapply(v1, "time10.5")
  res7  <- fapply(v1, "time10.6")
  res8  <- fapply(v1, "time10.7")
  res9  <- fapply(v1, "time10.8")
  res10 <- fapply(v1, "time10.9")

  # time10.
  expect_equal(res1[1],  "  -1:00:00")
  expect_equal(res1[2],  " -24:00:00")
  expect_equal(res1[3],  "   0:00:00")
  expect_equal(res1[4],  "   9:00:00")
  expect_equal(res1[5],  "   9:00:01")
  expect_equal(res1[6],  "   9:00:01")
  expect_equal(res1[7],  "   9:00:02")
  expect_equal(res1[8],  "  10:00:00")
  expect_equal(res1[9],  "  10:00:00")
  expect_equal(res1[10], "  23:43:20")
  expect_equal(res1[11], " 119:26:40")
  expect_equal(res1[12], "1388:53:20")

  # time10.1
  expect_equal(res2[1],  "-1:00:00.1")
  expect_equal(res2[2],  " -24:00:00")
  expect_equal(res2[3],  " 0:00:00.0")
  expect_equal(res2[4],  " 9:00:00.0")
  expect_equal(res2[5],  " 9:00:01.0")
  expect_equal(res2[6],  " 9:00:01.0")
  expect_equal(res2[7],  " 9:00:02.0")
  expect_equal(res2[8],  "10:00:00.0")
  expect_equal(res2[9],  "10:00:00.0")
  expect_equal(res2[10], "23:43:20.0")
  expect_equal(res2[11], " 119:26:40")
  expect_equal(res2[12], "1388:53:20")

  # time10.2
  expect_equal(res3[1],  "-1:00:00.1")
  expect_equal(res3[2],  " -24:00:00")
  expect_equal(res3[3],  "0:00:00.00")
  expect_equal(res3[4],  "9:00:00.00")
  expect_equal(res3[5],  "9:00:00.99")
  expect_equal(res3[6],  "9:00:01.01")
  expect_equal(res3[7],  "9:00:01.99")
  expect_equal(res3[8],  "9:59:59.99")
  expect_equal(res3[9],  "10:00:00.0")
  expect_equal(res3[10], "23:43:20.0")
  expect_equal(res3[11], " 119:26:40")
  expect_equal(res3[12], "1388:53:20")

  # time10.3
  expect_equal(res4[1],  "-1:00:00.1")
  expect_equal(res4[2],  " -24:00:00")
  expect_equal(res4[3],  "0:00:00.00")
  expect_equal(res4[4],  "9:00:00.00")
  expect_equal(res4[5],  "9:00:00.99")
  expect_equal(res4[6],  "9:00:01.01")
  expect_equal(res4[7],  "9:00:01.99")
  expect_equal(res4[8],  "9:59:59.99")
  expect_equal(res4[9],  "10:00:00.0")
  expect_equal(res4[10], "23:43:20.0")
  expect_equal(res4[11], " 119:26:40")
  expect_equal(res4[12], "1388:53:20")

  # time10.4
  expect_equal(res5[1],  "-1:00:00.1")
  expect_equal(res5[2],  " -24:00:00")
  expect_equal(res5[3],  "0:00:00.00")
  expect_equal(res5[4],  "9:00:00.00")
  expect_equal(res5[5],  "9:00:00.99")
  expect_equal(res5[6],  "9:00:01.01")
  expect_equal(res5[7],  "9:00:01.99")
  expect_equal(res5[8],  "9:59:59.99")
  expect_equal(res5[9],  "10:00:00.0")
  expect_equal(res5[10], "23:43:20.0")
  expect_equal(res5[11], " 119:26:40")
  expect_equal(res5[12], "1388:53:20")

  # time10.5
  expect_equal(res6[1],  "-1:00:00.1")
  expect_equal(res6[2],  " -24:00:00")
  expect_equal(res6[3],  "0:00:00.00")
  expect_equal(res6[4],  "9:00:00.00")
  expect_equal(res6[5],  "9:00:00.99")
  expect_equal(res6[6],  "9:00:01.01")
  expect_equal(res6[7],  "9:00:01.99")
  expect_equal(res6[8],  "9:59:59.99")
  expect_equal(res6[9],  "10:00:00.0")
  expect_equal(res6[10], "23:43:20.0")
  expect_equal(res6[11], " 119:26:40")
  expect_equal(res6[12], "1388:53:20")

  # time10.6
  expect_equal(res7[1],  "-1:00:00.1")
  expect_equal(res7[2],  " -24:00:00")
  expect_equal(res7[3],  "0:00:00.00")
  expect_equal(res7[4],  "9:00:00.00")
  expect_equal(res7[5],  "9:00:00.99")
  expect_equal(res7[6],  "9:00:01.01")
  expect_equal(res7[7],  "9:00:01.99")
  expect_equal(res7[8],  "9:59:59.99")
  expect_equal(res7[9],  "10:00:00.0")
  expect_equal(res7[10], "23:43:20.0")
  expect_equal(res7[11], " 119:26:40")
  expect_equal(res7[12], "1388:53:20")

  # time10.7
  expect_equal(res8[1],  "-1:00:00.1")
  expect_equal(res8[2],  " -24:00:00")
  expect_equal(res8[3],  "0:00:00.00")
  expect_equal(res8[4],  "9:00:00.00")
  expect_equal(res8[5],  "9:00:00.99")
  expect_equal(res8[6],  "9:00:01.01")
  expect_equal(res8[7],  "9:00:01.99")
  expect_equal(res8[8],  "9:59:59.99")
  expect_equal(res8[9],  "10:00:00.0")
  expect_equal(res8[10], "23:43:20.0")
  expect_equal(res8[11], " 119:26:40")
  expect_equal(res8[12], "1388:53:20")

  # time10.8
  expect_equal(res9[1],  "-1:00:00.1")
  expect_equal(res9[2],  " -24:00:00")
  expect_equal(res9[3],  "0:00:00.00")
  expect_equal(res9[4],  "9:00:00.00")
  expect_equal(res9[5],  "9:00:00.99")
  expect_equal(res9[6],  "9:00:01.01")
  expect_equal(res9[7],  "9:00:01.99")
  expect_equal(res9[8],  "9:59:59.99")
  expect_equal(res9[9],  "10:00:00.0")
  expect_equal(res9[10], "23:43:20.0")
  expect_equal(res9[11], " 119:26:40")
  expect_equal(res9[12], "1388:53:20")

  # time10.9
  expect_equal(res10[1],  "-1:00:00.1")
  expect_equal(res10[2],  " -24:00:00")
  expect_equal(res10[3],  "0:00:00.00")
  expect_equal(res10[4],  "9:00:00.00")
  expect_equal(res10[5],  "9:00:00.99")
  expect_equal(res10[6],  "9:00:01.01")
  expect_equal(res10[7],  "9:00:01.99")
  expect_equal(res10[8],  "9:59:59.99")
  expect_equal(res10[9],  "10:00:00.0")
  expect_equal(res10[10], "23:43:20.0")
  expect_equal(res10[11], " 119:26:40")
  expect_equal(res10[12], "1388:53:20")

})


test_that("timewd14: fapply() with time12. to time12.11 work as expected", {

  v1 <- c(-3600.12345,
          -86400,
          0,
          32400,
          32400.98765432101234,
          32401.005,
          32401.8365,
          35999.9949,
          35999.995,
          85400,
          430000,
          5000000
  )

  res1  <- fapply(v1, "time12.")
  res2  <- fapply(v1, "time12.1")
  res3  <- fapply(v1, "time12.2")
  res4  <- fapply(v1, "time12.3")
  res5  <- fapply(v1, "time12.4")
  res6  <- fapply(v1, "time12.5")
  res7  <- fapply(v1, "time12.6")
  res8  <- fapply(v1, "time12.7")
  res9  <- fapply(v1, "time12.8")
  res10 <- fapply(v1, "time12.9")
  res11 <- fapply(v1, "time12.10")
  res12 <- fapply(v1, "time12.11")

  # time12.
  expect_equal(res1[1],  "    -1:00:00")
  expect_equal(res1[2],  "   -24:00:00")
  expect_equal(res1[3],  "     0:00:00")
  expect_equal(res1[4],  "     9:00:00")
  expect_equal(res1[5],  "     9:00:01")
  expect_equal(res1[6],  "     9:00:01")
  expect_equal(res1[7],  "     9:00:02")
  expect_equal(res1[8],  "    10:00:00")
  expect_equal(res1[9],  "    10:00:00")
  expect_equal(res1[10], "    23:43:20")
  expect_equal(res1[11], "   119:26:40")
  expect_equal(res1[12], "  1388:53:20")

  # time12.1
  expect_equal(res2[1],  "  -1:00:00.1")
  expect_equal(res2[2],  " -24:00:00.0")
  expect_equal(res2[3],  "   0:00:00.0")
  expect_equal(res2[4],  "   9:00:00.0")
  expect_equal(res2[5],  "   9:00:01.0")
  expect_equal(res2[6],  "   9:00:01.0")
  expect_equal(res2[7],  "   9:00:01.8")
  expect_equal(res2[8],  "  10:00:00.0")
  expect_equal(res2[9],  "  10:00:00.0")
  expect_equal(res2[10], "  23:43:20.0")
  expect_equal(res2[11], " 119:26:40.0")
  expect_equal(res2[12], "1388:53:20.0")

  # time12.2
  expect_equal(res3[1],  " -1:00:00.12")
  expect_equal(res3[2],  "-24:00:00.00")
  expect_equal(res3[3],  "  0:00:00.00")
  expect_equal(res3[4],  "  9:00:00.00")
  expect_equal(res3[5],  "  9:00:00.99")
  expect_equal(res3[6],  "  9:00:01.01")
  expect_equal(res3[7],  "  9:00:01.84")
  expect_equal(res3[8],  "  9:59:59.99")
  expect_equal(res3[9],  " 10:00:00.00")
  expect_equal(res3[10], " 23:43:20.00")
  expect_equal(res3[11], "119:26:40.00")
  expect_equal(res3[12], "1388:53:20.0")

  # time12.3
  expect_equal(res4[1],  "-1:00:00.123")
  expect_equal(res4[2],  "-24:00:00.00")
  expect_equal(res4[3],  " 0:00:00.000")
  expect_equal(res4[4],  " 9:00:00.000")
  expect_equal(res4[5],  " 9:00:00.988")
  expect_equal(res4[6],  " 9:00:01.005")
  expect_equal(res4[7],  " 9:00:01.837")
  expect_equal(res4[8],  " 9:59:59.995")
  expect_equal(res4[9],  " 9:59:59.995")
  expect_equal(res4[10], "23:43:20.000")
  expect_equal(res4[11], "119:26:40.00")
  expect_equal(res4[12], "1388:53:20.0")

  # time12.4
  expect_equal(res5[1],  "-1:00:00.123")
  expect_equal(res5[2],  "-24:00:00.00")
  expect_equal(res5[3],  "0:00:00.0000")
  expect_equal(res5[4],  "9:00:00.0000")
  expect_equal(res5[5],  "9:00:00.9877")
  expect_equal(res5[6],  "9:00:01.0050")
  expect_equal(res5[7],  "9:00:01.8365")
  expect_equal(res5[8],  "9:59:59.9949")
  expect_equal(res5[9],  "9:59:59.9950")
  expect_equal(res5[10], "23:43:20.000")
  expect_equal(res5[11], "119:26:40.00")
  expect_equal(res5[12], "1388:53:20.0")

  # time12.5
  expect_equal(res6[1],  "-1:00:00.123")
  expect_equal(res6[2],  "-24:00:00.00")
  expect_equal(res6[3],  "0:00:00.0000")
  expect_equal(res6[4],  "9:00:00.0000")
  expect_equal(res6[5],  "9:00:00.9877")
  expect_equal(res6[6],  "9:00:01.0050")
  expect_equal(res6[7],  "9:00:01.8365")
  expect_equal(res6[8],  "9:59:59.9949")
  expect_equal(res6[9],  "9:59:59.9950")
  expect_equal(res6[10], "23:43:20.000")
  expect_equal(res6[11], "119:26:40.00")
  expect_equal(res6[12], "1388:53:20.0")

  # time12.6
  expect_equal(res7[1],  "-1:00:00.123")
  expect_equal(res7[2],  "-24:00:00.00")
  expect_equal(res7[3],  "0:00:00.0000")
  expect_equal(res7[4],  "9:00:00.0000")
  expect_equal(res7[5],  "9:00:00.9877")
  expect_equal(res7[6],  "9:00:01.0050")
  expect_equal(res7[7],  "9:00:01.8365")
  expect_equal(res7[8],  "9:59:59.9949")
  expect_equal(res7[9],  "9:59:59.9950")
  expect_equal(res7[10], "23:43:20.000")
  expect_equal(res7[11], "119:26:40.00")
  expect_equal(res7[12], "1388:53:20.0")

  # time12.7
  expect_equal(res8[1],  "-1:00:00.123")
  expect_equal(res8[2],  "-24:00:00.00")
  expect_equal(res8[3],  "0:00:00.0000")
  expect_equal(res8[4],  "9:00:00.0000")
  expect_equal(res8[5],  "9:00:00.9877")
  expect_equal(res8[6],  "9:00:01.0050")
  expect_equal(res8[7],  "9:00:01.8365")
  expect_equal(res8[8],  "9:59:59.9949")
  expect_equal(res8[9],  "9:59:59.9950")
  expect_equal(res8[10], "23:43:20.000")
  expect_equal(res8[11], "119:26:40.00")
  expect_equal(res8[12], "1388:53:20.0")

  # time12.8
  expect_equal(res9[1],  "-1:00:00.123")
  expect_equal(res9[2],  "-24:00:00.00")
  expect_equal(res9[3],  "0:00:00.0000")
  expect_equal(res9[4],  "9:00:00.0000")
  expect_equal(res9[5],  "9:00:00.9877")
  expect_equal(res9[6],  "9:00:01.0050")
  expect_equal(res9[7],  "9:00:01.8365")
  expect_equal(res9[8],  "9:59:59.9949")
  expect_equal(res9[9],  "9:59:59.9950")
  expect_equal(res9[10], "23:43:20.000")
  expect_equal(res9[11], "119:26:40.00")
  expect_equal(res9[12], "1388:53:20.0")

  # time12.9
  expect_equal(res10[1],  "-1:00:00.123")
  expect_equal(res10[2],  "-24:00:00.00")
  expect_equal(res10[3],  "0:00:00.0000")
  expect_equal(res10[4],  "9:00:00.0000")
  expect_equal(res10[5],  "9:00:00.9877")
  expect_equal(res10[6],  "9:00:01.0050")
  expect_equal(res10[7],  "9:00:01.8365")
  expect_equal(res10[8],  "9:59:59.9949")
  expect_equal(res10[9],  "9:59:59.9950")
  expect_equal(res10[10], "23:43:20.000")
  expect_equal(res10[11], "119:26:40.00")
  expect_equal(res10[12], "1388:53:20.0")

  # time12.10
  expect_equal(res11[1],  "-1:00:00.123")
  expect_equal(res11[2],  "-24:00:00.00")
  expect_equal(res11[3],  "0:00:00.0000")
  expect_equal(res11[4],  "9:00:00.0000")
  expect_equal(res11[5],  "9:00:00.9877")
  expect_equal(res11[6],  "9:00:01.0050")
  expect_equal(res11[7],  "9:00:01.8365")
  expect_equal(res11[8],  "9:59:59.9949")
  expect_equal(res11[9],  "9:59:59.9950")
  expect_equal(res11[10], "23:43:20.000")
  expect_equal(res11[11], "119:26:40.00")
  expect_equal(res11[12], "1388:53:20.0")

  # time12.11
  expect_equal(res12[1],  "-1:00:00.123")
  expect_equal(res12[2],  "-24:00:00.00")
  expect_equal(res12[3],  "0:00:00.0000")
  expect_equal(res12[4],  "9:00:00.0000")
  expect_equal(res12[5],  "9:00:00.9877")
  expect_equal(res12[6],  "9:00:01.0050")
  expect_equal(res12[7],  "9:00:01.8365")
  expect_equal(res12[8],  "9:59:59.9949")
  expect_equal(res12[9],  "9:59:59.9950")
  expect_equal(res12[10], "23:43:20.000")
  expect_equal(res12[11], "119:26:40.00")
  expect_equal(res12[12], "1388:53:20.0")

})


test_that("timewd15: fapply() with time16. to time16.15 work as expected", {
  
  v1 <- c(-3600.12345,
          -86400,
          0,
          32400,
          32400.98765432101234,
          32401.005,
          32401.8365,
          35999.9949,
          35999.995,
          85400,
          430000,
          5000000
  )
  
  res1  <- fapply(v1, "time16.")
  res2  <- fapply(v1, "time16.1")
  res3  <- fapply(v1, "time16.2")
  res4  <- fapply(v1, "time16.3")
  res5  <- fapply(v1, "time16.4")
  res6  <- fapply(v1, "time16.5")
  res7  <- fapply(v1, "time16.6")
  res8  <- fapply(v1, "time16.7")
  res9  <- fapply(v1, "time16.8")
  res10 <- fapply(v1, "time16.9")
  res11 <- fapply(v1, "time16.10")
  res12 <- fapply(v1, "time16.11")
  res13 <- fapply(v1, "time16.12")
  res14 <- fapply(v1, "time16.13")
  res15 <- fapply(v1, "time16.14")
  res16 <- fapply(v1, "time16.15")
  
  # time16.
  expect_equal(res1[1],  "        -1:00:00")
  expect_equal(res1[2],  "       -24:00:00")
  expect_equal(res1[3],  "         0:00:00")
  expect_equal(res1[4],  "         9:00:00")
  expect_equal(res1[5],  "         9:00:01")
  expect_equal(res1[6],  "         9:00:01")
  expect_equal(res1[7],  "         9:00:02")
  expect_equal(res1[8],  "        10:00:00")
  expect_equal(res1[9],  "        10:00:00")
  expect_equal(res1[10], "        23:43:20")
  expect_equal(res1[11], "       119:26:40")
  expect_equal(res1[12], "      1388:53:20")
  
  # time16.1
  expect_equal(res2[1],  "      -1:00:00.1")
  expect_equal(res2[2],  "     -24:00:00.0")
  expect_equal(res2[3],  "       0:00:00.0")
  expect_equal(res2[4],  "       9:00:00.0")
  expect_equal(res2[5],  "       9:00:01.0")
  expect_equal(res2[6],  "       9:00:01.0")
  expect_equal(res2[7],  "       9:00:01.8")
  expect_equal(res2[8],  "      10:00:00.0")
  expect_equal(res2[9],  "      10:00:00.0")
  expect_equal(res2[10], "      23:43:20.0")
  expect_equal(res2[11], "     119:26:40.0")
  expect_equal(res2[12], "    1388:53:20.0")
  
  # time16.2
  expect_equal(res3[1],  "     -1:00:00.12")
  expect_equal(res3[2],  "    -24:00:00.00")
  expect_equal(res3[3],  "      0:00:00.00")
  expect_equal(res3[4],  "      9:00:00.00")
  expect_equal(res3[5],  "      9:00:00.99")
  expect_equal(res3[6],  "      9:00:01.01")
  expect_equal(res3[7],  "      9:00:01.84")
  expect_equal(res3[8],  "      9:59:59.99")
  expect_equal(res3[9],  "     10:00:00.00")
  expect_equal(res3[10], "     23:43:20.00")
  expect_equal(res3[11], "    119:26:40.00")
  expect_equal(res3[12], "   1388:53:20.00")
  
  # time16.3
  expect_equal(res4[1],  "    -1:00:00.123")
  expect_equal(res4[2],  "   -24:00:00.000")
  expect_equal(res4[3],  "     0:00:00.000")
  expect_equal(res4[4],  "     9:00:00.000")
  expect_equal(res4[5],  "     9:00:00.988")
  expect_equal(res4[6],  "     9:00:01.005")
  expect_equal(res4[7],  "     9:00:01.837")
  expect_equal(res4[8],  "     9:59:59.995")
  expect_equal(res4[9],  "     9:59:59.995")
  expect_equal(res4[10], "    23:43:20.000")
  expect_equal(res4[11], "   119:26:40.000")
  expect_equal(res4[12], "  1388:53:20.000")
  
  # time16.4
  expect_equal(res5[1],  "   -1:00:00.1235")
  expect_equal(res5[2],  "  -24:00:00.0000")
  expect_equal(res5[3],  "    0:00:00.0000")
  expect_equal(res5[4],  "    9:00:00.0000")
  expect_equal(res5[5],  "    9:00:00.9877")
  expect_equal(res5[6],  "    9:00:01.0050")
  expect_equal(res5[7],  "    9:00:01.8365")
  expect_equal(res5[8],  "    9:59:59.9949")
  expect_equal(res5[9],  "    9:59:59.9950")
  expect_equal(res5[10], "   23:43:20.0000")
  expect_equal(res5[11], "  119:26:40.0000")
  expect_equal(res5[12], " 1388:53:20.0000")
  
  # time16.5
  expect_equal(res6[1],  "  -1:00:00.12345")
  expect_equal(res6[2],  " -24:00:00.00000")
  expect_equal(res6[3],  "   0:00:00.00000")
  expect_equal(res6[4],  "   9:00:00.00000")
  expect_equal(res6[5],  "   9:00:00.98765")
  expect_equal(res6[6],  "   9:00:01.00500")
  expect_equal(res6[7],  "   9:00:01.83650")
  expect_equal(res6[8],  "   9:59:59.99490")
  expect_equal(res6[9],  "   9:59:59.99500")
  expect_equal(res6[10], "  23:43:20.00000")
  expect_equal(res6[11], " 119:26:40.00000")
  expect_equal(res6[12], "1388:53:20.00000")
  
  # time16.6
  expect_equal(res7[1],  " -1:00:00.123450")
  expect_equal(res7[2],  "-24:00:00.000000")
  expect_equal(res7[3],  "  0:00:00.000000")
  expect_equal(res7[4],  "  9:00:00.000000")
  expect_equal(res7[5],  "  9:00:00.987654")
  expect_equal(res7[6],  "  9:00:01.005000")
  expect_equal(res7[7],  "  9:00:01.836500")
  expect_equal(res7[8],  "  9:59:59.994900")
  expect_equal(res7[9],  "  9:59:59.995000")
  expect_equal(res7[10], " 23:43:20.000000")
  expect_equal(res7[11], "119:26:40.000000")
  expect_equal(res7[12], "1388:53:20.00000")
  
  # time16.7
  expect_equal(res8[1],  "-1:00:00.1234500")
  expect_equal(res8[2],  "-24:00:00.000000")
  expect_equal(res8[3],  " 0:00:00.0000000")
  expect_equal(res8[4],  " 9:00:00.0000000")
  expect_equal(res8[5],  " 9:00:00.9876543")
  expect_equal(res8[6],  " 9:00:01.0050000")
  expect_equal(res8[7],  " 9:00:01.8365000")
  expect_equal(res8[8],  " 9:59:59.9949000")
  expect_equal(res8[9],  " 9:59:59.9950000")
  expect_equal(res8[10], "23:43:20.0000000")
  expect_equal(res8[11], "119:26:40.000000")
  expect_equal(res8[12], "1388:53:20.00000")
  
  # time16.8
  expect_equal(res9[1],  "-1:00:00.1234500")
  expect_equal(res9[2],  "-24:00:00.000000")
  expect_equal(res9[3],  "0:00:00.00000000")
  expect_equal(res9[4],  "9:00:00.00000000")
  expect_equal(res9[5],  "9:00:00.98765432")
  expect_equal(res9[6],  "9:00:01.00500000")
  expect_equal(res9[7],  "9:00:01.83650000")
  expect_equal(res9[8],  "9:59:59.99490000")
  expect_equal(res9[9],  "9:59:59.99500000")
  expect_equal(res9[10], "23:43:20.0000000")
  expect_equal(res9[11], "119:26:40.000000")
  expect_equal(res9[12], "1388:53:20.00000")
  
  # time16.9
  expect_equal(res10[1],  "-1:00:00.1234500")
  expect_equal(res10[2],  "-24:00:00.000000")
  expect_equal(res10[3],  "0:00:00.00000000")
  expect_equal(res10[4],  "9:00:00.00000000")
  expect_equal(res10[5],  "9:00:00.98765432")
  expect_equal(res10[6],  "9:00:01.00500000")
  expect_equal(res10[7],  "9:00:01.83650000")
  expect_equal(res10[8],  "9:59:59.99490000")
  expect_equal(res10[9],  "9:59:59.99500000")
  expect_equal(res10[10], "23:43:20.0000000")
  expect_equal(res10[11], "119:26:40.000000")
  expect_equal(res10[12], "1388:53:20.00000")
  
  # time16.10
  expect_equal(res11[1],  "-1:00:00.1234500")
  expect_equal(res11[2],  "-24:00:00.000000")
  expect_equal(res11[3],  "0:00:00.00000000")
  expect_equal(res11[4],  "9:00:00.00000000")
  expect_equal(res11[5],  "9:00:00.98765432")
  expect_equal(res11[6],  "9:00:01.00500000")
  expect_equal(res11[7],  "9:00:01.83650000")
  expect_equal(res11[8],  "9:59:59.99490000")
  expect_equal(res11[9],  "9:59:59.99500000")
  expect_equal(res11[10], "23:43:20.0000000")
  expect_equal(res11[11], "119:26:40.000000")
  expect_equal(res11[12], "1388:53:20.00000")
  
  # time16.11
  expect_equal(res12[1],  "-1:00:00.1234500")
  expect_equal(res12[2],  "-24:00:00.000000")
  expect_equal(res12[3],  "0:00:00.00000000")
  expect_equal(res12[4],  "9:00:00.00000000")
  expect_equal(res12[5],  "9:00:00.98765432")
  expect_equal(res12[6],  "9:00:01.00500000")
  expect_equal(res12[7],  "9:00:01.83650000")
  expect_equal(res12[8],  "9:59:59.99490000")
  expect_equal(res12[9],  "9:59:59.99500000")
  expect_equal(res12[10], "23:43:20.0000000")
  expect_equal(res12[11], "119:26:40.000000")
  expect_equal(res12[12], "1388:53:20.00000")
  
  # time16.12
  expect_equal(res13[1],  "-1:00:00.1234500")
  expect_equal(res13[2],  "-24:00:00.000000")
  expect_equal(res13[3],  "0:00:00.00000000")
  expect_equal(res13[4],  "9:00:00.00000000")
  expect_equal(res13[5],  "9:00:00.98765432")
  expect_equal(res13[6],  "9:00:01.00500000")
  expect_equal(res13[7],  "9:00:01.83650000")
  expect_equal(res13[8],  "9:59:59.99490000")
  expect_equal(res13[9],  "9:59:59.99500000")
  expect_equal(res13[10], "23:43:20.0000000")
  expect_equal(res13[11], "119:26:40.000000")
  expect_equal(res13[12], "1388:53:20.00000")
  
  # time16.13
  expect_equal(res14[1],  "-1:00:00.1234500")
  expect_equal(res14[2],  "-24:00:00.000000")
  expect_equal(res14[3],  "0:00:00.00000000")
  expect_equal(res14[4],  "9:00:00.00000000")
  expect_equal(res14[5],  "9:00:00.98765432")
  expect_equal(res14[6],  "9:00:01.00500000")
  expect_equal(res14[7],  "9:00:01.83650000")
  expect_equal(res14[8],  "9:59:59.99490000")
  expect_equal(res14[9],  "9:59:59.99500000")
  expect_equal(res14[10], "23:43:20.0000000")
  expect_equal(res14[11], "119:26:40.000000")
  expect_equal(res14[12], "1388:53:20.00000")
  
  # time16.14
  expect_equal(res15[1],  "-1:00:00.1234500")
  expect_equal(res15[2],  "-24:00:00.000000")
  expect_equal(res15[3],  "0:00:00.00000000")
  expect_equal(res15[4],  "9:00:00.00000000")
  expect_equal(res15[5],  "9:00:00.98765432")
  expect_equal(res15[6],  "9:00:01.00500000")
  expect_equal(res15[7],  "9:00:01.83650000")
  expect_equal(res15[8],  "9:59:59.99490000")
  expect_equal(res15[9],  "9:59:59.99500000")
  expect_equal(res15[10], "23:43:20.0000000")
  expect_equal(res15[11], "119:26:40.000000")
  expect_equal(res15[12], "1388:53:20.00000")
  
  # time16.15
  expect_equal(res16[1],  "-1:00:00.1234500")
  expect_equal(res16[2],  "-24:00:00.000000")
  expect_equal(res16[3],  "0:00:00.00000000")
  expect_equal(res16[4],  "9:00:00.00000000")
  expect_equal(res16[5],  "9:00:00.98765432")
  expect_equal(res16[6],  "9:00:01.00500000")
  expect_equal(res16[7],  "9:00:01.83650000")
  expect_equal(res16[8],  "9:59:59.99490000")
  expect_equal(res16[9],  "9:59:59.99500000")
  expect_equal(res16[10], "23:43:20.0000000")
  expect_equal(res16[11], "119:26:40.000000")
  expect_equal(res16[12], "1388:53:20.00000")
  
})

test_that("timewd16: fapply() with time20. to time20.19 work as expected", {
  
  v1 <- c(-3600.12345,
          -86400,
          0,
          32400,
          32400.98765432101234,
          32401.005,
          32401.8365,
          35999.9949,
          35999.995,
          85400,
          430000,
          5000000
  )
  
  res1  <- fapply(v1, "time20.")
  res2  <- fapply(v1, "time20.1")
  res3  <- fapply(v1, "time20.2")
  res4  <- fapply(v1, "time20.3")
  res5  <- fapply(v1, "time20.4")
  res6  <- fapply(v1, "time20.5")
  res7  <- fapply(v1, "time20.6")
  res8  <- fapply(v1, "time20.7")
  res9  <- fapply(v1, "time20.8")
  res10 <- fapply(v1, "time20.9")
  res11 <- fapply(v1, "time20.10")
  res12 <- fapply(v1, "time20.11")
  res13 <- fapply(v1, "time20.12")
  res14 <- fapply(v1, "time20.13")
  res15 <- fapply(v1, "time20.14")
  res16 <- fapply(v1, "time20.15")
  res17 <- fapply(v1, "time20.16")
  res18 <- fapply(v1, "time20.17")
  res19 <- fapply(v1, "time20.18")
  res20 <- fapply(v1, "time20.19")
  
  # time20.
  expect_equal(res1[1],  "            -1:00:00")
  expect_equal(res1[2],  "           -24:00:00")
  expect_equal(res1[3],  "             0:00:00")
  expect_equal(res1[4],  "             9:00:00")
  expect_equal(res1[5],  "             9:00:01")
  expect_equal(res1[6],  "             9:00:01")
  expect_equal(res1[7],  "             9:00:02")
  expect_equal(res1[8],  "            10:00:00")
  expect_equal(res1[9],  "            10:00:00")
  expect_equal(res1[10], "            23:43:20")
  expect_equal(res1[11], "           119:26:40")
  expect_equal(res1[12], "          1388:53:20")
  
  # time20.1
  expect_equal(res2[1],  "          -1:00:00.1")
  expect_equal(res2[2],  "         -24:00:00.0")
  expect_equal(res2[3],  "           0:00:00.0")
  expect_equal(res2[4],  "           9:00:00.0")
  expect_equal(res2[5],  "           9:00:01.0")
  expect_equal(res2[6],  "           9:00:01.0")
  expect_equal(res2[7],  "           9:00:01.8")
  expect_equal(res2[8],  "          10:00:00.0")
  expect_equal(res2[9],  "          10:00:00.0")
  expect_equal(res2[10], "          23:43:20.0")
  expect_equal(res2[11], "         119:26:40.0")
  expect_equal(res2[12], "        1388:53:20.0")
  
  # time20.2
  expect_equal(res3[1],  "         -1:00:00.12")
  expect_equal(res3[2],  "        -24:00:00.00")
  expect_equal(res3[3],  "          0:00:00.00")
  expect_equal(res3[4],  "          9:00:00.00")
  expect_equal(res3[5],  "          9:00:00.99")
  expect_equal(res3[6],  "          9:00:01.01")
  expect_equal(res3[7],  "          9:00:01.84")
  expect_equal(res3[8],  "          9:59:59.99")
  expect_equal(res3[9],  "         10:00:00.00")
  expect_equal(res3[10], "         23:43:20.00")
  expect_equal(res3[11], "        119:26:40.00")
  expect_equal(res3[12], "       1388:53:20.00")
  
  # time20.3
  expect_equal(res4[1],  "        -1:00:00.123")
  expect_equal(res4[2],  "       -24:00:00.000")
  expect_equal(res4[3],  "         0:00:00.000")
  expect_equal(res4[4],  "         9:00:00.000")
  expect_equal(res4[5],  "         9:00:00.988")
  expect_equal(res4[6],  "         9:00:01.005")
  expect_equal(res4[7],  "         9:00:01.837")
  expect_equal(res4[8],  "         9:59:59.995")
  expect_equal(res4[9],  "         9:59:59.995")
  expect_equal(res4[10], "        23:43:20.000")
  expect_equal(res4[11], "       119:26:40.000")
  expect_equal(res4[12], "      1388:53:20.000")
  
  # time20.4
  expect_equal(res5[1],  "       -1:00:00.1235")
  expect_equal(res5[2],  "      -24:00:00.0000")
  expect_equal(res5[3],  "        0:00:00.0000")
  expect_equal(res5[4],  "        9:00:00.0000")
  expect_equal(res5[5],  "        9:00:00.9877")
  expect_equal(res5[6],  "        9:00:01.0050")
  expect_equal(res5[7],  "        9:00:01.8365")
  expect_equal(res5[8],  "        9:59:59.9949")
  expect_equal(res5[9],  "        9:59:59.9950")
  expect_equal(res5[10], "       23:43:20.0000")
  expect_equal(res5[11], "      119:26:40.0000")
  expect_equal(res5[12], "     1388:53:20.0000")
  
  # time20.5
  expect_equal(res6[1],  "      -1:00:00.12345")
  expect_equal(res6[2],  "     -24:00:00.00000")
  expect_equal(res6[3],  "       0:00:00.00000")
  expect_equal(res6[4],  "       9:00:00.00000")
  expect_equal(res6[5],  "       9:00:00.98765")
  expect_equal(res6[6],  "       9:00:01.00500")
  expect_equal(res6[7],  "       9:00:01.83650")
  expect_equal(res6[8],  "       9:59:59.99490")
  expect_equal(res6[9],  "       9:59:59.99500")
  expect_equal(res6[10], "      23:43:20.00000")
  expect_equal(res6[11], "     119:26:40.00000")
  expect_equal(res6[12], "    1388:53:20.00000")
  
  # time20.6
  expect_equal(res7[1],  "     -1:00:00.123450")
  expect_equal(res7[2],  "    -24:00:00.000000")
  expect_equal(res7[3],  "      0:00:00.000000")
  expect_equal(res7[4],  "      9:00:00.000000")
  expect_equal(res7[5],  "      9:00:00.987654")
  expect_equal(res7[6],  "      9:00:01.005000")
  expect_equal(res7[7],  "      9:00:01.836500")
  expect_equal(res7[8],  "      9:59:59.994900")
  expect_equal(res7[9],  "      9:59:59.995000")
  expect_equal(res7[10], "     23:43:20.000000")
  expect_equal(res7[11], "    119:26:40.000000")
  expect_equal(res7[12], "   1388:53:20.000000")
  
  # time20.7
  expect_equal(res8[1],  "    -1:00:00.1234500")
  expect_equal(res8[2],  "   -24:00:00.0000000")
  expect_equal(res8[3],  "     0:00:00.0000000")
  expect_equal(res8[4],  "     9:00:00.0000000")
  expect_equal(res8[5],  "     9:00:00.9876543")
  expect_equal(res8[6],  "     9:00:01.0050000")
  expect_equal(res8[7],  "     9:00:01.8365000")
  expect_equal(res8[8],  "     9:59:59.9949000")
  expect_equal(res8[9],  "     9:59:59.9950000")
  expect_equal(res8[10], "    23:43:20.0000000")
  expect_equal(res8[11], "   119:26:40.0000000")
  expect_equal(res8[12], "  1388:53:20.0000000")
  
  # time20.8
  expect_equal(res9[1],  "   -1:00:00.12345000")
  expect_equal(res9[2],  "  -24:00:00.00000000")
  expect_equal(res9[3],  "    0:00:00.00000000")
  expect_equal(res9[4],  "    9:00:00.00000000")
  expect_equal(res9[5],  "    9:00:00.98765432")
  expect_equal(res9[6],  "    9:00:01.00500000")
  expect_equal(res9[7],  "    9:00:01.83650000")
  expect_equal(res9[8],  "    9:59:59.99490000")
  expect_equal(res9[9],  "    9:59:59.99500000")
  expect_equal(res9[10], "   23:43:20.00000000")
  expect_equal(res9[11], "  119:26:40.00000000")
  expect_equal(res9[12], " 1388:53:20.00000000")
  
  # time20.9
  expect_equal(res10[1],  "  -1:00:00.123450000")
  expect_equal(res10[2],  " -24:00:00.000000000")
  expect_equal(res10[3],  "   0:00:00.000000000")
  expect_equal(res10[4],  "   9:00:00.000000000")
  expect_equal(res10[5],  "   9:00:00.987654321")
  expect_equal(res10[6],  "   9:00:01.005000000")
  expect_equal(res10[7],  "   9:00:01.836500000")
  expect_equal(res10[8],  "   9:59:59.994900000")
  expect_equal(res10[9],  "   9:59:59.995000000")
  expect_equal(res10[10], "  23:43:20.000000000")
  expect_equal(res10[11], " 119:26:40.000000000")
  expect_equal(res10[12], "1388:53:20.000000000")
  
  # time20.10
  expect_equal(res11[1],  " -1:00:00.1234500000")
  expect_equal(res11[2],  "-24:00:00.0000000000")
  expect_equal(res11[3],  "  0:00:00.0000000000")
  expect_equal(res11[4],  "  9:00:00.0000000000")
  expect_equal(res11[5],  "  9:00:00.9876543210")
  expect_equal(res11[6],  "  9:00:01.0050000000")
  expect_equal(res11[7],  "  9:00:01.8365000000")
  expect_equal(res11[8],  "  9:59:59.9949000000")
  expect_equal(res11[9],  "  9:59:59.9950000000")
  expect_equal(res11[10], " 23:43:20.0000000000")
  expect_equal(res11[11], "119:26:40.0000000000")
  expect_equal(res11[12], "1388:53:20.000000000")
  
  # time20.11  
  expect_equal(res12[1],  "-1:00:00.12345000000")
  expect_equal(res12[2],  "-24:00:00.0000000000")
  expect_equal(res12[3],  " 0:00:00.00000000000")
  expect_equal(res12[4],  " 9:00:00.00000000000")
  expect_equal(res12[5],  " 9:00:00.98765432101")
  expect_equal(res12[6],  " 9:00:01.00500000000")
  expect_equal(res12[7],  " 9:00:01.83650000000")  
  expect_equal(res12[8],  " 9:59:59.99490000000")
  expect_equal(res12[9],  " 9:59:59.99500000000")
  expect_equal(res12[10], "23:43:20.00000000000")
  expect_equal(res12[11], "119:26:40.0000000000")
  expect_equal(res12[12], "1388:53:20.000000000")
  
  # time20.12
  expect_equal(res13[1],  "-1:00:00.12345000000")
  expect_equal(res13[2],  "-24:00:00.0000000000")
  expect_equal(res13[3],  "0:00:00.000000000000")
  expect_equal(res13[4],  "9:00:00.000000000000")
  expect_equal(res13[5],  "9:00:00.987654321012")
  expect_equal(res13[6],  "9:00:01.005000000001")
  expect_equal(res13[7],  "9:00:01.836500000001")
  expect_equal(res13[8],  "9:59:59.994899999998")
  expect_equal(res13[9],  "9:59:59.995000000003")
  expect_equal(res13[10], "23:43:20.00000000000")
  expect_equal(res13[11], "119:26:40.0000000000")
  expect_equal(res13[12], "1388:53:20.000000000")
  
  # time20.13
  expect_equal(res14[1],  "-1:00:00.12345000000")
  expect_equal(res14[2],  "-24:00:00.0000000000")
  expect_equal(res14[3],  "0:00:00.000000000000")
  expect_equal(res14[4],  "9:00:00.000000000000")
  expect_equal(res14[5],  "9:00:00.987654321012")
  expect_equal(res14[6],  "9:00:01.005000000001")
  expect_equal(res14[7],  "9:00:01.836500000001")
  expect_equal(res14[8],  "9:59:59.994899999998")
  expect_equal(res14[9],  "9:59:59.995000000003")
  expect_equal(res14[10], "23:43:20.00000000000")
  expect_equal(res14[11], "119:26:40.0000000000")
  expect_equal(res14[12], "1388:53:20.000000000")
  
  # time20.14
  expect_equal(res15[1],  "-1:00:00.12345000000")
  expect_equal(res15[2],  "-24:00:00.0000000000")
  expect_equal(res15[3],  "0:00:00.000000000000")
  expect_equal(res15[4],  "9:00:00.000000000000")
  expect_equal(res15[5],  "9:00:00.987654321012")
  expect_equal(res15[6],  "9:00:01.005000000001")
  expect_equal(res15[7],  "9:00:01.836500000001")
  expect_equal(res15[8],  "9:59:59.994899999998")
  expect_equal(res15[9],  "9:59:59.995000000003")
  expect_equal(res15[10], "23:43:20.00000000000")
  expect_equal(res15[11], "119:26:40.0000000000")
  expect_equal(res15[12], "1388:53:20.000000000")
  
  # time20.15
  expect_equal(res16[1],  "-1:00:00.12345000000")
  expect_equal(res16[2],  "-24:00:00.0000000000")
  expect_equal(res16[3],  "0:00:00.000000000000")
  expect_equal(res16[4],  "9:00:00.000000000000")
  expect_equal(res16[5],  "9:00:00.987654321012")
  expect_equal(res16[6],  "9:00:01.005000000001")
  expect_equal(res16[7],  "9:00:01.836500000001")
  expect_equal(res16[8],  "9:59:59.994899999998")
  expect_equal(res16[9],  "9:59:59.995000000003")
  expect_equal(res16[10], "23:43:20.00000000000")
  expect_equal(res16[11], "119:26:40.0000000000")
  expect_equal(res16[12], "1388:53:20.000000000")
  
  # time20.16
  expect_equal(res17[1],  "-1:00:00.12345000000")
  expect_equal(res17[2],  "-24:00:00.0000000000")
  expect_equal(res17[3],  "0:00:00.000000000000")
  expect_equal(res17[4],  "9:00:00.000000000000")
  expect_equal(res17[5],  "9:00:00.987654321012")
  expect_equal(res17[6],  "9:00:01.005000000001")
  expect_equal(res17[7],  "9:00:01.836500000001")
  expect_equal(res17[8],  "9:59:59.994899999998")
  expect_equal(res17[9],  "9:59:59.995000000003")
  expect_equal(res17[10], "23:43:20.00000000000")
  expect_equal(res17[11], "119:26:40.0000000000")
  expect_equal(res17[12], "1388:53:20.000000000")
  
  # time20.17
  expect_equal(res18[1],  "-1:00:00.12345000000")
  expect_equal(res18[2],  "-24:00:00.0000000000")
  expect_equal(res18[3],  "0:00:00.000000000000")
  expect_equal(res18[4],  "9:00:00.000000000000")
  expect_equal(res18[5],  "9:00:00.987654321012")
  expect_equal(res18[6],  "9:00:01.005000000001")
  expect_equal(res18[7],  "9:00:01.836500000001")
  expect_equal(res18[8],  "9:59:59.994899999998")
  expect_equal(res18[9],  "9:59:59.995000000003")
  expect_equal(res18[10], "23:43:20.00000000000")
  expect_equal(res18[11], "119:26:40.0000000000")
  expect_equal(res18[12], "1388:53:20.000000000")
  
  # time20.18
  expect_equal(res19[1],  "-1:00:00.12345000000")
  expect_equal(res19[2],  "-24:00:00.0000000000")
  expect_equal(res19[3],  "0:00:00.000000000000")
  expect_equal(res19[4],  "9:00:00.000000000000")
  expect_equal(res19[5],  "9:00:00.987654321012")
  expect_equal(res19[6],  "9:00:01.005000000001")
  expect_equal(res19[7],  "9:00:01.836500000001")
  expect_equal(res19[8],  "9:59:59.994899999998")
  expect_equal(res19[9],  "9:59:59.995000000003")
  expect_equal(res19[10], "23:43:20.00000000000")
  expect_equal(res19[11], "119:26:40.0000000000")
  expect_equal(res19[12], "1388:53:20.000000000")
  
  # time20.19
  expect_equal(res20[1],  "-1:00:00.12345000000")
  expect_equal(res20[2],  "-24:00:00.0000000000")
  expect_equal(res20[3],  "0:00:00.000000000000")
  expect_equal(res20[4],  "9:00:00.000000000000")
  expect_equal(res20[5],  "9:00:00.987654321012")
  expect_equal(res20[6],  "9:00:01.005000000001")
  expect_equal(res20[7],  "9:00:01.836500000001")
  expect_equal(res20[8],  "9:59:59.994899999998")
  expect_equal(res20[9],  "9:59:59.995000000003")
  expect_equal(res20[10], "23:43:20.00000000000")
  expect_equal(res20[11], "119:26:40.0000000000")
  expect_equal(res20[12], "1388:53:20.000000000")
  
})

test_that("timewd18: fapply() with difftime works as expected.", {
  
  t1 <- strptime("12:00", format = "%H:%M")
  t2 <- strptime("12:03:36", format = "%H:%M:%S")
  
  df1 <- t2 - t1  
  
  res <- fapply(df1, "time7")
  
  expect_equal(res, "0:03:36")
  
  
})



# test_that("timewd17: sas_round() work as expected", {
# 
#   v1 <- c(-1.25, -1.24, -0.15, -0.05, -0.04,
#           0,    0.04,  0.05,  0.15,  1.24,  1.25)
# 
#   v2 <- c(32401.90149999, 32400.8765, 32401.1004999999)
# 
#   res0 <- sas_round(v1, 0)
#   res1 <- sas_round(v1, 1)
#   
# 
#   expect_equal(res0, c(-1, -1,  0,  0,  0,
#                        0,  0,  0,  0,  1,  1))
# 
#   expect_equal(res1, c(-1.3, -1.2, -0.2, -0.1,  0.0,
#                        0.0,  0.0,  0.1,  0.2,  1.2,  1.3))
# 
#   expect_equal(sas_round(32401.90149999, 3), 32401.901)
#   expect_equal(sas_round(32400.876543, 3), 32400.877)
#   expect_equal(sas_round(32401.1004999999, 3), 32401.1)
# 
# })
