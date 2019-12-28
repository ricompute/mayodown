#' @title A mayo themed template for remark.js slides
#' @param nature See ?xaringan::moon_reader
#' @param ... Additional arguments passed to xaringan::moon_reader
#' @export

mayomoon_reader = function(nature =  list(countIncrementalSlides = "no",
                                       highlightLines = "yes",
                                       highlightStyle = "github"), ...) {

  ## Directories for resources
  pkg_resource = function(...) {
    system.file("resources", ..., package = "mayodown")
  }

  css_file <- pkg_resource("css", "mayo_xaringan.css")

  css_files <- mayotheme::use_mayo_css(c("color_variables", "fonts", "tables"))

  # call the base html_document function
  xaringan::moon_reader(
    css = c(css_file, css_files),
    self_contained = TRUE,
    ...
  )


}
