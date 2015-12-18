#' COS Preregistration Challenge template

#' Knit a PDF document
#'
#' @param ... additional arguments to \code{rmarkdown::pdf_document}
#' @export

cos_prereg <- function(...) {
  # Get cos_prereg template
  template <-  system.file(
    "rmarkdown", "templates", "cos_prereg", "resources"
    , "cos_prereg.tex"
    , package = "prereg"
  )
  if(template == "") stop("No LaTeX template file found.")

  rmarkdown::pdf_document(template = template, ...)
}