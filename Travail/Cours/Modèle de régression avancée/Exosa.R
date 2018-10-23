


# ---------- #
# Chapitre 2 #
# ---------- #


# Exercice 1 #

TV <- c(5,20,8,2)
Ag <- c(8,12,6,4)

reg <- lm(TV ~ Ag)
reg
attributes(reg)
summary(reg)

plot(Ag,TV)
abline(-7,2.1)
plot(reg)
anova(reg)

# Non-rejet de H0... et pas acceptation




# Exercice 2 #

#setwd("C:/Users/Clément/Seafile/Ma bibliothèque/MLG_M2R/Data")
setwd("~/Seafile/Ma Bibliothèque/MLG_M2R/Data")

D <- read.table("proc_pin.dat", col.names=c("Alt","Pente","NbPins","Hauteur","Diam","Densp","Orient.","Hauteurd","Strate","Mel","NbNids"))

NbNids <- D[,11]
LNbNids <- log(D[,11])
Alt <- D[,1]

Data <- data.frame(Alt=Alt,LNbNids=LNbNids)
Data1 <- Data[order(Data[,1],decreasing=FALSE),]

reg1 <- lm(NbNids~Alt)
reg2 <- lm(Data1[,2]~Data1[,1])

plot(reg1)

reg2
attributes(reg2)
plot(reg2)

plot(Alt,LNbNids)
abline(5.9584,-0.005148,col="red")

pred1 <- predict(reg2,interval="confidence")
lines(Data1[,1],pred1[,2],col="blue")
lines(Data1[,1],pred1[,3],col="blue")

pred2 <- predict(reg2,interval="prediction")
lines(Data1[,1],pred2[,2],col="green",lty=2)
lines(Data1[,1],pred2[,3],col="green",lty=2)


# Exercice 3 #

T <- read.table("televisions.dat",col.names=c("Pays","EV","PT","PP","FV","HV"))

plot(T[,3],T[,2])
reg1 <- lm(T[,2]~T[,3])
plot(reg1)

# On tente une transformation des donn?es
LEV <- log(T[,2])
plot(T[,3],LEV)
# Pas convaincant!!

# Une autre 
LTV <- log(T[,3])
EV <- T[,2]
plot(LTV,EV) 

reg2 <- lm(EV~LTV)
reg2
summary(reg2)
abline(77.89,-4.26,col="red")
anova(reg2)

# Corr?lation claire entre nbr de t?l? et esp?rance 
# de vie... Attention, pas de relation de cause ? effet :D
# On peut effectuer un travail similaire avec le nbre
# de physiciens

# Quid d'une diff?rentiation homme/femme? 

FV <- T[,5]
HV <- T[,6]
plot(FV,LTV,col="red")
points(HV,LTV,pch=0,col="blue")

# On retravaille les donn?es pour mettre ne place
# une analyse de covariance

Data <- data.frame(Esp = c(FV,HV), LogT = c(LTV,LTV),Sexe= c(rep(0,38),rep(1,38)))
Data
coplot(Esp ~ LogT|Sexe,Data)
plot(Esp ~ LogT, pch=as.numeric(Sexe),Data)

reg <- lm(Esp ~ LogT*Sexe,Data)
reg
anova(reg)
Anova(reg)   # Avec la librairie car
summary(reg)

# On obtient des résultats similaires quelque soit la décomp. utilisée. 
# On a clairement un effet 'télé'
# On a clairement un effet Sexe : l'espérance de vie moyenne est plus faible 
# pour les hommes que pour les femmes (Types I et II), la durée de vie extrapolée
# pour un nombre d'habitants par télé nul est identique suivant le sexe (N.B ce qui 
# n'a aucun sens ici!)



# Exercice 4

PH <- c(4.94,3.92,3.36,3.93,4.5,4.13,4.18,4.37,5.41,4.82,3.11,2.35,2.90,3.75,3.82,6.06,6.65,7.57,7.58,7.79)
Milieu <-c(rep('1',5),rep('2',5),rep('3',5),rep('4',5))

boxplot(PH~Milieu)

