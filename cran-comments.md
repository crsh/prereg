# Test environments

* local OS X 10.11 install, R 3.3.1
* local Ubuntu 14.04 install, R 3.3.1
* Ubuntu 12.04 (old release, release, and devel; on travis-ci)
* win-builder (devel and release)

# R CMD check results

There were no ERRORs or WARNINGs but one NOTE:

* Found the following (possibly) invalid URLs:
  URL: http://cos.io/prereg/
    From: README.md
    Status: Error
    Message: libcurl error code 35
    	Unknown SSL protocol error in connection to cos.io:443
  URL: https://cos.io/prereg/
    From: man/prereg.Rd
    Status: Error
    Message: libcurl error code 35
    	Unknown SSL protocol error in connection to cos.io:443

The URL is correct and the web page displays correctly in a web browser.

# Downstream dependencies

There are no downstream dependencies.