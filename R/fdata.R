

# Format Functions ----------------------------------------------

#' @title
#' Format a data frame or tibble
#' 
#' @description 
#' The \code{fdata} function applies formatting attributes
#' to the entire data frame.
#' 
#' @details 
#' If formats are assigned to the "format" attributes of the data frame
#' columns, the \code{fdata} function will apply those formats
#' to the specified columns, and return a new, formatted data frame. 
#' Formats can be specified as formatting strings, named vectors, user-defined
#' formats, or vectorized formatting functions.  The \code{fdata} 
#' function will
#' apply the format to the associated column data using the \code{\link{fapply}} 
#' function. A format can also be specified as a formatting list of the 
#' previous four types.  See the \code{\link{fapply}}
#' function for additional information.
#' 
#' After formatting each column, the \code{fdata} function will 
#' call the base R \code{\link{format}} function on 
#' the data frame.  Any follow on parameters will be sent to the \code{format}
#' function.   
#' 
#' The \code{fdata} function will also apply any \code{width} or \code{justify}
#' attributes assigned to the data frame columns.  These attributes can be 
#' controlled at the column level.  Using
#' attributes to assign formatting and \code{fdata} to apply those attributes
#' gives you a create deal of control over how
#' your data is presented.
#'
#' @param x A data frame or tibble to be formatted.
#' @param ... Any follow-on parameters to the format function.
#' @return A new, formatted data frame or tibble with the formats applied.
#' @seealso \code{\link{fcat}} to create a format catalog, 
#' \code{\link{fapply}} to apply a format to a vector,
#' \code{\link{value}} to define a format object,
#' \code{\link{fattr}} to assign formatting specifications to a single 
#' column/vector, and the
#' \code{\link{formats}}, \code{\link{widths}}, and \code{\link{justification}}
#' functions to get or set formatting for an entire data frame.  Also see
#' \link{FormattingStrings} for documentation on formatting strings.
#' @import tibble
#' @export
#' @examples 
#' # Construct data frame from state vectors
#' df <- data.frame(state = state.abb, area = state.area)[1:10, ]
#' 
#' # Calculate percentages
#' df$pct <- df$area / sum(state.area) * 100
#' 
#' # Before formatting 
#' df
#' 
#' #    state   area         pct
#' # 1     AL  51609  1.42629378
#' # 2     AK 589757 16.29883824
#' # 3     AZ 113909  3.14804973
#' # 4     AR  53104  1.46761040
#' # 5     CA 158693  4.38572418
#' # 6     CO 104247  2.88102556
#' # 7     CT   5009  0.13843139
#' # 8     DE   2057  0.05684835
#' # 9     FL  58560  1.61839532
#' # 10    GA  58876  1.62712846
#' 
#' # Create state name lookup list
#' name_lookup <- state.name
#' names(name_lookup) <- state.abb
#' 
#' # Assign formats
#' formats(df) <- list(state = name_lookup,                         
#'                     area  = function(x) format(x, big.mark = ","), 
#'                     pct   = "%.1f%%") 
#' 
#' # Apply formats
#' fdata(df)
#' 
#' #          state    area   pct
#' # 1      Alabama  51,609  1.4%
#' # 2       Alaska 589,757 16.3%
#' # 3      Arizona 113,909  3.1%
#' # 4     Arkansas  53,104  1.5%
#' # 5   California 158,693  4.4%
#' # 6     Colorado 104,247  2.9%
#' # 7  Connecticut   5,009  0.1%
#' # 8     Delaware   2,057  0.1%
#' # 9      Florida  58,560  1.6%
#' # 10     Georgia  58,876  1.6%
fdata <- function(x, ...) {
  

  if (all(class(x) != "data.frame"))
    stop("Input value must be derived from class data.frame")
  
  # Apply formats to all columns
  ret <- list()
  for (nm in names(x)) {
  
    ret[[length(ret) + 1]] <- fapply(x[[nm]])
    
    # Restore any labels
    if (!is.null(attr(x[[nm]], "label"))) {
      attr(ret[[length(ret)]], "label") <- attr(x[[nm]], "label")
    }
  }
  
  # Restore names, as they are sometimes messed up
  names(ret) <- names(x)
  
  # Convert list to data frame
  ret <- as.data.frame(ret)
  
  # Restore names again as they are getting lost in R 3.6
  for (nm in names(x)) {
    
    # Restore any labels
    if (!is.null(attr(x[[nm]], "label"))) {
      attr(ret[[nm]], "label") <- attr(x[[nm]], "label")
    }
  }
  
  
  # Transfer any rownames to new data frame
  rownames(ret) <- rownames(x)
  
  # Call base R format function
  # Honestly regret adding this.  Too late now.
  if (any(class(x) == "data.frame") & ...length() > 0) {
    
    ret <- base::format.data.frame(ret, ...)
  }
  
  if (any(class(x) == "tbl_df")) {
    
    ret <- as_tibble(ret)
    
    # Getting a missing or unexported object error on this
    # Not sure why. It exists.
    # Commenting out for now.
    #ret <- tibble::format.tbl(ret, ...)
    
  }
  
  # Restore attributes
  class(ret) <- class(x)
  mode(ret) <- mode(x)
  names(ret) <- names(x)
  
  return(ret)
  
}





