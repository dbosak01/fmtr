## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(rmarkdown.html_vignette.check_title = FALSE)


## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(tidyverse)
#  library(sassy)
#  
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
#  lf <- log_open(file.path(tmp, "example1.log"))
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
#  dm_mod <- sdtm$DM %>%
#    select(USUBJID, SEX, AGE, ARM) %>%
#    filter(ARM != "SCREEN FAILURE") %>%
#    put()
#  
#  
#  put("Get ARM population counts")
#  arm_pop <- count(dm_mod, ARM) %>% deframe() %>% put()
#  
#  # Create Format Catalog --------------------------------------------------
#  sep("Create format catalog")
#  
#  fmts <- fcat(AGECAT = value(condition(x >= 18 & x <= 24, "18 to 24"),
#                              condition(x >= 25 & x <= 44, "25 to 44"),
#                              condition(x >= 45 & x <= 64, "45 to 64"),
#                              condition(x >= 65, ">= 65"),
#                              condition(TRUE, "Other")),
#               SEX = value(condition(is.na(x), "Missing"),
#                           condition(x == "M", "Male"),
#                           condition(x == "F", "Female"),
#                           condition(TRUE, "Other")),
#               VAR = c("AGE" = "Age",
#                       "AGECAT" = "Age Group",
#                       "SEX" = "Sex"))
#  put(fmts)
#  
#  # Age Summary Block -------------------------------------------------------
#  
#  sep("Create summary statistics for age")
#  
#  age_block <-
#    dm_mod %>%
#    group_by(ARM) %>%
#    summarise( N = fmt_n(AGE),
#               `Mean (SD)` = fmt_mean_sd(AGE),
#               Median = fmt_median(AGE),
#               `Q1 - Q3` = fmt_quantile_range(AGE),
#               Range  = fmt_range(AGE)) %>%
#    pivot_longer(-ARM,
#                 names_to  = "label",
#                 values_to = "value") %>%
#    pivot_wider(names_from = ARM,
#                values_from = "value") %>%
#    add_column(var = "AGE", .before = "label") %>%
#    put()
#  
#  
#  # Age Group Block ----------------------------------------------------------
#  
#  sep("Create frequency counts for Age Group")
#  
#  
#  put("Create age group frequency counts")
#  ageg_block <-
#    dm_mod %>%
#    mutate(AGECAT = fapply(AGE, fmts$AGECAT)) %>%
#    select(ARM, AGECAT) %>%
#    group_by(ARM, AGECAT) %>%
#    summarize(n = n()) %>%
#    pivot_wider(names_from = ARM,
#                values_from = n,
#                values_fill = 0) %>%
#    transmute(var = "AGECAT",
#              label =  factor(AGECAT, levels = c("18 to 24",
#                                                 "25 to 44",
#                                                 "45 to 64",
#                                                 ">= 65")),
#              `ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
#              `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
#              `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
#              `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"])) %>%
#    arrange(label) %>%
#    put()
#  
#  
#  # Sex Block ---------------------------------------------------------------
#  
#  sep("Create frequency counts for SEX")
#  
#  
#  # Create sex frequency counts
#  sex_block <-
#    dm_mod %>%
#    select(ARM, SEX) %>%
#    group_by(ARM, SEX) %>%
#    summarize(n = n()) %>%
#    pivot_wider(names_from = ARM,
#                values_from = n,
#                values_fill = 0) %>%
#    transmute(var = "SEX",
#              label =   fct_relevel(SEX, "M", "F"),
#              `ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
#              `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
#              `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
#              `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"])) %>%
#    arrange(label) %>%
#    mutate(label = fapply(label, fmts$SEX)) %>%
#    put()
#  
#  put("Combine blocks into final data frame")
#  final <- bind_rows(age_block, ageg_block, sex_block) %>% put()
#  
#  # Report ------------------------------------------------------------------
#  
#  
#  sep("Create and print report")
#  
#  
#  # Create Table
#  tbl <- create_table(final, first_row_blank = TRUE, borders = c("top", "bottom")) %>%
#    column_defaults(from = `ARM A`, to = `ARM D`, align = "center", width = 1.25) %>%
#    stub(vars = c("var", "label"), "Variable", width = 2.5) %>%
#    define(var, blank_after = TRUE, dedupe = TRUE, label = "Variable",
#           format = fmts$VAR,label_row = TRUE) %>%
#    define(label, indent = .25, label = "Demographic Category") %>%
#    define(`ARM A`,  label = "Treatment Group 1", n = arm_pop["ARM A"]) %>%
#    define(`ARM B`,  label = "Treatment Group 2", n = arm_pop["ARM B"]) %>%
#    define(`ARM C`,  label = "Treatment Group 3", n = arm_pop["ARM C"]) %>%
#    define(`ARM D`,  label = "Treatment Group 4", n = arm_pop["ARM D"])
#  
#  rpt <- create_report(file.path(tmp, "output/example1.rtf"),
#                       output_type = "RTF", font = "Arial") %>%
#    set_margins(top = 1, bottom = 1) %>%
#    page_header("Sponsor: Company", "Study: ABC") %>%
#    titles("Table 1.0", bold = TRUE, blank_row = "none") %>%
#    titles("Analysis of Demographic Characteristics",
#           "Safety Population") %>%
#    add_content(tbl) %>%
#    footnotes("Program: DM_Table.R",
#              "NOTE: Denominator based on number of non-missing responses.") %>%
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
#  # View Log
#  # file.show(lf)
#  
#  
#  

