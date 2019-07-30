#' Registered Reports template
#'
#' Knit a PDF document for preregistration of Stage 1 Registered Reports
#'
#' @param ... additional arguments to \code{\link[rmarkdown]{pdf_document}}; \code{template} is ignored.
#' @examples
#' \dontrun{
#' # Create R Markdown file
#' rmarkdown::draft(
#'   "my_preregistration.Rmd"
#'   , "rr_prereg"
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

rr_prereg <- function(...) {
  ellipsis <- list(...)
  if(!is.null(ellipsis$template)) ellipsis$template <- NULL

  # Get cos_prereg template
  template <- system.file("rmd", "prereg_form.tex", package = "prereg")
  if(template == "") stop("No LaTeX template file found.") else ellipsis$template <- template

  # Create format
  rr_prereg_format <- do.call(rmarkdown::pdf_document, ellipsis)

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

  rr_prereg_format$pre_processor <- pre_processor

  rr_prereg_format
}
