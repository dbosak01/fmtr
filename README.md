# fmtr <img src="man/images/mat_star.svg" align="right" height="138" />

<!-- badges: start -->

[![logr version](https://www.r-pkg.org/badges/version/fmtr)](https://cran.r-project.org/package=fmtr)
[![logr lifecycle](https://img.shields.io/badge/lifecycle-stable-blue.svg)](https://cran.r-project.org/package=fmtr)
[![logr downloads](https://cranlogs.r-pkg.org/badges/grand-total/fmtr)](https://cran.r-project.org/package=fmtr)
[![Travis build status](https://travis-ci.com/dbosak01/logr.svg?branch=master)](https://travis-ci.com/dbosak01/fmtr)

<!-- badges: end -->

The **fmtr** package helps format data.  The package aims to replicate
the basic functionality of SAS® formats, but with R data frames.  Formats 
can be attached to data frame columns by assigning them to a **format** 
attribute.  Once formats are assigned, the formatted data can be displayed
using the `format()` function.  When the `format()` function is called,
a new data frame is returned with all the columns formatted as specified
in the **format** attributes.

The functions in the **fmtr** package also work with tidyverse tibbles.

## How to use
Data can be formatted by assigning formats to the **format** attribute
of the columns in your dataframe, and then by calling the `format()` 
function on that data frame.  A sample program is as follows:

```
# Set up data frame
df <- mtcars[1:10, c("mpg", "cyl")]

# Define and assign formats
attr(df$mpg, "format") <- value(condition(x >= 20, "High"),
                                condition(x < 20, "Low"))

attr(df$cyl, "format") <- function(x) {format(x, nsmall = 1)}

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
flexible. 

The formatting for a data frame is applied using the `fapply` function 
included in the **fmtr** package.  This function may also be used 
directly on vectors, independant of the `format` function.

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
the names on the vector correspond to the values in the vector.  The advantage
of using a named vector for formatting is its simplicity.  Here is an 
example of formatting using a named vector:
```
v1 <- c("A", "B", "C", "B")

fmt1 <- c(A = "Label A", B = "Label B", C= "Label C")

fapply(fmt1, v1)

```
#### User-defined formats
The **fmtr** package provides custom functions for creating user-defined 
formats, in a manner that is similar to a SAS® user-defined format.
These functions are `value` and `condition`.
The `value` function accepts one or more conditions.  The `conditions`
function accepts an expression/label pair.  A user-defined format has the 
advantage of a clear and flexible syntax.  It is excellent for categorizing
data.  Here is an example of a user-defined 
formatting function:
```
v1 <- c("A", "B", "C", "B")

fmt3 <- value(condition(x == "A", "Label A"),
              condition(x == "B", "Label B"),
              condition(TRUE, "Other"))
              
fapply(fmt3, v1)

```

#### Vectorized functions
Vectorized functions provide a very flexible and powerful way of formatting 
data.  The vectorized functions can be user-created, or an available packaged
function.  The vectorized function has the advantage of being nearly limitless
in the types of formatting you can perform.  Here is an example of formatting 
using a user-defined, vectorized function:
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

```

#### A formatting list
Sometime data needs to be formatted differently for each row of data.  This 
situation is normally difficult to deal with.  But it can be made easy 
with a formatting list.

A formatting list is a list that contains one or more of the three types
of formatting objects described above.  The `fapply` function applies the
list in two different ways: in order, or with a lookup.  

By default, the 
list is applied in order.  That means, the first format in the list is 
applied to the first item in the vector, the second format in the list is 
applied to the second item in the vector, as so on.  The list is recycled 
if the number of list items is shorter than the number of values in the 
vector.

For the lookup method, the `fapply` function will apply the formatting 
object as specified by a lookup vector.  The lookup vector should contain names 
associated with the elements in the formatting list. The lookup vector should 
also contain the same number of items as the data vector.  For each item
in the data vector, the `fapply` function will look up the approprate format
from the formatting list, and apply that format to corresponding the data value.

The following is an example of a lookup style formatting list:
```
## Coming soon
```

## Additional Features

### Feature 1

### Feature 2

