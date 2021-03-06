##### MANIPULACION Y LIMPIEZA DE DATOS #####


# Utilizaremos la colecci�n de paquetes inclu�dos en el "tidyverse" dise�ados para Ciencia de Datos

#install.packages("tidyverse")
library(tidyverse)



#### Manipulaci�n de Bases de Datos Parte 1

# Creamos un Tibble: Tibbles son Data Frames adaptados al tidyverse mediante el paquete "tibble"

df_ej <- tibble(genero = c("mujer", "hombre", "mujer", "mujer", "hombre"), 
                estatura = c(1.65, 1.80, 1.70, 1.60, 1.67))
df_ej

# Estudiaremos las funciones del paquete "dplyr" para manipular Datos Limpios
#La entrada es un Tibble y la salida es un Tibble


### Filtrar

## Obtiene un subconjunto de las filas de acuerdo a un criterio

filter(df_ej, genero == "mujer")
filter(df_ej, estatura > 1.65 & estatura < 1.75)


### Seleccionar

## Selecciona columnas de acuerdo al nombre

df_ej
select(df_ej, genero)
select(df_ej, -genero) #Elige todas las columnas excepto la llamada "genero"
select(df_ej, starts_with("g")) #Nombre empieza con la letra "g"
select(df_ej, contains("g")) #Nombre contiene la letra "g"


### Arreglar

## Reordena las filas

arrange(df_ej, genero) #Orden alfab�tico
arrange(df_ej, desc(estatura)) #Orden num�rico descendente


### Mutar

## Agrega nuevas variables

mutate(df_ej, estatura_cm = estatura * 100) 
mutate(df_ej, estatura_cm = estatura * 100, estatura_in = estatura_cm * 0.3937) 


### Sumarizados

## Crea nuevas bases de datos con res�menes o agregaciones de los datos originales.

summarise(df_ej, promedio = mean(estatura))

# Podemos hacer res�menes por grupo:
#Primero creamos una base de datos 'agrupada'
by_genero <- group_by(df_ej, genero)
by_genero

#Despu�s operamos sobre cada grupo, creando un resumen a nivel grupo
summarise(by_genero, promedio = mean(estatura))



#### Estableciendo el Directorio de Trabajo (Working Directory (WD))

getwd() #Directorio de Trabajo actual
setwd("C:/Users/lberdicha/Documents/ITAM/Cursos 2017/Otono 2017/Estadistica Computacional/Modulo 2")   #Change WD
getwd() 
dir() #Lista de archivos en el WD



#### Limpieza de Bases de Datos


### 1. Los Encabezados de las Columnas son Valores (Forma Matricial)


## Ejemplo 1: Relaci�n entre Ingreso y Afilici�n Religiosa (Pew Research)

# Cargamos una Tabla de una URL
pew <- read_delim("http://stat405.had.co.nz/data/pew.txt", "\t", 
                  escape_double = FALSE, trim_ws = TRUE)
?read_delim

pew # Esta base tiene como encabezado de columnas el rango de ingresos

# Datos Limpios:
# Utilizamos la funci�n "gather" al data frame "pew" para crear la variable "income" 
#en cuya columna se apilan los nombres de las columnas (rango de ingresos) y creamos 
#la variable "frequancy" en cuya columna se apilan los valores asociados a "income". 
pew_tidy <- gather(data = pew, income, frequency, -religion)
pew_tidy
#Notar que especificamos con un signo "-" la columna que no vamos a apilar
#Notar que "gather" apila las columnas de la 'matriz' de datos original una debajo de la anterior
# �Esta Base de Datos ya tiene la estructura de Datos Limpios!

# Hacemos una gr�fica de Fecuencia vs. Religi�n por Ingreso
ggplot(pew_tidy, aes(x = income, y = frequency, color = religion, group = religion)) +
  geom_line() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Creamos una Nueva Variable: Porcentaje, utilizando la funci�n "group_by"
filter_1 <-  filter(pew_tidy, income != "Don't know/refused") # Filtramos renglones (observaciones) que no hayan especificado el ingreso
filter_1
by_religion <- group_by(filter_1, religion) # Especificamos agrupaci�n para la funci�n "sum" en la nueva variable
by_religion
new_var <- mutate(by_religion, percent = frequency / sum(frequency)) # Creamos la nueva variable "percent"
new_var
pew_tidy_1 <- filter(new_var, sum(frequency) > 1000) # Filtramos Religiones cuyo n�mero total de afiliados sea mayor a 1000

