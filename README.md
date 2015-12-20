# prereg: Preregister scientific studies using RMarkdown
`prereg` provides an [RMarkdown](http://rmarkdown.rstudio.com/) template that facilitates authoring preregistrations of scientific studies in PDF format. The template is based on the [Center for Open Science Preregistration Challenge](https://cos.io/prereg/) template and is, thus, particularly suited to draft preregistrations that enter the challenge.

If you experience any problems, please [open an issue](https://github.com/crsh/prereg/issues).

## Setup
### Requirements
To use RMarkdown and `prereg` you need the following software on your computer:

- [R](http://www.r-project.org/) (2.11.1 or later)
- [RStudio](http://www.rstudio.com/) (0.99.441 or later) is optional; if you don't use RStudio, you need to install [pandoc](http://johnmacfarlane.net/pandoc/) using the [instructions for your operating system](https://github.com/rstudio/rmarkdown/blob/master/PANDOC.md)
- A [TeX](http://de.wikipedia.org/wiki/TeX) distribution (2013 or later; e.g., [MikTeX](http://miktex.org/) for Windows, [MacTeX](https://tug.org/mactex/) for Mac, obviously, or [TeX Live](http://www.tug.org/texlive/) for Linux)
  - If you are running **Windows**, use MikTex if possible. Currently, pandoc and the Windows version of Tex Live [don't seem to like each other](https://github.com/rstudio/rmarkdown/issues/6). Make sure you install the *complete*---not the basic---version.

### Install prereg
You can nstall `prereg` from this GitHub repository (you may have to install the `devtools` package first):

```S
install.packages("devtools")
devtools::install_github("crsh/prereg")
```

### Create a preregistration document
Once you have installed the `prereg` you can select the template when creating a new Markdown file through the RStudio menus.

#### Using prereg without RStudio
If you want to use `prereg` without RStudio you can use the `rmarkdown::render` function to create preregistration documents:

```S
rmarkdown::render("mymanuscript.Rmd")
```