Analyse <- aov(PH~ Milieu)
Analyse
summary(Analyse)
plot(Analyse)
pairwise.t.test(PH,Milieu,p.adjust.method="bonferroni")

# Il y a clairement un effet 'Milieu'



# Exercice 5

PTest <- c(12,6,9,13,12,10,18,8,16,5,9,8,10,4,10,17,9,7)
Test <- c(34,26,33,35,34,33,35,30,37,28,31,30,28,22,24,29,27,22)
Groupe <- c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3)

Psycho <- data.frame(PTest=PTest,Test=Test,Groupe=Groupe)

plot(Test~PTest,pch=as.numeric(Groupe),data=Psycho)

reg <- lm(Test ~ PTest*Groupe,data=Psycho)
summary(reg)
anova(reg)
Anova(reg)


# Quelle que soit la décomposition utilisée, il y a bien un effet 'Pre-test', alors
# que dans le même temps l'interaction n'est pas significative, i.e. rien n'indique
# que l'interaction entre Test et Pré-Test change d'une groupe à l'autre. 
# Par contre, l'effet groupe est significatif pour les décompositions I et II (on 
# compare le niveau moyen du Test extrapolé à un niveau moyen du pré-test), alors 
# qu'il n'y a rien de clair pour le Type III (mais dans ce cas, on extrapole le niveau des 
# Tests pour des niveau de pré-test nuls, ce qui n'a sûrement aucun intérêt ici)


# -------------------------------- #
#          Chapitre 3              #
# -------------------------------- #


# Exercice 2

setwd("~/Seafile/Ma Bibliothèque/MLG_M2R/Data")

D <- read.table("proc_pin.dat", col.names=c("Alt","Pente","NbPins","Hauteur","Diam","Densp","Orient.","Hauteurd","Strate","Mel","NbNids"))
# Passage au log pour améliorer la prédiction
D[,11] <- log(D[,11])


cor(D)
# Certaines variables sont extremements correlees, ce qui peut rendre le diagnostic difficile. 

# Choix de modèle par critère C_p
library(leaps)
Parcelle <- data.frame(D[,1:10])
reg <- leaps(Parcelle,D[,11],nbest=10)
summary(reg)
attributes(reg)

reg$Cp
reg$which
reg$size
plot(reg$size-1,reg$Cp)
t = (reg$Cp==min(reg$Cp))
colnames(Parcelle)[reg$whi[t]]

# On conserve avec ce critére, l'altitude, la pente, la hauteur et le diamètre 


# Choix de modèle par critère AIC
library(car)
library(MASS)
model <- lm(D[,11]~.,Parcelle)
AIC <- stepAIC(model,k=2)
Anova(AIC,type="III")
# Même résultat

# Choix de modèle par critère BIC
BIC <- stepAIC(model,l=log(33))
# Idem




# Exercice 3

Proc <- read.table("procaryotes.dat",header=TRUE)
Proc[1,]
length(Proc[,2])
AA <- data.frame(Proc[,2:19])
AA[1,]
cor(AA)

# Il manque tout un travail de statistique descriptif permettant 
# une prise en main de ce jeu de données. 

reg <- lm(Proc[,21]~.,AA)
summary(reg)


# On commence par une sélection de modèle sans interaction
R <- leaps(AA,Proc[,21],nbest=19)
plot(R$size-1,R$Cp)
t <- (R$Cp==min(R$Cp))
colnames(AA)[R$whi[t]]
# On conserve toutes les variables

# On décide maintenant d'inclure des interactions
regC <- lm(Proc[,21]~.*.,AA)
summary(regC)
# Pour le coup, l'ajustement est bien meilleur... sauf que le modèle est peut-être 
# un peu trop riche. 

# retente un AIC dans ce contexte
# Attention temps de calcul un peu plus important vu le nbre de régresseurs
AIC <-stepAIC(regC,k=2)
summary(AIC)
attributes(AIC)
Anova(AIC,type="III")
# On a élagué, mais encore beaucoup de régresseurs
# On tente un BIC
BIC <- stepAIC(regC,k=log(730))
# On ne conserve "que" 72 régresseurs... soit beaucoup moins que pour le modèle complet
Anova(BIC,type="III")





