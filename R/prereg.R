#' R Markdown Templates to Preregister Scientific Studies
#'
#' @description This package provides a collection of preregistration templates for empirical scientific studies.
#'
#' @section System requirements:
#' **prereg** depends on additional software, namely,
#'
#' 1. [R](https://www.R-project.org/) 2.11.1 or later and
#' 2. [pandoc](https://pandoc.org/) 1.19 or later
#' 3. [TeX](https://en.wikipedia.org/wiki/TeX) 2013 or later.
#'
#' If you work with [RStudio](https://www.rstudio.com/) (1.1.453 or later) pandoc should already be installed, otherwise refer to the [installation instructions](https://pandoc.org/installing.html) for your operating system.
#'
#' **prereg** can be used with common TeX distributions, such as [MikTeX](http://miktex.org/) on Windows, [MacTeX](https://tug.org/mactex/) on Mac, or [TeX Live](http://www.tug.org/texlive/) on Linux.
#'
#' If you mainly use TeX to render R Markdown documents, we strongly recommend using the [TinyTex](https://yihui.org/tinytex/) distribution.
#' It is lightweight and automatically installs missing LaTeX packages and can be installed from within R with \code{tinytex::install_tinytex()}.
#'
#' @section Author and Maintainer:
#'    Frederik Aust (frederik.aust at uni-koeln.de).
#' @references
#' Bosnjak, M., Fiebach, C. J., Mellor, D., Mueller, S., O'Connor, D. B., Oswald, F. L., & Sokol, R. I. (2022). A template for preregistration of quantitative research in psychology: Report of the joint psychological societies preregistration task force. American Psychologist, 77(4), 602–615. \doi{doi:10.1037/amp0000879}
#'
#' Brandt, M. J., IJzerman, H., Dijksterhuis, A., Farach, F. J., Geller, J., Giner-Sorolla, R., ... van 't Veer, A. (2014). The Replication Recipe: What makes for a convincing replication? Journal of Experimental Social Psychology, 50, 217--224. doi: \doi{doi:10.1016/j.jesp.2013.10.005}
#'
#' Crüwell, S. & Evans, N. J. (2021). Preregistration in diverse contexts: a preregistration template for the application of cognitive models. Royal Society Open Science. 8:210155. \doi{doi:10.1016/j.jesp.2013.10.005}
#'
#' Flannery, J. E. (2020, October 22). fMRI Preregistration Template. Retrieved from \url{https://osf.io/6juft}
#'
#' Haven, T. L., Errington, T. M., Gleditsch, K. S., van Grootel, L., Jacobs, A. M., Kern, F. G., ... Mokkink, L. B. (2020). Preregistering qualitative research: A Delphi study. International Journal of Qualitative Methods, 19. \doi{doi:10.1177/1609406920976417} 
#' 
#' Jenke, L., & Sullivan, N. J. (2024). Eye Tracking Preregistration Template. PsyArXiv. \doi{doi:10.31234/osf.io/yvfeq}#' 
#' 
#' Kirtley, O. J., Lafit, G., Achterhof, R., Hiekkaranta, A. P., & Myin-Germeys, I. (2021). Making the black box transparent: A template and tutorial for registration of studies using experience-sampling methods. Advances in Methods and Practices in Psychological Science, 4(1). \doi{doi:10.1177/2515245920924686}
#' 
#' Spitzer, L. (ed.). (2022). Preregistration Template for Scoping Reviews (based on PRP-QUANT & PRISMA-ScR). ZPID (Leibniz Institute for Psychology). \doi{doi:10.23668/psycharchives.5631}
#' 
#' Van den Akker, O. R., Weston, S., Campbell, L., Chopik, B., Damian, R., Davis-Kean, P., … Bakker, M. (2021). Preregistration of secondary data analysis: A template and tutorial. Meta-Psychology, 5. \doi{doi:10.15626/mp.2020.2625}
#'
#' van 't Veer, A. E., & Giner-Sorolla, R. (2016). Pre-registration in social psychology---A discussion and suggested template. Journal of Experimental Social Psychology, 67, 2--12. doi: \doi{doi:10.1016/j.jesp.2016.03.004}
#' @docType package
#' @name prereg

"_PACKAGE"
