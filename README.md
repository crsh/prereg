prereg: R Markdown Template for Preregistrations of Scientific Studies
================

[![CRAN status](http://www.r-pkg.org/badges/version/prereg)](https://cran.r-project.org/web/packages/prereg/index.html) [![Download counter](http://cranlogs.r-pkg.org/badges/prereg)](https://cran.r-project.org/web/packages/prereg/index.html) [![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Build status](https://travis-ci.org/crsh/prereg.svg?branch=master)](https://travis-ci.org/crsh/prereg)

`prereg` provides an [R Markdown](http://rmarkdown.rstudio.com/) template that facilitates authoring preregistrations of scientific studies in PDF format. The template is based on the [Center for Open Science Preregistration Challenge](https://cos.io/prereg/) template and is, thus, particularly suited to draft preregistrations that enter the challenge.

If you experience any problems or have suggestions for improvements, please [open an issue](https://github.com/crsh/prereg/issues).

Setup
-----

### Requirements

To use R Markdown and `prereg` you need the following software on your computer:

-   [R](http://www.r-project.org/) (2.11.1 or later)
-   [RStudio](http://www.rstudio.com/) (0.99.441 or later) is optional; if you don't use RStudio, you need to install [pandoc](http://johnmacfarlane.net/pandoc/) using the [instructions for your operating system](https://github.com/rstudio/rmarkdown/blob/master/PANDOC.md)
-   A [TeX](http://de.wikipedia.org/wiki/TeX) distribution (2013 or later; e.g., [MikTeX](http://miktex.org/) for Windows, [MacTeX](https://tug.org/mactex/) for Mac, obviously, or [TeX Live](http://www.tug.org/texlive/) for Linux)
-   If you are running **Windows**, use MikTex if possible. Currently, pandoc and the Windows version of Tex Live [don't seem to like each other](https://github.com/rstudio/rmarkdown/issues/6). Make sure you install the *complete*---not the basic---version.

### Install prereg

You can install the stable version of `prereg` from CRAN

``` s
install.packages("prereg")
```

or the development version from this GitHub repository (you may have to install the `devtools` package first).

``` s
install.packages("devtools")
devtools::install_github("crsh/prereg")
```

### Create a preregistration document

Once you have installed the `prereg` you can select the template when creating a new R Markdown file through the RStudio menus.

![](https://www.dropbox.com/s/y39lywyloypuncb/template_selection.png?dl=1)

#### Example

`prereg` produces a clean form-like document.

![](https://www.dropbox.com/s/fq6giram61bxe2m/prereg_page1.png?dl=1) ![](https://www.dropbox.com/s/cm64wpnl8la72q0/prereg_page2.png?dl=1)

The template file contains comments, which are invisible in the final PDF document, that provide further details on how to fill in the form.

![](https://www.dropbox.com/s/ylaf6zhxri46w42/prereg_rmd.png?dl=1)

#### Using prereg without RStudio

If you want to use `prereg` without RStudio you can use the `rmarkdown::render` function to create preregistration documents:

``` s
rmarkdown::render("mymanuscript.Rmd")
```
