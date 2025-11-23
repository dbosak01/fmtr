context("date Tests")

options("logr.output" = FALSE)
Sys.setenv("LANGUAGE" = "EN")
Sys.setlocale("LC_TIME", "English")

test_that("datew1: test error handling.", {
  
  
  expect_error(fapply(2018-03-15, "date4"))
  expect_error(fapply(2018-03-15, "date12"))
  expect_warning(fapply(2018-03-15, "datex"))
  expect_warning(fapply(2018-03-15, "I'd like to eat a date "))
  
})


test_that("datew2: format_datew() works as expected.", {
  
  v1 <- c("1900-01-01",
             "1912-06-15",
             "1924-02-29",
             NA,
             "1980-12-31",
             "2020-02-29",
             "2050-08-20",
             "2099-12-31")
  
  date = as.Date(v1)
  ndate = as.numeric(date, origin = "1970-01-01")
 
  
  res1 = format_datew(date,7)
  res2 = format_datew(ndate,7)
  
  expect_equal(res1[1], "01JAN00")
  expect_equal(res1[2], "15JUN12")
  expect_equal(res1[3], "29FEB24")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31DEC80")
  expect_equal(res1[6], "29FEB20")
  expect_equal(res1[7], "20AUG50")
  expect_equal(res1[8], "31DEC99")
  
  
  expect_equal(res2[1], "01JAN00")
  expect_equal(res2[2], "15JUN12")
  expect_equal(res2[3], "29FEB24")
  expect_equal(is.na( res2[4]), TRUE )
  expect_equal(res2[5], "31DEC80")
  expect_equal(res2[6], "29FEB20")
  expect_equal(res2[7], "20AUG50")
  expect_equal(res2[8], "31DEC99")
  
  res1 = format_datew(date,9)
  res2 = format_datew(ndate,9)
  
  expect_equal(res1[1], "01JAN1900")
  expect_equal(res1[2], "15JUN1912")
  expect_equal(res1[3], "29FEB1924")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31DEC1980")
  expect_equal(res1[6], "29FEB2020")
  expect_equal(res1[7], "20AUG2050")
  expect_equal(res1[8], "31DEC2099")
  
  expect_equal(res2[1], "01JAN1900")
  expect_equal(res2[2], "15JUN1912")
  expect_equal(res2[3], "29FEB1924")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], "31DEC1980")
  expect_equal(res2[6], "29FEB2020")
  expect_equal(res2[7], "20AUG2050")
  expect_equal(res2[8], "31DEC2099")
  
  res1 = format_datew(date,11)
  res2 = format_datew(ndate,11)
  
  expect_equal(res1[1], "01-JAN-1900")
  expect_equal(res1[2], "15-JUN-1912")
  expect_equal(res1[3], "29-FEB-1924")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31-DEC-1980")
  expect_equal(res1[6], "29-FEB-2020")
  expect_equal(res1[7], "20-AUG-2050")
  expect_equal(res1[8], "31-DEC-2099")
  
  expect_equal(res2[1], "01-JAN-1900")
  expect_equal(res2[2], "15-JUN-1912")
  expect_equal(res2[3], "29-FEB-1924")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], "31-DEC-1980")
  expect_equal(res2[6], "29-FEB-2020")
  expect_equal(res2[7], "20-AUG-2050")
  expect_equal(res2[8], "31-DEC-2099")

  
})

test_that("datew3: fapply with date5. format works as expected.", {

  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
  ndate = as.numeric(date, origin = "1970-01-01")
 
  
  res1 = fapply(date, "date5")
  res2 = fapply(date, "date5")

  expect_equal(res1[1], "01JAN")
  expect_equal(res1[2], "15JUN")
  expect_equal(res1[3], "29FEB")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31DEC")
  expect_equal(res1[6], "29FEB")
  expect_equal(res1[7], "20AUG")
  expect_equal(res1[8], "31DEC")
  
  expect_equal(res2[1], "01JAN")
  expect_equal(res2[2], "15JUN")
  expect_equal(res2[3], "29FEB")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], "31DEC")
  expect_equal(res2[6], "29FEB")
  expect_equal(res2[7], "20AUG")
  expect_equal(res2[8], "31DEC")

})

