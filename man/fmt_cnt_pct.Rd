% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{fmt_cnt_pct}
\alias{fmt_cnt_pct}
\title{Formatted count and percent}
\usage{
fmt_cnt_pct(x, denom = NULL, format = "\%5.1f", na = NULL, zero = NULL)
}
\arguments{
\item{x}{The input data vector or data frame column.}

\item{denom}{The denominator to use for the percentage. By default, the 
parameter is NULL, meaning the function will use the number of 
non-missing values of the data vector as the denominator.  
Otherwise, supply the denominator as a numeric value.}

\item{format}{A formatting string suitable for input into the 
\code{\link[base]{sprintf}} function.  By default, this format is
defined as "\%5.1f", which displays the value with one decimal place.}

\item{na}{The value to return for any NA value encountered in the input
vector.  Usually this parameter is passed as a string, such as 
"-", yet any value can be supplied.}

\item{zero}{The value to return for any zero values encountered
in the input vector.  Usually this value is supplied as string
such as "0 (-)".}
}
\value{
A character vector of formatted counts and percents.
}
\description{
A function to calculate and format a count and percent.
}
\details{
This function calculates a percent and appends to the provided count.  The 
input vector is assumed to contain the counts. This function will not perform 
counting.  It will calculate percentages and append to the given counts.

The result is then formatted using \code{\link[base]{sprintf}}. By default,
the number of non-missing values in the input data vector is used as the 
denominator.
Alternatively, you may supply the denominator using the \strong{denom}
parameter.
You may also control the percent format using the \strong{format} parameter.  
The function will return any NA values in the input data unaltered. 

If the calculated percentage is between 0\% and 1\%, the function will 
display "(< 1.0\%)" as the percentage value.  Zero values will be displayed
as "(  0.0\%)"
}
\examples{
v1 <- c(4, 3, 8, 6, 9, 5, NA, 0, 7, 4, 3, 7)

# Format count and percent
fmt_cnt_pct(v1)

# Output
# [1] "4 ( 36.4\%)" "3 ( 27.3\%)" "8 ( 72.7\%)" "6 ( 54.5\%)"
# [5] "9 ( 81.8\%)" "5 ( 45.5\%)" NA           "0 (  0.0\%)"
# [9] "7 ( 63.6\%)" "4 ( 36.4\%)" "3 ( 27.3\%)" "7 ( 63.6\%)"

# Custom values for NA and zero
fmt_cnt_pct(v1, na = "N/A", zero = "0 (-)")

# Custom NA and zero output
# [1] "4 ( 36.4\%)" "3 ( 27.3\%)" "8 ( 72.7\%)" "6 ( 54.5\%)"
# [5] "9 ( 81.8\%)" "5 ( 45.5\%)" "N/A"        "0 (-)"
# [9] "7 ( 63.6\%)" "4 ( 36.4\%)" "3 ( 27.3\%)" "7 ( 63.6\%)"
}
\seealso{
Other helpers: 
\code{\link{fmt_mean_sd}()},
\code{\link{fmt_median}()},
\code{\link{fmt_n}()},
\code{\link{fmt_quantile_range}()},
\code{\link{fmt_range}()}
}
\concept{helpers}
