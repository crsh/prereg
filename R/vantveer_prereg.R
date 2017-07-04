#' van 't Veer & Giner-Sorolla Preregistration template
#'
#' Knit a PDF document using the questions suggested by van 't Veer and Giner-Sorolla (2016) for social
#' psychologists
#'
#' @param ... additional arguments to \code{\link[rmarkdown]{pdf_document}}; \code{template} is ignored.
#' @references
#' van 't Veer, A. E., & Giner-Sorolla, R. (2016). Pre-registration in social psychology---A discussion and
#' suggested template. Journal of Experimental Social Psychology, 67, 2--12. doi:
#' \href{http://dx.doi.org/10.1016/j.jesp.2016.03.004}{10.1016/j.jesp.2016.03.004}
#' @examples
#' \dontrun{
#' # Create R Markdown file
#' rmarkdown::draft(
#'   "my_preregistration.Rmd"
#'   , "vantveer_prereg"
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

vantveer_prereg <- function(...) {
  ellipsis <- list(...)
  if(!is.null(ellipsis$template)) ellipsis$template <- NULL

  # Get vantveer_prereg template
  template <- system.file("rmd", "prereg_form.tex", package = "prereg")
  if(template == "") stop("No LaTeX template file found.") else ellipsis$template <- template

  # Create format
  vantveer_prereg_format <- do.call(rmarkdown::pdf_document, ellipsis)

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

  vantveer_prereg_format$pre_processor <- pre_processor

  vantveer_prereg_format
}


# Crawl OSF JSON

# vantveer <- jsonlite::read_json("https://raw.githubusercontent.com/CenterForOpenScience/osf.io/c932eb477493c194b8fa38d2df69ed3246adf1b6/website/project/metadata/veer-1.json")
#
# cat("<!--", vantveer$pages[[1]]$description, "\n")
#
# for(i in seq_along(vantveer$pages)) {
#   cat("\n\n#", vantveer$pages[[i]]$title, "\n")
#
#   for(j in seq_along(vantveer$pages[[i]]$questions)) {
#     cat(vantveer$pages[[i]]$questions[[j]]$title, "\n")
#
#     if(!is.null(vantveer$pages[[i]]$questions[[j]]$options)) {
#       cat(paste0("**", unlist(vantveer$pages[[i]]$questions[[j]]$options), "**", collapse = "\n"), "\n\n")
#     }
#
#     for(k in seq_along(vantveer$pages[[i]]$questions[[j]]$properties)) {
#       cat("##", vantveer$pages[[i]]$questions[[j]]$properties[[k]]$description, "\n\n")
#
#       for(l in seq_along(vantveer$pages[[i]]$questions[[j]]$properties[[k]]$properties)) {
#         cat("<!--", vantveer$pages[[i]]$questions[[j]]$properties[[k]]$properties[[l]]$description, "-->\n\n")
#       }
#     }
#   }
# }
