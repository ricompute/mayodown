#' Create and open a Mayo themed Rmd file
#'
#' Create a Mayo themed Rmd file to render to either word, html or
#'     xaringan::moon_reader.  If the usethis packages is installed and
#'    RStudio is in use, the file will be opened in the text editor.
#'
#' @param name file, or file path, for the generated markdown file.
#' @param overwrite logical; should existing destination files be overwritten?
#' @param blank logical; should a blank word template be used? If false,
#'     If FALSE, a memo format will be used
#' @export
#' @examples
#' \dontrun{
#' use_mayodocx("test_mayodocx", overwrite = TRUE)
#' use_mayohtml("test_mayohtml", overwrite = TRUE)
#' use_mayomoon_reader("test_xaringan", overwrite = TRUE)
#' }

use_mayodocx <- function(name, blank = TRUE,  overwrite = FALSE) {
  temp <- ifelse(blank, "word_blank", "word_memo")
  use_markdown(name = name, template = temp, overwrite = overwrite)
}

#' @export
#' @rdname use_mayodocx
use_mayohtml <- function(name, overwrite = FALSE) {
  use_markdown(name, "html", overwrite)
}

#' @export
#' @rdname use_mayodocx
use_mayomoon_reader <- function(name, overwrite = FALSE) {
  use_markdown(name, "moon_reader", overwrite)
}

use_markdown <- function(name, template, overwrite) {
  name <- gsub("\\.[R|r]md$", "", name)
  name <- paste0(name, ".Rmd")
  template_path <- system.file("rmarkdown/templates", template,
                               "skeleton/skeleton.Rmd", package = "mayodown")
  file.copy(template_path, name, overwrite = overwrite)
  if (requireNamespace("usethis", quietly = TRUE)) {
    usethis::edit_file(name)
  }
}
