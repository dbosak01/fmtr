context("Datetime Tests")

options("logr.output" = FALSE)

Sys.setenv("LANGUAGE" = "EN")
Sys.setlocale("LC_TIME", "English")
Sys.setenv(TZ = "UTC")

test_that("datetimewd1: test error handling.", {
  
  dt <- as.POSIXct("2000-02-29 12:34:56", tz = "UTC", origin = "1970-01-01")
  
  expect_error(format_datetimewd(dt, 6))
  expect_error(format_datetimewd(dt, 41))
  expect_error(format_datetimewd(dt, 10, 10))
  expect_error(format_datetimewd(dt, 20, 40))
})

test_that("datetimewd2: format_timewd() work as expected.", {
  
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 = v1 - sas_offset
  
  dt_pos <-as.POSIXct(v2, tz="utc", origin = "1970-01-01")
  
  #numeric input
  expect_equal(
    format_datetimewd(v2, 7),
    c("29FEB00",
      "01JAN00",
      "15JUL15",
      "31DEC69",
      "01JAN00")
  )
  
  expect_equal(
    format_datetimewd(v2, 17, 2),
    c("29FEB00:12:34:56.",
      "31DEC99:23:59:59.",
      "15JUL15:08:09:10.",
      "31DEC69:23:59:59.",
      "31DEC99:23:59:59.")
  )
  
  expect_equal(
    format_datetimewd(v2, 21, 2),
    c("29FEB2000:12:34:56.00",
      "31DEC1999:23:59:59.99",
      "15JUL2015:08:09:10.00",
      "31DEC1969:23:59:59.16",
      "31DEC2099:23:59:59.74")
  )
  
  expect_equal(
    format_datetimewd(v2, 25, 4),
    c("  29FEB2000:12:34:56.0000",
      "  31DEC1999:23:59:59.9950",
      "  15JUL2015:08:09:10.0000",
      "  31DEC1969:23:59:59.1647",
      "  31DEC2099:23:59:59.7421")
  )
  
  expect_equal(
    format_datetimewd(v2, 27, 6),
    c("  29FEB2000:12:34:56.000000",
      "  31DEC1999:23:59:59.995000",
      "  15JUL2015:08:09:10.000000",
      "  31DEC1969:23:59:59.164720",
      "  31DEC2099:23:59:59.742086")
  )
  
  expect_equal(
    format_datetimewd(v2, 29, 8),
    c("  29FEB2000:12:34:56.00000000",
      "  31DEC1999:23:59:59.99499989",
      "  15JUL2015:08:09:10.00000000",
      "  31DEC1969:23:59:59.16472000",
      "  31DEC2099:23:59:59.74208641")
  )
  
  expect_equal(
    format_datetimewd(v2, 33, 12),
    c("  29FEB2000:12:34:56.000000000000",
      "  31DEC1999:23:59:59.994999885559",
      "  15JUL2015:08:09:10.000000000000",
      "  31DEC1969:23:59:59.164719998837",
      "  31DEC2099:23:59:59.742086410522")
  )
  
  # POSIXct input
  expect_equal(
    format_datetimewd(dt_pos, 7),
    c("29FEB00",
      "01JAN00",
      "15JUL15",
      "31DEC69",
      "01JAN00")
  )
  
  expect_equal(
    format_datetimewd(dt_pos, 17, 2),
    c("29FEB00:12:34:56.",
      "31DEC99:23:59:59.",
      "15JUL15:08:09:10.",
      "31DEC69:23:59:59.",
      "31DEC99:23:59:59.")
  )
  
  expect_equal(
    format_datetimewd(dt_pos, 21, 2),
    c("29FEB2000:12:34:56.00",
      "31DEC1999:23:59:59.99",
      "15JUL2015:08:09:10.00",
      "31DEC1969:23:59:59.16",
      "31DEC2099:23:59:59.74")
  )
  
  expect_equal(
    format_datetimewd(dt_pos, 25, 4),
    c("  29FEB2000:12:34:56.0000",
      "  31DEC1999:23:59:59.9950",
      "  15JUL2015:08:09:10.0000",
      "  31DEC1969:23:59:59.1647",
      "  31DEC2099:23:59:59.7421")
  )
  
})

