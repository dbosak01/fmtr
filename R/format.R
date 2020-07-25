

# Format Functions ----------------------------------------------

#' @title
#' Format a data frame or tibble
#' 
#' @description 
#' The \code{format_data} function applies formatting attributes
#' to the entire data frame.
#' 
#' @details 
#' If formats are assigned to the "format" attributes of the data frame
#' columns, the \code{format_data} function will apply those formats
#' to the specified columns, and return a new formatted data frame. 
#' Format can be specified as named vectors, vectorized formatting functions, 
#' or a user-defined format.  The \code{format_data} function will
#' apply the format to the associated column data using the \code{fapply} 
#' function.  A format can also be specified as a list of 
#' formats of the previous three types.  
#' 
#' The \code{format_data} function has two overrides: 
#' \code{format.data.frame} and \code{format.tbl}.  The two overrides will
#' call \code{format_data} on the data.frame class and the tbl (tibble)
#' class, respectively.
#'
#' @param x A data frame or tibble to be formatted.
#' @param ... Any follow-on parameters to the format function.
#' @return A new, formatted data frame or tibble with the formats applied.
#' @seealso \code{\link{value}} to define a format,
#' \code{\link{levels}} or \code{labels} to access the labels, and 
#' \code{\link{fapply}} to apply the format to a vector.
#' @import tibble
#' @export
#' @aliases format.tbl format.data.frame
#' @examples 
#' ## Example 1: Simple Formats ##
#' # Set up data frame
#' df <- mtcars[1:10, c("mpg", "cyl")]
#' 
#' # Define and assign formats
#' attr(df$mpg, "format") <- value(condition(x >= 20, "High"),
#'                                 condition(x < 20, "Low"))
#'                                 
#' attr(df$cyl, "format") <- value(condition(x == 4, "Small"),
#'                                 condition(x == 6, "Midsize"),
#'                                 condition(x == 8, "Large"))
#'               
#' # Apply formatting
#' format(df)
#' 
#' ## Example 2: Formatting List ##
#' # Set up data
#' v1 <- c("type1", "type2", "type3", "type2", "type3", "type1")
#' v2 <- list(1.258, "H", as.Date("2020-06-19"),
#'            "L", as.Date("2020-04-24"), 2.8865)
#' 
#' df <- data.frame(type = v1, values = I(v2))
#' df
#' 
#' # Create formatting list
#' lst <- list()
#' lst$type1 <- function(x) format(x, digits = 2, nsmall = 1)
#' lst$type2 <- value(condition(x == "H", "High"),
#'                    condition(x == "L", "Low"),
#'                    condition(TRUE, "NA"))
#' lst$type3 <- function(x) format(x, format = "%y-%m")
#' 
#' # Assign list and lookup to column attributes
#' attr(df$values, "format") <- lst
#' attr(df$values, "format_lookup") <- "type"
#' 
#' # Apply formatting list
#' format(df)
format_data <- function(x, ...) {
  
  
  if (all(class(x) != "data.frame"))
    stop("Input value must be derived from class data.frame")
  
  ret <- list()
  for (nm in names(x)) {
  
    
    ret[[length(ret) + 1]] <- fapply(x[[nm]])
    
  }
  
  names(ret) <- names(x)
  ret <- as.data.frame(ret)
  rownames(ret) <- rownames(x)
  
  if (all(class(x) == "data.frame")) {
    
    ret <- base::format.data.frame(ret, ...)
  }
  
  if (any(class(x) == "tbl_df")) {
    
    ret <- as_tibble(ret)
    
    # Getting a missing or unexported object error on this
    # Not sure why. It exists.
    # Commenting out for now.
    #ret <- tibble::format.tbl(ret, ...)
    
  }
  
  class(ret) <- class(x)
  mode(ret) <- mode(x)
  names(ret) <- names(x)
  
  return(ret)
  
}

#' @aliases format_data
#' @export 
format.tbl <- function(x, ...) {



  fbl <- format_data(x, ...)


  return(fbl)
}


#' @aliases format_data
#' @export 
format.data.frame <- function(x, ...) {
  
  
  fbl <- format_data(x, ...)

  
  return(fbl)
  
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


