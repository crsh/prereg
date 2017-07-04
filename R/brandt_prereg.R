#' Brandt et al. Replication Recipe Preregistration template
#'
#' Knit a PDF document using the questions suggested by Brandt et al. (2013) 
#'
#' @param ... additional arguments to \code{\link[rmarkdown]{pdf_document}}; \code{template} is ignored.
#' @references
#' Brandt, M. J., IJzerman, H., Dijksterhuis, A., Farach, F. J., Geller, J., Giner-Sorolla, R., ... van 't Veer, A. (2014). The Replication Recipe: What makes for a convincing replication? Journal of Experimental Social Psychology, 50, 217--224. doi: \href{https://doi.org/10.1016/j.jesp.2013.10.005}{10.1016/j.jesp.2013.10.005}
#' @examples
#' \dontrun{
#' # Create R Markdown file
#' rmarkdown::draft(
#'   "my_preregistration.Rmd"
#'   , "brandt_prereg"
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

brandt_prereg <- function(...) {
  ellipsis <- list(...)
  if(!is.null(ellipsis$template)) ellipsis$template <- NULL
  
  # Get brandt_prereg template
  template <- system.file("rmd", "prereg_form.tex", package = "prereg")
  if(template == "") stop("No LaTeX template file found.") else ellipsis$template <- template
  
  # Create format
  brandt_prereg_format <- do.call(rmarkdown::pdf_document, ellipsis)
  
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
  
  brandt_prereg_format$pre_processor <- pre_processor
  
  brandt_prereg_format
}


# Crawl OSF JSON

# brandt <- jsonlite::read_json("https://raw.githubusercontent.com/CenterForOpenScience/osf.io/08a604c550c68c53653bf751ccd0571acc50cab4/website/project/metadata/brandt-prereg-2.json")
# 
# cat("<!--", brandt$description, "\n")
# 
# for(i in seq_along(brandt$pages)) {
#   cat("#", brandt$pages[[i]]$title, "\n\n")
# 
#   for(j in seq_along(brandt$pages[[i]]$questions)) {
#     cat("##", brandt$pages[[i]]$questions[[j]]$nav, "\n")
#     cat("<!--", brandt$pages[[i]]$questions[[j]]$title, "-->\n\n")
# 
#     if(!is.null(brandt$pages[[i]]$questions[[j]]$options)) {
#       cat(paste0("**", unlist(brandt$pages[[i]]$questions[[j]]$options), "**", collapse = "\n"), "\n\n\n")
#     } else {
#       cat("Enter your response here.\n\n\n")
#     }
# 
#     for(k in seq_along(brandt$pages[[i]]$questions[[j]]$properties)) {
#       cat("##", brandt$pages[[i]]$questions[[j]]$properties[[k]]$description, "\n\n")
# 
#       for(l in seq_along(brandt$pages[[i]]$questions[[j]]$properties[[k]]$properties)) {
#         cat("<!--", brandt$pages[[i]]$questions[[j]]$properties[[k]]$properties[[l]]$description, "-->\n\n")
#       }
#     }
#   }
# }