test_that("datetimewd3: fapply() with datetime7. to datetime7.6 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime7.")
  res2 <- fapply(v2, "datetime7.1")
  res3 <- fapply(v2, "datetime7.2")
  res4 <- fapply(v2, "datetime7.3")
  res5 <- fapply(v2, "datetime7.4")
  res6 <- fapply(v2, "datetime7.5")
  res7 <- fapply(v2, "datetime7.6")
  
  # datetime7.
  expect_equal(res1[1], "29FEB00")
  expect_equal(res1[2], "01JAN00")
  expect_equal(res1[3], "15JUL15")
  expect_equal(res1[4], "31DEC69")
  expect_equal(res1[5], "01JAN00")
  
  # datetime7.1
  expect_equal(res2[1], "29FEB00")
  expect_equal(res2[2], "01JAN00")
  expect_equal(res2[3], "15JUL15")
  expect_equal(res2[4], "31DEC69")
  expect_equal(res2[5], "31DEC99")
  
  # datetime7.2
  expect_equal(res3[1], "29FEB00")
  expect_equal(res3[2], "31DEC99")
  expect_equal(res3[3], "15JUL15")
  expect_equal(res3[4], "31DEC69")
  expect_equal(res3[5], "31DEC99")
  
  # datetime7.3
  expect_equal(res4[1], "29FEB00")
  expect_equal(res4[2], "31DEC99")
  expect_equal(res4[3], "15JUL15")
  expect_equal(res4[4], "31DEC69")
  expect_equal(res4[5], "31DEC99")
  
  # datetime7.4
  expect_equal(res5[1], "29FEB00")
  expect_equal(res5[2], "31DEC99")
  expect_equal(res5[3], "15JUL15")
  expect_equal(res5[4], "31DEC69")
  expect_equal(res5[5], "31DEC99")
  
  # datetime7.5
  expect_equal(res6[1], "29FEB00")
  expect_equal(res6[2], "31DEC99")
  expect_equal(res6[3], "15JUL15")
  expect_equal(res6[4], "31DEC69")
  expect_equal(res6[5], "31DEC99")
  
  # datetime7.6
  expect_equal(res7[1], "29FEB00")
  expect_equal(res7[2], "31DEC99")
  expect_equal(res7[3], "15JUL15")
  expect_equal(res7[4], "31DEC69")
  expect_equal(res7[5], "31DEC99")
  
})


test_that("datetimewd4: fapply() with datetime9. to datetime9.8 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime9.")
  res2 <- fapply(v2, "datetime9.1")
  res3 <- fapply(v2, "datetime9.2")
  res4 <- fapply(v2, "datetime9.3")
  res5 <- fapply(v2, "datetime9.4")
  res6 <- fapply(v2, "datetime9.5")
  res7 <- fapply(v2, "datetime9.6")
  res8 <- fapply(v2, "datetime9.8")
  
  # datetime9.
  expect_equal(res1[1], "29FEB2000")
  expect_equal(res1[2], "01JAN2000")
  expect_equal(res1[3], "15JUL2015")
  expect_equal(res1[4], "31DEC1969")
  expect_equal(res1[5], "01JAN2100")
  
  # datetime9.1
  expect_equal(res2[1], "29FEB2000")
  expect_equal(res2[2], "01JAN2000")
  expect_equal(res2[3], "15JUL2015")
  expect_equal(res2[4], "31DEC1969")
  expect_equal(res2[5], "31DEC2099")
  
  # datetime9.2
  expect_equal(res3[1], "29FEB2000")
  expect_equal(res3[2], "31DEC1999")
  expect_equal(res3[3], "15JUL2015")
  expect_equal(res3[4], "31DEC1969")
  expect_equal(res3[5], "31DEC2099")
  
  # datetime9.3
  expect_equal(res4[1], "29FEB2000")
  expect_equal(res4[2], "31DEC1999")
  expect_equal(res4[3], "15JUL2015")
  expect_equal(res4[4], "31DEC1969")
  expect_equal(res4[5], "31DEC2099")
  
  # datetime9.4
  expect_equal(res5[1], "29FEB2000")
  expect_equal(res5[2], "31DEC1999")
  expect_equal(res5[3], "15JUL2015")
  expect_equal(res5[4], "31DEC1969")
  expect_equal(res5[5], "31DEC2099")
  
  # datetime9.5
  expect_equal(res6[1], "29FEB2000")
  expect_equal(res6[2], "31DEC1999")
  expect_equal(res6[3], "15JUL2015")
  expect_equal(res6[4], "31DEC1969")
  expect_equal(res6[5], "31DEC2099")
  
  # datetime9.6
  expect_equal(res7[1], "29FEB2000")
  expect_equal(res7[2], "31DEC1999")
  expect_equal(res7[3], "15JUL2015")
  expect_equal(res7[4], "31DEC1969")
  expect_equal(res7[5], "31DEC2099")
  
  # datetime9.8
  expect_equal(res8[1], "29FEB2000")
  expect_equal(res8[2], "31DEC1999")
  expect_equal(res8[3], "15JUL2015")
  expect_equal(res8[4], "31DEC1969")
  expect_equal(res8[5], "31DEC2099")
  
})


