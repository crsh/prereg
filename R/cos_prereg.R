#' COS Preregistration Challenge template
#'
#' Knit a PDF document using the COS Preregistration Challenge template
#'
#' @param ... additional arguments to \code{\link[rmarkdown]{pdf_document}}; \code{template} is ignored.
#' @examples
#' \dontrun{
#' # Create R Markdown file
#' rmarkdown::draft(
#'   "my_preregistration.Rmd"
#'   , "cos_prereg"
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

cos_prereg <- function(...) {
  ellipsis <- list(...)
  if(!is.null(ellipsis$template)) ellipsis$template <- NULL

  # Get cos_prereg template
  template <- system.file(
    "rmarkdown", "templates", "cos_prereg", "resources"
    , "cos_prereg.tex"
    , package = "prereg"
  )
  if(template == "") stop("No LaTeX template file found.") else ellipsis$template <- template

  # Create format
  cos_prereg_format <- do.call(rmarkdown::pdf_document, ellipsis)

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

  cos_prereg_format$pre_processor <- pre_processor

  cos_prereg_format
}


# Preprocessor functions are adaptations from the RMarkdown package
# (https://github.com/rstudio/rmarkdown/blob/master/R/pdf_document.R)
# to ensure right geometry defaults in the absence of user specified values

pdf_pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir, output_dir) {
  args <- c()

  # Set margins if no other geometry options specified
  has_geometry <- function(text) {
    length(grep("^geometry:.*$", text)) > 0
  }
  if (!has_geometry(readLines(input_file, warn = FALSE)))
    args <- c(args
      , "--variable", "geometry:left=2.5in"
      , "--variable", "geometry:bottom=1.25in"
      , "--variable", "geometry:top=1.25in"
      , "--variable", "geometry:right=1in"
    )

  # Use APA6 CSL citations template if no other file is supplied
  has_csl <- function(text) {
    length(grep("^csl:.*$", text)) > 0
  }
  if (!has_csl(readLines(input_file, warn = FALSE))) {
    csl_template <- system.file(
      "rmarkdown", "templates", "cos_prereg", "resources"
      , "apa6.csl"
      , package = "prereg"
    )
    if(csl_template == "") stop("No CSL template file found.")
    args <- c(args, c("--csl", rmarkdown::pandoc_path_arg(csl_template)))
  }

  args
}
