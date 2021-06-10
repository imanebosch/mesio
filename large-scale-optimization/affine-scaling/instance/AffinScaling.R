library(Matrix)
options(digits=12)

affineScaling <- function(c, A, b, fM=100, scaling=TRUE, iter=500) {
  
    n <- dim(A)[2]
    m <- dim(A)[1]
    M <- fM*max(abs(c))
    
    el <- Matrix(rep(1,n))
    
    r <- b - A%*%el #infisibilities
    
    A <- cbind(A,r) #Adding a new variable 
    c <- rbind(c,M) #costs associated to the new variable
    x <- Matrix(rep(1,n+1)) #initial solution
    D <- Diagonal(n+1) #sacling matrix
    
    y <- solve(A%*%D%*%t(A),A%*%D%*%c,tol = 1e-30)
    
    k <- 0
    epsi <- 1e-6
    rho <- 0.95
    
    rel.gap <- abs(t(c)%*%x - t(b)%*%y)/(1+abs(t(c)%*%x))
    results <- data.frame(Iter=0,Gap=as.numeric(rel.gap))
    
    while ( (as.numeric(rel.gap) > epsi) & (k <= iter) ) {
        #print(k)
        z <- c - t(A)%*%y
        d <- -D%*%z
        
        if (sum(d>=0)==n+1) {
            print("Unbounded Problem")
            return("Unbounded Problem")
            }
        
        ratio <- -x/d
        alpha <- rho*min(ratio[d<=0])
        x <- x + alpha*d
        k <- k + 1
        
        if (scaling==TRUE) { 
            X <- Diagonal(x = as.numeric(x))
            D <- X^2
        }
        y <- solve(A%*%D%*%t(A),A%*%D%*%c,tol = 1e-30)
        rel.gap <- abs(t(c)%*%x - t(b)%*%y)/(1+abs(t(c)%*%x))
        
        results[k,] <- c(k,round(as.numeric(rel.gap),8))
      
    }
    
    if(k>=500 & as.numeric(rel.gap)>epsi) {
      print("No optimal solution found. Max Num iterations reached")
      opt<-round(x[1:n],5) #optima 
      Iter<-results #Relative gap per iteration
      Obj <- t(c)%*%x #Objective function value
      
      return(list(Optim=opt,Iter=Iter,Obj=as.numeric(Obj)))
      
    }
    
    if (x[n+1]>epsi) {
       print("Infeasible Problem")
       return("Infeasible Problem")
    } 
    
    else { 
      opt<-round(x[1:n],5) #optima 
      Iter<-results #Relative gap per iteration
      Obj <- t(c)%*%x #Objective function value
      
      print("Optimal Solution found")
      return(list(Optim=opt,Iter=Iter,Obj=as.numeric(Obj)))
    }
    
}

library(lpSolve)

#########################
######### P596 ##########
#########################

A <- Matrix(as.matrix(read.csv("data/P2/ex596A.csv", header=FALSE)))
b <- Matrix(read.table("data/P2/ex596b.csv", quote="\"", comment.char="")$V1)
c <- Matrix(read.table("data/P2/ex596c.csv", quote="\"", comment.char="")$V1)


sol1 <- affineScaling(c = c,A = A,b = b,fM=100, scaling=TRUE)
round(sol1$Obj,4)
max(sol1$Iter[,1])

lp <- lp(objective.in = as.matrix(c), const.mat = as.matrix(A), const.dir = "=", const.rhs = as.matrix(b))
print(lp)
sum(lp$solution!=0) #no cumpleix no degeneració. convergencia no garantida pero convergeix

sol1 <- affineScaling(c = c,A = A,b = b,fM=100, scaling=FALSE) #agotem 500 iteracions sense convergir
round(sol1$Obj,4)
max(sol1$Iter[,1])

#########################
######### P597 ##########
#########################

A <- Matrix(as.matrix(read.csv("data/P1/ex597A.csv", header=FALSE)))
b <- Matrix(read.table("data/P1/ex597b.csv", quote="\"", comment.char="")$V1)
c <- Matrix(read.table("data/P1/ex597c.csv", quote="\"", comment.char="")$V1)

sol1 <- affineScaling(c = c,A = A,b = b, fM=100, scaling=TRUE)
round(sol1$Obj,4)
max(sol1$Iter[,1])

lp <- lp(objective.in = as.matrix(c), const.mat = as.matrix(A), const.dir = "=", const.rhs = as.matrix(b))
print(lp)
sum(lp$solution!=0) #no cumpleix no degeneració. convergencia no garantida pero convergeix

sol1 <- affineScaling(c = c,A = A,b = b,fM=100, scaling=FALSE) #agotem 500 iteracions sense convergir
round(sol1$Obj,4)
max(sol1$Iter[,1])

#########################
######### P598 ##########
#########################

A <- Matrix(as.matrix(read.csv("data/P3/ex598A.csv", header=FALSE)))
b <- Matrix(read.table("data/P3/ex598b.csv", quote="\"", comment.char="")$V1)
c <- Matrix(read.table("data/P3/ex598c.csv", quote="\"", comment.char="")$V1)

sol1 <- affineScaling(c = c,A = A,b = b, fM=100, scaling=TRUE)

lp <- lp(objective.in = as.matrix(c), const.mat = as.matrix(A), const.dir = "=", const.rhs = as.matrix(b))
print(lp)
sum(lp$solution!=0) #no cumpleix no degeneració. convergencia no garantida (singularitat)

sol1 <- affineScaling(c = c,A = A,b = b,fM=100, scaling=FALSE) #agotem 500 iteracions sense convergir
round(sol1$Obj,4)
max(sol1$Iter[,1])