test_that("datetimewd5: fapply() with datetime15. to datetime15.12 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime15.")
  res2 <- fapply(v2, "datetime15.1")
  res3 <- fapply(v2, "datetime15.2")
  res4 <- fapply(v2, "datetime15.3")
  res5 <- fapply(v2, "datetime15.4")
  res6 <- fapply(v2, "datetime15.5")
  res7 <- fapply(v2, "datetime15.6")
  res8 <- fapply(v2, "datetime15.8")
  res9 <- fapply(v2, "datetime15.12")
  
  # datetime15.
  expect_equal(res1[1], "  29FEB00:12:34")
  expect_equal(res1[2], "  01JAN00:00:00")
  expect_equal(res1[3], "  15JUL15:08:09")
  expect_equal(res1[4], "  31DEC69:23:59")
  expect_equal(res1[5], "  01JAN00:00:00")
  
  # datetime15.1
  expect_equal(res2[1], "  29FEB00:12:34")
  expect_equal(res2[2], "  01JAN00:00:00")
  expect_equal(res2[3], "  15JUL15:08:09")
  expect_equal(res2[4], "  31DEC69:23:59")
  expect_equal(res2[5], "  31DEC99:23:59")
  
  # datetime15.2
  expect_equal(res3[1], "  29FEB00:12:34")
  expect_equal(res3[2], "  31DEC99:23:59")
  expect_equal(res3[3], "  15JUL15:08:09")
  expect_equal(res3[4], "  31DEC69:23:59")
  expect_equal(res3[5], "  31DEC99:23:59")
  
  # datetime15.3
  expect_equal(res4[1], "  29FEB00:12:34")
  expect_equal(res4[2], "  31DEC99:23:59")
  expect_equal(res4[3], "  15JUL15:08:09")
  expect_equal(res4[4], "  31DEC69:23:59")
  expect_equal(res4[5], "  31DEC99:23:59")
  
  # datetime15.4
  expect_equal(res5[1], "  29FEB00:12:34")
  expect_equal(res5[2], "  31DEC99:23:59")
  expect_equal(res5[3], "  15JUL15:08:09")
  expect_equal(res5[4], "  31DEC69:23:59")
  expect_equal(res5[5], "  31DEC99:23:59")
  
  # datetime15.5
  expect_equal(res6[1], "  29FEB00:12:34")
  expect_equal(res6[2], "  31DEC99:23:59")
  expect_equal(res6[3], "  15JUL15:08:09")
  expect_equal(res6[4], "  31DEC69:23:59")
  expect_equal(res6[5], "  31DEC99:23:59")
  
  # datetime15.6
  expect_equal(res7[1], "  29FEB00:12:34")
  expect_equal(res7[2], "  31DEC99:23:59")
  expect_equal(res7[3], "  15JUL15:08:09")
  expect_equal(res7[4], "  31DEC69:23:59")
  expect_equal(res7[5], "  31DEC99:23:59")
  
  # datetime15.8
  expect_equal(res8[1], "  29FEB00:12:34")
  expect_equal(res8[2], "  31DEC99:23:59")
  expect_equal(res8[3], "  15JUL15:08:09")
  expect_equal(res8[4], "  31DEC69:23:59")
  expect_equal(res8[5], "  31DEC99:23:59")
  
  # datetime15.12
  expect_equal(res9[1], "  29FEB00:12:34")
  expect_equal(res9[2], "  31DEC99:23:59")
  expect_equal(res9[3], "  15JUL15:08:09")
  expect_equal(res9[4], "  31DEC69:23:59")
  expect_equal(res9[5], "  31DEC99:23:59")
  
})