head(pew_tidy_1)

# Alternativamente podemos usar el comando "%>%"
pew_tidy_2 <- pew_tidy %>%
  filter(income != "Don't know/refused") %>%
  group_by(religion) %>%
  mutate(percent = frequency / sum(frequency)) %>% 
  filter(sum(frequency) > 1000)  

head(pew_tidy_2)

# Graficamos 
ggplot(pew_tidy_2, aes(x = income, y = percent, group = religion)) +
  facet_wrap(~ religion, nrow = 1) +
  geom_bar(stat = "identity", fill = "darkgray") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# Ejemplo 2: Datos de Billboard por 75 Semanas

# Cargamos un archivo cuyos valores est�n separados por comas (.csv) del WD
billboard <- read_csv("C:/Users/lberdicha/Documents/ITAM/Cursos 2017/Otono 2017/Estadistica Computacional/Modulo 2/billboard.csv")
#Alternativamente
billboard_1 <- read_csv("billboard.csv")
billboard
# Esta base tiene como encabezado de columnas el n�mero de semana

# Datos Limpios:
# Utilizamos la funci�n "gather" al data frame "billboard" para crear la variable "week" 
#en cuya columna se apilan los nombres de las columnas (n�mero de semana) y creamos 
#la variable "rank" en cuya columna se apilan los valores asociados a "week". 
billboard_long <- gather(billboard, week, rank, wk1:wk76, na.rm = TRUE)
billboard_long
#Notar que especificamos las columnas que s� vamos a apilar "wk1:wk76".
#Notar que eliminamos las observaciones con Valores Faltantes. 

# Realizamos una limpieza adicional creando mejores variables de fecha
billboard_tidy <- billboard_long %>%
  mutate(
    week = parse_number(week),
    date = date.entered + 7 * (week - 1), 
    rank = as.numeric(rank) #cambiamos la clase at�mica de caracter a num�rico
  ) %>%
  select(-date.entered)
billboard_tidy

# Filtramos por algunos valores de "track"
tracks <- filter(billboard_tidy, track %in% 
                   c("Higher", "Amazed", "Kryptonite", "Breathe", "With Arms Wide Open"))

# Graficamos
ggplot(tracks, aes(x = date, y = rank)) +
  geom_line() + 
  facet_wrap(~track, nrow = 1) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


### 2. Una Columna est� Asociada a m�s de una Variable

## Ejemplo: N�meros de Casos de Tuberculosis por Grupo Demogr�fico (Sexo-Edad)

tb <- read_csv("tb.csv")
tb
# Esta base tiene como encabezado de columnas el Grupo Demogr�fico (2 Variables)

# Datos Limpios:
#Primero apilamos las columnas asociadas con la Variable sexo-edad:
tb_long <- gather(tb, sex_age, n, new_sp_m04:new_sp_fu, na.rm = TRUE)
tb_long

# Separamas las dos Variables de la columna Sexo-Edad "sex_age" en dos columnas:
tb_tidy <- separate(tb_long, sex_age, c("sex", "age"), 8)
tb_tidy

# Creamos un mejor c�digo de g�nero
tb_tidy <- mutate(tb_tidy, sex = substr(sex, 8, 8))
tb_tidy

# Alternativamente
tb_tidy_2 <- tb_tidy %>%
  separate(sex, c("temp", "sex"), 7) %>%
  select(-temp)
tb_tidy_2

# Creamos sumarizados de cada Categor�a de la Variable "sex"
table(tb_tidy$sex)


### 3.Variables Almacenadas en Filas y Columnas

## Ejemplo: Clima en Cuernavaca

