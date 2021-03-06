##### EL AMBIENTE Y EL LENGUAJE DE R #####

### Instalaci�n

# R incluye funciones b�sicas. 
# Se pueden instalar y cargar librer�as que aportan funcionalidades adicionales
install.packages("ggplot2") # Instalar (�nicamente se instala 1 vez)
library(ggplot2) # Cargar (se debe cargar cada que iniciamos una nueva sesi�n)


### Lenguaje 

# Todo en R es un Objeto
# R est� compuesto por 5 clases b�sicas o at�micas de Objetos:
#(Num�rico, Entero, Complejo, L�gico y Simb�lico o Alfanum�rico (Caracter))
# Los Objetos tienen Atributos (Clase, Longitud, Nombre, etc.)
# Combinaciones de Objetos y Atributos forman otros Objetos o 
#Estructuras de Datos (Data Types)


#### R como Software Estad�stico

### Estructuras de Datos (Data Types) y Operaciones Vectorizadas

## Estructura de Datos: Vectores

# Un vector es la estructura de datos b�sica en R. 
#Sus Elementos son de la misma Clase at�mica.
#La excepci�n es que puede contener Objetos NA (Datos Faltantes).
#Los Atributos son Clase y Longitud.
x <- vector("numeric", length = 5) # Vector Nulo
x 
rm(x) # Eliminamos "x" del Ambiente Global
x
x <- c(5, 2, 4.1, 7, 9.2)
x
str(x)
length(x)
class(x)

# Indexaci�n: Extraemos elementos o subvectores
x[2] # Elemento en la posici�n 2
x[c(1,3,4)] # Subvector
x[3] <- 7 # Renombramos el elemento en la posici�n 3
x
x[3] <- 4.1
x

# Vector Secuencial
s_1 <- 1:10 
s_1
s_2 <- seq(0, 1, 0.25)
s_2

# Vector con elementos iguales
y <- rep(10, 5)
y

# Vector de Caracteres
frutas <- c('manzana', 'manzana', 'pera', 'pl�tano', 'fresa')
frutas


## Operaciones Vectorizadas: Elemento por Elemento
#Suma
b <- x + y # Dos Vectores de longitud 5
b
x + 10 # R expande el Vector de longitud 1 "10" a un Vector de longitud 5

#Multiplicaci�n
1:10 + c(3,7,11:18) # Dos Vectores de longitud 10
1:10 * 2 # R expande el Vector "2" a un Vector de longitud 10
1:10 * 1:5 # R expande el Vector de longitud 5 a longitud 10
1:10 * 1:3 # Warning! La longitud del Vector de mayor longitud tiene que ser
           #m�ltiplo de la longitud del Vector de menor longitud 

#Ra�z cuadrada
d <- sqrt(x)
d


## Estructura de Datos: Data Frames 

# Un Data Frame representa datos tabulare (Tabla)
#Cada columna puede ser de diferente Clase At�mica
#Tiene el Atributo "col.names" (Nombre de las Columnas)

# Se puede formar uniendo vectores del mismo tama�o (Longitud)
tabla <- data.frame(n = 1:5, valor = x, fruta = frutas)
tabla

# Podemos cargar un Data Frame (Tabla)
#La librer�a "ggplot2" contiene algunos Data Frames, como "diamonds"
head(diamonds) # Despliega las primeras 6 observaciones del Data Frame "diamonds"
str(diamonds) # Detalla los componentes de "diamonds"

# Indexaci�n (Para manipulaci�n de un subconjunto de datos)
diamonds[1:5, ] # Extrae los primeros 5 renglones (observaciones)
diamonds[1:5, c(2, 4, 6)] # Extrae los primeros 5 renglones y las columnas 2,4,6
diamonds$x # Extrae la columna que se llama "x" como un Vector
diamonds[, "x"] # Extrae la columna que se llama "x" como un Data Frame
diamonds[diamonds$x == diamonds$y, ] # Extrae las observaciones para las que 
                #la variable "x" es igual a la variable "y"
diamonds[-(3:20), ] # Elimina las observaciones 3 a 20
diamonds[ ,c("carat","price")] # Extrae las columnas nombradas


## Estructura de Datos: Datos Faltantes NA
str(NA)
class(NA)
# Operaciones (algebraicas, l�gicas, funciones, etc.) con NA da un objeto NA (se propaga)
5 + NA
NA / 2
NA < 3
NA == 3
NA == NA
sum(c(5, 4, NA))
mean(c(5, 4, NA))

0 / 0 # Resultados matem�ticos indeterminados son NaN. Un NaN es un NA, pero no viceversa

x <- c(1, 2, NA, NaN, 3)
is.na(x) # Prueba si un Objeto es NA
is.nan(x) # Prueba si un Objeto es NaN

# Algunas funciones tienen un argumento na.rm para remover Datos Faltantes 
sum(c(5, 4, NA), na.rm = TRUE)
mean(c(5, 4, NA), na.rm = TRUE)


## Ambiente Interactivo

# Documentaci�n
?mean
help(mean)

# Minimizaci�n de outputs (salidas)
a <- 10 # Se omite la salida
a
print(a)
(a <- 15) # Se imprime la salida

# Herramientas sencillas y flexibles para graficar como parte de R b�sico
qplot(carat, price, data = diamonds, colour = clarity) # �3 Variables!
#En este curso utilizaremos la funci�n "ggplot" de la librer�a "ggplot2" 



