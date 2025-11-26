#' @title A package for formatting data  
#'
#' @description The \strong{fmtr} package contains functions to 
#' format vectors and data frames.
#'
#' @details 
#' The \strong{fmtr} package helps format data frames, similar 
#' to the way datasets are formatted in SAS®.  Formats are assigned
#' to columns using a \strong{format} attribute.  Formats are then applied
#' by calling the \code{fdata} function on the data frame.  
#' The \code{fdata}
#' function returns a new data frame with the formats applied to each column
#' as specified. 
#' 
#' All functions in the \code{fmtr} package also work with tidyverse tibbles.
#' 
#' The \strong{fmtr} package also contains a function named 
#' \code{value} for defining user-defined formats in a manner
#' similar to SAS® formats.
#' 
#' @section Functions:
#' The main functions included in the \strong{fmtr} package are 
#' as follows:
#' \itemize{
#'   \item {\code{\link{fdata}}: Applies formatting 
#' to a dataframe.}
#'   \item {\code{\link{fapply}}: Applies formatting 
#' to a vector.}
#'   \item {\code{\link{fcat}}: Creates a format catalog.}
#'   \item {\code{\link{value}}: Creates a new
#' user-defined format.}
#'   \item {\code{\link{formats}}: Helps assign format attributes
#'   to a data frame.}
#'   \item {\code{\link{fattr}}: Helps assign formatting attributes
#'   to a vector.}
#' }
#' 
#' @section Available Formats:
#' The formats that can be used with \strong{fmtr} include the following:
#' \itemize{
#'   \item Formatting strings
#'   \item Named vectors
#'   \item Vectorized functions
#'   \item User-defined formats
#'   \item Formatting lists
#' }
#' 
#' A formatting string is a compact set of codes typically used for formatting
#' dates and numbers.  See \link{FormattingStrings} for a glossary of 
#' common formatting codes.
#' 
#' Named vectors map one string value to another string value.
#' 
#' Vectorized functions can be those created by the user or by a formatting
#' function like those created with Base R or the \strong{scales} package.
#' 
#' User-defined functions are those created by the \strong{fmtr} 
#' \code{value} function.  See \code{\link{value}} for 
#' additional details.
#' 
#' Formatting lists are lists which contain any of the above format types.
#' The formatting lists allow the user to apply one of several formats to the 
#' column.  Formatting lists may also be used to apply different formats 
#' to each item in a vector.  See \code{\link{flist}} for 
#' additional details on formatting lists.
#'
#' See the \code{\link{fapply}} function documentation for additional details
#' on applying formats.
#' 
#' Formats can be collected and stored as a single file, called a format
#' catalog.  This functionality makes it easy to reuse formats in new
#' programs, with new data, or to share them with colleagues.  
#' See the \code{\link{fcat}} function for 
#' additional information.
#' @keywords internal
#' @aliases fmtr-package
#' @name fmtr
"_PACKAGE"




#' @title Formatting Strings 
#' @description 
#' Formatting codes for formatting strings follow the conventions 
#' of the base R \code{\link[base]{strptime}} and \code{\link[base]{sprintf}}
#' functions. See below for further details.
#' @details 
#' The \strong{fmtr} packages accepts single strings as formatting 
#' specifications.  These formatting strings are interpreted differently 
#' depending on the data type of the vector being formatted.  For 
#' date and datetime vectors, the string will be interpreted as an input 
#' to the base R \code{strptime} function.  For all other types of vectors, 
#' the formatting string will be interpreted as an input to the \code{sprintf}
#' function.  
#' 
#' The formatting codes for these functions are simple to use. For example, 
#' the code \code{fapply(as.Date("1970-01-01"), "\%B \%d, \%Y")} will produce
#' the output \code{"January 01, 1970"}.  The code 
#' \code{fapply(1.2345, "\%.1f")} will produce the output \code{"1.2"}.
#' 
#' @section Date Formatting:  
#' Below are some commonly used formatting codes for dates:
#' \itemize{
#' \item \%d = day as a number 
#' \item \%a = abbreviated weekday
#' \item \%A = unabbreviated weekday	
#' \item \%m = month 
#' \item \%b = abbreviated month
#' \item \%B = unabbreviated month
#' \item \%y = 2-digit year
#' \item \%Y = 4-digit year	
#' \item \%H = hour (24 hour clock)
#' \item \%I = hour (12 hour clock)
#' \item \%M = minute
#' \item \%S = second
#' \item \%p = AM/PM indicator
#' \item \%q = Quarter as integer
#' \item \%Q = Quarter as "Q?"
#' }
#' 
#' See the \code{\link[base]{strptime}} function for additional codes and 
#' examples of formatting dates and times.
#' 
#' @section "date" Format:
#' The "dateW." format is a date-display format that replicates the
#' behavior of the SAS "DATEw." family of formats. The "dateW." format converts
#' either numeric date values, R \code{Date} objects, or \code{POSIXt} date-time
#' objects into standard fixed-width character representations.
#' 
#' Smaller widths show abbreviated forms (e.g., "JAN70" for "date5"), while
#' larger widths show full day/month/year values (e.g., "01JAN1970" for "date9"
#' or "01-JAN-1970" for "date11"). For \code{POSIXt} values, only the date
#' portion is used.
#'
#' Numeric inputs follow R conventions and are interpreted as days since
#' 1970-01-01. The default width is 7. A trailing dot (".") is optional.
#'
#' Output always occupies the specified width. If the date value is shorter 
#' than the specified width, it is left-padded with spaces. 
#' 
#' @section Numeric Formatting:
#' 
#' Below are some commonly used formatting codes for other data types:
#' 
#' \itemize{
#' \item \%s = string
#' \item \%d = integer
#' \item \%f = floating point number
#' }

