#' A Mayo themed Ioslides Template
#'
#' @param ... reserved for future arguments
#' @return NULL
#' @export

mayoioslides<- function(...) {

  css_vars <- mayotheme::use_mayo_css("color_variables.css")

  base_css <- system.file(
    "rmarkdown/templates/mayo_ioslides/resources/template.css",
    package = "mayodown"
  )

  logo <- mayotheme::use_mayo_logo("black")

  rmarkdown::ioslides_presentation(..., logo = logo, css = c(css_vars, base_css))

}
