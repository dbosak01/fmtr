% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fattr.R
\name{fattr<-}
\alias{fattr<-}
\title{Set formatting attributes}
\usage{
fattr(x) <- value
}
\arguments{
\item{x}{The vector or data frame column to assign attributes to.}

\item{value}{A named vector of attribute values.}
}
\description{
Assign formatting attributes to a vector
}
\details{
The \code{fattr} function is a convenience function for assigning 
formatting attributes to a vector.  The function accepts a named list of
formatting attributes.  Valid names are 'format', 'width', 'justify',
'label' and 'description'.
See \code{\link{fattr}} for additional details.
}
\examples{
# Create vector
a <- c(1.3243, 5.9783, 2.3848)

# Assign format attributes
fattr(a) <- list(format = "\%.1f")

# Apply format attributes
fapply(a)
# [1] "1.3" "6.0" "2.4"
}
\seealso{
\code{\link{fdata}} to apply formats to a data frame, 
 \code{\link{fapply}} to apply formats to a vector.
}