test_that("datetimewd6: fapply() with datetime17. to datetime17.12 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime17.")
  res2 <- fapply(v2, "datetime17.1")
  res3 <- fapply(v2, "datetime17.2")
  res4 <- fapply(v2, "datetime17.3")
  res5 <- fapply(v2, "datetime17.4")
  res6 <- fapply(v2, "datetime17.5")
  res7 <- fapply(v2, "datetime17.6")
  res8 <- fapply(v2, "datetime17.8")
  res9 <- fapply(v2, "datetime17.12")
  
  # datetime17.
  expect_equal(res1[1], "29FEB00:12:34:56")
  expect_equal(res1[2], "01JAN00:00:00:00")
  expect_equal(res1[3], "15JUL15:08:09:10")
  expect_equal(res1[4], "31DEC69:23:59:59")
  expect_equal(res1[5], "01JAN00:00:00:00")
  
  # datetime17.1
  expect_equal(res2[1], "29FEB00:12:34:56.")
  expect_equal(res2[2], "01JAN00:00:00:00.")
  expect_equal(res2[3], "15JUL15:08:09:10.")
  expect_equal(res2[4], "31DEC69:23:59:59.")
  expect_equal(res2[5], "31DEC99:23:59:59.")
  
  # datetime17.2
  expect_equal(res3[1], "29FEB00:12:34:56.")
  expect_equal(res3[2], "31DEC99:23:59:59.")
  expect_equal(res3[3], "15JUL15:08:09:10.")
  expect_equal(res3[4], "31DEC69:23:59:59.")
  expect_equal(res3[5], "31DEC99:23:59:59.")
  
  # datetime17.3
  expect_equal(res4[1], "29FEB00:12:34:56.")
  expect_equal(res4[2], "31DEC99:23:59:59.")
  expect_equal(res4[3], "15JUL15:08:09:10.")
  expect_equal(res4[4], "31DEC69:23:59:59.")
  expect_equal(res4[5], "31DEC99:23:59:59.")
  
  # datetime17.4
  expect_equal(res5[1], "29FEB00:12:34:56.")
  expect_equal(res5[2], "31DEC99:23:59:59.")
  expect_equal(res5[3], "15JUL15:08:09:10.")
  expect_equal(res5[4], "31DEC69:23:59:59.")
  expect_equal(res5[5], "31DEC99:23:59:59.")
  
  # datetime17.5
  expect_equal(res6[1], "29FEB00:12:34:56.")
  expect_equal(res6[2], "31DEC99:23:59:59.")
  expect_equal(res6[3], "15JUL15:08:09:10.")
  expect_equal(res6[4], "31DEC69:23:59:59.")
  expect_equal(res6[5], "31DEC99:23:59:59.")
  
  # datetime17.6
  expect_equal(res7[1], "29FEB00:12:34:56.")
  expect_equal(res7[2], "31DEC99:23:59:59.")
  expect_equal(res7[3], "15JUL15:08:09:10.")
  expect_equal(res7[4], "31DEC69:23:59:59.")
  expect_equal(res7[5], "31DEC99:23:59:59.")
  
  # datetime17.8
  expect_equal(res8[1], "29FEB00:12:34:56.")
  expect_equal(res8[2], "31DEC99:23:59:59.")
  expect_equal(res8[3], "15JUL15:08:09:10.")
  expect_equal(res8[4], "31DEC69:23:59:59.")
  expect_equal(res8[5], "31DEC99:23:59:59.")
  
  # datetime17.12
  expect_equal(res9[1], "29FEB00:12:34:56.")
  expect_equal(res9[2], "31DEC99:23:59:59.")
  expect_equal(res9[3], "15JUL15:08:09:10.")
  expect_equal(res9[4], "31DEC69:23:59:59.")
  expect_equal(res9[5], "31DEC99:23:59:59.")
  
})


