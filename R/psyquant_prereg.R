#' Preregistration for Quantitative Research in Psychology Template
#'
#' Knit a PDF document based on the Preregistration for Quantitative Research in Psychology Template
#'
#' @param ... additional arguments to \code{\link[rmarkdown]{pdf_document}}; \code{template} is ignored.
#' @examples
#' \dontrun{
#' # Create R Markdown file
#' rmarkdown::draft(
#'   "my_preregistration.Rmd"
#'   , "psyquant_prereg"
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

psyquant_prereg <- function(...) {
  ellipsis <- list(...)
  if(!is.null(ellipsis$template)) ellipsis$template <- NULL

  # Get prereg template
  template <- system.file("rmd", "prereg_form.tex", package = "prereg")
  if(template == "") stop("No LaTeX template file found.") else ellipsis$template <- template

  # Create format
  psyquant_prereg_format <- do.call(rmarkdown::pdf_document, ellipsis)

  ## Overwrite preprocessor to set correct margin and CSL defaults
  saved_files_dir <- NULL

  # Preprocessor functions are adaptations from the RMarkdown package
  # (https://github.com/rstudio/rmarkdown/blob/master/R/pdf_document.R)
  # to ensure right geometry defaults in the absence of user specified values
  pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir) {
    # save files dir (for generating intermediates)
    saved_files_dir <<- files_dir

    args <- pdf_pre_processor(metadata, input_file, runtime, knit_meta, files_dir, output_dir)
    header_includes <- c("\\setlength{\\headheight}{14.0pt}", metadata$`header-includes`)
    args <- c(args, "--variable", paste0("header-includes:", paste(header_includes, collapse = "\n")))
    args
  }

  psyquant_prereg_format$pre_processor <- pre_processor

  psyquant_prereg_format
}
