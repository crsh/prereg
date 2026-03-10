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
    csl_template <- system.file("rmd", "apa7.csl", package = "prereg")
    if(csl_template == "") stop("No CSL template file found.")
    args <- c(args, c("--csl", rmarkdown::pandoc_path_arg(csl_template)))
  }

  args
}
