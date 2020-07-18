

# Format Functions ----------------------------------------------

format_dataframe <- function(x, ...) {
  
  
  if (all(class(x) != "data.frame"))
    stop("Input value must be derived from class data.frame")
  
  ret <- list()
  for (nm in names(x)) {
    
    if (is.null(attr(x[[nm]], "format")) == FALSE) {
      
      fmt <- attr(x[[nm]], "format")
      
      if (is.vector(fmt))
        ret[[length(ret) + 1]] <- fmt[x[[nm]]] 
      else if (is.function(fmt))
        ret[[length(ret) + 1]] <- do.call(fmt, list(x[[nm]]))
      else if (is.format(fmt))
        ret[[length(ret) + 1]] <- apply_format(fmt, x[[nm]])
      
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
  
  return(ret)
  
}



format.tbl <- function(x, ...) {



  fbl <- format_dataframe(x, ...)


  return(fbl)
}


format.data.frame <- function(x, ...) {
  
  
  fbl <- format_dataframe(x, ...)

  
  return(fbl)
  
}







# Testing -----------------------------------------------------------------
# 
# 
# df1 <- mtcars[1:10, ]
# 
# print(df1)
# 
# 
# fmt1 <- create_format(condition(x >= 20, "H"),
#                       condition(x < 20, "L"))
# 
# fmt2 <- c(H = "High", L = "Low")
# 
# is.format(fmt1)
# 
# df1$mpgc <- apply_format(fmt1, df1$mpg)
# attr(df1$mpg, "format") <- fmt1
# attr(df1$mpgc, "format") <- fmt2
# 
# df2 <- format(df1, digits = 2, justify = "left")
# df2
# class(df2)
# 
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
# tb2 <- format(tb1)
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
