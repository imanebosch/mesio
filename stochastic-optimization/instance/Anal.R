library(xtable)

data <- read.table("~/Documents/03.AMPL/PE/PE.Assignment5/BD_Alg_Res.txt", quote="\"", comment.char="")

names(data) <- c("Iter","GAP","Upper B.","Lower B.","x")


png("Chart.png")
par(mgp=c(1.7,0.5,0), mar= c(5, 4, 3, 2))
plot(x=data$Iter, y=data$`Lower B.`, ylim = c(-0.055,max(data$`Upper B.`)),
     pch=1, cex=0.7, col="blue", cex.lab=0.9,cex.axis=0.8,
     ylab = "Total Cost", xlab = "Iteration number",
     main = "Convergency of Benders Algorithm from x=50",xaxt = "n")
axis(1, c(1:25),cex.axis=0.8)
lines(x=data$Iter, y=data$`Upper B.`, col="red")
points(x=data$Iter, y=data$`Upper B.`, 
       pch=1, cex=0.7, col="red",cex.lab=0.9,cex.axis=0.8)
lines(x=data$Iter, y=data$`Lower B.`, col="blue")
dev.off()

#results table for latex
print(xtable(data,digits=c(0,5,5,5,5,2)),include.rownames=FALSE)

RP <- 0.03025
WS <- 0.021902
EEV <- 0.0332752

(EVPI <- RP-WS)
(VSS <- EEV-RP)




