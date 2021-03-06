################################################
###    Ciência de dados em software livre    ###
###         http://filipezabala.com          ###
###  https://github.com/filipezabala/cddesl  ###
###            Início: 2020-10-11            ###
###      Última atualização: 2021-07-10      ###
################################################

# Playlist
# https://www.youtube.com/playlist?list=PLgnUrXr7_7coSfm067nFXPvShO18o6GQ_

### Textos
# https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf
# http://r4ds.had.co.nz/
# https://www.curso-r.com/
# https://www.ufrgs.br/wiki-r
# http://www.burns-stat.com/pages/Tutor/R_inferno.pdf
# https://www.amazon.com/ggplot2-Elegant-Graphics-Data-Analysis/dp/331924275X/

### Formulários e resumos
# https://www.rstudio.com/resources/cheatsheets/
# https://www.causascientia.org/math_stat/Dists/Compendium.pdf

### Gráficos
# https://plot.ly/r/
# https://www.r-graph-gallery.com/
# https://github.com/d3/d3/wiki/Gallery
# http://kateto.net/network-visualization
# https://www.shinyapps.org/apps/RGraphCompendium/index.php
# http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html

### Links para a instalação do R e RStudio
# https://cloud.r-project.org/
# https://www.rstudio.com/products/rstudio/download/preview/

### (R) tools
# https://cran.r-project.org/bin/windows/Rtools/
# https://cran.r-project.org/bin/macosx/tools/

### Tópicos
#  0 A primeira seção de R e RStudio
#  1 Funções básicas do R e RStudio
#  2 Objetos e funções úteis
#  3 Criando e manipulando funções
#  4 Manipulando dados com dplyr and tidyr
#  5 Estatística	descritiva, visualização e séries temporais
#  6 Probabilidade
#  7 Cadeias de Markov
#  8 Simulação
#  9 Inferência
# 10 Tópicos em Modelos Lineares Generalizados  <-- 
# 11 Aprendizado de máquina



####################################################
### 10 Tópicos em Modelos Lineares Generalizados ###
####################################################


###
## Modelo de regressao linear simples, lm() com uma unica variavel x
#



# Lendo dados
x <- read.table('http://www.filipezabala.com/data/drinks.txt', header = T)
head(x)

# Descritivas
summary(x)

# Correlacao
plot(x$temp, x$gar)
cor(x$temp, x$gar) # (coeficiente de) correlação (amostral) (de Pearson)
cor.test(x$temp, x$gar)

# Diagnostico
d <- function(modelo){
  print(summary(modelo))
  par(mfrow=c(2,2));plot(modelo, which = 1:4)
  shapiro.test(modelo$residuals)
}

# Modelos
# linear
fit <- lm(gar ~ temp, data = x)
d(fit)
model.matrix(fit)

# linear sem intercepto
fit1 <- lm(gar ~ temp - 1, data = x)   # '+0' tb funciona
d(fit1)
model.matrix(fit1)

 # quadratico incompleto
fit2 <- lm(gar ~ I(temp^2))  # veja ?I e ?formula
d(fit2)

# cubico incompleto
fit3 <- lm(gar ~ I(temp^3))
d(fit3)

# logaritmico
fit4 <- lm(gar ~ log(temp))
d(fit4)

# Graficos
par(mfrow=c(1,1))
plot(temp, gar)
abline(a = fit$coefficients[1], b = fit$coefficients[2],col = 'red')
lines(sort(temp), fitted(fit1)[order(temp)], col='orange', type='l')
lines(sort(temp), fitted(fit2)[order(temp)], col='blue', type='l')
lines(sort(temp), fitted(fit3)[order(temp)], col='green', type='l')
lines(sort(temp), fitted(fit4)[order(temp)], col='black', type='l')

# criterio de Akaike (menor, melhor)
AIC(fit)
AIC(fit1)
AIC(fit2)
AIC(fit3)
AIC(fit4)

# predicao
newdata = data.frame(temp=39)
predict(fit, newdata, interval='predict')
predict(fit1, newdata, interval='predict')
predict(fit2, newdata, interval='predict')
predict(fit3, newdata, interval='predict')
predict(fit4, newdata, interval='predict')


###
## Modelo de regressao linear multipla, lm() com multiplas variaveis x
# Altman (1991) - Practical Statistics for Medical Research, Tabela 12.11, Chapman & Hall.
# https://books.google.com.br/books?hl=en&lr=&id=v-walRnRxWQC&oi=fnd&pg=PR11&dq=Altman+(1991)+-+Practical+Statistics+for+Medical+Research&ots=SxYVFfuo1f&sig=eU6mb7FCjnexAzfzhdS4YVR6StU#v=onepage&q=o'neill&f=false

