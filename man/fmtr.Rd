% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fmtr.R
\docType{package}
\name{fmtr}
\alias{fmtr}
\alias{fmtr-package}
\title{A package for formatting data}
\description{
The \strong{fmtr} package contains functions to 
format vectors and data frames.
}
\details{
The \strong{fmtr} package helps format data frames, similar 
to the way datasets are formatted in SAS®.  Formats are assigned
to columns using a \strong{format} attribute.  Formats are then applied
by calling the \code{fdata} function on the data frame.  
The \code{fdata}
function returns a new data frame with the formats applied to each column
as specified. 

All functions in the \code{fmtr} package also work with tidyverse tibbles.

The \strong{fmtr} package also contains a function named 
\code{value} for defining user-defined formats in a manner
similar to SAS® formats.
}
\section{Functions}{

The main functions included in the \strong{fmtr} package are 
as follows:
\itemize{
  \item {\code{\link{fdata}}: Applies formatting 
to a dataframe.}
  \item {\code{\link{fapply}}: Applies formatting 
to a vector.}
  \item {\code{\link{fcat}}: Creates a format catalog.}
  \item {\code{\link{value}}: Creates a new
user-defined format.}
  \item {\code{\link{formats}}: Helps assign format attributes
  to a data frame.}
  \item {\code{\link{fattr}}: Helps assign formatting attributes
  to a vector.}
}
}

\section{Available Formats}{

The formats that can be used with \strong{fmtr} include the following:
\itemize{
  \item Formatting strings
  \item Named vectors
  \item Vectorized functions
  \item User-defined formats
  \item Formatting lists
}

A formatting string is a compact set of codes typically used for formatting
dates and numbers.  See \link{FormattingStrings} for a glossary of 
common formatting codes.

Named vectors map one string value to another string value.

Vectorized functions can be those created by the user or by a formatting
function like those created with Base R or the \strong{scales} package.

User-defined functions are those created by the \strong{fmtr} 
\code{value} function.  See \code{\link{value}} for 
additional details.

Formatting lists are lists which contain any of the above format types.
The formatting lists allow the user to apply one of several formats to the 
column.  Formatting lists may also be used to apply different formats 
to each item in a vector.  See \code{\link{flist}} for 
additional details on formatting lists.

See the \code{\link{fapply}} function documentation for additional details
on applying formats.

Formats can be collected and stored as a single file, called a format
catalog.  This functionality makes it easy to reuse formats in new
programs, with new data, or to share them with colleagues.  
See the \code{\link{fcat}} function for 
additional information.
}

\seealso{
Useful links:
\itemize{
  \item \url{https://fmtr.r-sassy.org}
  \item \url{https://github.com/dbosak01/fmtr}
  \item Report bugs at \url{https://github.com/dbosak01/fmtr/issues}
}

}
\keyword{internal}
