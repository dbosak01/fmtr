# fmtr 1.5.8

* Fixed bug on `fapply()` that was causing it to pick up and apply
haven format attributes. 
* Added `fapply2()` function to format and combine two variables.
* Added `na` and `zero` parameters to `fmt_cnt_pct()` to apply specified string 
in cases where the count is NA or zero.  

# fmtr 1.5.7

* Fixed `fapply()` so that NA values in data are returned as NA instead of 
a string "NA".

# fmtr 1.5.5

* Fixed bug in `as.fmt.data.frame()` that was converting all label and order
values to character. Now it will return the stored data type.
* Added **sd_format** parameter to the `fmt_mean_sd()` function to format the 
standard deviation separately if desired.
* Documentation fixes/updates.

# fmtr 1.5.4

* Added FAQ and Complete Example to vignettes.
* Took out errors on convenience functions if data frame does not have a variable
specified on the incoming list.  Now this situation is ignored, and no error
is generated. The error was removed to allow the list to contain more 
formats/labels/etc. than exist on the data frame, but still assign the matching
items.

# fmtr 1.5.3

* Added covr and codecov.
* Allow assignment of NULL to convenience functions to clear attributes.
* Update examples and documentation for convenience functions.

# fmtr 1.5.2

* Fixed bug on R 3.6 where `fdata()` function was turning all columns into factors.
* Changed fapply() function so it will accept non-character vector formats.  Now
works with integer, numeric, and date vectors also.


# fmtr 1.5.1

* Fixed bug when vector format has no corresponding input value.  Was assigning
  an NA.  Now leaving the original value.
* Made code compatible back to R version 3.6.0
* Added GitHub Actions for prior R version checks

# fmtr 1.5.0

* Added `labels.data.frame()` function to assign label attributes of a data frame
* Small documentation fixes

# fmtr 1.4.1

* Added `descriptions()` attribute assignment functions
* Modified `fattr()` functions to include description attribute
* Added pkgdown site

# fmtr 1.3.0

* Added functions to convert data frames, tibble, and format catalogs to flist
* Print summarized list of fcat contents 
* Fixed bug on `as.fmt()` when input data is a tibble
* Added label and description parameters to fattr()
* Added `descriptions()` function to set descriptions for data frame
* Fixed bug on `levels()` and `labels()` functions when formats read from data frame
* Made a few documentation fixes

# fmtr 1.2.2

* Documentation updates/improvements.


# fmtr 1.2.1  

* Improved printing of format catalogs, formats, formatting lists
* Added a `NEWS.md` file to track changes to the package.


# fmtr 1.2.0

* Added `fcat()` function to create a format catalog
* Added associated utility functions for format catalogs for reading, writing,
printing, and converting from/to data frames
* Fixed bug on `fapply()` with user-define format, which was throwing an error when
no conditions were met.  Now, values that meet no conditions will fall through
unaltered


# fmtr 1.1.0 

* Added Helper functions for common statistical formatting: `fmt_cnt_pct()`, 
`fmt_range()`, `fmt_n()`, `fmt_median()`, `fmt_mean_sd()`, `fmt_quantile_rng()`
* Added "order" parameter on `condition()` function to order labels differently
than specified in the `value()` function
* Made small change to `fdata()` to not call base `format()` function unless a
parameter is specifically passed to on "..."


# fmtr 1.0.0 

* Initial version
* Added `fapply()` to format a vector
* Added `fdata()` to format an entire data frame/tibble
* Added `value()` and condition() functions to create a user-defined format
* Added `flist()` function to create a formatting list
* Added `fattr()` to assign format information to a vector
* Added `formats()`, `widths()`, and `justification()` functions to assign 
formatting formation to multiple columns in a data frame
* Created package infrastructure, including testthat tests, description file,
readme file, vignette, and man pages