test_that("datew3: fapply with date6. format works as expected.", {
  
  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
  ndate = as.numeric(date, origin = "1970-01-01")
 
  
  res1 = fapply(date, "date6")
  res2 = fapply(ndate, "date6")
  
  expect_equal(res1[1], " 01JAN")
  expect_equal(res1[2], " 15JUN")
  expect_equal(res1[3], " 29FEB")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], " 31DEC")
  expect_equal(res1[6], " 29FEB")
  expect_equal(res1[7], " 20AUG")
  expect_equal(res1[8], " 31DEC")
  
  expect_equal(res2[1], " 01JAN")
  expect_equal(res2[2], " 15JUN")
  expect_equal(res2[3], " 29FEB")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], " 31DEC")
  expect_equal(res2[6], " 29FEB")
  expect_equal(res2[7], " 20AUG")
  expect_equal(res2[8], " 31DEC")
  
})

test_that("datew4: fapply with date7. format works as expected.", {
  
  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
  ndate = as.numeric(date, origin = "1970-01-01")
 
  
  res1 = fapply(date, "date7")
  res2 = fapply(ndate, "date7")

  expect_equal(res1[1], "01JAN00")
  expect_equal(res1[2], "15JUN12")
  expect_equal(res1[3], "29FEB24")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31DEC80")
  expect_equal(res1[6], "29FEB20")
  expect_equal(res1[7], "20AUG50")
  expect_equal(res1[8], "31DEC99")
  
  expect_equal(res2[1], "01JAN00")
  expect_equal(res2[2], "15JUN12")
  expect_equal(res2[3], "29FEB24")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], "31DEC80")
  expect_equal(res2[6], "29FEB20")
  expect_equal(res2[7], "20AUG50")
  expect_equal(res2[8], "31DEC99")
  
})

test_that("datew5: fapply with date8. format works as expected.", {
  
  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
 
  ndate = as.numeric(date, origin = "1970-01-01")
  
  res1 = fapply(date, "date8")
  res2 = fapply(ndate, "date8")
  
  
  expect_equal(res1[1], " 01JAN00")
  expect_equal(res1[2], " 15JUN12")
  expect_equal(res1[3], " 29FEB24")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], " 31DEC80")
  expect_equal(res1[6], " 29FEB20")
  expect_equal(res1[7], " 20AUG50")
  expect_equal(res1[8], " 31DEC99")

  
  expect_equal(res2[1], " 01JAN00")
  expect_equal(res2[2], " 15JUN12")
  expect_equal(res2[3], " 29FEB24")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], " 31DEC80")
  expect_equal(res2[6], " 29FEB20")
  expect_equal(res2[7], " 20AUG50")
  expect_equal(res2[8], " 31DEC99")
  
})

test_that("datew6: fapply with date9. format works as expected.", {
  
  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
 
  ndate = as.numeric(date, origin = "1970-01-01")
  
  res1 = fapply(date, "date9")
  res2 = fapply(ndate, "date9")
  
  
  expect_equal(res1[1], "01JAN1900")
  expect_equal(res1[2], "15JUN1912")
  expect_equal(res1[3], "29FEB1924")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31DEC1980")
  expect_equal(res1[6], "29FEB2020")
  expect_equal(res1[7], "20AUG2050")
  expect_equal(res1[8], "31DEC2099")
  
  expect_equal(res2[1], "01JAN1900")
  expect_equal(res2[2], "15JUN1912")
  expect_equal(res2[3], "29FEB1924")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], "31DEC1980")
  expect_equal(res2[6], "29FEB2020")
  expect_equal(res2[7], "20AUG2050")
  expect_equal(res2[8], "31DEC2099")
  
})

test_that("datew7: fapply with date10. format works as expected.", {
  
  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
 
  ndate = as.numeric(date, origin = "1970-01-01")
  
  res1 = fapply(date, "date10")
  res2 = fapply(ndate, "date10")
  
  
  expect_equal(res1[1], " 01JAN1900")
  expect_equal(res1[2], " 15JUN1912")
  expect_equal(res1[3], " 29FEB1924")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], " 31DEC1980")
  expect_equal(res1[6], " 29FEB2020")
  expect_equal(res1[7], " 20AUG2050")
  expect_equal(res1[8], " 31DEC2099")
  
  expect_equal(res2[1], " 01JAN1900")
  expect_equal(res2[2], " 15JUN1912")
  expect_equal(res2[3], " 29FEB1924")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], " 31DEC1980")
  expect_equal(res2[6], " 29FEB2020")
  expect_equal(res2[7], " 20AUG2050")
  expect_equal(res2[8], " 31DEC2099")
  
})

