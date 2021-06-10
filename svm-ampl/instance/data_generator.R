##### Transofrma les dades del generador a arxius .dat hàbils per AMPL #####

dades_50 <- read.table("dades_50.txt", quote="\"", comment.char="")
dades_100 <- read.table("dades_100.txt", quote="\"", comment.char="")
#dades_500 <- read.table("dades_500.txt", quote="\"", comment.char="")

list <- list(dades_50,dades_100)
N <- c(50,100)

for (i in 1:2) {
file.name <- paste("data_N",N[i],".dat",sep = "")

cat("param x:\n", file=file.name)
cat(c(1:ncol(data.frame(list[i]))),":=\n", file=file.name,  append=TRUE)
write.table(data.frame(list[i]), file=file.name, quote = FALSE, append=TRUE, col.names = F)
cat(";", file=file.name, append=TRUE)
}


##### GENERACIO DE DADES KAGGLE ####

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

file.name2<-"diffheight2.dat"
cat("param x:\n", file=file.name2)
cat(c(1:ncol(df4)),":=\n", file=file.name2,  append=TRUE)
write.table(df4, file=file.name2, quote = FALSE, append=TRUE, col.names = F)
cat(";", file=file.name2, append=TRUE)

