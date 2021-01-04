<!-- badges: start -->

[![fmtr version](https://www.r-pkg.org/badges/version/fmtr)](https://cran.r-project.org/package=fmtr)
[![fmtr lifecycle](https://img.shields.io/badge/lifecycle-stable-blue.svg)](https://cran.r-project.org/package=fmtr)
[![fmtr downloads](https://cranlogs.r-pkg.org/badges/grand-total/fmtr)](https://cran.r-project.org/package=fmtr)
[![Travis build status](https://travis-ci.com/dbosak01/fmtr.svg?branch=master)](https://travis-ci.com/dbosak01/fmtr)

<!-- badges: end -->

# Introduction to **fmtr**
<img src="man/images/fmtr2.png" align="left" height="138" style="margin-right:10px"/>

R has a variety of ways to format data. There are functions for 
formatting dates, several functions to format numbers, plus you can always 
do a lookup with a named vector, or write your own vectorized function.  Yet
there are several problems with the way R handles formatting.

One problem is that there are *too many* formatting functions.  It is not
easy to remember which functions do what, and the differences between them.
One goal of the **fmtr** package is to consolidate R's formatting capabilities 
into a smaller number of functions.

Another problem is when you want to *reuse* a format. While there are many ways
to format data, there is no mechanism to save a format and reuse it later. 
Therefore, another goal of the **fmtr** package is to promote format reuse. 

A third problem is when you have a complex format that can only be 
accomplished with multiple formatting functions.  It would be nice to 
have a way to keep these multiple formats together, and assign them
all at once.

Finally, there are some formatting activities that are so common, it seems 
like there should be a function for it.  The **fmtr** package also contains
several functions that fall into this category.

### Solution

The **fmtr** package was developed to address the above problems.  The package
addresses those problems in the following ways:

1. **Two formatting functions**:  With **fmtr**, all formatting has been 
consolidated into two formatting functions: `fapply()` and `fdata()`.  `fapply()`
applies a format to a vector.  `fdata()` applies formats to a data
frame or tibble. The implementation of the `fapply()` function is 
reminiscent of a SAS® `put` function.

2. **The format catalog**: The **fmtr** package also introduces the concept
of a *format catalog* to R.  A format catalog is a collection of formats 
that can be saved as a file, shared, and reused. This concept was taken
directly from SAS® software.

3. **User-defined format**: The **fmtr** package also improves on the native R 
formatting capabilities by introducing the concept of a *user-defined format*. 
A user-defined format is an expression-driven lookup.  You can define a set 
of logical expressions that, when true, will return a corresponding lookup 
value. The implementation of the user-defined format is similar to 
a SAS® user-defined format.

4. **The formatting list**: For complicated formats that require more than
one function, the **fmtr** package also introduces the concept of a 
*formatting list*.  A formatting list can perform operations that are difficult
to accomplish otherwise.

5. **Helper and Convenience functions**: Finally, the **fmtr** package contains 
a set of functions to help you with common formatting tasks.
For instance, it has functions to assist 
in assigning formatting attributes to an entire data frame.  It also has
some ready-made functions to perform very common types of statistical 
formatting.

All together, the above capabilities make formatting with the **fmtr** package
both simpler and more powerful.  The reuse features also make R more suitable 
to team programming. 

For additional reading, examples, and a complete function reference, refer to
the **fmtr** documentation site [here](https://fmtr.r-sassy.org/articles/fmtr.html).

### Installation

To install the **fmtr** package, you
may do so by running the following command from your R console:

    install.packages("fmtr")


Then put the following line at the top of your script:

    library(fmtr)

The **fmtr** package will then be loaded, and available for use in your project.

For examples and usage information, please visit the **fmtr**
documentation site [here](https://fmtr.r-sassy.org/articles/fmtr.html).
These examples will demonstrate the 
extraordinary usefulness of the formatting functions, and give you many ideas
on how and where to use the **fmtr** package.

### Getting Help

If you need help with the **fmtr** package, the best place 
to turn to is the [fmtr](https://fmtr.r-sassy.org) web site. 
This web site offers many examples, and full
documentation on every function.  

If you need additional help, please turn 
to [stackoverflow.com](https://stackoverflow.com).  The stackoverflow 
community will be very willing to answer your questions.  

If you want to look at the code for the **fmtr** package, visit the
github page [here](https://github.com/dbosak01/fmtr).

If you encounter a bug or have a feature request, please submit your
issue [here](https://github.com/dbosak01/fmtr/issues)

### See Also

The **fmtr** package is part of the **sassy** meta-package. 
The **sassy** meta-package includes several packages that help make R
easier for SAS® programmers.  You can read more about the **sassy** package
[here](https://sassy.r-sassy.org).

