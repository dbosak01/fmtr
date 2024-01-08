## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(rmarkdown.html_vignette.check_title = FALSE)


## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(sassy)
#  
#  # Prepare Log -------------------------------------------------------------
#  
#  
#  options("logr.autolog" = TRUE,
#          "logr.notes" = FALSE)
#  
#  # Get temp location for log and report output
#  tmp <- tempdir()
#  
#  # Open log
#  lf <- log_open(file.path(tmp, "example2.log"))
#  
#  
#  # Load and Prepare Data ---------------------------------------------------
#  
#  sep("Prepare Data")
#  
#  # Get path to sample data
#  pkg <- system.file("extdata", package = "fmtr")
#  
#  # Define data library
#  libname(sdtm, pkg, "csv")
#  
#  # Prepare data
#  put("Subset DM dataset")
#  dm_mod <- subset(sdtm$DM, ARM != "SCREEN FAILURE",
#                   v(USUBJID, SEX, AGE, ARM)) |> put()
#  
#  put("Get ARM population counts")
#  arm_pop <- proc_freq(dm_mod, tables = ARM,
#                       output = long,
#                       options = v(nocum, nopercent, nonobs))
#  
#  
#  # Create Format Catalog --------------------------------------------------
#  sep("Create format catalog")
#  
#  fmts <- fcat(AGECAT = value(condition(x >= 18 & x <= 24, "18 to 24"),
#                              condition(x >= 25 & x <= 44, "25 to 44"),
#                              condition(x >= 45 & x <= 64, "45 to 64"),
#                              condition(x >= 65, ">= 65")),
#               SEX = value(condition(is.na(x), "Missing", order = 3),
#                           condition(x == "M", "Male", order = 1),
#                           condition(x == "F", "Female", order = 2)),
#               VAR = c("AGE" = "Age",
#                       "AGECAT" = "Age Group",
#                       "SEX" = "Sex"))
#  
#  numfmts <- fcat(N = "%d", MEAN = "%.1f", STD = "(%04.2f)", MEDIAN = "%d", Q1 = "%.1f",
#                  Q3 = "%.1f", MIN = "%d", MAX = "%d", CNT = "%d", PCT = "(%4.1f%%)")
#  
#  numlbls <- c(N = "n", MEANSD = "Mean (SD)", MEDIAN = "Median", Q1Q3 = "Q1 - Q3",
#               MINMAX = "Min - Max")
#  
#  # Age Summary Block -------------------------------------------------------
#  
#  sep("Create summary statistics for age")
#  
#  age_block <- proc_means(dm_mod, stats = v(n, mean, std, median, q1, q3, min, max),
#                          class = ARM, options = v(nway, notype, nofreq)) |>
#    datastep(format = numfmts,
#             keep = v(CLASS, VAR, N, MEANSD, MEDIAN, Q1Q3, MINMAX),
#             {
#  
#               MEANSD <- fapply2(MEAN, STD)
#               Q1Q3 <- fapply2(Q1, Q3, sep = " - ")
#               MINMAX <- fapply2(MIN, MAX, sep = " - ")
#             }) |>
#    proc_transpose(id = CLASS, copy = VAR,
#                   var = v(N, MEANSD, MEDIAN, Q1Q3, MINMAX),
#                   name = "LABEL") |>
#    datastep({LABEL <- fapply(LABEL, numlbls)})
#  
#  
#  # Age Group Block ----------------------------------------------------------
#  
#  sep("Create frequency counts for Age Group")
#  
#  put("Create age group frequency counts")
#  ageg_block <- dm_mod |>
#    datastep({AGECAT <- fapply(AGE, fmts$AGECAT)}) |>
#    proc_freq(tables = AGECAT, by = ARM,
#              options = nonobs) |>
#    datastep(format = numfmts,
#             keep = v(VAR, BY, LABEL, CNTPCT),
#             {
#               LABEL <- CAT
#               CNTPCT <- fapply2(CNT, PCT)
#             }) |>
#    proc_transpose(var = CNTPCT, by = LABEL, copy = VAR, id = BY, options = noname)
#  
#  put("Sort age groups as desired")
#  ageg_block$LABEL <- factor(ageg_block$LABEL, levels = levels(fmts$AGECAT))
#  ageg_block <- proc_sort(ageg_block, by = LABEL, as.character = TRUE)
#  
#  
#  # Sex Block ---------------------------------------------------------------
#  
#  sep("Create frequency counts for SEX")
#  
#  put("Create sex frequency counts")
#  sex_block <- dm_mod |>
#    datastep({SEX <- fapply(SEX, fmts$SEX)}) |>
#    proc_freq(tables = SEX, by = ARM,
#              options = nonobs) |>
#    datastep(format = numfmts,
#             keep = v(VAR, BY, LABEL, CNTPCT),
#             {
#               LABEL <- CAT
#               CNTPCT <- fapply2(CNT, PCT)
#             }) |>
#    proc_transpose(var = CNTPCT, by = LABEL, copy = VAR, id = BY, options = noname)
#  
#  put("Sort age groups as desired")
#  sex_block$LABEL <- factor(sex_block$LABEL, levels = levels(fmts$SEX))
#  sex_block <- proc_sort(sex_block, by = LABEL, as.character = TRUE)
#  
#  
#  put("Combine blocks into final data frame")
#  final <- bind_rows(age_block, ageg_block, sex_block) |> put()
#  
#  # Report ------------------------------------------------------------------
#  
#  
#  sep("Create and print report")
#  
#  # Create Table
#  tbl <- create_table(final, first_row_blank = TRUE, borders = c("top", "bottom")) |>
#    column_defaults(from = `ARM A`, to = `ARM D`, align = "center", width = 1.25) |>
#    stub(vars = v(VAR, LABEL), "Variable", width = 2.5) |>
#    define(VAR, blank_after = TRUE, dedupe = TRUE, label = "Variable",
#           format = fmts$VAR,label_row = TRUE) |>
#    define(LABEL, indent = .25, label = "Demographic Category") |>
#    define(`ARM A`,  label = "Treatment Group 1", n = arm_pop["ARM A"]) |>
#    define(`ARM B`,  label = "Treatment Group 2", n = arm_pop["ARM B"]) |>
#    define(`ARM C`,  label = "Treatment Group 3", n = arm_pop["ARM C"]) |>
#    define(`ARM D`,  label = "Treatment Group 4", n = arm_pop["ARM D"])
#  
#  rpt <- create_report(file.path(tmp, "output/example2.rtf"),
#                       output_type = "RTF", font = "Arial") |>
#    set_margins(top = 1, bottom = 1) |>
#    page_header("Sponsor: Company", "Study: ABC") |>
#    titles("Table 1.0", bold = TRUE, blank_row = "none") |>
#    titles("Analysis of Demographic Characteristics",
#           "Safety Population") |>
#    add_content(tbl) |>
#    footnotes("Program: DM_Table.R",
#              "NOTE: Denominator based on number of non-missing responses.") |>
#    page_footer(paste0("Date Produced: ", fapply(Sys.time(), "%d%b%y %H:%M")),
#                right = "Page [pg] of [tpg]")
#  
#  res <- write_report(rpt)
#  
#  
#  # Clean Up ----------------------------------------------------------------
#  sep("Clean Up")
#  
#  # Close log
#  log_close()
#  
#  # View report
#  # file.show(res$modified_path)
#  
#  # View log
#  # file.show(lf)
#  
#  
#  

