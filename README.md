# fmtr <img src="man/images/mat_star.svg" align="right" height="138" />

<!-- badges: start -->

[![logr version](https://www.r-pkg.org/badges/version/fmtr)](https://cran.r-project.org/package=fmtr)
[![logr lifecycle](https://img.shields.io/badge/lifecycle-stable-blue.svg)](https://cran.r-project.org/package=fmtr)
[![logr downloads](https://cranlogs.r-pkg.org/badges/grand-total/fmtr)](https://cran.r-project.org/package=fmtr)
[![Travis build status](https://travis-ci.com/dbosak01/logr.svg?branch=master)](https://travis-ci.com/dbosak01/fmtr)

<!-- badges: end -->

The **fmtr** package helps format data.  The package aims to replicate
the basic functionality of SAS® formats, but with R.  

**fmtr** can apply 
formats to data frames, tibbles, vectors, and factors.  The `format()` function
is used to apply formats to data frames and tibbles, and the `fapply()`
function is used to apply formats to vectors and factors.


## How to use format()
Data can be formatted by assigning formats to the **format** attribute
of the columns in your dataframe or tibble, and then by calling the `format()` 
function on that data.  A sample program is as follows:

```
# Set up data frame
df <- mtcars[1:10, c("mpg", "cyl")]

# Define and assign formats
attr(df$mpg, "format") <- value(condition(x >= 20, "High"),
                                condition(x < 20, "Low"))

attr(df$cyl, "format") <- function(x) format(x, nsmall = 1)

# Apply formatting
format(df)

```

Here is the mtcars subset before formatting:
```
                   mpg cyl
Mazda RX4         21.0   6
Mazda RX4 Wag     21.0   6
Datsun 710        22.8   4
Hornet 4 Drive    21.4   6
Hornet Sportabout 18.7   8
Valiant           18.1   6
Duster 360        14.3   8
Merc 240D         24.4   4
Merc 230          22.8   4
Merc 280          19.2   6
```

And here is the mtcars subset after formatting:
```
                   mpg cyl
Mazda RX4         High 6.0
Mazda RX4 Wag     High 6.0
Datsun 710        High 4.0
Hornet 4 Drive    High 6.0
Hornet Sportabout Low  8.0
Valiant           Low  6.0
Duster 360        Low  8.0
Merc 240D         High 4.0
Merc 230          High 4.0
Merc 280          Low  6.0

```

You may apply formatting to variables of any data type: character, numeric, 
date, etc.  The format label (the result) can also be any data type. 
In addition, the type of objects that can be used for formatting is very 
flexible. Under the hood, the `format()` function is using the `fapply()`
function on each column in the data frame.  If there is no format assigned
to a column, that column is returned unaltered.

## How to use fapply()

The `fapply()` function applies a format to a vector or factor. This function 
may be used independantly of the `format()` function.  Here is an example:
```
v1 <- c("A", "B", "C", "B")

fmt1 <- value(condition(x == "A", "Label A"),
              condition(x == "B", "Label B"),
              condition(TRUE, "Other"))

fapply(fmt1, v1)

```
Here is the vector before formatting:
```
# [1] "A" "B" "C" "B"
```

And here is the vector after formatting:
```
#         A         B         C         B 
# "Label A" "Label B"   "Other" "Label B" 
```
One advantage of using `fapply()` is that your original data is not
altered. The formatted values are assigned to a new object, with no 
direct connection to your original data values.  If your orignial data 
changes, the formatting function should be reapplied to maintain consistency
with the original data.

## What kind of formats are available
Data can be formatted with four different types of objects:
  * A named vector
  * A user-defined format
  * A vectorized function
  * A formatting list

You can use the type of formatting object that is most suitable to 
your data and situation.  Each type of formatting object has it's own 
strengths and weaknesses.

#### Named vectors
Data may be formatted using a named vector as a lookup.  Simply ensure that 
the names on the formatting vector correspond to the values in the data vector.  
The advantage
of using a named vector for formatting is its simplicity.  The disadvantage
is that it only works with character values. Here is an 
example of formatting using a named vector:
```
v1 <- c("A", "B", "C", "B")

fmt1 <- c(A = "Label A", B = "Label B", C= "Label C")

fapply(fmt1, v1)

#         A         B         C         B 
# "Label A" "Label B" "Label C" "Label B" 

```
#### User-defined formats
The **fmtr** package provides custom functions for creating user-defined 
formats, in a manner that is similar to a SAS® user-defined format.
These functions are `value` and `condition`.
The `value` function accepts one or more conditions.  The `conditions`
function accepts an expression/label pair.  A user-defined format has the 
advantage of a clear and flexible syntax.  It is excellent for categorizing
data.  Here is an example of a user-defined 
format:
```
v1 <- c("A", "B", "C", "B")
f1 <- factor(v1, levels = c("A", "B", "C"))

fmt2 <- value(condition(x == "A", "Label A"),
              condition(x == "B", "Label B"),
              condition(TRUE, "Other"))
              
fapply(fmt2, f1)

#         A         B         C         B 
# "Label A" "Label B"   "Other" "Label B" 

```

#### Vectorized functions
Vectorized functions provide the most powerful way of formatting 
data.  Vectorized functions can be user-defined, or wrapping an 
available packaged function.  The vectorized function has the advantage 
of being nearly limitless
in the types of formatting you can perform.  The drawback is that a 
vectorized function can be more complicated to write.  Here is an 
example of formatting 
with a user-defined, vectorized function:
```
v1 <- c("A", "B", "C", "B")

fmt2 <- Vectorize(function(x) {
    
    if (x == "A") 
      ret <- "Label A"
    else if (x == "B")
      ret <- "Label B"
    else 
      ret <- "Other"
    
    return(ret)
    
  })
  
fapply(fmt2, v1)

#         A         B         C         B 
# "Label A" "Label B"   "Other" "Label B" 

```

#### A formatting list
Sometimes data needs to be formatted differently for each row.  This 
situation is difficult to deal with in any language.  
But it can be made easy in R with the **fmtr** package and a formatting list.

A formatting list is a list that contains one or more of the three types
of formatting objects described above.  A formatting list can be applied
two different ways: in order, or with a lookup.  

By default, the 
list is applied in order.  That means the first format in the list is 
applied to the first item in the vector, the second format in the list is 
applied to the second item in the vector, and so on.  The list is recycled 
if the number of list items is shorter than the number of values in the 
vector.

For the lookup method, the formatting object is specified by a lookup vector. 
The lookup vector should contain names 
associated with the elements in the formatting list. The lookup vector should 
also contain the same number of items as the data vector.  For each item
in the data vector, **fmtr** will look up the approprate format
from the formatting list, and apply that format to the
corresponding data value.

The following is an example of a lookup style formatting list:
```
# Set up data
v1 <- c("type1", "type2", "type3", "type2", "type3", "type1")
v2 <- list(1.258, "H", as.Date("2020-06-19"),
           "L", as.Date("2020-04-24"), 2.8865)

df <- data.frame(type = v1, values = I(v2))
df

#    type     values
# 1 type1      1.258
# 2 type2          H
# 3 type3 2020-06-19
# 4 type2          L
# 5 type3 2020-04-24
# 6 type1     2.8865

# Set up formatting list
lst <- list()
lst$type1 <- function(x) format(x, digits = 2, nsmall = 1)
lst$type2 <- value(condition(x == "H", "High"),
                   condition(x == "L", "Low"),
                   condition(TRUE, "NA"))
lst$type3 <- function(x) format(x, format = "%y-%m")

# Assign formatting list to values column
attr(df$values, "format") <- lst
attr(df$values, "format_lookup") <- "type"

# Apply formatting
format_dataframe(df)

#    type values
# 1 type1    1.3
# 2 type2   High
# 3 type3  20-06
# 4 type2    Low
# 5 type3  20-04
# 6 type1    2.9


```

## Additional Features

### The `formats()` function
The formats associated with a data frame can be easily extracted or 
assigned with the `formats()` function.  This function returns or accepts 
a named list of formatting objects.  The names of the list items  
correspond to the names of the columns in the data frame.  This function is
useful when you want to assign column formats from metadata.

### The `labels()` and `levels()` functions
The labels associated with a user-defined format object can be extracted
using the `labels()` or `levels()` functions.  These functions will return a 
vector of labels
that have been assigned in each of the conditions, in the order they were 
assigned.  This function is useful
if you wish to create an ordered factor for your data.  You can assign the 
levels property of the `factor()` function to the output of the 
`levels()` or `labels()` function
to keep your data ordered and everything in sync.


