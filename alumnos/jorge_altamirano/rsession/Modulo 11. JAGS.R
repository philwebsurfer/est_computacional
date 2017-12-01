##### JAGS #####

library(tidyverse)
#install.packages("R2jags")
library(R2jags)
#install.packages("rjags")
library(rjags)


#### Muestreador de Gibbs (MCMC) con JAGS

### Una Cadena de Markov

## Ejemplo 1: Sesgo de una Moneda (Verosimilitud Bernoulli)

# Distribuciones Iniciales y Verosimilitud
modelo_bb.bugs <-
  '
  model{
  for(i in 1:N){
  x[i] ~ dbern(theta)
  }
  # inicial
  theta ~ dbeta(1, 1)
  }
  '
modelo_bb.bugs

# Datos
n = 20
x <- rbernoulli(n, 0.5)
x

# Valor Inicial del Parámetro: Estimador de Máxima Verosimilitud
theta_init <- sum(x) / n
theta_init

# Valor Inicial del Parámetro: Punto aleatorio alrededor del Estimador de Máxima Verosimilitud
init_theta <- function(){
  x_s <- sample(x, replace = TRUE)
  return(list(theta = sum(x_s) / n)) #Estimador de Máxima Verosimilitud
}
init_theta()

# Llamamos a JAGS para generar la(s) Cadena(s) de Markov (Caminata Aleatoria)
cat(modelo_bb.bugs, file = 'modelo_bb.bugs')

jags_fit <- jags(
  model.file = "modelo_bb.bugs",    # modelo de JAGS
  inits = init_theta,   # valores iniciales
  data = list(x = x, N = n),    # lista con los datos
  parameters.to.save = c("theta"),  # parámetros por guardar
  n.chains = 1,   # número de cadenas
  n.iter = 1000,    # número de pasos
  n.burnin = 500   # calentamiento de la cadena
)

# Resumen del Ajuste
head(jags_fit$BUGSoutput$summary)

# Graficamos la Cadena de Markov 
traceplot(jags_fit, varname = "theta")





# La cadena de Parámetros es
mus <- jags_fit$BUGSoutput$sims.matrix[, 2]
mus
sigmas <- sqrt(jags_fit$BUGSoutput$sims.matrix[, 4])
sigmas

#2) Predicción
y <- rnorm(length(mus), mus[1], sigmas[1])
mean(y)
sd(y)


### Diagnóstico

## Ejemplo: Normal con 3 Cadenas
jags_fit_pred <- jags(
  model.file = "modelo_normal.bugs",    # modelo de JAGS
  inits = jags.inits,   # valores iniciales
  data = list(x = x, N = N),    # lista con los datos
  parameters.to.save = c("mu", "nu", "sigma2"),  # parámetros por guardar
  n.chains = 3,   # número de cadenas
  n.iter = 50,    # número de pasos
  n.burnin = 0,   # calentamiento de la cadena
  n.thin = 1
)

# Podemos ver las cadenas
traceplot(jags_fit_pred, varname = c("mu", "sigma2"))

# Medida de Convergencia de Gelman-Rubin y Número de Simulaciones Efectivo
jags_fit_pred$BUGSoutput$summary


## Ejemplo 3: Verosimilitud Bernoulli con Distribución Inicial Jerárquica

# Distribuciones Iniciales y Verosimilitud
modelo_jer.txt <-
  '
model{
  for(t in 1:N){
    x[t] ~ dbern(theta[coin[t]])
  }
  for(j in 1:nCoins){
    theta[j] ~ dbeta(a, b)
  }
  a <- mu * kappa
  b <- (1 - mu) * kappa
  # A_mu = 2, B_mu = 2
  mu ~ dbeta(2, 2)
  kappa ~ dgamma(1, 0.1)
}
'

# Datos
x <- c(0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1)
coin <- c(rep(1, 5), rep(2, 5), rep(3, 5), rep(4, 5), rep(5, 5))

# Llamamos a JAGS para generar la(s) Cadena(s) de Markov (Caminata Aleatoria)
cat(modelo_jer.txt, file = 'modelo_jer.bugs')

# Valores iniciales para los parámetros
jags.inits <- function(){
  list("mu" = runif(1, 0.1, 0.9),
       "kappa" = runif(1, 5, 20))
}

# Ajustamos el Modelo (Generamos una Cadena de Markov)
jags_fit <- jags(
  model.file = "modelo_jer.bugs",    # modelo de JAGS
  inits = jags.inits,   # valores iniciales
  data = list(x = x, coin = coin, nCoins = 5,  N = 25),    # lista con los datos
  parameters.to.save = c("mu", "kappa", "theta"),  # parámetros por guardar
  n.chains = 3,   # número de cadenas
  n.iter = 10000,    # número de pasos
  n.burnin = 1000   # calentamiento de la cadena
)

#Graficamos la Cadena de Markov para cada Parámetro por separado
traceplot(jags_fit, varname = c("kappa", "mu", "theta"))

# Modelo Ajustado
jags_fit

#1) Estimación
sims_df <- data.frame(n_sim = 1:jags_fit$BUGSoutput$n.sims,
                      jags_fit$BUGSoutput$sims.matrix) %>% 
  dplyr::select(-deviance) %>%
  gather(parametro, value, -n_sim)

ggplot(filter(sims_df, parametro != "kappa"), aes(x = value)) +
  geom_histogram(alpha = 0.8) + facet_wrap(~ parametro)
