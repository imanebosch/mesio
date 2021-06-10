#Testea el resultado obtenido en un data set de validacion de datos
library(xtable)

dades_50 <- read.table("dades_50.txt", quote="\"", comment.char="")
dades_100 <- read.table("dades_100.txt", quote="\"", comment.char="")

Primal_res <- read.table("Primal_res.txt", quote="\"")
Dual_res <- read.table("Dual_res.txt", quote="\"", comment.char="")

names(Primal_res) <- c("v","y","w1","w2","w3","w4")
names(Dual_res) <- c("v","y","w1","w2","w3","w4")

print(xtable(Primal_res),include.rownames=FALSE)
print(xtable(Dual_res),include.rownames=FALSE)

Prim_50_train <- dades_50
Prim_100_test <- dades_100

for (i in Primal_res[,1]) { 
  
  d <- as.matrix(Prim_50_train[,1:4])%*%t(as.matrix(Primal_res[i,3:6]))
  m <- ifelse(d>=Primal_res[i,2],1,-1)
  
  Prim_50_train <- cbind(Prim_50_train,m)
  print(i)
  
  }

for (i in Primal_res[,1]) { 
  
  d <- as.matrix(Prim_100_test[,1:4])%*%t(as.matrix(Primal_res[i,3:6]))
  m <- ifelse(d>=Primal_res[i,2],1,-1)
  
  Prim_100_test <- cbind(Prim_100_test,m)
  print(i)
  
}

train.y <- Prim_50_train$V5
test.y <- Prim_100_test$V5
acuracy.train <- sapply(Prim_50_train[,-c(1:5)], FUN=function(x) {sum(train.y==x)/length(x)})
acuracy.test <- sapply(Prim_100_test[,-c(1:5)], FUN=function(x) {sum(test.y==x)/length(x)})


png("Chart.png")
par(mgp=c(1.7,0.5,0), mar= c(5, 4, 3, 2))
plot(x=Primal_res$v,y=acuracy.train, type = "l", cex.lab=0.9,cex.axis=0.8,
     col="red", xlab = "v values", ylab = "Accuracy",
     main = "Accuracy of the algorithm by different values of v")
lines(x=Primal_res$v,y=acuracy.test, col="blue")
legend("bottomright", legend=c("Train", "Test"),
       col=c("red", "blue"), lty=1, cex=0.8)
dev.off()



# Dades: https://www.kaggle.com/mustafaali96/weight-height
df3 <- read.csv("weight-height.csv")
for(i in 1:nrow(df3)){
  if(df3$Gender[i]=="Male"){df3$Class[i]<-1}
  else df3$Class[i]<--1}

# From inches to cm
df3$Height <- df3$Height*2.54
# From lb to kg
df3$Weight <- df3$Weight/2.205

df4<-data.frame()
df4<-rbind(df3[1:100,2:4],df3[5001:5100,2:4])

plot(x=df4$Height, y=df4$Weight, col=df4$Class+2, xlab = "Height [cm]", ylab = "Weight[kg]",
     main = "Height vs Weight")

rownames(df4)<- seq(1,200,by=1)

###### Gràfic amb hiperplans #####

# Dades de Kaggle

png("ChartKaggle.png")
par(mgp=c(1.7,0.5,0), mar= c(5, 4, 3, 2))
plot(x=df4$Height, y=df4$Weight, col=df4$Class+2, xlab = "Height [cm]", ylab = "Weight[kg]",
     main = "Height vs Weight", cex=0.7, cex.lab=0.9, cex.axis=0.8)
lines(x=df4$Height, y=6.56/0.261+(df4$Height)*0.073/0.261, col="red")
lines(x=df4$Height, y=5.56/0.261+(df4$Height)*0.073/0.261, col="red")
lines(x=df4$Height, y=7.56/0.261+(df4$Height)*0.073/0.261, col="red")
points(x=df4$Height[c(84,96,120)],y=df4$Weight[c(84,96,120)], pch=3)
legend("bottomright", legend=c("Female", "Male", "SVM"),
       col=c(1, 3, 1), pch=c(1,1,3), cex=0.8)
dev.off()