test_that("datew8: fapply with date11. format works as expected.", {
  
  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
 
  ndate = as.numeric(date, origin = "1970-01-01")
  
  res1 = fapply(date, "date11")
  res2 = fapply(ndate, "date11")
  
  
  expect_equal(res1[1], "01-JAN-1900")
  expect_equal(res1[2], "15-JUN-1912")
  expect_equal(res1[3], "29-FEB-1924")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31-DEC-1980")
  expect_equal(res1[6], "29-FEB-2020")
  expect_equal(res1[7], "20-AUG-2050")
  expect_equal(res1[8], "31-DEC-2099")
  
  expect_equal(res2[1], "01-JAN-1900")
  expect_equal(res2[2], "15-JUN-1912")
  expect_equal(res2[3], "29-FEB-1924")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], "31-DEC-1980")
  expect_equal(res2[6], "29-FEB-2020")
  expect_equal(res2[7], "20-AUG-2050")
  expect_equal(res2[8], "31-DEC-2099")
  
})

test_that("datew9: test default value handling.", {
  
  v1 <- c("1900-01-01",
          "1912-06-15",
          "1924-02-29",
          NA,
          "1980-12-31",
          "2020-02-29",
          "2050-08-20",
          "2099-12-31")
  
  date = as.Date(v1)
  ndate = as.numeric(date, origin = "1970-01-01")
 
  
  res1 = fapply(date, "date")
  res2 = fapply(ndate, "date")
  
  expect_equal(res1[1], "01JAN00")
  expect_equal(res1[2], "15JUN12")
  expect_equal(res1[3], "29FEB24")
  expect_equal(is.na(res1[4]), TRUE )
  expect_equal(res1[5], "31DEC80")
  expect_equal(res1[6], "29FEB20")
  expect_equal(res1[7], "20AUG50")
  expect_equal(res1[8], "31DEC99")
  
  expect_equal(res2[1], "01JAN00")
  expect_equal(res2[2], "15JUN12")
  expect_equal(res2[3], "29FEB24")
  expect_equal(is.na(res2[4]), TRUE )
  expect_equal(res2[5], "31DEC80")
  expect_equal(res2[6], "29FEB20")
  expect_equal(res2[7], "20AUG50")
  expect_equal(res2[8], "31DEC99")
  
})

test_that("datew10: test case sensitivity of the format name.", {
  
  date = as.Date("2025-08-06")
  
  res1 = fapply(date, "date9.")
  res2 = fapply(date, "DATE9")
  res3 = fapply(date, "Date9")
  res4 = fapply(date, "Date9.")
  res5 = fapply(date, "daTe9")
  
  expect_equal(res1, "06AUG2025")
  expect_equal(res2, "06AUG2025")
  expect_equal(res3, "06AUG2025")
  expect_equal(res4, "06AUG2025")
  expect_equal(res5, "06AUG2025")
  

})

test_that("datew11: fapply with POSIXt class work as expected", {
  
  v1 = c(
    "2025-01-01 10:30:00",
    "2025-02-15 23:59:59",
    "2025-03-20 08:05:12",
    "2025-04-10 14:45:30",
    "2025-05-05 00:00:00"
  )
  
  datetime = as.POSIXct(v1)
  
  res1 = fapply(datetime, "date7")
  res2 = fapply(datetime, "date11")
  
  expect_equal(res1[1], "01JAN25")
  expect_equal(res1[2], "15FEB25")
  expect_equal(res1[3], "20MAR25")
  expect_equal(res1[4], "10APR25")
  expect_equal(res1[5], "05MAY25")
  
  expect_equal(res2[1], "01-JAN-2025")
  expect_equal(res2[2], "15-FEB-2025")
  expect_equal(res2[3], "20-MAR-2025")
  expect_equal(res2[4], "10-APR-2025")
  expect_equal(res2[5], "05-MAY-2025")
  
  
})
