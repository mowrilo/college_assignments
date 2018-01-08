

rm(list=ls())

distancia <- function(x1, x2) sqrt(sum((x1 - x2) ^ 2))

myknn <- function(xt, X, Y, k)
{
  # calcula as distancias de xt a X, sort e pega os k
  N <- dim(X)[1]
  n <- dim(X)[2]
  vdist <- numeric(N)
  for (i in 1:N)
  {
    vdist[i] <- distancia(xt, X[i,])
  }
  
  vdist <- cbind(vdist, Y)
  ordem<-order(vdist[,1])
  
  nneigh <- vdist[ordem[1:k],]
  # print(matrix(nneigh,))
  #kmat<-1/sqrt(2*pi) * exp(1/2 * nneigh)
  #alfa <- 1/sum(1/nneigh[,1])
  
  #pc1 <- 0 
  #pc2 <- 0
  
  c1 <- which(nneigh[,2] == -1)
  c2 <- which(nneigh[,2] == 1)
  
  
  pc1 <- abs(sum(nneigh[c1,2]))
  pc2 <- abs(sum(nneigh[c2,2]))
  
  #pc1 <- sum(alfa/nneigh[c1,1])
  #pc2 <- sum(alfa/nneigh[c2,1])
  
  if (pc1 >= pc2)
  {
    return(1)
  }
  else
  {
    return(2)
  }
}

library(mlbench)
library(plot3D)

ntest<-20

p <- mlbench.spirals(400, 1, .07)
plot(p)

#X <- p[[1]]

xc1<-matrix(rnorm(200, 3, .35),ncol=2)
xc2<-matrix(rnorm(200, 4, .35),ncol=2)

X <- rbind(xc1,xc2)

N<-nrow(X)
C<-numeric(length=N)

C[1:100] <- 1
C[101:200] <- 2
#C <- as.numeric(p[[2]])

plot(X[1:100,],xlim=c(1.5,5.5),ylim=c(1.5,5.5),col='black')
par(new=T)
plot(X[101:200,],xlim=c(1.5,5.5),ylim=c(1.5,5.5),col='red')

xablau <- sample(N)

Xtrain <- X[xablau[1:(N-ntest)],]
Y <- C[xablau[1:(N-ntest)]]
Yall <- C
Y[which(Y == 2)] <- -1
Yall[which(Yall == 2)] <- -1

Xtst <- X[xablau[(N-ntest+1):N],] 
Ctst <- C[xablau[(N-ntest+1):N]]

k<-3
erro <- 0

for (i in 1:nrow(Xtst))
{
  classe <- myknn(Xtst[i,],Xtrain,Y,k)
  if (classe != C[i])
  {
    erro <- erro + 1
  }
}

seqi <- seq(1.5,5.5,.1)
seqj <- seq(1.5,5.5,.1)

ene <- length(seqi)

grid <- matrix(nrow=ene, ncol=ene)

ci <- 0
for (i in seqi)
{
  ci<-ci+1
  cj<-0
  for (j in seqj)
  {
    cj<-cj+1
    #print()
    grid[ci,cj] <- myknn(c(i,j),X,Yall,k)
  }
}

ribbon3D(seqi,seqj,grid)