# ---------------------------- #
#     Chapitre IV              #
# ---------------------------- #

# Exercice 2 (Question 3)

DVie <- c(65,156,100,134,16,108,121,4,39,143,56,26,22,1,1,5,65)
Gblanc <- c(3.36,2.88,3.63,3.41,3.78,4.02,4,4.23,3.73,3.36,2.88,3.63,3.41,3.78,4.02,4,4.23)
plot(Gblanc,DVie)
boxplot(DVie)
boxplot(Gblanc)
glm1 <- glm(DVie ~ Gblanc, family=Gamma("log"))
#NB: on utilise une modélisation par loi Gamma, qui englobe 
# la loi exponentielle -> possible d'affiner ce choix? 

glm1
summary(glm1)
# La variable 'Globule blancs' n'est pas significative ici pour l'explication 
# de la durée de vie. 

# On tente un changement en utilisant la fonction de lien par défaut des lois gamma
glm2 <- glm(DVie~Gblanc,family=Gamma)
summary(glm2)
# Même constat. 


# Exercice 3
P <- read.table("PLASMA.DAT",col.names=c("Fibri","Gamma","Sedim"))
P
P <- P[order(P[,1],decreasing=FALSE),]
plot(P)
cor(P[,2],P[,3])
# A vue de nez, les deux variables explicatives semblent peu corrélées... ce qui se confirme
# en effectuant le calcul. 

# On utilise un modèle glm de type logistique
glm1 <- glm(Sedim ~ Fibri + Gamma,family=binomial,data=P)
summary(glm1)

# La présence de \gamma-glob. semble peu pertinente pour expliquer cette vitesse de 
# sédimentation. 
glm2 <- glm(Sedim ~ Fibri,family=binomial,data=P)
summary(glm2)



# Exercice 4

Abs <- read.table("ozkidsm.dat",col.names=c("comb","groupe","sexe","age","niveau","Nabs"))

boxplot(Nabs~sexe,Abs)
hist(Abs[,6],main=paste(""),xlab="Abs")

# On va modéliser le nombre de jous d'absence pour chaque individu par une loi de Poisson. 
# On utlise la fonction de lien usuelle (log). 
# On commence avec le modèle complet sans interaction

glm1 <- glm(Nabs~groupe+sexe+age+niveau,family=poisson,data=Abs)
summary(glm1)
anova(glm1,test="Chisq")

# Toutes les variables semblent significatives dans ce modèle...
# ... sauf la 'variance résiduelle' (residual deviance) et beaucoup plus grande que le nombre
# de degrés de liberté. Schémtiquement, la variance 'empirique' des variables Y_i est beaucoup
# plus grande que leur moyenne: c'est un problème assez classique dès lors que l'on manipule des 
# lois de Poisson -> on parle dans ce cas d'un phénomène de sur-dispersion. 
# On peut contourner cette problématique en utilisant une approximation de la loi de Poisson 
# faisant intervenir un parmètre de dispersion (=1 si variance = espérance). 

glm2 <- glm(Nabs~groupe+sexe+age+niveau,family=quasipoisson,data=Abs)
summary(glm2)
anova(glm2,test="Chisq")

# Le paramètre de dispersion est clairement différent de 1, il y a bien surdispertion. 
# Avec cette nouvelle modélisation, le sexe et le niveau des étudiants ne sont plus 
# considérés comme statistiquement significatifs pour expliquer le nombre de jours d'absence. 

glm3 <- glm(Nabs~groupe+sexe+age,family=quasipoisson,data=Abs)
summary(glm3)
anova(glm3,test="Chisq")

glm4 <- glm(Nabs~groupe+age,family=quasipoisson,data=Abs)
summary(glm4)
anova(glm4,test="Chisq")

# Le groupe N est typiquement plus absent que l'autre. 
# Par rapport au niveau F0, l'absence diminue dans le groupe F1, avant de remonter 
# dans les groupes F2 (maximal) et F3. 




