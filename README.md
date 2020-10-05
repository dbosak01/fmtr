# fmtr <img src="man/images/mat_star.svg" align="right" height="138" />

<!-- badges: start -->

[![fmtr version](https://www.r-pkg.org/badges/version/fmtr)](https://cran.r-project.org/package=fmtr)
[![fmtr lifecycle](https://img.shields.io/badge/lifecycle-stable-blue.svg)](https://cran.r-project.org/package=fmtr)
[![fmtr downloads](https://cranlogs.r-pkg.org/badges/grand-total/fmtr)](https://cran.r-project.org/package=fmtr)
[![Travis build status](https://travis-ci.com/dbosak01/fmtr.svg?branch=master)](https://travis-ci.com/dbosak01/fmtr)

<!-- badges: end -->

The **fmtr** package helps format data.  The package aims to simulate 
the basic functionality of SAS® formats, but with R.  

Formatting may be assigned
to data frame columns using the **format**, **width**, and **justify** 
attributes.  Formatting is then applied by calling the `fdata` function. 
`fdata` returns a new data frame with the specified formatting applied. This 
method of formatting provides much greater control over data formatting
than the base R `format` function.

Here is a example:

```
# Construct data frame from state vectors
df <- data.frame(state = state.abb, area = state.area)[1:10, ]

# Calculate percentages
df$pct <- df$area / sum(state.area) * 100

# Before formatting 
df

#    state   area         pct
# 1     AL  51609  1.42629378
# 2     AK 589757 16.29883824
# 3     AZ 113909  3.14804973
# 4     AR  53104  1.46761040
# 5     CA 158693  4.38572418
# 6     CO 104247  2.88102556
# 7     CT   5009  0.13843139
# 8     DE   2057  0.05684835
# 9     FL  58560  1.61839532
# 10    GA  58876  1.62712846

# Create state name lookup list
name_lookup <- state.name
names(name_lookup) <- state.abb

# Assign formats
formats(df) <- list(state = name_lookup,                         
                    area  = function(x) format(x, big.mark = ","), 
                    pct   = "%.1f%%") 

# Apply formats
fdata(df)

#          state    area   pct
# 1      Alabama  51,609  1.4%
# 2       Alaska 589,757 16.3%
# 3      Arizona 113,909  3.1%
# 4     Arkansas  53,104  1.5%
# 5   California 158,693  4.4%
# 6     Colorado 104,247  2.9%
# 7  Connecticut   5,009  0.1%
# 8     Delaware   2,057  0.1%
# 9      Florida  58,560  1.6%
# 10     Georgia  58,876  1.6%

```
## Key Features

**fmtr** contains the following key features:

* The `fdata` function to apply formatting to any data frame or tibble.
* The `fapply` function to apply formatting to any vector.
* The `formats` and `fattr` functions to easily assign formatting attributes.
* The `value` and `condition` functions to create a new user-defined format.
* The `flist` function to create a formatting list.
* The `fcat` function to create a format catalog \*NEW in v1.2\*.
* A set of formatting helper functions for statistical reports. 

## How to use fdata()
Data can be formatted by assigning formats to the **format** attribute
of the columns in your dataframe or tibble, and then by calling the `fdata()` 
function on that data.  A sample program is as follows:

```
# Set up data frame
df <- mtcars[1:10, c("mpg", "cyl")]
df

# Define and assign formats
attr(df$mpg, "format") <- value(condition(x >= 20, "High"),
                                condition(x < 20, "Low"))

attr(df$cyl, "format") <- function(x) format(x, nsmall = 1)

# Apply formatting
fdata(df)

```

Here is the mtcars subset before formatting:
```
#                    mpg cyl
# Mazda RX4         21.0   6
# Mazda RX4 Wag     21.0   6
# Datsun 710        22.8   4
# Hornet 4 Drive    21.4   6
# Hornet Sportabout 18.7   8
# Valiant           18.1   6
# Duster 360        14.3   8
# Merc 240D         24.4   4
# Merc 230          22.8   4
# Merc 280          19.2   6
```

And here is the mtcars subset after formatting:
```
#                    mpg cyl
# Mazda RX4         High 6.0
# Mazda RX4 Wag     High 6.0
# Datsun 710        High 4.0
# Hornet 4 Drive    High 6.0
# Hornet Sportabout Low  8.0
# Valiant           Low  6.0
# Duster 360        Low  8.0
# Merc 240D         High 4.0
# Merc 230          High 4.0
# Merc 280          Low  6.0

```

You may apply formatting to variables of any data type: character, numeric, 
date, etc. Internally, the `fdata()` function is using the `fapply()`
function on each column in the data frame.  If there is no format assigned
to a column, that column is returned unaltered.

## How to use fapply()

The `fapply()` function applies a format to a vector, factor, or list. 
This function 
may be used independently of the `fdata()` function.  Here is an example:
```
v1 <- c("A", "B", "C", "B")
v1

# [1] "A" "B" "C" "B"

fmt1 <- value(condition(x == "A", "Label A"),
              condition(x == "B", "Label B"),
              condition(TRUE, "Other"))

fapply(v1, fmt1)

# "Label A" "Label B"   "Other" "Label B" 

```
One advantage of using `fapply()` is that your original data is not
altered. The formatted values are assigned to a new object. If your 
original data changes, the formatting function should be reapplied 
to maintain consistency with the original data.

## What kind of formats are available
Data can be formatted with several different types of objects:
  * A formatting string
  * A named vector
  * A user-defined format
  * A vectorized function
  * A formatting list

You can use the type of formatting object that is most suitable to 
your data and situation.  Each type of formatting object has it's own 
strengths and weaknesses.

#### Formatting String
The formatting functions accept formatting strings such as those associated
with the Base R `format` and `sprintf` functions.  If the data type of the 
vector is a date or datetime, `fapply` will use the format codes associated 
with the `format` function.  For other data types, `fapply` will use the format
codes associated with `sprintf`.  Here is an example:
```
v1 <- c(1.367, 8.356, 4.583, 2.873)

fapply(v1, "%.1f%%")

[1] "1.4%" "8.4%" "4.6%" "2.9%"

```

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

fapply(v1, fmt1)

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
v1 <- c("A", "B", NA, "C")

fmt2 <- value(condition(is.na(x), "Missing"),
              condition(x == "A", "Label A"),
              condition(x == "B", "Label B"),
              condition(TRUE, "Other"))
              
fapply(v1, fmt2)

# "Label A" "Label B"   "Missing" "Other" 

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
v1 <- c("A", "B", NA, "C")

fmt2 <- Vectorize(function(x) {
    
    if (is.na(x)) 
      ret <- "Missing"
    else if (x %in% c("A", "B"))
      ret <- paste("Label", x)
    else 
      ret <- "Other"
    
    return(ret)
    
  })
  
fapply(v1, fmt2)

# "Label A" "Label B"   "Missing" "Other" 

```

#### A formatting list
Sometimes data needs to be formatted differently for each row.  This 
situation is difficult to deal with in any language.  
But it can be made easy in R with the **fmtr** package and a formatting list.

A formatting list is a list that contains one or more of the four types
of formatting objects described above.  A formatting list can be applied in 
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
in the data vector, **fmtr** will look up the appropriate format
from the formatting list, and apply that format to the
corresponding data value.

The following is an example of a lookup style formatting list:
```
# Set up data
v1 <- c("num", "char", "date", "char", "date", "num")
v2 <- list(1.258, "H", as.Date("2020-06-19"),
           "L", as.Date("2020-04-24"), 2.8865)

df <- data.frame(type = v1, values = I(v2))
df

#    type     values
# 1   num      1.258
# 2  char          H
# 3  date 2020-06-19
# 4  char          L
# 5  date 2020-04-24
# 6   num     2.8865

# Set up formatting list
lst <- flist(type = "row", lookup = v1,
             num = "%.1f",
             char = value(condition(x == "H", "High"),
                          condition(x == "L", "Low"),
                          condition(TRUE, "NA")),
             date = "%y-%m")

# Assign formatting list to values column
attr(df$values, "format") <- lst


# Apply formatting
fdata(df)

#   type values
# 1  num    1.3
# 2 char   High
# 3 date  20-06
# 4 char    Low
# 5 date  20-04
# 6  num    2.9


```

## Format Catalogs

### The `fcat()` function
As of **fmtr** version 1.2, you can now create a format catalog.  A format
catalog is a collection of formats that can be saved, and shared, and reused.
The format catalog is created with the `fcat()` function.  A format catalog 
can also be converted to and from a data frame using the `as.data.frame()`
and `as.fcat()` functions.  These functions make it easy to store
formatting information as tabular metadata, such as in database tables or 
Excel spreadsheets. Here is an example:
```
# Create format catalog
c1 <- fcat(num_fmt  = "%.1f",
           label_fmt = value(condition(x == "A", "Label A"),
                             condition(x == "B", "Label B"),
                             condition(TRUE, "Other")),
           date_fmt = "%d%b%Y")
 
# Use formats in the catalog
fapply(2, c1$num_fmt)
fapply(c("A", "B", "C", "B"), c1$label_fmt)
fapply(Sys.Date(), c1$date_fmt)

# Convert to a data frame
dat <- as.data.frame(c1)
dat

# Save format catalog for later use
write.fcat(c1, tempdir())

```

## Convenience Functions

### The `formats()` function
The formats associated with a data frame can be easily extracted or 
assigned with the `formats()` function.  This function returns or accepts 
a named list of formatting objects.  The names of the list items  
correspond to the names of the columns in the data frame.  This function is
useful when you want to assign formats to many columns.

### The `fattr()` function
The `fattr()` function helps assign formatting attributes to a vector or
data frame column.  The `fattr()` function can assign the format, width, 
and justify attributes all at once.  These attributes are passed in as
arguments to the `fattr()` function, instead of as properties on a call
to `attr()`.

### Other convenience functions
The `fmtr` package contains several other functions for setting attributes
easily.  These include the `widths` and `justification` functions to set 
columns widths and column justification on an entire data frame.  The package
also includes class testing functions like `is.format` and `is.flist`.

## Formatting Helper Functions

The **fmtr** package also contains several formatting helper functions.  These
functions help with common formatting styles seen in statistical reports.
For example, a range from 1 to 10 is commonly displayed as "1 - 10", with a 
hyphen separating the minimum from the maximum.  To accomplish this formatting
easily, the package provides a `fmt_range()` function that both calculates
the range and formats it in the desired manner.

Below is a complete list of the formatting helper functions.  See the help 
documentation for additional details:

* `fmt_range()`
* `fmt_n()`
* `fmt_quantile_range()`
* `fmt_median()`
* `fmt_cnt_pct()`
* `fmt_mean_sd()`
