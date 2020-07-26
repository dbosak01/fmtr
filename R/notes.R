#' Additional attributes: format, width, justify
#' Additional class for defining a format: fmt
#' Additional class for containing multiple formats: fmt_lst
#' Additional function for applying a format to a vector: fapply
#' Additional/override functions for applying formats to data frame or tibble: format_data, format.data.frame, format.tbl
#' Convenience functions for setting attributes: fattr(), formats(), widths(), justification()
# 
# mtcars
# iris
# ToothGrowth
# PlantGrowth
# USArrests
# 
# df <- USArrests
# df$per_capita_murder <- df$murder / df$UrbanPop
# 
# state.area
# state.abb
# state.name
# tot_area <-
# 
# 
# 
# # Construct data frame from state vectors
# df <- data.frame(state = state.abb, area = state.area)[1:10, ]
# 
# # Calculate percentages
# df$pct <- df$area / sum(state.area) * 100
# 
# # Before formatting
# df
# 
# # Create state name lookup list
# name_lookup <- state.name
# names(name_lookup) <- state.abb
# 
# # Assign formats
# formats(df) <- list(state = name_lookup,
#                     area  = function(x) format(x, big.mark = ","),
#                     pct   = "%.1f%%")
# 
# df$state <- fattr(df$state, justify = "left")
# 
# # Apply formats
# fdata(df)
# 
# df$state
# df$state <- fattr(df$state, keep = FALSE)
# df$state
