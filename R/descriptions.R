
#' @title
#' Get or set descriptions for data frame columns
#' 
#' @description 
#' The \code{descriptions} function extracts all assigned description
#' attributes from a 
#' data frame, and returns them in a named list. The function also
#' assigns description attributes from a named list.
#' 
#' @details 
#' If descriptions are assigned to the "description" 
#' attributes of the data frame
#' columns, the \code{descriptions} function will extract those values.  The 
#' function will return the description values in a named list, 
#' where the names
#' correspond to the name of the column that the description was assigned to.
#' If a column does not have a description attribute assigned, that column
#' will not be included in the list. 
#' 
#' When used on the receiving side of an assignment, the function will assign
#' descriptions to a data frame.  The description values 
#' should be in a named list, where
#' each name corresponds to the name of the data frame column to assign
#' values to.
#' 
#' Finally, if you wish to clear out the description attributes, assign
#' a NULL value to the \code{descriptions} function.    
#' @param x A data frame or tibble.
#' @return A named list of description values. 
#' @seealso \code{\link{fdata}} to display formatted data, 
#' \code{\link{value}} to create user-defined formats, and 
#' \code{\link{fapply}} to apply formatting to a vector.
#' @export
#' @aliases descriptions<-
#' @examples 
#' # Take subset of data
#' df1 <- mtcars[1:5, c("mpg", "cyl") ]
#' 
#' # Print current state
#' print(df1)
#' #                    mpg cyl
#' # Mazda RX4         21.0   6
#' # Mazda RX4 Wag     21.0   6
#' # Datsun 710        22.8   4
#' # Hornet 4 Drive    21.4   6
#' # Hornet Sportabout 18.7   8
#' 
#' # Assign descriptions
#' descriptions(df1) <- list(mpg = "Miles per Gallon", cyl = "Cylinders")
#' 
#' # Display descriptions
#' descriptions(df1)
#' # $mpg
#' # [1] "Miles per Gallon"
#' # 
#' # $cyl
#' # [1] "Cylinders"
#' 
#' # Clear descriptions
#' descriptions(df1) <- NULL
#' 
#' # Confirm descriptions are cleared
#' descriptions(df1)
#' # list()
descriptions <- function(x) {
  
  ret <- list()
  
  for (nm in names(x)) {
    
    if (!is.null(attr(x[[nm]], "description", exact = TRUE))) {
      ret[[nm]] <- attr(x[[nm]], "description", exact = TRUE)
    }
    
  }
  
  return(ret)
  
}

#' @aliases descriptions
#' @rdname  descriptions
#' @param x A data frame or tibble
#' @param verbose If TRUE, the function will emit messages regarding
#' @param value A named list of description values. 
#' misspelled column names, missing columns, etc.  This option is helpful
#' if you are setting a lot of descriptions on your data, and need
#' more feedback.
#' @export 
`descriptions<-` <- function(x, verbose = FALSE, value) {
  
  
  if (verbose) {
    x <- descriptions_verbose(x, value)
    
  } else {
    
    x <- assign_descriptions(x, value) 
  
  }
  

  
  return(x)
  
}

assign_descriptions <- function(x, value) {
 
  if (all(is.null(value))) {
    
    for (nm in names(x)) {
      
      attr(x[[nm]], "description") <- NULL
    }
    
    
  } else {
    
    for (nm in names(value)) {
      
      if (!is.null(x[[nm]])) 
        attr(x[[nm]], "description") <- value[[nm]]
      
    }
  } 
  
  return(x)
  
}

#' @noRd
descriptions_verbose <- function(x, value){
  
  if(any(duplicated(names(value)))){
    stop("List `value` names must be unique.")
  }
  vars.overdescribed <- setdiff(names(value), names(x))
  
  if(length(vars.overdescribed) > 0){
    message("The following variables are defined in descriptions list and not in dataframe: ")
    cat("  ", paste0(vars.overdescribed, collapse = ", "), "\n")
  }
  
  
  cur.descriptions = descriptions(x)
  description.collisions = intersect(names(cur.descriptions), names(value))
  if(length(description.collisions) > 0){
    description.overwrites = data.frame(variable = description.collisions,
                                        original = do.call(c, cur.descriptions[description.collisions]),
                                        new = do.call(c, value[description.collisions]))
    description.overwrites = description.overwrites[description.overwrites$original != description.overwrites$new,]
    #print(description.overwrites)
    if(nrow(description.overwrites) > 0){
      #browser()
      updates.formatted = paste0("- ", description.overwrites$variable, ":  ",
                                 description.overwrites$original, " -> ", 
                                 description.overwrites$new, "\n")

      message("The following descriptions are being updated:")
      
      for (uf in updates.formatted) {
        cat(paste0(uf))
      }
    }
  }
  x <- assign_descriptions(x, value)
  
  vars.undefined = setdiff(names(x), names(descriptions(x)))
  if(length(vars.undefined)>0){
    message("The following variables are still undescribed:")
    cat("  ", paste0(vars.undefined, collapse = ", "), "\n")
    
  } else {
    message("All variables described")
  }
  return(x)
}

## alternative version of `descriptions<-` that provides feedback on variables that are left undescribed,
## descriptions that are being overwritten.
# descriptions_verbose2 <- function(x, value){
#   if(any(duplicated(names(value)))){
#     cli::cli_abort("`value` names must be unique!")
#   }
#   vars.overdescribed <- setdiff(names(value), names(x))
#   
#   if(length(vars.overdescribed) > 0){
#     cli::cli_alert("The following variables are defined in descriptions list and not in dataframe: {vars.overdescribed}")
#   }
#   
#   
#   cur.descriptions = fmtr::descriptions(x)
#   description.collisions = intersect(names(cur.descriptions), names(value))
#   if(length(description.collisions) > 0){
#     description.overwrites = data.frame(variable = description.collisions,
#                                         original = do.call(c, cur.descriptions[description.collisions]),
#                                         new = do.call(c, value[description.collisions]))
#     description.overwrites = description.overwrites[description.overwrites$original != description.overwrites$new,]
#     if(nrow(description.overwrites) > 0){
#       updates.formatted = paste0("{.strong ", description.overwrites$variable, "}:  ",
#                                  description.overwrites$original, " {.emph ->} ", description.overwrites$new)
#       names(updates.formatted) = rep("*", length(updates.formatted))
#       cli::cli_alert("The following descriptions are being updated")
#       cli::cli_div(theme = list(span.emph = list(color = "cornflowerblue")))
#       cli::cli_bullets(updates.formatted)
#     }
#   }
#   x <- assign_descriptions(x, value)
#   vars.undefined = setdiff(names(x), names(fmtr::descriptions(x)))
#   if(length(vars.undefined)>0){
#     cli::cli_alert_warning("The following variables are still undescribed: {vars.undefined}")
#   } else {
#     cli::cli_alert_success("All variables described")
#   }
#   return(x)
# }
