data <- read.table("~/Documents/03.AMPL/OGD/OGD.Entrega3/Ignasi/CP_Iter_res.txt", quote="\"", comment.char="")
names(data) <- c("Iter", "F.Objective", "Gap", "beta1", "beta2", "beta3","Y1","Y2","Y3", "|Wx|", "|Ws|", "rho")

library(xtable)

data$alphaWx <- data$beta1
data$alphaWs1 <- ifelse(data$Y2==1, data$beta2, 
                       ifelse(data$Y2==0 & data$Y3 ==1, data$beta3, data$beta2))

data$alphaWs2 <- ifelse(data$Y2==0 & data$Y3==1, 0,data$beta3) 



print <- rbind(data[1:20,c(1:3,10:15)],data[(nrow(data)-5):nrow(data),c(1:3,10:15)])

xtable(print[,-1], digits = c(0,2,5,0,0,0,2,2,2))

pdf("Chart.pdf")
par(mgp=c(1.7,0.5,0), mar= c(5, 4, 3, 2))
plot(x=data$Iter, y=log(abs(data$Gap)),
     pch=1, cex=0.7, col="blue", cex.lab=0.9,cex.axis=0.8,
     ylab = "Total Cost", xlab = "Value N of the discretization",
     main = "Convergency of the RSD algorithm",xaxt = "n")
axis(1, seq(from=min(data$Iter), to=max(data$Iter), by=50),cex.axis=0.8)
abline(h=-240, col="red")
dev.off()

