% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{fmt_mean_sd}
\alias{fmt_mean_sd}
\title{Formatted mean and standard deviation}
\usage{
fmt_mean_sd(x, format = "\%.1f", sd_format = NULL)
}
\arguments{
\item{x}{The input data vector or data frame column.}

\item{format}{A formatting string suitable for input into the 
\code{\link[base]{sprintf}} function.  By default, this format is
defined as "\%.1f", which displays the mean and standard deviation with 
one decimal place.}

\item{sd_format}{An optional format for the standard deviation.  If this 
parameter is not supplied, the standard deviation will be formatted
the same as the mean, according to the `format` parameter.}
}
\value{
The formatted mean and standard deviation.
}
\description{
A function to calculate and format a mean and standard deviation.
}
\details{
This function calculates a mean and standard deviation, and formats using
\code{\link[base]{sprintf}}. 
You may control the format using the \strong{format} parameter.  
Function will ignore NA values in the input data. Results are 
returned as a character vector.
}
\examples{
v1 <- c(4.3, 3.7, 8.7, 6.1, 9.2, 5.6, NA, 0.7, 7.8, 4.9)

# Format mean and standard deviation
fmt_mean_sd(v1)
# "5.7 (2.7)"
}
\seealso{
Other helpers: 
\code{\link{fmt_cnt_pct}()},
\code{\link{fmt_median}()},
\code{\link{fmt_n}()},
\code{\link{fmt_quantile_range}()},
\code{\link{fmt_range}()}
}
\concept{helpers}
