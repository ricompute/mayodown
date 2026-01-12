#' @title A Mayo-themed HTML format
#' @param mayo_footer logical; `TRUE` to include the Mayo copyright footer
#' @param toc logical; `TRUE` to include a table of contents in the output
#' @param toc_float `TRUE` to float the table of contents to the left
#'     of the main document content.
#' @param toc_depth Depth of headers to include in table of contents
#' @param number_sections logical; `TRUE` to number section headings
#' @param extra_css Additional CSS files to include.
#' @param zoom_img logical; `TRUE` to enable zooming images on click
#' @param self_contained logical; `TRUE` to create a self-contained HTML document
#' @param highlight Syntax highlight engine and style. Defaults to "tango"
#' @param ... Additional arguments passed to [rmarkdown::html_document()]
#' @export

mayohtml <- function(mayo_footer = TRUE, toc = TRUE, toc_float = TRUE,
                     toc_depth = 6, number_sections = TRUE, extra_css = NULL,
                    zoom_img = TRUE, self_contained = TRUE,
                    highlight = "tango", ...) {

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

  if (mayo_footer) {
  footer <- htmltools::tags$div(
    class = "footerholder",
    htmltools::tags$footer(
      class = "footer",
      htmltools::tags$hr(),
      htmltools::tags$div(
        class = "row",
        htmltools::tags$div(
          class="col-md-12", align="center",
          htmltools::tags$small(
            class = "text-muted",
            paste0("© 1998–",
                   format(Sys.Date(), "%Y"),
                   " Mayo Foundation for Medical Education and Research. All rights reserved.")
          ),
          htmltools::tags$br(),
          htmltools::tags$small(
            class = "text-muted",
            "Proprietary and confidential. Do not distribute."
          )
        )
      )))} else {
        footer <- NULL
      }
  footer_file <- tempfile(fileext = ".html")
  writeLines(as.character(footer), footer_file)

  # Add Lua filter to allow colored text
  lua_filter <-  rmarkdown::pandoc_lua_filter_args(
    system.file("pandoc", "color-text.lua", package = "mayodown")
  )

  # call the base html_document function
  rmarkdown::html_document(
    toc = toc,
    toc_float = toc_float,
    toc_depth = toc_depth,
    number_sections = number_sections,
    highlight = highlight,
    css = c(css_files, css_file, extra_css),
    self_contained = self_contained,
    includes = rmarkdown::includes(
      in_header = header_files,
      after_body = footer_file
    ),
    pandoc_args = lua_filter,
    ...
  )


}
