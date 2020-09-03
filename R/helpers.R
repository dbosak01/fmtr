
# Formatting Helper Functions ---------------------------------------------



#' @title Formatted Range
#' @description A function to calculate and format a numeric range
#' @param x The input data vector.
#' @param sep The token used to separate the minimum and maximum range
#' values.  Default value is a hyphen ("-").
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%s", which simply converts the value to a string with no
#' specific formatting.
#' @return The formatted range values
#' @family helpers 
#' @export
fmt_range <- function(x, format = "%s", sep = "-") {
  
  dat <- range(x, na.rm = TRUE)
  
  ret <- paste(sprintf(format, dat[1]), sep, sprintf(format, dat[2]))
  
  return(ret)
}

#' @title Formatted Count
#' @description A function to calculate and format a numeric count
#' @param x The input data vector.
#' @return The formatted count value
#' @family helpers 
#' @export
fmt_n <- function(x) {
  
  ret <- as.character(sum(!is.na(x)))
  
  return(ret)
}

#' @title Formatted Quantile Range
#' @description A function to calculate and format a quantile range 
#' @param x The input data vector.
#' @param sep The token used to separate the minimum and maximum range
#' values.  Default value is a hyphen ("-").
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%.1f", which displays the value with one decimal place.
#' @param sep The character to use as a separator between the two quantiles.
#' @return The formatted quantile range
#' @family helpers 
#' @import stats
#' @export
fmt_quantile_range <- function(x, format = "%.1f", sep = "-") {
  
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  
  ret <- paste(sprintf(format, q1), sep, sprintf(format, q3))
  
  return(ret)
}

#' @title Formatted Median
#' @description A function to calculate and format a median 
#' @param x The input data vector.
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%.1f", which displays the value with one decimal place.
#' @return The formatted median value
#' @family helpers 
#' @import stats
#' @export
fmt_median <- function(x, format = "%.1f") {
  
  dat <- median(x, na.rm = TRUE)
  
  ret <- sprintf(format, dat)
  
  return(ret)
  
}


#' @title Formatted count and percent
#' @description A function to calculate and format a count and percent
#' @param x The input data vector.
#' @param denom The denominator to use for the percentage. By default, the 
#' parameter is NULL, meaning the function will use non-missing values of the 
#' data vector as the denominator.  Otherwise, supply the denominator as 
#' a numeric value.
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%5.1f", which displays the value with one decimal place.
#' @return The formatted median value
#' @family helpers 
#' @export
fmt_cnt_pct <- function(x, denom = NULL, format = "%5.1f") {
  
  # Default denominator is count of non-missing values
  if (is.null(denom))
    denom <- sum(!is.na(x))
  
  # Calculate Percent
  pcts <- x/denom * 100
  
  # Deal with values between 0 and 1
  f <- sprintf(format, 1)
  t <- paste0("<",  substring(f, 2))
  pctf <- ifelse(pcts > 0 & pcts < 1 , t, sprintf(format, pcts))
  
  # Format result
  ret <- sprintf("%d (%s%%)", x, pctf)
  
  # Deal with NA values
  ret <- ifelse(substring(ret, 1, 2) == "NA", NA, ret)
  
  return(ret)
}

#' @title Formatted mean and standard deviation
#' @description A function to calculate and format a mean and standard deviation
#' @param x The input data vector.
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%.1f", which displays the mean and standard deviation with 
#' one decimal place.
#' @return The formatted mean and standard deviation
#' @family helpers 
#' @export
fmt_mean_sd <- function(x, format = "%.1f") {
  
  m <- mean(x, na.rm = TRUE)
  sd <- sd(x, na.rm = TRUE)
  
  # Format result
  ret <- sprintf(paste0(format, " (", format, ")"), m, sd)
  
  return(ret)
}



