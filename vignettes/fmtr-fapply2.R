## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Create sample vectors
#  v1 <- c(27, 43, 22, 56)
#  v2 <- c(18.24324, 29.05405, 14.86486, 37.83784)
#  
#  # Create data frame
#  dat <- data.frame("Counts" = v1, "Percents" = v2)
#  
#  # Format and Combine
#  dat$CntPct <- fapply2(dat$Counts, dat$Percents, "%d", "(%.1f%%)")
#  
#  # View results
#  dat
#  #   Counts Percents     CntPct
#  # 1     27 18.24324 27 (18.2%)
#  # 2     43 29.05405 43 (29.1%)
#  # 3     22 14.86486 22 (14.9%)
#  # 4     56 37.83784 56 (37.8%)
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(dplyr)
#  
#  # Create sample vectors
#  v1 <- c(27, 43, 22, 56)
#  v2 <- c(18.24324, 29.05405, 14.86486, 37.83784)
#  
#  # Create data frame
#  dat <- data.frame("Counts" = v1, "Percents" = v2)
#  
#  # Format and Combine
#  dat <- dat |>
#    mutate(CntPct = fapply2(dat$Counts, dat$Percents, "%d", "(%.1f%%)"))
#  
#  # View results
#  dat
#  #   Counts Percents     CntPct
#  # 1     27 18.24324 27 (18.2%)
#  # 2     43 29.05405 43 (29.1%)
#  # 3     22 14.86486 22 (14.9%)
#  # 4     56 37.83784 56 (37.8%)
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(libr)
#  
#  # Create sample vectors
#  v1 <- c(27, 43, 22, 56)
#  v2 <- c(18.24324, 29.05405, 14.86486, 37.83784)
#  
#  # Create data frame
#  dat <- data.frame("Counts" = v1, "Percents" = v2)
#  
#  # Format and Combine
#  dat <- datastep(dat,
#           {
#             CntPct <- fapply2(Counts, Percents, "%d", "(%.1f%%)")
#           })
#  
#  # View results
#  dat
#  #   Counts Percents     CntPct
#  # 1     27 18.24324 27 (18.2%)
#  # 2     43 29.05405 43 (29.1%)
#  # 3     22 14.86486 22 (14.9%)
#  # 4     56 37.83784 56 (37.8%)
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  # Create sample vectors
#  v1 <- c(27, 43, 22, 56)
#  v2 <- c(18.24324, 29.05405, 14.86486, 37.83784)
#  
#  # Create data frame
#  dat <- data.frame("Counts" = v1, "Percents" = v2)
#  
#  formats(dat) <- list(Counts = "%d", Percents = "(%.1f%%)")
#  
#  # Format and Combine - Formats already assigned
#  dat$CntPct <- fapply2(dat$Counts, dat$Percents)
#  
#  # View results
#  dat
#  #   Counts Percents     CntPct
#  # 1     27 18.24324 27 (18.2%)
#  # 2     43 29.05405 43 (29.1%)
#  # 3     22 14.86486 22 (14.9%)
#  # 4     56 37.83784 56 (37.8%)
#  

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(libr)
#  
#  # Create sample vectors
#  grp <- c("Group1", "Group2", "Group3", "Group4")
#  v1 <- c(27, 43, 22, 56)
#  v2 <- c(18.24324, 29.05405, 14.86486, 37.83784)
#  v3 <- c(5.24883, 8.83724, 2.39483, 9.12542)
#  v4 <- c(2.97632, 3.32845, 0.29784, 4.22156)
#  
#  # Create data frame
#  dat <- data.frame("Group" = grp, "Counts" = v1, "Percents" = v2,
#                    "Mean" = v3, "SD" = v4)
#  
#  # View original data
#  dat
#  #    Group Counts Percents    Mean      SD
#  # 1 Group1     27 18.24324 5.24883 2.97632
#  # 2 Group2     43 29.05405 8.83724 3.32845
#  # 3 Group3     22 14.86486 2.39483 0.29784
#  # 4 Group4     56 37.83784 9.12542 4.22156
#  
#  # Create format catalog
#  fc <- fcat(Counts = "%d", Percents = "(%03.1f%%)",
#             Mean = "%.1f", SD = "(%04.2f)")
#  
#  # Format and Combine columns using Format catalog
#  dat2 <- datastep(dat, format = fc,
#                   keep = v(Group, CntPct, MeanSD),
#                   {
#  
#                     CntPct <- fapply2(Counts, Percents)
#                     MeanSD <- fapply2(Mean, SD)
#  
#                   })
#  # View results
#  dat2
#  #    Group     CntPct     MeanSD
#  # 1 Group1 27 (18.2%) 5.2 (2.98)
#  # 2 Group2 43 (29.1%) 8.8 (3.33)
#  # 3 Group3 22 (14.9%) 2.4 (0.30)
#  # 4 Group4 56 (37.8%) 9.1 (4.22)
#  

