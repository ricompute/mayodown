#' @title A mayo themed docx format
#' @param mapstyles a named list of style to be replaced in the generated
#' @param header logical; should the Mayo header logo be included?
#' @param contact logical; should the contact section be included?
#' @param greeting logical; should the greeting section be included?
#' @param in_contact Named list of arguments to be included in the contact section.
#'     Can inlude `person`, `department`, `location`, `ext`, and `email`.
#'     These options can be set globaly in .Rprofile.
#' @param in_greeting Named list of arguments to be included in the greeting section.
#'     Can inlude `from`, `to`, and `re`.
#' @param reference_docx Use the specified file as a style reference in producing a docx file.
#'     If left unused, a default template from the mayodown package will be used.
#' @param ... arguments used by \link[rmarkdown]{word_document}
#' @export
mayodocx <- function(mapstyles, header = TRUE, contact = TRUE, greeting = TRUE,
                     in_contact = list(), in_greeting = list(), reference_docx = NA, ...) {

  person <- contact_option("person", in_contact)
  ext <- contact_option("ext", in_contact, pre = "Extension ")
  email <- contact_option("email", in_contact)
  department <- contact_option("department", in_contact)
  location <- contact_option("location", in_contact, pre = "Mayo Clinic, ")

  logo = pkg_resource("resources/images/header.png")

  if (is.na(reference_docx)) {
    reference_docx <- pkg_resource("resources/templates/template.docx")
  }

  output_formats <- rmarkdown::word_document(reference_docx = reference_docx, ...)

  if( missing(mapstyles) )
    mapstyles <- list()

  output_formats$pre_processor = function(metadata, input_file, runtime, knit_meta, files_dir, output_dir){
    md <- readLines(input_file)
    md <- officedown:::chunk_macro(md)
    md <- officedown:::block_macro(md)
    writeLines(md, input_file)
  }

  output_formats$post_processor <- function(metadata, input_file, output_file, clean, verbose) {

    x <- officer::read_docx(output_file)
    x <- officer::body_end_section(x, margins = c(top = NA, bottom = NA, left = NULL, right = NULL))
    x <- officer::cursor_begin(x)

    if (header) {
      x <- officer::body_add_img(x, logo, height = 1.4, width = 6.5, pos = "before")
      x <- officer::body_add_par(x, "")
    }

    if (contact) {
      x <- add_contact_info(x, person)
      x <- add_contact_info(x, department)
      x <- add_contact_info(x, location)
      x <- add_contact_info(x, ext)
      x <- add_contact_info(x, email)
      x <- officer::body_add_par(x, "")
      x <- officer::body_add_fpar(x, bold_regular("Date:   ", format(Sys.Date(), "%B %d, %Y")))
    }

    if (greeting) {
      x <- add_greeting_info(x, "From: ", in_greeting$from)
      x <- add_greeting_info(x, "To:      ", in_greeting$to)
      x <- add_greeting_info(x, "Re:      ", in_greeting$re)
    }

    x <- officedown:::process_images(x)
    x <- officedown:::process_links(x)
    x <- officedown:::process_embedded_docx(x)
    x <- officedown:::process_chunk_style(x)
    x <- officedown:::process_sections(x)
    x <- officedown:::process_par_settings(x)
    x <- officer::change_styles(x, mapstyles = mapstyles)

    print(x, target = output_file)
    output_file
  }

  output_formats
}

pkg_resource = function(...) {
  system.file(..., package = "mayodown")
}

contact_option <- function(x, options, pre = "") {
  if (!is.null(options[[x]])) tmp <- options[[x]]
  else tmp <- getOption(paste("mayodown", x, sep = "."))
  if (!is.null(tmp)) tmp <- paste0(pre, tmp)
  tmp
}

add_contact_info <- function(x, info) {
  print(info)
  if (!is.null(info)) officer::body_add_fpar(x, right_align(info))
  else x
}

add_greeting_info <- function(x, desc, info) {
  if (!is.null(info)) officer::body_add_fpar(x, bold_regular(desc, info))
  else x
}

regular_text <- function() {
  officer::fp_text(font.size = 12, font.family = "Times")
}

bold_regular <- function(b, r) {
  bold <- stats::update(regular_text(), bold = TRUE)
  officer::fpar(officer::ftext(b, prop = bold), officer::ftext(r, regular_text()))
}

right_align <- function(text) {
  officer::fpar(
    officer::ftext(text, regular_text()),
    fp_p = officer::fp_par(text.align = "right") )
}

add_hyperref = function (x, email="", pos = "after") {

  target <- paste0("mailto:", email)

  refID = sprintf("rId%d",x$doc_obj$relationship()$get_next_id())

  x$doc_obj$relationship()$add( refID,
                                type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink",
                                target=target, target_mode="External")

  xml_elt = sprintf("<w:hyperlink r:id='%s' w:history='1'><w:r w:rsidRPr='00CD112F'><w:rPr><w:rStyle w:val='Hyperlink'/></w:rPr><w:t>%s</w:t></w:r></w:hyperlink>",
                    refID,
                    email)

  xml_elt = paste0(officer:::wml_with_ns("w:p"), "<w:pPr><w:jc w:val='right'/></w:pPr>", xml_elt, "</w:p>")

  officer::body_add_xml(x = x, str = xml_elt, pos = pos)
}