# Testing -----------------------------------------------------------------

# 
# df1 <- mtcars[1:10, c("mpg", "cyl") ]
# 
# print(df1)
# 
# 
# fmt1 <- value(condition(x >= 20, "High"),
#                       condition(x < 20, "Low"))
# 
# fmt2 <- c(H = "High", L = "Low")
# 
# is.format(fmt1)
# 
# #df1$mpgc <- fapply(fmt1, df1$mpg)
# attr(df1$mpg, "format") <- fmt1
# attr(df1$cyl, "format") <- function(x) {format(x, nsmall = 1)}
# 
# 
# df2 <- format(df1, justify = "left")
# df2
# class(df2)
# 
# 
# library(tibble)
# tb1 <- tibble(mtcars[1:10, ])
# tb1
# class(tb1)
# print(tb1)
# 
# tb1$mpgc <- fapply(fmt1, tb1$mpg)
# attr(tb1$mpg, "format") <- fmt1
# attr(tb1$mpgc, "format") <- fmt2
# tb1
# 
# 
# tibble::format.tbl()
# tb2 <- format(tb1)
# print(tb2, n = 5)
# class(tb2)
#
# base::format(tb1)
# 

# Colors
# txt<-"test"
# for(col in 29:47){ cat(paste0("\033[0;", col, "m", col, txt,"\033[0m","\n"))}
# 
# cat(paste0("\033[0;", "37", "m", "hello","\033[0m","\n"))

# v1 <- c("A", "B", "C", "B")
# 
# fmt1 <- c(A = "Label A", B = "Label B", C= "Label C")
# 
# fapply(fmt1, v1)
# 
# 
# v1 <- c("A", "B", "C", "B")
# 
# fmt2 <- Vectorize(function(x) {
#   
#   if (x == "A") 
#     ret <- "Label A"
#   else if (x == "B")
#     ret <- "Label B"
#   else 
#     ret <- "Other"
#   
#   return(ret)
#   
# })
# 
# fapply(fmt2, v1)
# 
# v1 <- c("A", "B", "C", "B")
# 
# fmt3 <- value(condition(x == "A", "Label A"),
#               condition(x == "B", "Label B"),
#               condition(TRUE, "Other"))
# 
# fapply(fmt3, v1)
# 
# 
# v1 <- c("A", "B", "C", "B")
# 
# fmt1 <- value(condition(x == "A", "Label A"),
#               condition(x == "B", "Label B"),
#               condition(TRUE, "Other"))
# 
# fapply(fmt1, v1)
# v1
# 
# 
# v1 <- c("A", "B", "C", "B", "A", "C")
# f1 <- factor(v1, levels = c("A", "B", "C"))
# 
# fmt2 <- value(condition(x == "A", "Label A"),
#               condition(x == "B", "Label B"),
#               condition(TRUE, "Other"))
# 
# fapply(fmt2, f1)
# 
# 

# # Set up data frame
# df <- mtcars[1:10, c("mpg", "cyl")]
# 
# # Define and assign formats
# attr(df$mpg, "format") <- value(condition(x >= 20, "High"),
#                                 condition(x < 20, "Low"))
# 
# attr(df$cyl, "format") <- function(x) format(x, nsmall = 1)
# 
# # Apply formatting
# format(df)


