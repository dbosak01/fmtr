% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{fmt_n}
\alias{fmt_n}
\title{Formatted Count}
\usage{
fmt_n(x)
}
\arguments{
\item{x}{The input data vector or data frame column.}
}
\value{
The formatted count value.
}
\description{
A function to calculate and format a numeric count.
}
\details{
This function calculates a count using the Base R \code{\link[base]{sum}}
function. NA values are not counted. Results are returned as a 
character vector.
}
\examples{
# Create example vector
v1 <- c(4.3, 3.7, 8.7, 6.1, 9.2, 5.6, NA, 0.7, 7.8, 4.9)

# Format n
fmt_n(v1)
# "9"
}
\seealso{
Other helpers: 
\code{\link{fmt_cnt_pct}()},
\code{\link{fmt_mean_sd}()},
\code{\link{fmt_median}()},
\code{\link{fmt_quantile_range}()},
\code{\link{fmt_range}()}
}
\concept{helpers}