test_that("datetimewd7: fapply() with datetime18. to datetime18.12 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime18.")
  res2 <- fapply(v2, "datetime18.1")
  res3 <- fapply(v2, "datetime18.2")
  res4 <- fapply(v2, "datetime18.3")
  res5 <- fapply(v2, "datetime18.4")
  res6 <- fapply(v2, "datetime18.5")
  res7 <- fapply(v2, "datetime18.6")
  res8 <- fapply(v2, "datetime18.8")
  res9 <- fapply(v2, "datetime18.12")
  
  # datetime18.
  expect_equal(res1[1], "  29FEB00:12:34:56")
  expect_equal(res1[2], "  01JAN00:00:00:00")
  expect_equal(res1[3], "  15JUL15:08:09:10")
  expect_equal(res1[4], "  31DEC69:23:59:59")
  expect_equal(res1[5], "  01JAN00:00:00:00")
  
  # datetime18.1
  expect_equal(res2[1], "29FEB00:12:34:56.0")
  expect_equal(res2[2], "01JAN00:00:00:00.0")
  expect_equal(res2[3], "15JUL15:08:09:10.0")
  expect_equal(res2[4], "31DEC69:23:59:59.2")
  expect_equal(res2[5], "31DEC99:23:59:59.7")
  
  # datetime18.2
  expect_equal(res3[1], "29FEB00:12:34:56.0")
  expect_equal(res3[2], "31DEC99:23:59:59.9")
  expect_equal(res3[3], "15JUL15:08:09:10.0")
  expect_equal(res3[4], "31DEC69:23:59:59.1")
  expect_equal(res3[5], "31DEC99:23:59:59.7")
  
  # datetime18.3
  expect_equal(res4[1], "29FEB00:12:34:56.0")
  expect_equal(res4[2], "31DEC99:23:59:59.9")
  expect_equal(res4[3], "15JUL15:08:09:10.0")
  expect_equal(res4[4], "31DEC69:23:59:59.1")
  expect_equal(res4[5], "31DEC99:23:59:59.7")
  
  # datetime18.4
  expect_equal(res5[1], "29FEB00:12:34:56.0")
  expect_equal(res5[2], "31DEC99:23:59:59.9")
  expect_equal(res5[3], "15JUL15:08:09:10.0")
  expect_equal(res5[4], "31DEC69:23:59:59.1")
  expect_equal(res5[5], "31DEC99:23:59:59.7")
  
  # datetime18.5
  expect_equal(res6[1], "29FEB00:12:34:56.0")
  expect_equal(res6[2], "31DEC99:23:59:59.9")
  expect_equal(res6[3], "15JUL15:08:09:10.0")
  expect_equal(res6[4], "31DEC69:23:59:59.1")
  expect_equal(res6[5], "31DEC99:23:59:59.7")
  
  # datetime18.6
  expect_equal(res7[1], "29FEB00:12:34:56.0")
  expect_equal(res7[2], "31DEC99:23:59:59.9")
  expect_equal(res7[3], "15JUL15:08:09:10.0")
  expect_equal(res7[4], "31DEC69:23:59:59.1")
  expect_equal(res7[5], "31DEC99:23:59:59.7")
  
  # datetime18.8
  expect_equal(res8[1], "29FEB00:12:34:56.0")
  expect_equal(res8[2], "31DEC99:23:59:59.9")
  expect_equal(res8[3], "15JUL15:08:09:10.0")
  expect_equal(res8[4], "31DEC69:23:59:59.1")
  expect_equal(res8[5], "31DEC99:23:59:59.7")
  
  # datetime18.12
  expect_equal(res9[1], "29FEB00:12:34:56.0")
  expect_equal(res9[2], "31DEC99:23:59:59.9")
  expect_equal(res9[3], "15JUL15:08:09:10.0")
  expect_equal(res9[4], "31DEC69:23:59:59.1")
  expect_equal(res9[5], "31DEC99:23:59:59.7")
  
})