#### R como Lenguaje de Programaci�n

## Funciones

# Funci�n "Weighted Mean" con dos variables de entradas (inputs "x", "wt") con una
#variable libre "x" y una variable "wt" con un valor "por default" especificado
wtd_mean <- function(x, wt = rep(1,length(x))){
    sum(x * wt) / sum(wt)
}
wtd_mean(1:10)
wtd_mean(1:10, 10:1)
# Partes de una Funci�n
body(wtd_mean) # 1) Cuerpo (c�digo dentro de la funci�n)
formals(wtd_mean) # 2) Argumentos o Formales (Entradas)
environment(wtd_mean) # 3) Ambiente en el que est� definido la funci�n


## Reglas de B�squeda Lexical (Lexical Scoping Rules)

# Las Variables y Funciones no anidadas que construimos est�n definidas en el 
#Ambiente Global. 
# Cada funci�n constituye un nuevo Ambiente.
# Cada librer�a que cargamos constituye un ambiente independiente del Ambiente Global

environment(ggplot) # Pertenece al Ambiente de la librer�a "ggplot2".

#Funci�n 1
rm(x, y)
x <- 5
f <- function(){
  y <- 10
  c(x = x, y = y) # Salida
}
f()
x # Variable Global: Definida en el Ambiente Global
y # Variable Local: Definida en el Ambiente de la funci�n "f"
rm(x, f) # Elimina los Objetos del Ambiente Global

#Funci�n 2
x <- 5
g <- function(){
  x <- 20 #Variable Local
  y <- 10
  c(x = x, y = y) # Salida
}
g()
x # Valor de la Variable Global

#Funci�n 3
rm(z)
x <- 5
h <- function(){
  y <- 10
  i <- function(){
    z <- 20
    c(x = x, y = y, z = z)
  }
  i() 
}
h() # Funci�n Global: Definida en el Ambiente Global
i() # Funci�n Local: Definida en el Ambiente de la funci�n "h"

#Funci�n 4
rm(a)
j <- function(){
  if (!exists("a")){
    a <- 5
  } else{
    a <- a + 1 
  }
  print(a) 
}
j()
a <- 2
j()

# 5 �qu� regresa k()? �y k()()?
k <- function(){
  x <- 1
  function(){
    y <- 2
    x + y 
  }
}
k() # La Salida es la funci�n interna
k()() # Eval�a las 2 funciones anidadas. Comparar con la Funci�n 3.

# Reglas de B�squeda Lexical: 
#1) Los valores de las Variables Locales se buscan primero en el ambiente definido
#por la funci�n que las llama
#2) Si la funci�n "i" est� definida dentro de otra funci�n "h", y as�
# sucesivamente, el ambiente m�s bajo es la funci�n "i", el siguiente es la 
#funci�n "h", y as� sucesivamente hasta llegar al ambiente m�s alto que es el 
#Ambiente Global.  
#3) R busca las Variables de manera Ascendente en los ambientes.
#4) Ver documentaci�n para m�s detalles y otras reglas de b�squeda lexicales.



##### VISUALIZACI�N #####

## Paquete para Graficar
#install.packages(ggplot2) # S�lo se instala una vez.
#library(ggplot2) # Se carga cada que iniciamos sesi�n


## Cargar Datos

# Un archivo .csv de nuestro equipo
bnames <- read.csv("WD/bnames.csv") # El documento tiene que estar en nuestro WD

# Una tabla precargada en R
?mpg # Data Frame contenido en el paquete "ggplot2"
head(mpg)
str(mpg)

summary(mpg) # Sumarizados Estad�sticos (Estad�stica Descriptiva)


## Gr�ficas de Dispersi�n

# Entradas b�sicas: Base de Datos, 2 Variables (num vs. int), Tipo de Gr�fica
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()
ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy)) # Equivalente

# Caracter�sticas Est�ticas (color, tama�o, forma)
ggplot(mpg, aes(x = displ, y = hwy, color = class)) + geom_point()
#permite visualizar otras variables

# El comando "geom_xxx" define el tipo de gr�fica
p <- ggplot(mpg, aes(x = displ, y = hwy))
p + geom_line() # en este caso no es una buena gr�fica �Por qu�?

# Otras Variables con otroS tipo de gr�ficaS
p <- ggplot(mpg, aes(x = cty, y = hwy)) # (int vs. int)
p + geom_point() 
p + geom_jitter() 

ggplot(mpg, aes(x = class, y = hwy)) + geom_point()

# Reordenamos la variable "class"
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + geom_point()

# Diagrama de Cajas
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + geom_boxplot()

# M�s de un tipo de gr�fica superpuestas, ej. 2 gr�ficas
ggplot(mpg, aes(x = reorder(class, hwy), y = hwy)) + geom_jitter() + geom_boxplot()


## P�neles

# P�neles por categor�a de una tercera variable
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_wrap(~ cyl)

# P�neles horizontales por categor�a de una tercera variable 
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_grid(~ cyl)

# P�neles horizontales y verticales por categor�as de una tercera y cuarta variables
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_grid(cyl ~ class)

# Agegamos un suavizador (Ajustamos una Curva) con el m�todo "loess" (span = 3)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter() +
  facet_wrap(~ cyl) +
  geom_smooth(span = 3)
