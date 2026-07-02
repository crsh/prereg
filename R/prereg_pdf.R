#' Preregistration renderer
#'
#' Knit a PDF document using preregistration document template
#'
#' @param ... additional arguments to \code{\link[rmarkdown]{pdf_document}};
#'   \code{template} is ignored.
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
#' Kirtley, O. J., Lafit, G., Achterhof, R., Hiekkaranta, A. P., & Myin-Germeys, I. (2021). Making the black box transparent: A template and tutorial for registration of studies using experience-sampling methods. Advances in Methods and Practices in Psychological Science, 4(1). \doi{doi:10.1177/2515245920924686}
#' 
#' Spitzer, L. (ed.). (2022). Preregistration Template for Scoping Reviews (based on PRP-QUANT & PRISMA-ScR). ZPID (Leibniz Institute for Psychology). \doi{doi:10.23668/psycharchives.5631}
#' 
#' Van den Akker, O. R., Weston, S., Campbell, L., Chopik, B., Damian, R., Davis-Kean, P., … Bakker, M. (2021). Preregistration of secondary data analysis: A template and tutorial. Meta-Psychology, 5. \doi{doi:10.15626/mp.2020.2625}
#'
#' van 't Veer, A. E., & Giner-Sorolla, R. (2016). Pre-registration in social psychology---A discussion and suggested template. Journal of Experimental Social Psychology, 67, 2--12. doi: \doi{doi:10.1016/j.jesp.2016.03.004}
#'
#' @examples
#' \dontrun{
#' # Create R Markdown file
#' rmarkdown::draft(
#'   "my_preregistration.Rmd"
#'   , "cos_prereg"
#'   , package = "prereg"
#'   , create_dir = FALSE
#'   , edit = FALSE
#' )
#'
#' # Render file
#' rmarkdown::render("my_preregistration.Rmd")
#' }
#'
#' @export

prereg_pdf <- function(...) {
  ellipsis <- list(...)
  if(!is.null(ellipsis$template)) ellipsis$template <- NULL

  # Get cos_prereg template
  template <- system.file("rmd", "prereg_form.tex", package = "prereg")
  if(template == "") stop("No LaTeX template file found.") else ellipsis$template <- template

  # Create format
  prereg_format <- do.call(rmarkdown::pdf_document, ellipsis)

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

  prereg_format$pre_processor <- pre_processor

  prereg_format
}


#' @rdname prereg_pdf
#' @export

aspredicted_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
}

#' @rdname prereg_pdf
#' @export

brandt_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
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

#' @rdname prereg_pdf
#' @export

cos_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
}

#' @rdname prereg_pdf
#' @export

fmri_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
}

#' @rdname prereg_pdf
#' @export

psyquant_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
}

#' @rdname prereg_pdf
#' @export

prp_quant_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
}

#' @rdname prereg_pdf
#' @export

rr_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
}


#' @rdname prereg_pdf
#' @export

vantveer_prereg <- function(...) {
  .Deprecated("prereg_pdf")
  prereg_pdf(...)
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
