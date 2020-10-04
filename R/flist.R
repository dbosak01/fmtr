

# Flist Function ----------------------------------------------------------


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
#' @family flist
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
  x <- structure(list(), class = c("fmt_lst", "list"))
  
  x$formats <- list(...)
  x$type <- type
  x$lookup <- lookup
  x$simplify <- simplify
  if (!is.null(lookup))
    x$lookupname <- deparse1(substitute(lookup, env = environment()))
  
  
  return(x)
  
}


# Utilities ---------------------------------------------------------------



#' @title Is object a formatting list
#' @description Determines if object is a formatting list of class 'fmt_lst'.
#' @param x Object to test.
#' @return TRUE or FALSE, depending on class of object.
#' @family flist
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
#' @family flist
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
  f <- structure(list(), class = c("fmt_lst", "list"))
  
  f$formats <- x
  f$type <- type
  f$lookup <- lookup
  f$simplify <- simplify
  
  return(f)
}


#' @title Convert a formatting list to a data frame
#' @description This function takes the information stored in a formatting 
#' list, and converts it to a data frame.  The data frame format is 
#' useful for storage, editing, saving to a spreadsheet, etc.  The 
#' data frame shows the name of the formats, their type, and the format 
#' expression.  For use-defined formats, the data frame populates 
#' additional columns for the label and order.
#' @param x The formatting list to convert.
#' @param row.names Row names of the return data frame.  Default is NULL.
#' @param optional TRUE or FALSE value indicating whether converting to
#' syntactic variable names is desired.  In the case of formats, the 
#' resulting data frame will always be returned with syntactic names, and 
#' this parameter is ignored.
#' @param ... Any follow-on parameters.
#' @return A data frame that contains the values stored in the formatting 
#' list.  
#' @family flist
#' @examples 
#' # Create a format catalog
#' c1 <- fcat(num_fmt  = "%.1f",
#'            label_fmt = value(condition(x == "A", "Label A"),
#'                              condition(x == "B", "Label B"),
#'                              condition(TRUE, "Other")),
#'            date_fmt = "%d%b%Y")
#'            
#' # Convert catalog to data frame to view the structure
#' df <- as.data.frame(c1)
#' print(df)
#' 
#' #       Name Type Expression   Label Order
#' # 1   num_fmt    S       %.1f            NA
#' # 2 label_fmt    U   x == "A" Label A    NA
#' # 3 label_fmt    U   x == "B" Label B    NA
#' # 4 label_fmt    U       TRUE   Other    NA
#' # 5  date_fmt    S     %d%b%Y            NA
#' 
#' # Convert data frame back to a format catalog
#' c2 <- as.fcat(df)
#' @export
as.data.frame.fmt_lst <- function(x, row.names = NULL, optional = FALSE, ...) {
  
  if (!"fmt_lst" %in% class(x))
    stop("Class of object must include 'fmt_lst'")
  fmts <- x$formats
  tmp <- list()
  
  nms <- names(fmts)
  if (is.null(nms))
    nms <- paste0("format", seq(from = 1, to = length(fmts)))
  
  for (i in seq_along(fmts)) {
    
    nm <- nms[[i]]
    
    if (any(class(fmts[[i]]) == "fmt")) {
      
      tmp[[nm]] <- as.data.frame.fmt(fmts[[i]], name = nm)
      
    } else if (all(class(fmts[[i]]) == "character")) {
      
      if (length(fmts[[i]]) == 1 & is.null(names(fmts[[i]]))) {
        tmp[[nm]] <- data.frame(Name = nm, 
                                Type = "S",
                                Expression = fmts[[i]],
                                Label = "", 
                                Order = NA)
      } else {
        tmp[[nm]] <- data.frame(Name = nm, 
                                Type = "V",
                                Expression = deparse1(fmts[[i]]),
                                Label = "", 
                                Order = NA)
      }
      
    } else if (any(class(fmts[[i]]) == "function")) {
      
      tmp[[nm]] <-  data.frame(Name = nm, 
                               Type = "F",
                               Expression = deparse1(fmts[[i]]),
                               Label = "", 
                               Order = NA)
      
      
    }
    
  }
  
  
  ret <- do.call("rbind", tmp)
  
  if (!is.null(row.names))
    rownames(ret) <- row.names
  else
    rownames(ret) <- NULL
  
  return(ret)
  
}


#' @title Print a formatting list
#' @param x The formatting list to print
#' @param ... Follow-on parameters to the print function
#' @param verbose Whether to print in summary or list-style.
#' @family flist
#' @export
print.fmt_lst <- function(x, ..., verbose = FALSE) {
  
  if (verbose == TRUE) {
    print(unclass(x)) 
  } else {
    
    grey60 <- make_style(grey60 = "#999999")
    cat(grey60("# A formatting list: " %+% 
                 as.character(length(x$formats)) %+% " formats\n")) 
    cat(grey60("- type: " %+% x$type %+% "\n"))
    if (!is.null(x$lookupname))
      cat(grey60("- lookup: " %+% x$lookupname %+% "\n"))
    cat(grey60("- simplify: " %+% as.character(x$simplify) %+% "\n"))
    
    print(as.data.frame(x))
    
  }
  
  invisible(x)
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


