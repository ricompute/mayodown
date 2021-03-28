#' A Mayo themed Ioslides Template
#'
#' @param ... reserved for future arguments
#' @return NULL
#' @export

mayoioslides<- function(...) {

  css <- system.file(
    "rmarkdown/templates/mayo_ioslides/resources/template.css",
    package = "mayodown"
  )

  rmarkdown::ioslides_presentation(..., css = css)

}
