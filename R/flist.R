

#' @title Create a formatting list
#' @description A formatting list contains more than one formatting object
#' @details 
#' To apply more than one formatting object to a vector, use a formatting
#' list.  There are two types of formatting list: column and row.  The column
#' type formatting lists applies all formats to all values in the
#' vector.  The row type formatting list can apply a different format to 
#' each value in the vector.  
#' 
#' Further, there are two styles of row type list: ordered and lookup.  The
#' ordered style applies each format in the list to the vector values
#' in the order specified.  The
#' ordered style will recycle the formats as needed.  The lookup style 
#' formatting list uses a lookup to determine which format from the list to
#' apply to a particular value of the vector.  The lookup column values should
#' correspond to names on the formatting list.  
#' 
#' Examples of column type and row type formatting lists are given below. 
#' @param ... A set of formatting objects.
#' @param type The type of formatting list.  Valid values are 'row' or 'column'.
#' The default value is 'column'.
#' @param lookup A lookup vector.  Used for looking up the format from 
#' the formatting list.  This parameter is only used for 'row' type 
#' formatting lists.
#' @param simplify Whether to simplify the results to a vector.  Valid values 
#' are TRUE or FALSE.  Default is TRUE.  If the value is set to FALSE, the 
#' return type will be a list.
#' @return A vector or list of formatted values.  The type of return value 
#' can be controlled with the \code{simplify} parameter.  The default return
#' type is a vector.
#' @seealso \code{\link{fapply}} for information on how formats are applied
#' to a vector, \code{\link{value}} for how to create a user-defined format,
#' and \code{\link{as.flist}} to convert an existing list of formats 
#' to a formatting
#' list. Also see \link{FormattingStrings} for details on how to use
#' formatting strings.
#' @export
#' @examples
#' #' ## Example 1: Formatting List - Column Type ##
#' # Set up data
#' v1 <- c(Sys.Date(), Sys.Date() + 30, Sys.Date() + 60)
#' 
#' # Create formatting list
#' fl1 <- flist("%B", "The month is: %s")
#' 
#' # Apply formatting list to vector
#' fapply(v1, fl1)
#' 
#' 
#' ## Example 2: Formatting List - Row Type ordered ##
#' # Set up data
#' # Notice each row has a different data type
#' l1 <- list("A", 1.263, as.Date("2020-07-21"), 
#'           "B", 5.8732, as.Date("2020-10-17"))
#'           
#' # These formats will be recycled in the order specified           
#' fl2 <- flist(type = "row",
#'              c(A = "Label A", B = "Label B"),
#'              "%.1f",
#'              "%d%b%Y")
#' 
#' fapply(l1, fl2)
#' 
#' 
#' ## Example 3: Formatting List - Row Type with lookup ##
#' # Set up data
#' # Notice each row has a different data type
#' l2 <- list(2841.258, "H", as.Date("2020-06-19"),
#'            "L", as.Date("2020-04-24"), 1382.8865)
#' v3 <- c("num", "char", "date", "char", "date", "num")
#' 
#' # Create formatting list
#' fl3 <- flist(type = "row", lookup = v3,
#'              num = function(x) format(x, digits = 2, nsmall = 1, 
#'                                   big.mark=","),
#'              char = value(condition(x == "H", "High"),
#'                      condition(x == "L", "Low"),
#'                      condition(TRUE, "NA")),
#'              date = "%d%b%Y")
#' 
#' # Apply formatting list to vector, using lookup
#' fapply(l2, fl3)
flist <- function(..., type = "column", lookup = NULL, simplify = TRUE) {
  
  if (!type %in% c("column", "row"))
    stop (paste("Invalid value for type parameter.", 
                "Value values are 'column' or 'row'"))
  
  if (!simplify %in% c(TRUE, FALSE))
    stop (paste("Invalid value for simplify parameter.", 
                "Valid values are TRUE or FALSE."))
  
  if (is.null(lookup) == FALSE & type == "column")
    stop (paste("Lookup parameter only allowed on type 'row'."))
  
  # Create new structure of class "fmt_lst"
  x <- structure(list(), class = c("fmt_lst"))
  
  x$formats <- list(...)
  x$type <- type
  x$lookup <- lookup
  x$simplify <- simplify
  
  
  return(x)
  
}

#' @title Is object a formatting list
#' @description Determines if object is a formatting list of class 'fmt_lst'.
#' @param x Object to test.
#' @return TRUE or FALSE, depending on class of object.
#' @export
#' @examples
#' # Create flist
#' flst <- flist("%d%b%Y", "%.1f")
#' is.flist(flst)
#' is.flist("A")
is.flist <- function(x) {
 
  if (any(class(x) == "fmt_lst"))
    ret <- TRUE
  else
    ret <- FALSE
  
  return(ret)
}


#' @title Convert to a formatting list
#' @description Converts a normal list to a formatting list.  All
#' other parameters are the same as the \code{flist} function.
#' @param x List to convert.
#' @return A formatting list object.
#' @inherit flist
#' @seealso \code{\link{flist}} function documentation for additional details.
#' @export
#' @examples
#' # Create flist
#' lst <- list("%d%b%Y", "%.1f")
#' flst <- as.flist(lst)
#' is.flist(flst)
#' is.flist("A")
as.flist <- function(x, type = "column", lookup = NULL, simplify = TRUE) {
  
  
  if (!type %in% c("column", "row"))
    stop (paste("Invalid value for type parameter.", 
                "Value values are 'column' or 'row'"))
  
  if (!simplify %in% c(TRUE, FALSE))
    stop (paste("Invalid value for simplify parameter.", 
                "Valid values are TRUE or FALSE."))
  
  if (is.null(lookup) == FALSE & type == "column")
    stop (paste("Lookup parameter only allowed on type 'row'."))
  
  # Create new structure of class "fmt_lst"
  f <- structure(list(), class = c("fmt_lst"))
  
  f$formats <- x
  f$type <- type
  f$lookup <- lookup
  f$simplify <- simplify
  
  return(f)
}


# Testing -----------------------------------------------------------------
# 
# # Simple use case
# id <- 100:109
# col1 <- sample(rep(c("A", "B", "C"), 5), 10)
# col2 <- sample(seq(0, 100, by = .001), 10)
# 
# 
# df <- data.frame(id, col1, col2)
# df
# 
# 
# col1_fmt <- c(A = "Placebo", B = "Drug", C = "Other")
# col2_fmt <- Vectorize(function(x) if (x > 88) "High" else if (x < 12) "Low" else x)
#   
# 
# 
# 
# formats(df) <- list(col1 = col1_fmt, col2 = col2_fmt)
# formats(df)
# 
# format(df)
# 
# col1_fmt2 <- function(x) format(x, justify = "left") 
# col2_fmt2 <- function(x) format(x, justify = "left")
# 
# col1_flist <- flist(col1_fmt, col1_fmt2)
# col2_flist <- flist(col2_fmt, col2_fmt2)
# 
# is.flist(col1_fmt)
# 
# formats(df) <- list(col1_flist, col2_flist)
# 
# col1_flist