#' See the \code{\link[base]{sprintf}} function for additional codes and 
#' examples of formatting other data types.
#' 
#' @section "best" Numeric Format:
#' The "best" format is a special numeric format that replicates the "best"
#' style of formatting from SAS.  The "best" format automatically determines
#' the best way to format a number within a specified with.  
#' 
#' For example, if you have a number
#' like 123.45678, and format it with "best6", the result will be "123.46".
#' Note that the decimal point counts as one of the digits. Also note that 
#' the rightmost digit will be rounded according to SAS rounding rules.
#' 
#' The same number above formatted with "best8" will be "123.4567".  The default
#' width is 12. That means, if you simply send the format "best" with no width, 
#' it will be interpreted as "best12".
#' 
#' @seealso \code{\link{fapply}} for formatting vectors, and 
#' \code{\link{fdata}} for formatting data frames.
#' @examples 
#' # Examples for formatting dates and times 
#' t <- Sys.time()
#' fapply(t, "%d/%m/%Y")              # Day/Month/Year
#' fapply(t, "%d%b%Y")                # Day abbreviated month year
#' fapply(t, "%y-%m")                 # Two digit year - month
#' fapply(t, "%A, %B %d")             # Weekday, unabbreviated month and date
#' fapply(t, "%Y-%Q")                 # Year and Quarter
#' fapply(t, "%Y-%m%-%d %H:%M:%S %p") # Common timestamp format
#' 
#' # Examples for formatting dates (date and times) using "dateW."
#' d <- Sys.Date()
#' fapply(d, "date5")                 # Month Year (mmmyy)
#' fapply(d, "date7")                 # Day Month Year (ddmmmyy)
#' fapply(d, "date9")                 # Day Month Year (ddmmmyyyy)
#' fapply(d, "date11")                # Day Month Year (dd-mmm-yyyy)
#' t <- Sys.time()
#' fapply(t, "date5")                 # Month Year (mmmyy)
#' fapply(t, "date7")                 # Day Month Year (ddmmmyy)
#' fapply(t, "date9")                 # Day Month Year (ddmmmyyyy)
#' fapply(t, "date11")                # Day Month Year (dd-mmm-yyyy)
#' 
#' # Examples for formatting numbers
#' a <- 1234.56789
#' fapply(a, "%f")                    # Floating point number
#' fapply(a, "%.1f")                  # One decimal place
#' fapply(a, "%8.1f")                 # Fixed width
#' fapply(a, "%-8.1f")                # Fixed width left justified
#' fapply(a, "%08.1f")                # Zero padded
#' fapply(a, "%+.1f")                 # Forced sign
#' fapply(-a, "%+.1f")                # Negative 
#' fapply(a, "%.1f%%")                # Percentage
#' fapply(a, "$%.2f")                 # Currency
#' fapply(a, "The number is %f.")     # Interpolation
#' 
#' # "best" formatting
#' fapply(a, "best6")                 # Total width of 6
#' fapply(a, "best8")                 # Total width of 8
#' 
#' @name FormattingStrings
NULL

  




