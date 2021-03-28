#' @title A mayo themed docx format
#' @description Format for converting from R Markdown to MS Word
#'     based on \link[officedown]{rdocx_document}.
#' @param ... arguments used by \link[rmarkdown]{word_document}
#' @export
mayodocx <- function(...) {

  ref_doc <- system.file(
    "resources/templates/template.docx",
    package = "mayodown"
  )

  tables <- list(
    style = "Plain Table 31",
    layout = "autofit",
    width = 1,
    caption = list(style = "Table Caption", pre = "Table ", sep = ": "),
    conditional = list(
      first_row = TRUE, first_column = FALSE, last_row = FALSE,
      last_column = FALSE, no_hband = FALSE, no_vband = TRUE
    )
  )

  plots <- list(
    style = "Normal",
    align = "center",
    caption = list(
      style = "Image Caption",
      pre = "Figure ",
      sep = ": "
    )
  )

  officedown::rdocx_document(
    reference_docx = ref_doc,
    tables = tables,
    plots = plots,
    ...
  )

}
