

# Format Functions ----------------------------------------------

#' @title
#' Format a data table
#' 
#' @description 
#' The \code{format_dataframe} function applies formatting attributes
#' to the entire data frame.
#' 
#' @details 
#' If formats are assigned to the "format" attributes of the data frame
#' columns, the \code{format_dataframe} function will apply those formats
#' to the specified columns, and return a new formatted data frame. 
#' Format can be specified as named vectors, vectorized formatting functions, 
#' or a user-defined format.  The \code{format_dataframe} function will
#' apply the format to the associated column data using the \code{fapply} 
#' function.  A format can also be specified as a list of 
#' formats of the previous three types.  
#' 
#' The \code{format_dataframe} function has two overrides: 
#' \code{format.data.frame} and \code{format.tbl}.  The two overrides will
#' call \code{format_dataframe} on the data.frame class and the tbl (tibble)
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
#' # Set up vector
#' df <- mtcars[1:10, c("mpg", "cyl")]
#' 
#' # Define format
#' attr(df$mpg, "format") <- value(condition(x >= 20, "High"),
#'                                 condition(x < 20, "Low"))
#'                                 
#' attr(df$cyl, "format") <- value(condition(x == 4, "Small"),
#'                                 condition(x == 6, "Mid-size"),
#'                                 condition(x == 8, "Large"))
#'               
#' # Apply formatting
#' format(df)
format_dataframe <- function(x, ...) {
  
  
  if (all(class(x) != "data.frame"))
    stop("Input value must be derived from class data.frame")
  
  ret <- list()
  for (nm in names(x)) {
    
    if (is.null(attr(x[[nm]], "format")) == FALSE) {
      
      fmt <- attr(x[[nm]], "format")
      ret[[length(ret) + 1]] <- fapply(fmt, x[[nm]])
      
    } else {
      
      ret[[length(ret) + 1]] <- x[[nm]]
    }
    
  }
  
  names(ret) <- names(x)
  ret <- as.data.frame(ret)
  rownames(ret) <- rownames(x)
  
  if (all(class(x) == "data.frame")) {
    
    ret <- base::format.data.frame(ret, ...)
  }
  
  if (any(class(x) == "tbl_df")) {
    
    ret <- as_tibble(ret)
    
  }
  
  class(ret) <- class(x)
  mode(ret) <- mode(x)
  names(ret) <- names(x)
  
  return(ret)
  
}

#' @aliases format_dataframe
#' @export 
format.tbl <- function(x, ...) {



  fbl <- format_dataframe(x, ...)


  return(fbl)
}


#' @aliases format_dataframe
#' @export 
format.data.frame <- function(x, ...) {
  
  
  fbl <- format_dataframe(x, ...)

  
  return(fbl)
  
}







# Testing -----------------------------------------------------------------


# df1 <- mtcars[1:10, ]
# 
# print(df1)
# 
# 
# fmt1 <- value(condition(x >= 20, "H"),
#                       condition(x < 20, "L"))
# 
# fmt2 <- c(H = "High", L = "Low")
# 
# is.format(fmt1)
# 
# df1$mpgc <- fapply(fmt1, df1$mpg)
# attr(df1$mpg, "format") <- fmt1
# attr(df1$mpgc, "format") <- fmt2
# 
# df2 <- format(df1, digits = 2, justify = "left")
# df2
# class(df2)
# mode(df2)
# mode(mtcars)
# 
# mode(df1$mpg)


# all(class(tb1) == "data.frame")
# 
# library(tibble)
# tb1 <- tibble(mtcars[1:10, ])
# tb1
# class(tb1)
# print(tb1)
# 
# tb1$mpgc <- apply_format(fmt1, tb1$mpg)
# attr(tb1$mpg, "format") <- fmt1
# attr(tb1$mpgc, "format") <- fmt2
# tb1
# 
# tb2 <- format(tb1, digits = 2)
# tb2
# class(tb2)
# 
# base::format(tb1)
# 

# Colors
# txt<-"test"
# for(col in 29:47){ cat(paste0("\033[0;", col, "m", col, txt,"\033[0m","\n"))}
# 
# cat(paste0("\033[0;", "37", "m", "hello","\033[0m","\n"))

# 
# 
# 
# class(tibble(mtcars))
# 
# 
# attr(f2$mpg, "format") <- fmt1
# format(f2)
# 
# 
# format(1:10)
# format(1:10, trim = TRUE)
# 
# zz <- data.frame(col1= c("aaaaa", "b"), col2 = c(1, 2))
# format(zz)
# format(zz, justify = "left")
# 
# ## use of nsmall
# format(13.7)
# format(13.7, nsmall = 3)
# format(c(6.0, 13.1), digits = 2)
# format(c(6.0, 13.1), digits = 2, nsmall = 1)
# 
# tbl1 <- mtcars[1:10, ]
# 
# attr(tbl1$mpg, "format") <- fmt1
# 
# format(tbl1, digits = 2)
# 
# 
# base::format(tbl1, digits = 2)
