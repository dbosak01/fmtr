# fmtr 1.5.1

* Fixed bug when vector format has no corresponding input value.  Was assigning
  an NA.  Now leaving the original value.
* Added GitHub Actions for prior R version checks.

# fmtr 1.5.0

* Added labels.data.frame() function to assign label attributes of a data frame
* Small documentation fixes

# fmtr 1.4.1

* Added descriptions() attribute assignment functions
* Modified fattr() functions to include description attribute
* Added pkgdown site

# fmtr 1.3.0

* Added functions to convert data frames, tibble, and format catalogs to flist
* Print summarized list of fcat contents 
* Fixed bug on as.fmt() when input data is a tibble
* Added label and description parameters to fattr()
* Added descriptions() function to set descriptions for data frame
* Fixed bug on levels() and labels() functions when formats read from data frame
* Made a few documentation fixes

# fmtr 1.2.2

* Documentation updates/improvements.


# fmtr 1.2.1  

* Improved printing of format catalogs, formats, formatting lists
* Added a `NEWS.md` file to track changes to the package.


# fmtr 1.2.0

* Added fcat() function to create a format catalog
* Added associated utility functions for format catalogs for reading, writing,
printing, and converting from/to data frames
* Fixed bug on fapply() with user-define format, which was throwing an error when
no conditions were met.  Now, values that meet no conditions will fall through
unaltered


# fmtr 1.1.0 

* Added Helper functions for common statistical formatting: fmt_cnt_pct(), 
fmt_range(), fmt_n(), fmt_median(), fmt_mean_sd(), fmt_quantile_rng()
* Added "order" parameter on condition() function to order labels differently
than specified in the value() function
* Made small change to fdata() to not call base format() function unless a
parameter is specifically passed to on "...".


# fmtr 1.0.0 

* Initial version
* Added fapply() to format a vector
* Added fdata() to format an entire data frame/tibble
* Added value() and condition() functions to create a user-defined format
* Added flist() function to create a formatting list
* Added fattr() to assign format information to a vector
* Added formats(), widths(), and justification() functions to assign 
formatting formation to multiple columns in a data frame
* Created package infrastructure, including testthat tests, description file,
readme file, vignette, and man pages