# lendo dados
cystfibr <- read.table('http://www.filipezabala.com/data/cystfibr.dat', header = T)
summary(cystfibr)

# matriz de dispesao
pairs(cystfibr, gap=0, cex.labels=0.9)

# modelo saturado
fit <- lm(Pemax ~., data = cystfibr)
summary(fit)
par(mfrow=c(2,2)); plot(fit, which = 1:4)
step(fit, trace=2)

# modelo sugerido por step()
fit2 <- lm(Pemax ~ Peso + VEF1 + VR + CRF + TLC, data = cystfibr)
summary(fit2)
par(mfrow=c(2,2));plot(fit1, which = 1:4)

# modelo artesanal
fit3 <- lm(formula = Pemax ~ Peso + VEF1 + VR - 1, data = cystfibr)
summary(fit3)
par(mfrow=c(2,2));plot(fit3, which = 1:4)

# predicao
newdata1 <- with(cystfibr, data.frame(Peso = 13,
                                      VEF1 = 18,
                                      VR = 158))
newdata2 <- with(cystfibr, data.frame(Peso = 74,
                                      VEF1 = 57,
                                      VR = 450))
predict(fit3, newdata1, interval='predict')
predict(fit3, newdata2, interval='predict')


# Exemplo 7.3
# http://filipezabala.com/enrs/modelos-lineares.html#regressão-linear-múltipla

library(readxl)
url1 <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/00242/ENB2012_data.xlsx'
download.file(url1, 'temp.xlsx', mode = 'wb')
energy <- read_excel('temp.xlsx')
str(energy)   # dando uma olhada nas variáveis

# análise exploratória
pairs(energy)
summary(energy)

# modelo saturado
fit <- lm(Y1 ~ ., data = energy[,-10])
summary(fit)

# stepwise
fit2 <- step(fit) # AIC (menor melhor)
summary(fit2)
d(fit2)

# possível ponto infuente 
fit3 <- lm(Y1 ~ X1 + X2 + X3 + X5 + X7 + X8, data = energy[-22,])
summary(fit3)
d(fit3)

?locate


###
## Regressão logística bivariada
# https://mathdept.iut.ac.ir/sites/mathdept.iut.ac.ir/files/AGRESTI.PDF
# https://www.ime.usp.br/~giapaula/texto_2013.pdf
# http://www.utstat.toronto.edu/~brunner/oldclass/2201s11/readings/glmbook.pdf

library(tidyverse)

n <- 20
(y <- c(rep(0,n), rep(1,n)))
set.seed(1); (x1 <- c(rbinom(n,1,.2),rbinom(n,1,.9)))
set.seed(1); (x2 <- rbinom(2*n,1,.5))
x1 <- as.factor(x1)
x2 <- as.factor(x2)
(taby <- table(y))
prop.table(taby)
by(y,x1,table) %>%
  lapply(prop.table)
by(y,x2,table) %>%
  lapply(prop.table)

# modelo 1
fit1 <- glm(y ~ x1, family = 'binomial')
summary(fit1)
(b0 <- fit1$coef[1])
(b1 <- fit1$coef[2])

# x1=0
# π(0) = Pr(Y=1|X1=0)
exp(b0+b1*0)/(1+exp(b0+b1*0))

# x1=1
# π(1) = Pr(Y=1|X1=1)
exp(b0+b1*1)/(1+exp(b0+b1*1))



# modelo 2
fit2 <- glm(y ~ x2, family = 'binomial')
summary(fit2)


###
## Modelo Poisson
#

x <- read.table('http://www.filipezabala.com/data/fraturas.dat',
                header = TRUE)
colnames(x) <- c('numeroFraturas', 'menorDistancia', 'extracaoCarvao',
                 'alturaFendaInf','tempoOpera')
summary(x)

par(mfrow=c(1,1))
boxplot(x)
pairs(x)

fit0 <- glm(numeroFraturas ~ ., data = x,
            family = poisson(link=log))
summary(fit0)
step(fit0)

fit1 <- glm(numeroFraturas ~ menorDistancia + extracaoCarvao +
              tempoOpera, family = poisson(link = log), data = x[-29,])
summary(fit1)
par(mfrow=c(2,2))
plot(fit1,which=1:4)

# predições
summary(x)

# maximizando
newdata1 <- with(x,
                 data.frame(menorDistancia = 11,
                            extracaoCarvao = 90,
                            tempoOpera = 0))
predict(fit1, newdata1, type='response')

# minimizando
newdata2 <- with(x,
                 data.frame(menorDistancia = 900,
                            extracaoCarvao = 50,
                            tempoOpera = 35))
predict(fit1, newdata2, type='response')