test_that("datetimewd8: fapply() with datetime21. to datetime21.12 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime21.")
  res2 <- fapply(v2, "datetime21.1")
  res3 <- fapply(v2, "datetime21.2")
  res4 <- fapply(v2, "datetime21.3")
  res5 <- fapply(v2, "datetime21.4")
  res6 <- fapply(v2, "datetime21.5")
  res7 <- fapply(v2, "datetime21.6")
  res8 <- fapply(v2, "datetime21.8")
  res9 <- fapply(v2, "datetime21.12")
  
  # datetime21.
  expect_equal(res1[1], "   29FEB2000:12:34:56")
  expect_equal(res1[2], "   01JAN2000:00:00:00")
  expect_equal(res1[3], "   15JUL2015:08:09:10")
  expect_equal(res1[4], "   31DEC1969:23:59:59")
  expect_equal(res1[5], "   01JAN2100:00:00:00")
  
  # datetime21.1
  expect_equal(res2[1], "29FEB2000:12:34:56.0")
  expect_equal(res2[2], "01JAN2000:00:00:00.0")
  expect_equal(res2[3], "15JUL2015:08:09:10.0")
  expect_equal(res2[4], "31DEC1969:23:59:59.2")
  expect_equal(res2[5], "31DEC2099:23:59:59.7")
  
  # datetime21.2
  expect_equal(res3[1], "29FEB2000:12:34:56.00")
  expect_equal(res3[2], "31DEC1999:23:59:59.99")
  expect_equal(res3[3], "15JUL2015:08:09:10.00")
  expect_equal(res3[4], "31DEC1969:23:59:59.16")
  expect_equal(res3[5], "31DEC2099:23:59:59.74")
  
  # datetime21.3
  expect_equal(res4[1], "29FEB00:12:34:56.000")
  expect_equal(res4[2], "31DEC99:23:59:59.995")
  expect_equal(res4[3], "15JUL15:08:09:10.000")
  expect_equal(res4[4], "31DEC69:23:59:59.165")
  expect_equal(res4[5], "31DEC99:23:59:59.742")
  
  # datetime21.4
  expect_equal(res5[1], "29FEB00:12:34:56.0000")
  expect_equal(res5[2], "31DEC99:23:59:59.9950")
  expect_equal(res5[3], "15JUL15:08:09:10.0000")
  expect_equal(res5[4], "31DEC69:23:59:59.1647")
  expect_equal(res5[5], "31DEC99:23:59:59.7421")
  
  # datetime21.5
  expect_equal(res6[1], "29FEB00:12:34:56.0000")
  expect_equal(res6[2], "31DEC99:23:59:59.9950")
  expect_equal(res6[3], "15JUL15:08:09:10.0000")
  expect_equal(res6[4], "31DEC69:23:59:59.1647")
  expect_equal(res6[5], "31DEC99:23:59:59.7420")
  
  # datetime21.6
  expect_equal(res7[1], "29FEB00:12:34:56.0000")
  expect_equal(res7[2], "31DEC99:23:59:59.9950")
  expect_equal(res7[3], "15JUL15:08:09:10.0000")
  expect_equal(res7[4], "31DEC69:23:59:59.1647")
  expect_equal(res7[5], "31DEC99:23:59:59.7420")
  

  
})


