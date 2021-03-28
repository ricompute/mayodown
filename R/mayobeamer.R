#' A Mayo themed Beamer template
#' @param ... reserved for future arguments
#' @return NULL
#' @export
mayobeamer <- function(...) {

  template <- system.file(
    "rmarkdown/templates/mayo_beamer/resources/template.tex",
    package = "mayodown"
  )

  preamble <- system.file(
    "rmarkdown/templates/mayo_beamer/resources/preamble.tex",
    package = "mayodown"
  )

  rmarkdown::beamer_presentation(
    ...,
    template=template,
    includes=rmarkdown::includes(in_header = preamble)
  )

}
