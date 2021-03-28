## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, fig.align = "center")

## ----echo = FALSE-------------------------------------------------------------
library(dplyr)
library(ggplot2)

## -----------------------------------------------------------------------------
tibble(
  a = Sys.time() + runif(1e3) * 86400,
  b = Sys.Date() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

## -----------------------------------------------------------------------------
diamonds %>% select(cut, carat, color, clarity) %>% head() %>%  knitr::kable()
