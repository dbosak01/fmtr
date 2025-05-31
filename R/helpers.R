
# Formatting Helper Functions ---------------------------------------------



#' @title Formatted Range
#' @description A function to calculate and format a numeric range.
#' @details 
#' This function calculates a range using the Base R \code{\link[base]{range}}
#' function, and then formats the output using \code{\link[base]{sprintf}}.
#' You may control the format using the \strong{format} parameter.  Any NA values
#' in the input data are ignored. Results are returned as a character vector. 
#' @param x The input data vector or data frame column.
#' @param sep The token used to separate the minimum and maximum range
#' values.  Default value is a hyphen ("-").
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%s", which simply converts the value to a string with no
#' specific formatting.
#' @return The formatted range values.
#' @family helpers 
#' @examples 
#' # Create example vector
#' v1 <- c(4.3, 3.7, 8.7, 6.1, 9.2, 5.6, NA, 0.7, 7.8, 4.9)
#' 
#' # Format range
#' fmt_range(v1)
#' # "0.7 - 9.2"
#' @export
fmt_range <- function(x, format = "%s", sep = "-") {
  
  dat <- range(x, na.rm = TRUE)
  
  ret <- paste(sprintf(format, dat[1]), sep, sprintf(format, dat[2]))
  
  return(ret)
}

#' @title Formatted Count
#' @description A function to calculate and format a numeric count.
#' @details 
#' This function calculates a count using the Base R \code{\link[base]{sum}}
#' function. NA values are not counted. Results are returned as a 
#' character vector. 
#' @param x The input data vector or data frame column.
#' @return The formatted count value.
#' @family helpers 
#' @examples 
#' # Create example vector
#' v1 <- c(4.3, 3.7, 8.7, 6.1, 9.2, 5.6, NA, 0.7, 7.8, 4.9)
#' 
#' # Format n
#' fmt_n(v1)
#' # "9"
#' @export
fmt_n <- function(x) {
  
  ret <- as.character(sum(!is.na(x)))
  
  return(ret)
}

#' @title Formatted Quantile Range
#' @description A function to calculate and format a quantile range.
#' @details 
#' This function calculates a quantile range using the stats package
#' \code{\link[stats]{quantile}}
#' function, and then formats the output using \code{\link[base]{sprintf}}.
#' You may control the format using the \strong{format} parameter.  Function will 
#' ignore any NA values in the input data. Results are returned as a 
#' character vector. 
#' 
#' By default, the function calculates the 1st and 3rd quantiles at .25 and .75.
#' The upper and lower quantile ranges may be changed with the \code{upper}
#' and \code{lower} parameters. 
#' @param x The input data vector or data frame column.
#' @param sep The token used to separate the minimum and maximum range
#' values.  Default value is a hyphen ("-").
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%.1f", which displays the value with one decimal place.
#' @param sep The character to use as a separator between the two quantiles.
#' @param lower The lower quantile range.  Default is .25.
#' @param upper The upper quantile range.  Default is .75.
#' @param type An integer between 1 and 9 selecting one of the nine quantile
#' algorithms.  The default is 7, which is the standard R default.
#' If you are trying to match SAS results, use type 2.
#' See the \code{\link{quantile}} function documentation for further details.
#' @return The formatted quantile range.
#' @family helpers 
#' @import stats
#' @examples 
#' # Create example vector
#' v1 <- c(4.3, 3.7, 8.7, 6.1, 9.2, 5.6, NA, 0.7, 7.8, 4.9)
#' 
#' # Format Quantiles
#' fmt_quantile_range(v1)
#' # "4.3 - 7.8"
#' @export
fmt_quantile_range <- function(x, format = "%.1f", sep = "-", 
                               lower = .25, upper = .75, type = 7) {
  
  q1 <- quantile(x, lower, na.rm = TRUE, type = type)
  q3 <- quantile(x, upper, na.rm = TRUE, type = type)
  
  ret <- paste(sprintf(format, q1), sep, sprintf(format, q3))
  
  return(ret)
}

#' @title Formatted Median
#' @description A function to calculate and format a median.
#' @details 
#' This function calculates a median using the stats package
#' \code{\link[stats]{median}}
#' function, and then formats the output using \code{\link[base]{sprintf}}.
#' You may control the format using the \strong{format} parameter.  Function will 
#' ignore any NA values in the input data. Results are returned as a 
#' character vector. 
#' @param x The input data vector or data frame column.
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%.1f", which displays the value with one decimal place.
#' @return The formatted median value.
#' @family helpers 
#' @import stats
#' @examples
#' v1 <- c(4.3, 3.7, 8.7, 6.1, 9.2, 5.6, NA, 0.7, 7.8, 4.9)
#' 
#' # Format median
#' fmt_median(v1)
#' # "5.6"
#' @export
fmt_median <- function(x, format = "%.1f") {
  
  dat <- median(x, na.rm = TRUE)
  
  ret <- sprintf(format, dat)
  
  return(ret)
  
}


