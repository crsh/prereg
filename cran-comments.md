## Test environments
* local OS X 10.11 install, R 3.2.3
* local Ubuntu 14.04 install, R 3.2.3
* Ubuntu 12.04 (on travis-ci), R 3.2.3
* win-builder (devel and release)

## R CMD check results
There were no ERRORs and WARNINGs.

There was 1 NOTE:

* Maintainer: 'Frederik Aust <frederik.aust@uni-koeln.de>'
  New submission

## Downstream dependencies
This is the first submission of prereg; there are no downstream
dependencies.

## Resubmission
This is a resubmission. In this version I have:

* Removed 'prereg' and 'preregistrations' from DESCRIPTION
  (sorry for the confusion)
* Added example and package documentation (?prereg)
* Changed the term 'RMarkdown' in DESCRIPTION to 'R Markdown'
  in accordance with the spelling used in, e.g., the rmarkdown
  package