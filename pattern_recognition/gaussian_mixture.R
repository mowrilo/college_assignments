# A Bayesian classifier estimating likelihoods with
# a gaussian mixture and k nearest neighbors

rm(list=ls())
library('plot3D')
#library('rgl')

##################################################################
mymixgauss <- function(x,inlist)
{
  pdfnvar <- function(x,m,K,n) ((1/(sqrt((2*pi)^n*(det(K)))))*exp(-.5*(t(x-m) %*% (solve(K)) %*% (x-m))))
  
  ng<-length(inlist)
  klist<-list()
  mlist<-list()
  pglist<-list()
  nglist<-list()
  n<-dim(inlist[[1]])[2]
  
  for (i in (1:ng))
  {
    klist[[i]]<-cov(inlist[[i]])
    mlist[[i]]<-colMeans(inlist[[i]])
    nglist[[i]]<-dim(inlist[[i]])[1]
  }
  N<-0
  for (i in (1:ng))
  {
    N<-N+nglist[[i]]
  }
  for (i in (1:ng))
  {
    pglist[[i]]<-nglist[[i]]/N
  }
  Px<-0
  for (i in (1:ng))
  {
    Px<-Px+pglist[[i]]*pdfnvar(x,mlist[[i]],klist[[i]],n)
  }
  return (Px)}


##################################################################
# 
# 
# 
# # 
# # s1<-.5
# # s2<-.2
# N<-100
# 
# xc1 <- matrix(rnorm(N), ncol=2)*.5+2
# xc2 <- matrix(rnorm(N), ncol=2)*.5+3
# 
# m11 <- mean(xc1[,1])
# m12 <- mean(xc1[,2])
# 
# m1<-matrix(c(m11,m12),ncol=1,nrow=2)
# k1<-cov(xc1)
# m21 <- mean(xc2[,1])
# m22 <- mean(xc2[,2])
# m2<-matrix(c(m21,m22),ncol=1,nrow=2)
# k2<-cov(xc2)
# seqi <- seq(0,6,.1)
# seqj <- seq(0,6,.1)
# 
# n1<-dim(xc1)
# n2<-dim(xc2)
# 
# pg1<-n1[1]/(n1[1]+n2[1])
# pg2<-n2[1]/(n1[1]+n2[1])
# 
# np<-length(seqi)
# M1 <- matrix(nrow=np,ncol=np)
# M2 <- matrix(nrow=np,ncol=np)
# M3 <- matrix(nrow=np,ncol=np)
# ci<-0
# 
# for(i in seqi){
#   ci<-ci+1
#   cj<-0
#   for(j in seqj){
#     cj<-cj+1
#     xt<-matrix(c(i,j),nrow=2,ncol=1)
#     M3[ci,cj] <- mymixgauss(c(i,j),list(xc1,xc2))#(pg1*M1[ci,cj]) + (pg2*M2[ci,cj])
#   }
#  }
# persp3D(seqi,seqj,M3,xlim=c(0,6),ylim=c(0,6))

library(plot3D)
library(rgl)
library(mlbench)
# 
# X <- matrix(c(4,4,4.3,4.1,4.4,5.3,5.2,5.3,5.3,5.5,4.5,4.65,4.75,4.6,4.7,0,.7,.2,.3,.5,.2,.1,.5,.6,.25,2.1,2.2,2.4,2.5,2.36),nrow=15,ncol=2)
# X <- matrix(c(4,4,4.3,4.1,4.4,5,5.2,5.3,5.3,5.5,4.59,4.9,4.75,4.6,4.7,0,.7,.2,.3,.5,.2,.1,.5,.6,.25,1.1,1.2,1.4,1.5,1.36),nrow=15,ncol=2)
# 
# data("iris")
# X<-as.matrix(iris[,(1:4)])

mykmedias<-function(X,k)
{
  
  N<-dim(X)[1]
  n<-dim(X)[2]
  
  mi<-sample(N)
  
  m <- matrix(nrow=k,ncol=n)
  m<-X[mi[1:k],] #matriz de dados sorteada
  
  d<-matrix(nrow=k,ncol=1) #matriz de distancias
  c<-matrix(nrow=N,ncol=1) #matriz de clusters
  
  for (kk in (1:200))
  {
    for(i in (1:N))
    {
      xt<-as.matrix(X[i,])
      for(j in (1:k))
      {
        d[j]<-sum((t(xt)-m[j,])^2)
      }
      c[i]<-which.min(d)
    }
    for(i in (1:k))
    {
      ici<-which(c[] == i)
      ni <- length(ici)
      acc<-matrix(0,nrow=1,ncol=n)
      for(j in (1:ni))
      {
        acc<-acc+t(as.matrix(X[ici[j],]))
      }
      m[i,]<-acc/ni
    }
  }
  retlist<-list(m,c)
  return(retlist)
}

p<-mlbench.spirals(1000,3,0.01)
k<-50

ici1<-which(p[[2]]==1)
ici2<-which(p[[2]]==2)
X <- as.matrix(p[[1]])

X1<-X[ici1,]
X2<-X[ici2,]

qwert<-mykmedias(X1,k)
qwery<-mykmedias(X2,k)
xc1<-qwert[[2]]
xc2<-qwery[[2]]
xclusters1<-list()
xclusters2<-list()
for(i in (1:k))
{
  ind1 <- which(xc1[] == i)
  xclusters1[[i]]<-X1[ind1,]
  
  ind2 <- which(xc2[] == i)
  xclusters2[[i]]<-X2[ind2,]
}

lbi<-(min(X[,1])-.5)
ubi<-(max(X[,1])+.5)

lbj<-(min(X[,2])-.5)
ubj<-(max(X[,2])+.5)

seqi <- seq(lbi,ubi,.05)
seqj <- seq(lbj,ubj,.05)

npi<-length(seqi)
npj<-length(seqj)
M1 <- matrix(nrow=npi,ncol=npj)
M2<- matrix(nrow=npi,ncol=npj)
M3<- matrix(nrow=npi,ncol=npj)
M4<- matrix(nrow=0,ncol=2)
guarda<-0
ci<-0
for(i in seqi){
  ci<-ci+1
  cj<-0
  for(j in seqj){
    cj<-cj+1
    M1[ci,cj] <- mymixgauss(c(i,j),xclusters1)
    M2[ci,cj] <- mymixgauss(c(i,j),xclusters2)
    M3[ci,cj] <- 1*(M1[ci,cj] > M2[ci,cj])
    
    if (cj>1){
      if (M3[ci,cj] != M3[ci,(cj-1)])
      {
        M4 <- rbind(M4,c(i,j))
        M4 <- rbind(M4,c(i,j+.01))
      }}
    if (ci>1){
      if (M3[ci,cj] != M3[(ci-1),cj])
      {
        M4 <- rbind(M4,c(i,j))
      }}
  }
}

plot(p,xlim=c(lbi,ubi),ylim=c(lbj,ubj))
par(new=T)
contour(seqi,seqj,M3,nlevels=1,col='blue')

persp3d(seqi,seqj,M1,xlim=c(lbi,ubi),ylim=c(lbj,ubj),col='red')
persp3d(seqi,seqj,M2,xlim=c(lbi,ubi),ylim=c(lbj,ubj),col='green',add=T)
persp3d(seqi,seqj,M3,xlim=c(lbi,ubi),ylim=c(lbj,ubj),col='blue',add=T)
