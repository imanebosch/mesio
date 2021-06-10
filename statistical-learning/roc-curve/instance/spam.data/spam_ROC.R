# Practice on ROC and AUC
# 1. Usa el script {\tt spam.R} para leer los datos de la SPAM e-mail database.

# SPAM E-mail Database
# downloaded from 
# http://web.stanford.edu/~hastie/ElemStatLearn/datasets/spam.info.txt
# http://web.stanford.edu/~hastie/ElemStatLearn/datasets/spam.data
# http://web.stanford.edu/~hastie/ElemStatLearn/datasets/spam.traintest
# 03-05-2016
#
# 
# 
spam <- read.table("spambase/spambase.data",sep=",")

spam.names <- c(read.table("spambase/spambase.names",sep=":",skip=33,nrows=53,as.is=TRUE)[,1],
                "char_freq_#",
                read.table("spambase/spambase.names",sep=":",skip=87,nrows=3,as.is=TRUE)[,1],
                "spam.01")

names(spam) <- spam.names 

n<-dim(spam)[1]
p<-dim(spam)[2]-1

spam.01 <- spam[,p+1]
spam.vars <- as.matrix(spam[,1:p])

cat(paste("n = ",n,', p = ',p,sep=""))
cat(paste("Proportion of spam e-mails =",round(mean(spam.01),2),sep=""))

glm.spam <- glm(spam.01 ~ spam.vars,family=binomial)
summary(glm.spam)

# 2. Separa un tercio de los datos para construir una muestra test. 
# Hazlo de forma que la formen un tercio de los e-mails marcados como SPAM, 
# y un tercio de los marcadados como NO SPAM. 
# El resto de los datos formarán la muestra de entrenamiento.
set.seed(1234)

spam.1 <- which(spam.01==1)
spam.0 <- which(spam.01==0)
n1 <- length(spam.1)
n0 <- length(spam.0)

spam.1.tr <- sort(sample(spam.1, round(2*n1/3)))
spam.0.tr <- sort(sample(spam.0, round(2*n0/3)))

spam.1.test <- setdiff(spam.1,spam.1.tr)
spam.0.test <- setdiff(spam.0,spam.0.tr)

spam.tr <- union(spam.1.tr,spam.0.tr)
spam.test <- union(spam.1.test,spam.0.test)

n.tr <- length(spam.tr)
n.test <- length(spam.test)

# 3. Compararemos el comportamiento de 3 reglas discriminantes: 
### a. Regresión logística estimada por máxima verosimilitud (IRWLS, {\tt glm}).
### b. Regresión logística estimada mediante Lasso ({\tt glment}).
### %c. Red neuronal ({\tt nnet})
### c. k-nn ({\tt knn} and {\tt knn.cv} from package {\tt})
# Usa la muestra de entrenamiento para fijar los {\em tunning parameters} y para estimar los parámetros de los diferentes métodos. 

### a. Regresión logística estimada por máxima verosimilitud (IRWLS, {\tt glm}).
glm.spam.tr <- glm(spam.01 ~ . , data=spam, subset=spam.tr, family=binomial)
summary(glm.spam.tr)

### b. Regresión logística estimada mediante Lasso ({\tt glment}).

### %c. Red neuronal ({\tt nnet})
### c. k-nn ({\tt knn} and {\tt knn.cv} from package {\tt class})

# 4. Usa la muestra test para construir (y dibujar) la curva ROC y calcular la AUC para cada una de estas reglas.

### a. Regresión logística estimada por máxima verosimilitud (IRWLS, {\tt glm}).
pred.glm.spam.test <- predict(glm.spam.tr, newdata = spam[spam.test,], type="response")

boxplot(pred.glm.spam.test ~ spam$spam.01[spam.test])
table( spam$spam.01[spam.test], pred.glm.spam.test>.5 )

library(pROC)
roc(spam$spam.01[spam.test] ~ pred.glm.spam.test, plot=TRUE)
roc(spam$spam.01[spam.test] ~ pred.glm.spam.test, smooth=TRUE, plot=TRUE, add=TRUE, col=4)

library(ROC632)
J <- 201
cut.points <- (0:J)/J
ROC.obj <- ROC(status=spam$spam.01[spam.test], marker=pred.glm.spam.test, cut.values=cut.points)
plot(ROC.obj$FP, ROC.obj$TP, ylab="Sensitivity=True Positive Rates",
     xlab="1-Specificity = False Positive Rates", type="s", lwd=2)
ROC.obj$AUC
AUC(sens=ROC.obj$TP, spec=1-ROC.obj$FP)

### b. Regresión logística estimada mediante Lasso ({\tt glment}).

### %c. Red neuronal ({\tt nnet})
### c. k-nn ({\tt knn} and {\tt knn.cv} from package {\tt class})


# 5. Calcula también la tasa de error de cada regla cuando se usa $c=1/2$. 

### a. Regresión logística estimada por máxima verosimilitud (IRWLS, {\tt glm}).
1 - sum(diag(table( spam$spam.01[spam.test], pred.glm.spam.test>.5 )))/n.test

### b. Regresión logística estimada mediante Lasso ({\tt glment}).

### %c. Red neuronal ({\tt nnet})
### c. k-nn ({\tt knn} and {\tt knn.cv} from package {\tt class})

# 6, Calcula $\ell_{\mbox{val}}$ para cada regla.
#  \ell_{\mbox{val}}(g_S) = 
#  \frac{1}{m}\sum _{j=1}^m \left( y_j^v \log g_S(\bx_j^v) + (1-y_j^v) \log (1-g_S(\bx_j^v)) \right).

### a. Regresión logística estimada por máxima verosimilitud (IRWLS, {\tt glm}).
mean( spam$spam.01[spam.test]*log(pred.glm.spam.test) + 
                   (1-spam$spam.01[spam.test])*log(1-pred.glm.spam.test))

### b. Regresión logística estimada mediante Lasso ({\tt glment}).

### %c. Red neuronal ({\tt nnet})
### c. k-nn ({\tt knn} and {\tt knn.cv} from package {\tt class})

