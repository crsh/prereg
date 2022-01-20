#' Crüwell & Evans preregistration for application of cognitive models
#'
#' Knit a PDF document using the Crüwell & Evans preregistration for application
#' of cognitive models
#'
#' @param ... additional arguments to \code{\link[rmarkdown]{pdf_document}}; \code{template} is ignored.
#' @references
#' Crüwell, S. & Evans, N. J. (2021). Preregistration in diverse contexts: a preregistration template for the application of cognitive models. Royal Society Open Science. 8:210155 doi: \url{https://doi.org/10.1016/j.jesp.2013.10.005}
#' @examples
#' \dontrun{
#' # Create R Markdown file
#' rmarkdown::draft(
#'   "my_preregistration.Rmd"
#'   , "cruewell_prereg"
#'   , package = "prereg"
#'   , create_dir = FALSE
#'   , edit = FALSE
#'   )
#'
#' # Render file
#' rmarkdown::render("my_preregistration.Rmd")
#' }
#'
#' @export

cruewell_prereg <- function(...) {
  ellipsis <- list(...)
  if(!is.null(ellipsis$template)) ellipsis$template <- NULL

  # Get cruewell_prereg template
  template <- system.file("rmd", "prereg_form.tex", package = "prereg")
  if(template == "") stop("No LaTeX template file found.") else ellipsis$template <- template

  # Create format
  cruewell_prereg_format <- do.call(rmarkdown::pdf_document, ellipsis)

  ## Overwrite preprocessor to set correct margin and CSL defaults
  saved_files_dir <- NULL

  # Preprocessor functions are adaptations from the RMarkdown package
  # (https://github.com/rstudio/rmarkdown/blob/master/R/pdf_document.R)
  # to ensure right geometry defaults in the absence of user specified values
  pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir) {
    # save files dir (for generating intermediates)
    saved_files_dir <<- files_dir

    pdf_pre_processor(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
  }

  cruewell_prereg_format$pre_processor <- pre_processor

  cruewell_prereg_format
}
