## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(rmarkdown.html_vignette.check_title = FALSE)


## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Create sample data
#  dat <- data.frame(SUBJ = c(1, 2, 3),
#                    BDATE = c(as.Date("1945-10-17"),
#                              as.Date("1967-09-04"),
#                              as.Date("1998-04-28")),
#                    SEX = c("M", "F", "M"),
#                    WEIGHT = c(77.1107, 64.2848, 85.9842))
#  
#  # View data
#  dat
#  #   SUBJ      BDATE SEX  WEIGHT
#  # 1    1 1945-10-17   M 77.1107
#  # 2    2 1967-09-04   F 64.2848
#  # 3    3 1998-04-28   M 85.9842
#  
#  # Assign formats
#  formats(dat) <- list(BDATE = "%Y/%m/%d",
#                       SEX = c("M" = "Male", "F" = "Female"),
#                       WEIGHT = "%1.1f kg")
#  
#  # Apply formats to new data frame
#  dat2 <- fdata(dat)
#  
#  # View new data frame
#  dat2
#  #   SUBJ      BDATE    SEX  WEIGHT
#  # 1    1 1945/10/17   Male 77.1 kg
#  # 2    2 1967/09/04 Female 64.3 kg
#  # 3    3 1998/04/28   Male 86.0 kg

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  fmt <- value(condition(x < 5, "A"),
#               condition(x >= 5, "B"))
#  
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  dat <- data.frame(ID = c(1, 2, 3),
#                    NUM = c(2, 3, 7))

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Base R method
#  dat$CAT <- fapply(dat$NUM, fmt)
#  
#  # View result
#  dat
#  #   ID NUM CAT
#  # 1  1   2   A
#  # 2  2   3   A
#  # 3  3   7   B
#  
#  # tidyverse method
#  dat <- dat %>%
#         mutate(CAT = fapply(NUM, fmt))
#  
#  dat
#  #   ID NUM CAT
#  # 1  1   2   A
#  # 2  2   3   A
#  # 3  3   7   B
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Create sample data frame
#  dat <- data.frame(ID = c(1, 2, 3, 4),
#                    CODE = c("A", "C", "B", NA))
#  
#  # Create decode vector
#  v1 <- c(A = "Value A", B = "Value B", C = "Value C")
#  
#  # Create user-defined format
#  fmt1 <- value(condition(x == "A", "Value A"),
#                condition(x == "B", "Value B"),
#                condition(x == "C", "Value C"),
#                condition(TRUE, "Other"))
#  
#  # Apply decode vector
#  fapply(dat$CODE, v1)
#  # [1] "Value A" "Value C" "Value B" NA
#  
#  # Apply user-defined format
#  fapply(dat$CODE, fmt1)
#  # [1] "Value A" "Value C" "Value B" "Other"

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Sample metadata
#  mdat <- data.frame(var = c("col1", "col2", "col3"),
#                     fmt = c("%1.1f", "%m-%d-%Y", "%1.2f%%"))
#  
#  # View metadata
#  mdat
#  #    var      fmt
#  # 1 col1    %1.1f
#  # 2 col2 %m-%d-%Y
#  # 3 col3  %1.2f%%
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Sample data
#  dat <- data.frame(col1 = c(1.235, 3.3947, 7.2842),
#                    col2 = c(as.Date("2021-11-01"),
#                             as.Date("2021-11-02"),
#                             as.Date("2021-11-03")),
#                    col3 = c(23.325, 87.2746, 64.2184))
#  
#  # View sample data
#  dat
#  #     col1       col2    col3
#  # 1 1.2350 2021-11-01 23.3250
#  # 2 3.3947 2021-11-02 87.2746
#  # 3 7.2842 2021-11-03 64.2184

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Create list out of metadata vectors
#  lst <- as.list(mdat$fmt)
#  names(lst) <- mdat$var
#  
#  # View List
#  lst
#  # $col1
#  # [1] "%1.1f"
#  #
#  # $col2
#  # [1] "%m-%d-%Y"
#  #
#  # $col3
#  # [1] "%1.2f%%"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Assign formats to data
#  formats(dat) <- lst
#  
#  # Data not formatted yet
#  dat
#  #     col1       col2    col3
#  # 1 1.2350 2021-11-01 23.3250
#  # 2 3.3947 2021-11-02 87.2746
#  # 3 7.2842 2021-11-03 64.2184
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Apply the formats to entire data frame
#  fdata(dat)
#  #   col1       col2   col3
#  # 1  1.2 11-01-2021 23.32%
#  # 2  3.4 11-02-2021 87.27%
#  # 3  7.3 11-03-2021 64.22%

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Create sample list of labels
#  lst <- list(col1 = "My First Columns",
#              col2 = "My Second Column",
#              col3 = "My Third Column")
#  
#  # Create sample data frame
#  dat <- data.frame(col1 = c(1.235, 3.3947, 7.2842),
#                    col2 = c(as.Date("2021-11-01"),
#                             as.Date("2021-11-02"),
#                             as.Date("2021-11-03")),
#                    col3 = c(23.325, 87.2746, 64.2184))
#  
#  # Assign labels to data frame
#  labels(dat) <- lst
#  
#  # View label attributes
#  labels(dat)
#  # $col1
#  # [1] "My First Columns"
#  #
#  # $col2
#  # [1] "My Second Column"
#  #
#  # $col3
#  # [1] "My Third Column"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Assign descriptions
#  descriptions(dat) <- list(col1 = "Here is my description for col1.",
#                            col2 = "Here is my description for col2.",
#                            col3 = "Here is my description for col3.")
#  
#  # View descriptions
#  descriptions(dat)
#  # $col1
#  # [1] "Here is my description for col1."
#  #
#  # $col2
#  # [1] "Here is my description for col2."
#  #
#  # $col3
#  # [1] "Here is my description for col3."
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(fmtr)
#  
#  # Create format catalog
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
#  
#  # Save format catalog
#  write.fcat(fmts, "c:/mypath")
#  
#  # Read format catalog back in
#  fmts <- read.fcat("c:/mypath/fmts.fcat")
#  
#  # View format catalog
#  fmts
#  # # A format catalog: 3 formats
#  # - $AGECAT: type U, 5 conditions
#  # - $SEX: type U, 4 conditions
#  # - $VAR: type V, 3 elements
#  
#  # Use restored formats
#  fapply(c(55, 27, 19), fmts$AGECAT)
#  # [1] "45 to 64" "25 to 44" "18 to 24"

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Read format catalog back in
#  fmts <- read.fcat("c:/mypath/fmts.fcat")
#  
#  # View format catalog
#  fmts
#  # # A format catalog: 3 formats
#  # - $AGECAT: type U, 5 conditions
#  # - $SEX: type U, 4 conditions
#  # - $VAR: type V, 3 elements
#  
#  # Use restored formats
#  fapply(c(55, 27, 19), fmts$AGECAT)
#  # [1] "45 to 64" "25 to 44" "18 to 24"
#  
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Read format catalog in
#  fmts <- read.fcat("c:/mypath/fmts.fcat")
#  
#  # View format catalog
#  fmts
#  # # A format catalog: 3 formats
#  # - $AGECAT: type U, 5 conditions
#  # - $SEX: type U, 4 conditions
#  # - $VAR: type V, 3 elements
#  
#  # Create sample data frame
#  dat <- read.table(header = TRUE, text = '
#  SUBJECT  AGECAT SEX
#  101       35      F
#  102       19      F
#  103       57      M
#  ')
#  
#  # Assign formats from catalog to data frame
#  formats(dat) <- fmts
#  
#  # View formatted data
#  fdata(dat)
#  #   SUBJECT   AGECAT    SEX
#  # 1     101 25 to 44 Female
#  # 2     102 18 to 24 Female
#  # 3     103 45 to 64   Male
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Read format catalog in
#  fmts <- read.fcat("c:/packages/fmts.fcat")
#  
#  # View format catalog
#  fmts
#  # # A format catalog: 3 formats
#  # - $AGECAT: type U, 5 conditions
#  # - $SEX: type U, 4 conditions
#  # - $VAR: type V, 3 elements
#  
#  # Create sample data frame
#  dat <- read.table(header = TRUE, text = '
#  SUBJ     AGE GENDER
#  101       35      F
#  102       19      F
#  103       57      M
#  ')
#  
#  # Reassign format names in catalog
#  names(fmts) <- c("AGE", "GENDER", "VAR")
#  
#  # Assign formats from catalog to data frame
#  formats(dat) <- fmts
#  
#  # View formatted data
#  fdata(dat)
#  #   SUBJECT   AGECAT    SEX
#  # 1     101 25 to 44 Female
#  # 2     102 18 to 24 Female
#  # 3     103 45 to 64   Male

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(fmtr)
#  library(readxl)
#  
#  # Read data from Excel
#  xldat <- read_excel("c:\\packages\\myxlfile.xlsx")
#  
#  # View data frame
#  xldat
#  # # A tibble: 10 x 5
#  # Name   Type  Expression                                                Label    Order
#  # <chr>  <chr> <chr>                                                     <chr>    <lgl>
#  # 1  AGECAT U     "x >= 18 & x <= 24"                                       18 to 24 NA
#  # 2  AGECAT U     "x >= 25 & x <= 44"                                       25 to 44 NA
#  # 3  AGECAT U     "x >= 45 & x <= 64"                                       45 to 64 NA
#  # 4  AGECAT U     "x >= 65"                                                 >= 65    NA
#  # 5  AGECAT U     "TRUE"                                                    Other    NA
#  # 6  SEX    U     "is.na(x)"                                                Missing  NA
#  # 7  SEX    U     "x == \"M\""                                              Male     NA
#  # 8  SEX    U     "x == \"F\""                                              Female   NA
#  # 9  SEX    U     "TRUE"                                                    Other    NA
#  # 10 VAR    V     "c(AGE = \"Age\", AGECAT = \"Age Group\", SEX = \"Sex\")" NA       NA
#  
#  # Convert dataframe to format catalog
#  fmts <- as.fcat(xldat)
#  
#  # View format catalog
#  fmts
#  # # A format catalog: 3 formats
#  # - $AGECAT: type U, 5 conditions
#  # - $SEX: type U, 4 conditions
#  # - $VAR: type V, 3 element
#  
#  
#  # Create sample data frame
#  dat <- read.table(header = TRUE, text = '
#  SUBJECT AGECAT  SEX
#  101       35      F
#  102       19      F
#  103       57      M
#  ')
#  
#  # Assign formats from catalog
#  formats(dat) <- fmts
#  
#  # Apply formats
#  fdata(dat)
#  #   SUBJECT   AGECAT    SEX
#  # 1     101 25 to 44 Female
#  # 2     102 18 to 24 Female
#  # 3     103 45 to 64   Male

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(fmtr)
#  library(openxlsx)
#  
#  # Create sample format catlog
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
#  
#  # View format catalog
#  fmts
#  # # A format catalog: 3 formats
#  # - $AGECAT: type U, 5 conditions
#  # - $SEX: type U, 4 conditions
#  # - $VAR: type V, 3 element
#  
#  # Convert format catalog to data frame
#  dat <- as.data.frame(fmts)
#  
#  # Write data frame to Excel using openxlsx
#  write.xlsx(dat, "c:\\mypath\\myxlfile.xlsx")

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(fmtr)
#  
#  # Create sample input data
#  dat <- read.table(header = TRUE, text ='
#          Col1  Col2
#          A    "Label A"
#          B    "Label B"
#          C    "Label C"')
#  
#  # Create main conditions
#  df1 <- data.frame(Name = "myfmt",
#                    Type = "U",
#                    Expression = paste0("x == '", dat$Col1, "'"),
#                    Label = dat$Col2,
#                    Order = NA)
#  
#  # Create default condition
#  df2 <- data.frame(Name = "myfmt",
#                    Type = "U",
#                    Expression = "TRUE",
#                    Label = "Other",
#                    Order = NA)
#  
#  # Append default condition
#  df <- rbind(df, df2)
#  
#  # View input data
#  df
#  #    Name Type Expression   Label Order
#  # 1 myfmt    U   x == 'A' Label A    NA
#  # 2 myfmt    U   x == 'B' Label B    NA
#  # 3 myfmt    U   x == 'C' Label C    NA
#  # 4 myfmt    U       TRUE   Other    NA
#  
#  # Convert data frame to user-defined format
#  fmt <- as.fmt(df)
#  
#  # Apply the format
#  fapply(c("A", "B", "C", NA), fmt)
#  # [1] "Label A" "Label B" "Label C" "Other"
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(fmtr)
#  
#  nfmt <- value(condition(x == "A", 1),
#                condition(x == "B", 2),
#                condition(TRUE, 3))
#  
#  fapply(c("A", "B", "C"), nfmt)
#  # [1] 1 2 3
#  

