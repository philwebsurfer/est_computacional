library(tidyverse)
setwd("~/Documents/jorge3a/itam/est_computacional/04-Probabilidad/data")
dado <- read.table("dado.csv", header=TRUE, quote='"')
n <- nrow(dado)
table(dado$observado / n)

set.seed(175904)
mediaBoot <- function(x) {
  n <- length(x)
  muestra_boot <- sample(x, size=n, replace = TRUE)
  mean(muestra_boot)
}

thetas_boot <- rerun(1000, mediaBoot(dado$observado)) %>% flatten_dbl()
mean(thetas_boot)

se = function(x) {
  sqrt(sum((x - mean(x)) ^ 2)) / length(x)
}
se(dado$observado)

seMediaBoot <- function(x, B) {
  thetas_boot <- rerun(B, mediaBoot(x)) %>% flatten_dbl()
}

B_muestras <- data_frame(n_sims = c(5, 25, 50, 100, 200, 400, 1000, 1500, 3000)) %>%
   mutate(est = map_dbl(n_sims, ~seMediaBoot(x = dado$observado, B = .)))
B_muestras