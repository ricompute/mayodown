#' A Mayo themed Beamer template
#' @param ... reserved for future arguments
#' @param extra_preamble Additional tex files to include.
#' @return NULL
#' @export
mayobeamer <- function(..., extra_preamble = NULL) {

  template <- system.file(
    "rmarkdown/templates/mayo_beamer/resources/template.tex",
    package = "mayodown"
  )


  preamble <- system.file(
    "rmarkdown/templates/mayo_beamer/resources/preamble.tex",
    package = "mayodown"
  )

  # Create a temp file that we can replace mayotheme contents with
  tmp_preamble <- tempfile(fileext = ".tex")
  file.copy(preamble, tmp_preamble)

  preamble_text <- readLines(tmp_preamble)

  # Color replacements
  blue1 <- gsub("#", "", mayotheme::mayocolors$blue)
  blue2 <- gsub("#", "", mayotheme::mayocolors$brightblue)
  preamble_text <- gsub("MAYOTHEME_BLUE1", blue1, preamble_text)
  preamble_text <- gsub("MAYOTHEME_BLUE2", blue2, preamble_text)

  # Logo replacement
  logo <- mayotheme::use_mayo_logo("black")
  preamble_text <- gsub("MAYOTHEME_LOGO", logo, preamble_text)

  # Write the result
  cat(preamble_text, file = tmp_preamble, sep="\n")

  # Render
  rmarkdown::beamer_presentation(
    ...,
    template=template,
    includes=rmarkdown::includes(in_header = c(tmp_preamble, extra_preamble))
  )

}
