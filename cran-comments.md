## Test environments

* macOS 10.15.7 Catalina, R 4.0.2 (local)
* macOS 10.13.6 High Sierra, R-release, brew (r-hub)
* Ubuntu 16.04.6 Xenial, R-oldrel  (Travis-CI)
* Ubuntu 16.04.6 Xenial, R-release  (Travis-CI)
* Ubuntu 16.04.6 Xenial, R-devel  (Travis-CI)
* Debian Linux, R-devel, GCC (r-hub)
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (r-hub)
* Windows Server 2008, R-oldrel (win-builder)
* Windows Server 2008, R-release (win-builder)

## R CMD check results

0 errors | 0 warnings | 1 note

## Comments

This is a resubmission. Addresses 1 note:

>   Found the following (possibly) invalid URLs:
    URL: https://cos.io/prereg/ (moved to https://www.cos.io/initiatives/prereg)
      From: README.md
      Status: 200
      Message: OK

* Followed moved content

I keep seeing one issue:

> Found the following (possibly) invalid URLs
  
  Found the following (possibly) invalid URLs:
    URL: https://aspredicted.org/
      From: man/prereg.Rd
      Status: 406
      Message: Not Acceptable

But URL is valid.