test_that("datetimewd9: fapply() with datetime25. to datetime25.12 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime25.")
  res2 <- fapply(v2, "datetime25.1")
  res3 <- fapply(v2, "datetime25.2")
  res4 <- fapply(v2, "datetime25.3")
  res5 <- fapply(v2, "datetime25.4")
  res6 <- fapply(v2, "datetime25.5")
  res7 <- fapply(v2, "datetime25.6")
  res8 <- fapply(v2, "datetime25.8")
  res9 <- fapply(v2, "datetime25.12")
  
  # datetime25.
  expect_equal(res1[1], "       29FEB2000:12:34:56")
  expect_equal(res1[2], "       01JAN2000:00:00:00")
  expect_equal(res1[3], "       15JUL2015:08:09:10")
  expect_equal(res1[4], "       31DEC1969:23:59:59")
  expect_equal(res1[5], "       01JAN2100:00:00:00")
  
  # datetime25.1
  expect_equal(res2[1], "     29FEB2000:12:34:56.0")
  expect_equal(res2[2], "     01JAN2000:00:00:00.0")
  expect_equal(res2[3], "     15JUL2015:08:09:10.0")
  expect_equal(res2[4], "     31DEC1969:23:59:59.2")
  expect_equal(res2[5], "     31DEC2099:23:59:59.7")
  
  # datetime25.2
  expect_equal(res3[1], "    29FEB2000:12:34:56.00")
  expect_equal(res3[2], "    31DEC1999:23:59:59.99")
  expect_equal(res3[3], "    15JUL2015:08:09:10.00")
  expect_equal(res3[4], "    31DEC1969:23:59:59.16")
  expect_equal(res3[5], "    31DEC2099:23:59:59.74")
  
  # datetime25.3
  expect_equal(res4[1], "   29FEB2000:12:34:56.000")
  expect_equal(res4[2], "   31DEC1999:23:59:59.995")
  expect_equal(res4[3], "   15JUL2015:08:09:10.000")
  expect_equal(res4[4], "   31DEC1969:23:59:59.165")
  expect_equal(res4[5], "   31DEC2099:23:59:59.742")
  
  # datetime25.4
  expect_equal(res5[1], "  29FEB2000:12:34:56.0000")
  expect_equal(res5[2], "  31DEC1999:23:59:59.9950")
  expect_equal(res5[3], "  15JUL2015:08:09:10.0000")
  expect_equal(res5[4], "  31DEC1969:23:59:59.1647")
  expect_equal(res5[5], "  31DEC2099:23:59:59.7421")
  
  # datetime25.5
  expect_equal(res6[1], "29FEB2000:12:34:56.00000")
  expect_equal(res6[2], "31DEC1999:23:59:59.99500")
  expect_equal(res6[3], "15JUL2015:08:09:10.00000")
  expect_equal(res6[4], "31DEC1969:23:59:59.16472")
  expect_equal(res6[5], "31DEC2099:23:59:59.74209")
  
  # datetime25.6
  expect_equal(res7[1], "29FEB2000:12:34:56.000000")
  expect_equal(res7[2], "31DEC1999:23:59:59.995000")
  expect_equal(res7[3], "15JUL2015:08:09:10.000000")
  expect_equal(res7[4], "31DEC1969:23:59:59.164720")
  expect_equal(res7[5], "31DEC2099:23:59:59.742086")
  
  # datetime25.8
  expect_equal(res8[1], "29FEB00:12:34:56.00000000")
  expect_equal(res8[2], "31DEC99:23:59:59.99499989")
  expect_equal(res8[3], "15JUL15:08:09:10.00000000")
  expect_equal(res8[4], "31DEC69:23:59:59.16472000")
  expect_equal(res8[5], "31DEC99:23:59:59.74208641")
  
  # datetime25.12
  expect_equal(res9[1], "29FEB00:12:34:56.00000000")
  expect_equal(res9[2], "31DEC99:23:59:59.99499988")
  expect_equal(res9[3], "15JUL15:08:09:10.00000000")
  expect_equal(res9[4], "31DEC69:23:59:59.16471999")
  expect_equal(res9[5], "31DEC99:23:59:59.74208641")
  
})


