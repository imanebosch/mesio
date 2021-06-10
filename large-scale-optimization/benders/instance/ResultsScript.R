##Amb aquest arxiu he tractat els resultats de sortida de AMPL.
##Grafics etc.. No es necessari fer-lo servir

res <- read.table("BD_Alg_Res.txt")
names(res) <- c("Ini.y","Iter","lbound","ubound","Inv.cost","Expl.cost")

inv <- read.table("BD_Inv_Arc.txt")
names(inv) <- c("Ini.y","Iter","4.5","3.6",
                "15.13","21.18","6.14","10.5",
                "14.13","16.15","13.17","11.22")
epsi <- 1.0e-6

res$relgap <- (res$ubound-res$lbound) / (abs(res$lbound) + epsi)

###PLOT FOR Y=0
res.y0 <- res[res$Ini.y==0,]
inv.y0 <- inv[inv$Ini.y==0,]

par(mgp=c(1.7,0.5,0), mar= c(5, 4, 3, 2))
plot(x=res.y0$Iter, y=res.y0$lbound, ylim = c(8000,18000), 
     pch=1, cex=0.7, col="blue", cex.lab=0.9,cex.axis=0.8,
     ylab = "Total Cost", xlab = "Iteration number",
     main = "Convergency of Benders Algorithm from y=0",xaxt = "n")
axis(1, c(1:25),cex.axis=0.8)
lines(x=res.y0$Iter, y=res.y0$lbound, col="blue")
points(x=res.y0$Iter, y=res.y0$ubound, 
       pch=1, cex=0.7, col="red",cex.lab=0.9,cex.axis=0.8)
lines(x=res.y0$Iter, y=res.y0$ubound, col="red")

write.csv2(res.y0, file = "resy_0.csv")
write.csv2(inv.y0, file = "invy_0.csv")

###PLOT FOR Y=1
res.y1 <- res[res$Ini.y==1,]
inv.y1 <- inv[inv$Ini.y==1,]

par(mgp=c(1.7,0.5,0), mar= c(5, 4, 3, 2))
plot(x=res.y1$Iter, y=res.y1$lbound, ylim = c(10000,18000), 
     pch=1, cex=0.7, col="blue", cex.lab=0.9,cex.axis=0.8,
     ylab = "Total Cost", xlab = "Iteration number",
     main = "Convergency of Benders Algorithm from y=1",xaxt = "n")
axis(1, c(1:25),cex.axis=0.75)
lines(x=res.y1$Iter, y=res.y1$lbound, col="blue")
points(x=res.y1$Iter, y=res.y1$ubound, 
       pch=1, cex=0.7, col="red",cex.lab=0.9,cex.axis=0.7)
lines(x=res.y1$Iter, y=res.y1$ubound, col="red")

write.csv2(res.y1, file = "resy_1.csv")
write.csv2(inv.y1, file = "invy_1.csv")

flows3 <- read.table("flows3.txt")
names(flows3) <- c("k","i","j","value")

flows3.y0 <- flows3[flows3$k==0,]
flows3.y0$arc <- paste("{",flows3.y0$i,",",flows3.y0$j,"}",sep="")

flows3.y1 <- flows3[flows3$k==1,]
flows3.y1$arc <- paste("{",flows3.y1$i,",",flows3.y1$j,"}",sep="")

write.csv2(flows3.y0[,4:5], file = "flows3_0.csv")
write.csv2(flows3.y1[,4:5], file = "flows3_1.csv")


flows11 <- read.table("flows11.txt")
names(flows11) <- c("k","i","j","value")

flows11.y0 <- flows11[flows11$k==0,]
flows11.y0$arc <- paste("{",flows11.y0$i,",",flows11.y0$j,"}",sep="")

flows11.y1 <- flows11[flows11$k==1,]
flows11.y1$arc <- paste("{",flows11.y1$i,",",flows11.y1$j,"}",sep="")

write.csv2(flows11.y0[,4:5], file = "flows11_0.csv")
write.csv2(flows11.y1[,4:5], file = "flows11_1.csv")


sum(flows11.y0[,-1]!=flows11.y1[,-1])


