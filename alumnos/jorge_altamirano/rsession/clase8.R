library(ggplot2)
library(plotly)
library(purrr)
library(dplyr)

set.seed(918739837)
muestra_ninas <-rbinom(1000,400,.488)
mean(muestra_ninas)
sd(muestra_ninas)

sims_ninas <- rerun(1000, rbinom(1,400, 0.488)) %>% flatten_dbl()
graph_1 <- ggplot() + geom_histogram(aes(x=sims_ninas), binwidth = 3)
ggplotly(graph_1)
mean(sims_ninas)
sd(sims_ninas)

tipo_nacimiento <- sample(c("unico", "fraternal", "identicos"), size = 400,
                          replace = T,
                          prob = c(1- 1/125 - 1/300, 1/125, 1/300))
summary(as.factor(tipo_nacimiento))
 
vector_mu <- c(rep(78+12,30), rep(78, 20))
vector_mu

y <- rnorm(50, vector_mu, 20)
y
qplot(y)
mean(y)

sims_y <- rerun(2000, rnorm(50, vector_mu, 20))
medias <- sims_y %>% map_dbl(mean)
qplot(medias, geom = "histogram", binwidth = 1.5)
quantile(medias, c(0.025, .1, .25, .5, .75, .9, .975))

rchisq(1, 432)

glimpse(airports)
(airports$lat) %>% sum
(airports$lat) %>% map_dbl(sum)
dim(airports[c("lat","long")])
airports[c("lat","long")] %>% map_dbl(mean)


optim()