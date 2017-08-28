x = vector("numeric", length = 5) #Vector nulo
x
rm(x)
x = c(5,2,4.1,7,9.2)
x
str(x)
print(x)
length(x)
class(x)

#Indexación
x[0]
x[3]

x[1:4]
x[c(1,3,4)]
x +1 
x=1:5
y=7:10
x
y

#dataframes
table1 = data.frame(n = 1:5, fruta = c("fresa", "mango", "maracuya", "aguacate", "piña"), equis = x)
table1

#ggplot2
library(ggplot2)
head(diamonds)
tail(diamonds)
str(diamonds)
str(diamonds["cut"])
y=6:10
x%*%y
x
y
cut1=data.frame(diamonds$cut) #extrae dataframe
cut1=diamonds[,"cut"] #extrae dataframe
diamonds[-(1:100),] #elimina los registros del 1 al 100

#datos faltantes
str(NA) #cuando no está informada o reportada
NA+0
NA/2
sum(c(1,2,3))
sum(c(1,2,NA))
median(c(5,3,8,9,NA))
0/0
z = c(0, 1, 2, NA, NaN, 3)
is.na(z)
is.nan(z)

#algunas funciones tienen un argumento na.rm para remover datos faltantes
sum(z, na.rm = TRUE)
mean(z, na.rm=TRUE)
z

#documentación
?mean
help(mean)

#Visualización de 3 variables
qplot(carat, price, data = diamonds, color=clarity)

#Funciones de programación
## weighted mean
wtd_mean = function(x, wt = rep(1, length(x))) {
  sum(x*wt)
}
wtd_mean(1:10, 5)

#Partes de una función
body(wtd_mean) # código
formals(wtd_mean) #argumentos o formales
environment(wtd_mean) #ambiente

#variables globales y locales
x = 5
f = function() {
  x = 10
  c(x,y)
}
f()
x

qplot(carat, price, data = diamonds, color=cut)
qplot(x=displ,y=cty,data=mpg,color=manufacturer)

# Reglas de búsqueda lexical
#1. variables libres se buscan primero
#2. la función  lexical scoping rules 

#ggplot
summary(mpg)
librar
ggplot(mpg,aes(x=displ,y=cty,color=hwy)) + geom_dotplot()
