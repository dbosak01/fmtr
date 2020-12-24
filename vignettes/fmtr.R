## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  library(fmtr)
#  
#  # Construct data frame from state vectors
#  df <- data.frame(state = state.abb, area = state.area)[1:10, ]
#  
#  # Calculate percentages
#  df$pct <- df$area / sum(state.area) * 100
#  
#  # Before formatting
#  df
#  #    state   area         pct
#  # 1     AL  51609  1.42629378
#  # 2     AK 589757 16.29883824
#  # 3     AZ 113909  3.14804973
#  # 4     AR  53104  1.46761040
#  # 5     CA 158693  4.38572418
#  # 6     CO 104247  2.88102556
#  # 7     CT   5009  0.13843139
#  # 8     DE   2057  0.05684835
#  # 9     FL  58560  1.61839532
#  # 10    GA  58876  1.62712846
#  
#  # Create state name lookup list
#  name_lookup <- state.name
#  names(name_lookup) <- state.abb
#  
#  # Assign formats
#  formats(df) <- list(state = name_lookup,
#                      area  = function(x) format(x, big.mark = ","),
#                      pct   = "%.1f%%")
#  
#  # Apply formats
#  fdata(df)
#  #          state    area   pct
#  # 1      Alabama  51,609  1.4%
#  # 2       Alaska 589,757 16.3%
#  # 3      Arizona 113,909  3.1%
#  # 4     Arkansas  53,104  1.5%
#  # 5   California 158,693  4.4%
#  # 6     Colorado 104,247  2.9%
#  # 7  Connecticut   5,009  0.1%
#  # 8     Delaware   2,057  0.1%
#  # 9      Florida  58,560  1.6%
#  # 10     Georgia  58,876  1.6%
#  

