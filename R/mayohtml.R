#' @title A mayo themed html format
#' @param toc logical; TRUE to include a table of contents in the output
#' @param toc_float TRUE to float the table of contents to the left
#'     of the main document content.
#' @param toc_depth Depth of headers to include in table of contents
#' @param number_sections logical; TRUE to number section headings
#' @param ... Additional arguments passed to rmarkdown::html_document
#' @param extra_css Additional CSS files to include.
#' @param zoom_img logical; TRUE to enable zooming images on click
#' @export

mayohtml <- function(toc = FALSE, toc_float = TRUE, toc_depth = 6,
                    number_sections = FALSE, ..., extra_css = NULL,
                    zoom_img = FALSE) {

  ## Directories for resources
  pkg_resource <- function(...) {
    system.file("resources", ..., package = "mayodown")
  }

  header <-  htmltools::tagList(
    htmltools::div(class = "topbar"),
    htmltools::img(src = mayotheme::use_mayo_logo("black", data_uri = TRUE),
                   alt = "logo", class = "logo",
                   style = paste0(
                     "width:100px;",
                     "top:10px;",
                     "right:25px;",
                     "padding:10px;",
                     "position:absolute;")
    )
  )

  header_file <- tempfile(fileext = ".html")
  writeLines(as.character(header), header_file)

  if (zoom_img) {
    header_files <- c(header_file,
                      pkg_resource("html", "zoom.html"))
  } else {
    header_files <- header_file
  }

  css_files <- mayotheme::use_mayo_css(c("color_variables", "topbar",
                                         "tables", "bootstrap"))
  css_file <- pkg_resource("css", "styles.css")
  footer <- pkg_resource("html", "footer.html")

  # call the base html_document function
  rmarkdown::html_document(
    toc = toc,
    toc_float = toc_float,
    toc_depth = toc_depth,
    number_sections = number_sections,
    # highlight = "pygments",
    css = c(css_files, css_file, extra_css),
    self_contained = TRUE,
    includes = rmarkdown::includes(
      in_header = header_files,
      after_body = footer
    ),
    ...
  )


}