# Cargamos un archivo .txt del WD (Notar que especificamos el tipo de separador)
clima <- read_delim("clima.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
clima
# Esta base tiene las Variables ("id", "year", "month") en columnas. 
#Las Variables ("TMAX", "TMIN") en renglones. Adem�s tiene como encabezado de 
#columnas los valores de la variable d�a "day".

# Datos Limpios:
#Primero apilamos las columnas asociadas con la Variable d�a:
clima_long <- gather(clima, day, value, d1:d31, na.rm = TRUE)
clima_long
# Notar que la columna "element" no es una Variable, sino que almacena el
#nombre de dos Variables ("TMAX", "TMIN")

# Ordenamos los valores de "element" (no es necesario)
clima_arranged <- arrange(clima_long, element)
clima_arranged

# Aplicamos la funci�n "spread" para desapilar la columna "element"
clima_tidy <- spread(clima_arranged, element, value)
clima_tidy
# Notar que la funci�n "spread" realiza la operaci�n inversa que la funci�n "gather"


### 4. Multiples Unidades Observacionales en una sola Tabla (Separaci�n o Uni�n Horizontal)

# La tabla billboard en formato de Datos Limpios u Organizada (billboard_tidy)
#tiene dos Unidades Observacionales. Veamos por qu�...
billboard_tidy

# Notar que a cada canci�n est� asociada a un artista y una duraci�n.
#Sin embargo, tenemos un ranking de la canci�n por semana.
#Para evitar que en la misma tabla se repitan las variables Artista, A�o y Duraci�n
#de manera redundante, separamos la tabla en dos tablas con diferentes Unidades Observacionales

#i) Artista, Canci�n y Duraci�n (La Variable Canci�n define una Unidad Observacional)
song <- billboard_tidy %>% 
  select(artist, track, year, time) %>% #Artista, A�o y Duraci�n son las caracter�sticas de la canci�n.
  unique() %>% #Eliminamos observaciones repetidas
  arrange(artist) %>% #Ordenamos por artista
  mutate(song_id = row_number(artist)) #Creamos la variable "song_id" para identificar la Unidad Observacional Canci�n y ligarla a la segunda tabla
song

#ii) Ranking de la Canci�n cada Semana (las Variables (Semana, Canci�n (o "song_id")) definen una Unidad Observacional) 
rank <- billboard_tidy %>%
  left_join(song, c("artist", "track", "year", "time")) %>%
  select(song_id, date, week, rank) %>% #Pegamos la nueva Variable "song_id". Fecha y Semana son las caracter�sticas de la Unidad Observacional
  arrange(song_id, date) %>%
  #tbl_df #Si es que es necesario convertir el nuevo Data Frame a formato Tibble
rank

# En resumen: 
# 1) Unidades Observacionales son entidades a las cuales les medimos ciertas caracter�sticas.
# 2) Una Unidad Observacional en una tabla puede estar compuesta de una o m�s Variables. 
# 3) Una tabla de Datos Limpios consta de un solo tipo de Unidad Observacional. 
# 4) La descomposi�n de una tabla en t�rminos de subtablas de Datos Limpios es �nico.
# 5) El almacenamiento de una tabla en t�rminos de las subtablas de Datos Limpios es �ptimo.


### 5. Una Misma Unidad Observacional est� Almacenada en M�ltiples Tablas (Uni�n Vertical)

## Ejemplo: Monitoreo de Contaminaci�n en 332 Ubicaciones de EUA

# Cada archivo contiene informaci�n de una unidad de monitoreo y el n�mero de identificaci�n del
#monitor es el nombre del archivo. Por ejemplo,
spec_1 <- read_csv("specdata/001.csv")
spec_1

# Datos Limpios:
#Primero creamos un vector con los nombres de los archivos (.cvs) en un directorio dentro del WD
paths <- dir("specdata", pattern = "\\.csv$", full.names = TRUE) 
paths

#Despu�s le asignamos el nombre del csv al nombre de cada elemento del vector
paths <- set_names(paths, basename(paths))
paths

#La funci�n "map_df" itera sobre cada direcci�n, lee el .csv en dicha direcci�n y 
#los combina en un Data Frame
specdata_us <- map_df(paths, ~read_csv(., col_types = "Tddi"), .id = "filename")
specdata_us

#Eliminamos la basura del id
specdata <- specdata_us %>%
  mutate(monitor = parse_number(filename)) %>%
  select(id = ID, monitor, date = Date, sulfate, nitrate)
specdata



#### Manipulaci�n de Bases de Datos Parte 2

# Cargamos las siguientes tablas (Tribbles/Data Frames)
flights <- read_csv("flights.csv")
flights
weather <- read_csv("weather.csv")
weather
planes <- read_csv("planes.csv")
planes
airports <- read_csv("airports.csv")
airports