#' @title Formatted count and percent
#' @description A function to calculate and format a count and percent.
#' @details 
#' This function calculates a percent and appends to the provided count.  The 
#' input vector is assumed to contain the counts. This function will not perform 
#' counting.  It will calculate percentages and append to the given counts.
#' 
#' The result is then formatted using \code{\link[base]{sprintf}}. By default,
#' the number of non-missing values in the input data vector is used as the 
#' denominator.
#' Alternatively, you may supply the denominator using the \strong{denom}
#' parameter.
#' You may also control the percent format using the \strong{format} parameter.  
#' The function will return any NA values in the input data unaltered. 
#' 
#' If the calculated percentage is between 0\% and 1\%, the function will 
#' display "(< 1.0\%)" as the percentage value.  Zero values will be displayed
#' as "(  0.0\%)"
#'
#' @param x The input data vector or data frame column.
#' @param denom The denominator to use for the percentage. By default, the 
#' parameter is NULL, meaning the function will use the number of 
#' non-missing values of the data vector as the denominator.  
#' Otherwise, supply the denominator as a numeric value.
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%5.1f", which displays the value with one decimal place.
#' @param na The value to return for any NA value encountered in the input
#' vector.  Usually this parameter is passed as a string, such as 
#' "-", yet any value can be supplied.  
#' @param zero The value to return for any zero values encountered
#' in the input vector.  Usually this value is supplied as string
#' such as "0 (-)".
#' @return A character vector of formatted counts and percents. 
#' @family helpers 
#' @examples
#' v1 <- c(4, 3, 8, 6, 9, 5, NA, 0, 7, 4, 3, 7)
#' 
#' # Format count and percent
#' fmt_cnt_pct(v1)
#' 
#' # Output
#' # [1] "4 ( 36.4%)" "3 ( 27.3%)" "8 ( 72.7%)" "6 ( 54.5%)"
#' # [5] "9 ( 81.8%)" "5 ( 45.5%)" NA           "0 (  0.0%)"
#' # [9] "7 ( 63.6%)" "4 ( 36.4%)" "3 ( 27.3%)" "7 ( 63.6%)"
#' 
#' # Custom values for NA and zero
#' fmt_cnt_pct(v1, na = "N/A", zero = "0 (-)")
#' 
#' # Custom NA and zero output
#' # [1] "4 ( 36.4%)" "3 ( 27.3%)" "8 ( 72.7%)" "6 ( 54.5%)"
#' # [5] "9 ( 81.8%)" "5 ( 45.5%)" "N/A"        "0 (-)"
#' # [9] "7 ( 63.6%)" "4 ( 36.4%)" "3 ( 27.3%)" "7 ( 63.6%)"
#' @export
fmt_cnt_pct <- function(x, denom = NULL, format = "%5.1f", 
                        na = NULL, zero = NULL) {
  
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
  
  # Deal with Zero Values
  if (!is.null(zero)) {
    ret <- ifelse(x == 0, zero, ret) 
  }
  
  # Deal with NA values
  if (!is.null(na))
    ret <- ifelse(is.na(ret), na, ret)
  else
    ret <- ifelse(substring(ret, 1, 2) == "NA", NA, ret)
  
  return(ret)
}


#' @title Formatted mean and standard deviation
#' @description A function to calculate and format a mean and standard deviation.
#' @details
#' This function calculates a mean and standard deviation, and formats using
#' \code{\link[base]{sprintf}}. 
#' You may control the format using the \strong{format} parameter.  
#' Function will ignore NA values in the input data. Results are 
#' returned as a character vector. 
#' @param x The input data vector or data frame column.
#' @param format A formatting string suitable for input into the 
#' \code{\link[base]{sprintf}} function.  By default, this format is
#' defined as "\%.1f", which displays the mean and standard deviation with 
#' one decimal place.
#' @param sd_format An optional format for the standard deviation.  If this 
#' parameter is not supplied, the standard deviation will be formatted
#' the same as the mean, according to the `format` parameter.
#' @return The formatted mean and standard deviation.
#' @family helpers 
#' @examples 
#' v1 <- c(4.3, 3.7, 8.7, 6.1, 9.2, 5.6, NA, 0.7, 7.8, 4.9)
#' 
#' # Format mean and standard deviation
#' fmt_mean_sd(v1)
#' # "5.7 (2.7)"
#' @export
fmt_mean_sd <- function(x, format = "%.1f", sd_format = NULL) {
  
  m <- mean(x, na.rm = TRUE)
  sd <- sd(x, na.rm = TRUE)
  
  sd_format <- ifelse(is.null(sd_format), format, sd_format)
  
  # Format result
  ret <- sprintf(paste0(format, " (", sd_format, ")"), m, sd)
  
  return(ret)
}


# stderr <- function(x) sd(x) / sqrt(length(x))