test_that("datetimewd10: fapply() with datetime40. to datetime40.12 work as expected", {
  v1 <- c(1267446896,
          1262303999.995,
          1752566950,
          315619199.16472,
          4418063999.74208615)
  sas_offset <- 315619200
  
  v2 <- v1 - sas_offset
  
  res1 <- fapply(v2, "datetime40.")
  res2 <- fapply(v2, "datetime40.1")
  res3 <- fapply(v2, "datetime40.2")
  res4 <- fapply(v2, "datetime40.3")
  res5 <- fapply(v2, "datetime40.4")
  res6 <- fapply(v2, "datetime40.5")
  res7 <- fapply(v2, "datetime40.6")
  res8 <- fapply(v2, "datetime40.8")
  res9 <- fapply(v2, "datetime40.12")
  
  # datetime40.
  expect_equal(res1[1], "                      29FEB2000:12:34:56")
  expect_equal(res1[2], "                      01JAN2000:00:00:00")
  expect_equal(res1[3], "                      15JUL2015:08:09:10")
  expect_equal(res1[4], "                      31DEC1969:23:59:59")
  expect_equal(res1[5], "                      01JAN2100:00:00:00")
  
  # datetime40.1
  expect_equal(res2[1], "                    29FEB2000:12:34:56.0")
  expect_equal(res2[2], "                    01JAN2000:00:00:00.0")
  expect_equal(res2[3], "                    15JUL2015:08:09:10.0")
  expect_equal(res2[4], "                    31DEC1969:23:59:59.2")
  expect_equal(res2[5], "                    31DEC2099:23:59:59.7")
  
  # datetime40.2
  expect_equal(res3[1], "                   29FEB2000:12:34:56.00")
  expect_equal(res3[2], "                   31DEC1999:23:59:59.99")
  expect_equal(res3[3], "                   15JUL2015:08:09:10.00")
  expect_equal(res3[4], "                   31DEC1969:23:59:59.16")
  expect_equal(res3[5], "                   31DEC2099:23:59:59.74")
  
  # datetime40.3
  expect_equal(res4[1], "                  29FEB2000:12:34:56.000")
  expect_equal(res4[2], "                  31DEC1999:23:59:59.995")
  expect_equal(res4[3], "                  15JUL2015:08:09:10.000")
  expect_equal(res4[4], "                  31DEC1969:23:59:59.165")
  expect_equal(res4[5], "                  31DEC2099:23:59:59.742")
  
  # datetime40.4
  expect_equal(res5[1], "                 29FEB2000:12:34:56.0000")
  expect_equal(res5[2], "                 31DEC1999:23:59:59.9950")
  expect_equal(res5[3], "                 15JUL2015:08:09:10.0000")
  expect_equal(res5[4], "                 31DEC1969:23:59:59.1647")
  expect_equal(res5[5], "                 31DEC2099:23:59:59.7421")
  
  # datetime40.5
  expect_equal(res6[1], "                29FEB2000:12:34:56.00000")
  expect_equal(res6[2], "                31DEC1999:23:59:59.99500")
  expect_equal(res6[3], "                15JUL2015:08:09:10.00000")
  expect_equal(res6[4], "                31DEC1969:23:59:59.16472")
  expect_equal(res6[5], "                31DEC2099:23:59:59.74209")
  
  # datetime40.6
  expect_equal(res7[1], "               29FEB2000:12:34:56.000000")
  expect_equal(res7[2], "               31DEC1999:23:59:59.995000")
  expect_equal(res7[3], "               15JUL2015:08:09:10.000000")
  expect_equal(res7[4], "               31DEC1969:23:59:59.164720")
  expect_equal(res7[5], "               31DEC2099:23:59:59.742086")
  
  # datetime40.8
  expect_equal(res8[1], "             29FEB2000:12:34:56.00000000")
  expect_equal(res8[2], "             31DEC1999:23:59:59.99499989")
  expect_equal(res8[3], "             15JUL2015:08:09:10.00000000")
  expect_equal(res8[4], "             31DEC1969:23:59:59.16472000")
  expect_equal(res8[5], "             31DEC2099:23:59:59.74208641")
  
  # datetime40.12
  expect_equal(res9[1], "         29FEB2000:12:34:56.000000000000")
  expect_equal(res9[2], "         31DEC1999:23:59:59.994999885559")
  expect_equal(res9[3], "         15JUL2015:08:09:10.000000000000")
  expect_equal(res9[4], "         31DEC1969:23:59:59.164719998837")
  expect_equal(res9[5], "         31DEC2099:23:59:59.742086410522")
  
})

