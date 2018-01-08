library(plot3D)
rm(list=ls())
data("iris")
x<-as.matrix(iris[,(1:4)])
y<-matrix(as.numeric(iris[,5]), nrow=150)
pairs(iris)


v1<-3
v2<-4
plot(x[(1:50),v1],x[(1:50),v2],col='red',type='p',xlim=c(0,10),ylim=c(0,10))
par(new=TRUE)
plot(x[(51:100),v1],x[(51:100),v2],col='blue',type='p',xlim=c(0,10),ylim=c(0,10))
par(new=TRUE)
plot(x[(101:150),v1],x[(101:150),v2],col='green',type='p',xlim=c(0,10),ylim=c(0,10))

pdfnvar <- function(x,m,K,n) ((1/(sqrt((2*pi)^n*(det(K)))))*exp(-.5*(t(x-m) %*% (solve(K)) %*% (x-m))))

matAcertos<-matrix(nrow=10,ncol=3)
acertosGlobal<-c(0,0,0,0,0,0,0,0,0,0)
for (j in 1:10)
{
  xseq<- sample(50)
  xtrainc1<-matrix(x[xseq[1:40],],nrow=40)
  xtestc1<-x[xseq[41:50],]
  mediasc1<-matrix(colMeans(xtrainc1))
  kc1<-cov(xtrainc1)
  
  xseq<- sample(50)+50
  xtrainc2<-matrix(x[xseq[1:40],],nrow=40)
  xtestc2<-x[xseq[41:50],]
  mediasc2<-matrix(colMeans(xtrainc2))
  kc2<-cov(xtrainc2)
  
  xseq<- sample(50)+100
  xtrainc3<-matrix(x[xseq[1:40],],nrow=40)
  xtestc3<-x[xseq[41:50],]
  mediasc3<-matrix(colMeans(xtrainc3))
  kc3<-cov(xtrainc3)
  
  pc<-c(0,0,0)
  confusao<-matrix(c(0,0,0,0,0,0,0,0,0),nrow=3, ncol=3)
  for(i in (1:10)){
    xtest <- matrix(xtestc1[i,])
    pc[1]<-pdfnvar(xtest,mediasc1,kc1,4)
    pc[2]<-pdfnvar(xtest,mediasc2,kc2,4)
    pc[3]<-pdfnvar(xtest,mediasc3,kc3,4)
    index<-which.max(pc)
    confusao[1,index] <- confusao[1,index] + 1
  }
  for(i in (1:10)){
    xtest <- matrix(xtestc2[i,])
    pc[1]<-pdfnvar(xtest,mediasc1,kc1,4)
    pc[2]<-pdfnvar(xtest,mediasc2,kc2,4)
    pc[3]<-pdfnvar(xtest,mediasc3,kc3,4)
    index<-which.max(pc)
    confusao[2,index] <- confusao[2,index] + 1
  }
  for(i in (1:10)){
    xtest <- matrix(xtestc3[i,])
    pc[1]<-pdfnvar(xtest,mediasc1,kc1,4)
    pc[2]<-pdfnvar(xtest,mediasc2,kc2,4)
    pc[3]<-pdfnvar(xtest,mediasc3,kc3,4)
    index<-which.max(pc)
    confusao[3,index] <- confusao[3,index] + 1
  }
  for(k in 1:3){
    matAcertos[j,k] <- confusao[k,k]
    acertosGlobal[j] <- acertosGlobal[j] + confusao[k,k]
  }
}

medAcertos <- numeric(length=3)
dpAcertos <- numeric(length=3)

medGlobal <- mean(acertosGlobal)
dpGlobal <- sd(acertosGlobal)

taxaGlobal <- (medGlobal/30) * 100

for (i in 1:3)
{
  medAcertos[i]<-mean(matAcertos[,i])
  dpAcertos[i]<-sd(matAcertos[,i])
}

print(taxaGlobal)
