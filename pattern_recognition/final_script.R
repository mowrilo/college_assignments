rm(list=ls())
library(mlbench)
library(plot3D)
library(rgl)
library(MASS)
library(parallel)

euclidDist <- function(a,b)
{
  sub <- a-b
  return(sqrt(sub[1]^2 + sub[2]^2))
}

pxkdenvartst<-function(xrange,xtrn,h) #teste, treino, h
{
  #########################
  knorm<-function(u,h)
  {
    K <- (1/sqrt(2*pi*h*h)) * exp(-0.5*u^2)
    return(K)
  }
  #########################
  
  # nteste <- nrow(xrange)
  # ntrain <- nrow(xtrn)
  # 
  # Distt <- matrix(nrow=nteste,ncol=ntrain)
  # 
  # for (i in 1:nteste)
  # {
  #   for (j in 1:ntrain)
  #   {
  #     Distt[i,j] <- dist(rbind(xrange[i,],xtrn[j,]))
  #   }
  # }
  # 
  # K <- exp(-(Distt^2)/(2*h^2))
  # N<-dim(xtrn)[1]
  # px <- rowSums(K)#/(N*h)
  # 
  N<-dim(xtrn)[1]
  
  Nxrange<-dim(xrange)[1]
  nxrange<-dim(xrange)[2]
  
  px<-matrix(nrow=Nxrange,ncol=1)
  for (i in 1:Nxrange)
  {
    if (nxrange >= 2)
    {
      xi<-xrange[i,]
    }
    else
    {
      xi<-xrange[i]
    }
    
    kxixall<-0
    for (j in 1:N)
    {
      xj<-xtrn[j,]
      u<-(sqrt(sum((xi-xj)^2)))/h
      kxixall<-kxixall+knorm(u,h)
    }
    px[i]<-kxixall
  }
  px<-px/(N)
  return(px)
} 



pxkdenvar<-function(xrange,X,h) #teste, treino, h
{
  #########################
  knorm<-function(u,h)
  {
    K <- (1/sqrt(2*pi*h*h)) * exp(-0.5*u^2)
    return(K)
  }
  #########################
  
  N<-dim(X)[1]
  
  Nxrange<-dim(xrange)[1]
  nxrange<-dim(xrange)[2]
  
  px<-matrix(nrow=Nxrange,ncol=1)
  for (i in 1:Nxrange)
  {
    if (nxrange >= 2)
    {
      xi<-xrange[i,]
    }
    else
    {
      xi<-xrange[i]
    }
    
    kxixall<-0
    for (j in 1:N)
    {
      xj<-X[j,]
      u<-(sqrt(sum((xi-xj)^2)))/h
      kxixall<-kxixall+knorm(u,h)
    }
    px[i]<-kxixall
  }
  px<-px/(N)
  return(px)
} 

mykde <- function(h,x,data)
{
  prob <- 0
  N<-nrow(data)
  for(i in 1:N)
  {
    dif <- x - data[i,]
    distance <- sqrt(dif[1]^2 + dif[2]^2)
    K <- 1/sqrt(2*pi) * exp(-1/2 * ((distance/h)^2))
    probponto <- 1/h * K
    prob <- prob + probponto/N #1/h * K
  }
  return (prob)
}

#funções de distancia
dist2d <- function(a,b,c) 
{
  v1 <- b - c
  v2 <- a - b
  m <- cbind(v1,v2)
  d <- abs(det(m))/sqrt(sum(v1*v1))
  return (d)
}


mahDist <- function(x,mi,s)
{
  d <- sqrt(t(x-mi) %*% ginv(s) %*% (x-mi))
  return(d)
}

derivada <- function(func, ponto, rel)
{
  if (ponto == length(func))
  {
    p1 <- ponto
  }
  else
  {
    p1 <- ponto+1
  }
  
  if (ponto == 1)
  {
    p2 <- ponto
  }
  else
  {
    p2 <- ponto-1
  }
  
  dely <- func[p1] - func[p2]
  delx <- rel[p1] - rel[p2]
  
  return(dely/delx)
}
  
  maxlocal <- function(vec)
  {
    asd <- 1
    while(vec[asd] < vec[asd+1])
    {
      asd <- asd+1
    }
    return (asd)
  }

minlocal <- function(vec)
{
  asd <- 2
  while(vec[asd] > vec[asd+1])
  {
    asd <- asd+1
  }
  return (asd)
}
  
  ntestes <- 15

erromin <- numeric(length=ntestes)
#errodma <- numeric(length=ntestes)
errodm <- numeric(length=ntestes)
erromaxdev <- numeric(length=ntestes)
errozerodev1 <- numeric(length=ntestes)
errozerodev2 <- numeric(length=ntestes)
#errorm <- numeric(length=ntestes)
#errorv <- numeric(length=ntestes)
#errormv <- numeric(length=ntestes)
#errovar1 <- numeric(length=ntestes)
#errovar2 <- numeric(length=ntestes)
errodret <- numeric(length=ntestes)
#errocov <- numeric(length=ntestes)
erromaks <- numeric(length=ntestes)
erroder2 <- numeric(length=ntestes)
errominder11 <- numeric(length=ntestes)
errominder122 <- numeric(length=ntestes)
errocov1 <- numeric(ntestes)

#count <- 1
#for(count in 1:ntestes)
#{
p<-mlbench.spirals(2000,3,0.07)
#p<-mlbench.circle(2000)
#p<-mlbench.2dnormals(2000)

#full moon
#corners
seqh<-seq(.001,.5,.001)
ncores <- detectCores()-1
# 
# adData <- read.csv("adultTrain.csv")
# 
# datamat <- as.numeric(adData[,1])
# 
# for (i in 2:(ncol(adData)-1))
# {
#   datamat <- cbind(datamat,as.numeric(adData[,i]))
# }
# 
# classes<-as.numeric(adData[,ncol(adData)])
# 
# datamat <- datamat[1:1200,]
# classes <- classes[1:1200]
# 
# p<-list(datamat,classes)


# data("BreastCancer")
# dadoss <- as.matrix(BreastCancer[,2:10])
# dados <- matrix(nrow=nrow(dadoss),ncol=ncol(dadoss))
# for(i in 1:ncol(dados))
# {
#   dados[,i] <- as.numeric(dadoss[,i])
# }
# classes <- matrix(as.numeric(BreastCancer[,11]),ncol=1)
# p <- list(dados,classes)

# data("PimaIndiansDiabetes")
# dadoss <- as.matrix(PimaIndiansDiabetes[,1:8])
# dados <- matrix(nrow=nrow(dadoss),ncol=ncol(dadoss))
# for(i in 1:ncol(dados))
# {
#   dados[,i] <- as.numeric(dadoss[,i])
# }
# classes <- matrix(as.numeric(PimaIndiansDiabetes[,9]),ncol=1)
# p <- list(dados,classes)
# 
# data("HouseVotes84")
# dadoss <- as.matrix(HouseVotes84[,2:17])
# dados <- matrix(nrow=nrow(dadoss),ncol=ncol(dadoss))
# for(i in 1:ncol(dados))
# {
#   for (j in 1:nrow(dados))
#   {
#     if (is.na(dadoss[j,i]))
#     {
#       dados[j,i] <- 0
#     }
#     else
#     {
#       if (dadoss[j,i] == "y")
#       {
#         dados[j,i] <- 1
#       }
#       else if (dadoss[j,i] == "n")
#       {
#         dados[j,i] <- -1
#       }
#     }
#   }
# }
# classes <- matrix(as.numeric(HouseVotes84[,1]),ncol=1)
#  p <- list(dados,classes)



#plot(p)

ici1<-which(p[[2]]==1)
ici2<-which(p[[2]]==2)
X <- as.matrix(p[[1]])

isna <- is.na(X)
X[isna] <- 0

X1<-X[ici1,]
X2<-X[ici2,]

#X1<-matrix(rnorm(400,2,.5),ncol=2)
#X2<-matrix(rnorm(400,3.75,.5),ncol=2)
#plot(X1,col='blue',xlim=c(0,6),ylim=c(0,6))
#par(new=T)
#plot(X2,col='red',xlim=c(0,6),ylim=c(0,6))

tam1 <- nrow(X1)
tam2 <- nrow(X2)

smp1 <- sample(tam1)
smp2 <- sample(tam2)

ntst <- 1500#round(dim(X)[1]/2)

ntst2 <- floor(tam2/(tam1+tam2)*ntst)
ntst1 <- ntst - ntst2

x1trn <- X1[smp1[1:(tam1-ntst1)],]
x1tst <- X1[smp1[(tam1-(ntst1-1)):tam1],]

x2trn <- X2[smp2[1:(tam2-ntst2)],]
x2tst <- X2[smp2[(tam2-(ntst2-1)):tam2],]

#encontrar hmin pelo erro na regra de bayes
xtrn <- rbind(x1trn,x2trn)
xtst <- rbind(x1tst,x2tst)

ntrain<-nrow(xtrn)
nteste<-nrow(xtst)

Dspirtst <- matrix(nrow=nteste,ncol=ntrain)
sigmat <- matrix(nrow=nteste,ncol=ntrain)

for (i in 1:nteste)
{
  for (j in 1:ntrain)
  {
    Dspirtst[i,j] <- dist(rbind(xtst[i,],xtrn[j,]))
  }
}

n2 <- nrow(x2tst)
n1 <- nrow(x1tst)

ntr1 <- nrow(x1trn)
ntr2 <- nrow(x2trn)

sigmat[1:n1,1:ntr1] <- 1
sigmat[1:n1,(ntr1 + 1):ntrain] <- -1
sigmat[(n1 + 1):nteste,1:ntr1] <- -1
sigmat[(n1 + 1):nteste,(ntr1 + 1):ntrain] <- 1

taxaerro<-numeric(length=length(seqh))
nerro <-numeric(length=length(seqh))

ce<-0
for (h in seqh)
{
  ce<-ce+1
  kspir <- exp(-(Dspirtst^2)/(2*h^2))
  
  yy <- sigmat * kspir
  
  yerro<-rowSums(yy)
  
  nerro[ce] <- sum(1*(yerro<=0))
  
  taxaerro[ce] <- nerro[ce]/(n1+n2)
}

plot(seqh,taxaerro*100,type='l',main=as.character(count))

xtrn <- list(x1trn,x2trn)
xtst <- list(x1tst,x2tst)

hmin <- seqh[which.min(taxaerro)]
#erromin[count] <- min(taxaerro)
erromin <- min(taxaerro)
poshmin <- which(seqh == hmin)

  
  #aquisição de dados no espaço das verossimilhanças
  #seqh<-seq(.001,1,.0005)
  ch <- 0
matvarc1 <- matrix(ncol=2,nrow=length(seqh))
matvarc2 <- matrix(ncol=2,nrow=length(seqh))
matmedc1 <- matrix(ncol=2,nrow=length(seqh))
matmedc2 <- matrix(ncol=2,nrow=length(seqh))
# matcovc1 <- array(dim=c(2,2,length(seqh)))
# matcovc2 <- array(dim=c(2,2,length(seqh)))
# matcovall <- array(dim=c(2,2,length(seqh)))
# for(h in seqh)
# {
#   m1 <- matrix(ncol=2,nrow=nrow(x1trn))
#   m2 <- matrix(ncol=2,nrow = nrow(x2trn))
#   
#   xx<-seq(0,1,0.005)
#   yy<-xx
#   
#  # for (i in 1:nrow(x1tst))
#   #{
#    m1[,1] <- pxkdenvar(x1trn,x1trn,h)#mykde(h,x1tst[i,],x1trn)
#    m1[,2] <- pxkdenvar(x1trn,x2trn,h)#mykde(h,x1tst[i,],x2trn)
#   #}
#   
#  # for (i in 1:nrow(x2tst))
#  # {
#     #lst <- lapply(seqh,pxkdenvartst,xrange=x1trn,xtrn=x1trn)
#     m2[,1] <- pxkdenvar(x2trn,x1trn,h)#mykde(h,x2tst[i,],x1trn)
#     m2[,2] <- pxkdenvar(x2trn,x2trn,h)#mykde(h,x2tst[i,],x2trn)
#  #}
# # cc0 <- as.character(ch)
# # #cc <- paste0(cc0,".jpeg")
# # #jpeg(cc)
# # if (h == hmin)
# #   {
# #   strr <- paste("h otimo:",as.character(h))
# #   plot(m1[,1],m1[,2],col='blue',xlim=c(0,1),ylim=c(0,1),xlab='P(x|C1)',ylab='P(x|C2)',main=strr)
# # }
# # else
# # {
# #   plot(m1[,1],m1[,2],col='blue',xlim=c(0,1),ylim=c(0,1),xlab='P(x|C1)',ylab='P(x|C2)')
# # }
# # par(new=TRUE)
# # plot(m2[,1],m2[,2],col='red',xlim=c(0,1),ylim=c(0,1),xlab = '',ylab = '')
# # par(new=TRUE)
# # plot(xx,yy,type='l',col='black',xlim=c(0,1),ylim=c(0,1),xlab = '',ylab = '')
#  # text(h,col=2)
#  # dev.off()
# ch<-ch+1
# # matvarc1[ch,] <- c(sd(m1[,1]),sd(m1[,2]))
# # matvarc2[ch,] <- c(sd(m2[,1]),sd(m2[,2]))
# matmedc1[ch,] <- c(mean(m1[,1]),mean(m1[,2]))
# matmedc2[ch,] <- c(mean(m2[,1]),mean(m2[,2]))
# # matcovc1[,,ch] <- cov(m1)
# # matcovc2[,,ch] <- cov(m2)
# # matcovall[,,ch] <- cov(rbind(m1,m2))
# print(length(seqh[ch:length(seqh)]))
# }
#matmedc11 <- matrix(ncol=2,nrow=length(seqh))
#matmedc22 <- matrix(ncol=2,nrow=length(seqh))
tamanho<-length(seqh)
cl <- makeCluster(ncores)

m11 <- parLapply(cl,seqh,pxkdenvartst,xrange=x1trn,xtrn=x1trn)
m12 <- parLapply(cl,seqh,pxkdenvartst,xrange=x1trn,xtrn=x2trn)
m21 <- parLapply(cl,seqh,pxkdenvartst,xrange=x2trn,xtrn=x1trn)
m22 <- parLapply(cl,seqh,pxkdenvartst,xrange=x2trn,xtrn=x2trn)

matmedc1[,1] <- unlist(lapply(m11[1:length(m11)],mean))
matmedc1[,2] <- unlist(lapply(m12[1:length(m12)],mean))

matmedc2[,1] <- unlist(lapply(m21[1:length(m21)],mean))
matmedc2[,2] <- unlist(lapply(m22[1:length(m22)],mean))

matvarc1[,1] <- unlist(lapply(m11[1:length(m11)],var))
matvarc1[,2] <- unlist(lapply(m12[1:length(m12)],var))

matvarc2[,1] <- unlist(lapply(m21[1:length(m21)],var))
matvarc2[,2] <- unlist(lapply(m22[1:length(m22)],var))

matcov <- numeric(tamanho)
matcovc1 <- numeric(tamanho)
matcovc2 <- numeric(tamanho)

for (batman in 1:tamanho)
{
  matcov[batman]<-cov(rbind(m11[[batman]],m21[[batman]]),rbind(m12[[batman]],m22[[batman]]))
  matcovc1[batman] <- cov(m11[[batman]],m12[[batman]])
  matcovc2[batman] <- cov(m21[[batman]],m22[[batman]])
}

stopCluster(cl)

#métodos de minimização

#distancia de mahalanobis entre medias
# asd <- 1
# distmah <- numeric(length=(length(seqh)))
# distmah2to1 <- numeric(length=(length(seqh)))
# for (i in 1:length(seqh))
# {
#   distmah[i] <- mahDist(matmedc1[i,],matmedc2[i,],matcovc2[,,i])
#   distmah2to1[i] <- mahDist(matmedc2[i,],matmedc1[i,],matcovc1[,,i])
# }
# 
# lim1 <- length(seqh)
# lim0 <- 1
# 
# 
# hdma <- seqh[which.max(distmah[lim0:lim1]) + lim0-1]
# errodma1to2 <- taxaerro[which(seqh == hdma)]
#  plot(seqh[lim0:lim1],distmah[lim0:lim1],type='l',ylab="Distância de Mahalanobis",xlab="h")
#  
#  plot(seqh[(poshmin-2):(poshmin+20)],distmah[(poshmin-2):(poshmin+20)],type='l')
#  par(new=T)
#  plot(seqh[(poshmin-2):(poshmin+20)],taxaerro[(poshmin-2):(poshmin+20)],type='l')
# 
# 
# hdma2to1 <- seqh[which.max(distmah2to1)]
# errodma2to1 <- taxaerro[which.max(distmah2to1[lim0:lim1])]
# plot(seqh[lim0:lim1],distmah2to1[lim0:lim1],type='l',ylab="Distância de Mahalanobis",xlab="h")
# 
# errodma <- min(c(errodma1to2,errodma2to1))

#distancia euclidiana entre medias
distmed <- numeric(length=(length(seqh)))
for (i in 1:length(seqh))
{
  #asd <- matmedc1[i] - matmedc2[i]
  distmed[i] <- euclidDist(matmedc1[i,],matmedc2[i,])
}
hdm <- seqh[which.min(distmed)]
errodm <- taxaerro[which(seqh == hdm)]
plot(seqh,distmed,type='l')
#par(new=T)

lims <- poshmin-3#88
limi <- 100

posmedmin <- which.min(distmed[(poshmin-lims):(poshmin+limi)]) + (poshmin-lims-1)
maksimo<-which.max(distmed[posmedmin:length(distmed)])
hmaks<- seqh[maksimo+posmedmin-1]
erromaks[count] <- taxaerro[maksimo+posmedmin-1]
# 
#  plot(seqh[(poshmin-lims):(poshmin+limi)],distmed[(poshmin-lims):(poshmin+limi)],type='l',xlim=c(seqh[poshmin-lims],seqh[poshmin+limi]),ylim=c(0,.4),ylab='',xlab='')
#  par(new=T)
#  plot(seqh[(poshmin-lims):(poshmin+limi)],taxaerro[(poshmin-lims):(poshmin+limi)],type='l',xlim=c(seqh[poshmin-lims],seqh[poshmin+limi]),col='red')
# par(new=T)
# plot(seqh[posmedmin],distmed[posmedmin],xlim=c(seqh[poshmin-lims],seqh[poshmin+limi]),ylim=c(0,.4),ylab='',xlab='')
# par(new=T)
# plot(seqh[maksimo],distmed[maksimo],xlim=c(seqh[poshmin-lims],seqh[poshmin+limi]),ylim=c(0,.4),ylab='',xlab='')


#analise da derivada

derdm <- numeric(tamanho)
zeros <- numeric(tamanho)

for (pos in 1:tamanho)
{
  derdm[pos] <- derivada(lag,pos,seqh)
}

posmaxdev <-maxlocal(derdm)
#  poszero <- which.min(abs(derdm))
posinf <- which.min(abs(derdm[1:posmaxdev]))
possup <- which.min(abs(derdm[posmaxdev:tamanho]))+posmaxdev-1


plot(seqh,derdm,type='l',ylim=c(-1,max(derdm)),xlim=c(0,max(seqh)),xlab="Valor de h",ylab="Derivada da distância euclidiana")
par(new=T)
plot(seqh,zeros,type='l',ylim=c(-1,max(derdm)),xlim=c(0,max(seqh)),xlab="",ylab="",xaxt="n",yaxt="n")
par(new=T)
plot(seqh,taxaerro,xlim=c(0,max(seqh)),xaxt="n",yaxt="n",xlab="",ylab="",col='red',type='l',main=as.character(count))

axis(4)
mtext("Taxa de erro empírico",side=4,line=2)
#legend("topright",col=c("red","blue"),lty=1,legend=c("y1","y2"))

#  abline(v=seqh[posinf],col='blue',pch=22, lty=2)
#  abline(v=seqh[possup],col='blue',pch=22, lty=2)
abline(v=seqh[posmaxdev],col='blue',pch=22, lty=2)

#PRA ALGUNS CASOS, A DERIVADA PRIMEIRA NAO CRUZA O ZERO!!!

erromaxdev[count] <- taxaerro[posmaxdev]
#errozerodev1[count] <- taxaerro[posinf]
#errozerodev2[count] <- taxaerro[possup]

distder2 <- numeric(length=(length(seqh)))

for (pos in 1:tamanho)
{
  distder2[pos] <- derivada(derdm,pos,seqh)
}

plot(seqh,distder2,type='l',ylim=c(min(distder2),3),xlim=c(0,max(seqh)),xlab="Valor de h",ylab="Derivada segunda da distância euclidiana")
par(new=T)
plot(seqh,zeros,type='l',ylim=c(min(distder2),1),xlim=c(0,max(seqh)),xlab="",ylab="",xaxt="n",yaxt="n",col='green')
par(new=T)
plot(seqh,taxaerro,xlim=c(0,max(seqh)),xaxt="n",yaxt="n",xlab="",ylab="",col='red',type='l',main=as.character(count))
axis(4)
posminder2 <- minlocal(distder2)
abline(v=seqh[posminder2],col='blue',pch=22, lty=2)

erroder2[count] <- taxaerro[posminder2]

# #plotcomzoom
# zoom <- posminder2 - poshmin
# 
# plot(seqh[(posminder2-zoom):(posminder2+zoom)],distder2[(posminder2-zoom):(posminder2+zoom)],type='l',xlab="Valor de h",ylab="Derivada da distância euclidiana",xlim=c(seqh[posminder2-zoom],seqh[posminder2+zoom]),ylim=c(min(distder2[(posminder2-zoom):(posminder2+zoom)]),max(distder2[(posminder2-zoom):(posminder2+zoom)])))
# par(new=T)
# plot(seqh[(posminder2-zoom):(posminder2+zoom)],zeros[(posminder2-zoom):(posminder2+zoom)],type='l',xlab="",ylab="",xaxt="n",yaxt="n",ylim=c(min(distder2[(posminder2-zoom):(posminder2+zoom)]),max(distder2[(posminder2-zoom):(posminder2+zoom)])))
# par(new=T)
# plot(seqh[(posminder2-zoom):(posminder2+zoom)],taxaerro[(posminder2-zoom):(posminder2+zoom)],xaxt="n",yaxt="n",xlab="",ylab="",col='red',type='l',main=as.character(count),xlim=c(seqh[posminder2-zoom],seqh[posminder2+zoom]))

# derivada terceira
# 
#   distder3 <- numeric(length=(length(seqh)))
# 
#   for (pos in 1:tamanho)
#   {
#     distder3[pos] <- derivada(distder2,pos,seqh)
#   }
# 
#   plot(seqh,distder3,type='l',ylim=c(-300,300),xlim=c(0,max(seqh)),xlab="Valor de h",ylab="Derivada terceira da distância euclidiana")
#   par(new=T)
#   plot(seqh,zeros,type='l',ylim=c(-300,300),xlim=c(0,max(seqh)),xlab="",ylab="",xaxt="n",yaxt="n")
#   par(new=T)
#   plot(seqh,taxaerro,xlim=c(0,max(seqh)),xaxt="n",yaxt="n",xlab="",ylab="",col='red',type='l',main=as.character(count))
# 
#   abline(v=seqh[which(distder3 == max(distder3[100:tamanho]))],col='blue',pch=22, lty=2)


#covariancia

hcov <- seqh[which.max(matcov)]
errocov <- taxaerro[which.max(matcov)]
plot(seqh,matcov,type='l')

#derivacovs

covder <- numeric(tamanho)
covderc1 <- numeric(tamanho)
covderc2 <- numeric(tamanho)

for (pos in 1:tamanho)
{
  covder[pos] <- derivada(matcov,pos,seqh)
  covderc1[pos] <- derivada(matcovc1,pos,seqh)
  covderc2[pos] <- derivada(matcovc2,pos,seqh)
}

plot(seqh,covderc1,type='l')

posmincov1 <- which.min(covderc1)
errocov1[count] <- taxaerro[posmincov1]

# #relaçao entre medias das verossimilhanças
# relmed <- numeric(length=(length(seqh)))
# 
# for (i in 1:length(seqh))
# {
#   relmedc1 <- matmedc1[i,1]/matmedc1[i,2]
#   relmedc2 <- matmedc2[i,2]/matmedc2[i,1]
#   
#   relmed[i] <- relmedc1*relmedc2
# }
# plot(seqh,relmed,type='l')
# hrm <- seqh[which.max(relmed)]
# errorm <- taxaerro[which.max(relmed)]
# 
#relaçao entre variancias das verossimilhanças
relvar <- numeric(length=(length(seqh)))

for (i in 1:length(seqh))
{
  relvarc1 <- matvarc1[i,1]/matvarc1[i,2]
  relvarc2 <- matvarc2[i,1]/matvarc2[i,2]
  relvar[i] <- relvarc1*relvarc2
}
plot(seqh,relvar,type='l')
hrv <- seqh[which.max(relvar)]
errorv <- taxaerro[which(seqh == hrv)]
# 
# #relacao media/variancia
# relmedvar <- numeric(length=(length(seqh)))
# 
# for (i in 1:length(seqh))
# {
#   relmedvarc1 <- matmedc1[i,1]/(matmedc1[i,2]*matvarc1[i,2])
#   relmedvarc2 <- matmedc2[i,1]/(matmedc1[i,2]*matvarc2[i,2])
#   relmedvar[i] <- relmedvarc1*relmedvarc2
# }
# 
# plot(seqh,relmedvar,type='l')
# hrmv <- seqh[which.max(relmedvar[1:500])]
# errormv <- taxaerro[which.max(relmedvar[1:500])]
# 
# #distancia das medias à reta unitaria
dmedc1 <- numeric(length = length(seqh))
dmedc2 <- numeric(length = length(seqh))

for (i in 1:length(seqh))
{
  dmedc1[i] <- dist2d(matmedc1[i,],c(0,0),c(0,1))
  dmedc2[i] <- dist2d(matmedc2[i,],c(0,0),c(0,1))
}
plot(seqh,dmedc1,type='l')

hdret <- seqh[which.min(dmedc1)]
errodret[count] <- taxaerro[which.min(dmedc1)]

#analise de variancias 
plot(seqh,matvarc1[,2],type='l')

hvar2 <- seqh[which.max(matvarc1[,2])]
errovar2 <- taxaerro[which.max(matvarc1[,2])]

plot(seqh,matvarc1[,1],type='l')

hvar1 <- seqh[which.max(matvarc1[,1])]
errovar1 <- taxaerro[which.max(matvarc1[,1])]
# 
# plot(seqh,matvarc2[,2],type='l')
# plot(seqh,matvarc2[,1],type='l')

#derivada das variancias 

# varder11 <- numeric(tamanho)
# varder12 <- numeric(tamanho)
# varder21 <- numeric(tamanho)
# varder22 <- numeric(tamanho)
# 
# varder112 <- numeric(tamanho)
# varder122 <- numeric(tamanho)
# varder212 <- numeric(tamanho)
# varder222 <- numeric(tamanho)
#  
# for (pos in 1:tamanho)
# {
#   varder11[pos] <- derivada(matvarc1[,1],pos,seqh)
#   varder12[pos] <- derivada(matvarc1[,2],pos,seqh)
#   varder21[pos] <- derivada(matvarc2[,1],pos,seqh)
#   varder22[pos] <- derivada(matvarc2[,2],pos,seqh)
# }
# 
# for (pos in 1:tamanho)
# {
#   varder112[pos] <- derivada(varder11,pos,seqh)
#   varder122[pos] <- derivada(varder12,pos,seqh)
#   varder212[pos] <- derivada(varder21,pos,seqh)
#   varder222[pos] <- derivada(varder22,pos,seqh)
# }
# 
# plot(seqh,varder112,type='l')#,xlim=c(seqh[20],seqh[100]))
# 
# posminder122 <- which.min(varder122)
# errominder122[count] <- taxaerro[posminder122]
# asd<-20
# if (poshmin < 20)
# {
#   asd <-poshmin
# }
# posminder11 <- which.min(varder11[((poshmin-asd):(poshmin+20))]) + poshmin-21
# errominder11[count] <- taxaerro[posminder11]
# abline(v=seqh[posminder11],col='blue',pch=22, lty=2)
#VARIANCIA NAO TEM COMPORTAMENTO REGULAR PARA TODAS AS BASES!!!!!
}

# globaldma <- mean(errodma-erromin)
# globaldm <- mean(errodm-erromin)
# globalrm <- mean(errorm-erromin)
# globalrv <- mean(errorv-erromin)
# globalrmv <- mean(errormv-erromin)
# globalvar1 <- mean(errovar1-erromin)
# globalvar2 <- mean(errovar2-erromin)
# globaldret <- mean(errodret-erromin)
# globalcov <- mean(errocov-erromin)
# 
# errotot <- matrix(nrow=10,ncol=ntestes+1)
# errotot[1,1:ntestes] <- erromin
# errotot[1,ntestes+1] <- mean(erromin)
# errotot[2,1:ntestes] <- errodma
# errotot[2,ntestes+1] <- globaldma
# errotot[3,1:ntestes] <- errodm
# errotot[3,ntestes+1] <- globaldm
# errotot[4,1:ntestes] <- errorm
# errotot[4,ntestes+1] <- globalrm
# errotot[5,1:ntestes] <- errorv
# errotot[5,ntestes+1] <- globalrv
# errotot[6,1:ntestes] <- errormv
# errotot[6,ntestes+1] <- globalrmv
# errotot[7,1:ntestes] <- errovar1
# errotot[7,ntestes+1] <- globalvar1
# errotot[8,1:ntestes] <- errovar2
# errotot[8,ntestes+1] <- globalvar2
# errotot[9,1:ntestes] <- errodret
# errotot[9,ntestes+1] <- globaldret
# errotot[10,1:ntestes] <- errocov
# errotot[10,ntestes+1] <- globalcov

#erroabs <- numeric(length=nrow(errotot))

#erroabs[2:10] <- errotot[2:10,11] + errotot[1,11]
#erroabs[1] <- errotot[1,11]



#nomes <- c("minimo","mahalanobis","distmedias","rel-medias","rel-var","rel-medvar","var-11","var-12","distreta","cov")

nomes <- c("minimo", "distmedias", "distmax", "distder_max", "distder_zero1","distder_zero2","distreta","der2")
erros <- rbind(erromin,erromaxdev,errozerodev1,errozerodev2,errodret,erroder2)
erros <- cbind(erros,rowMeans(erros))
sub <- erros[2:nrow(erros),(ntestes+1)] - erros[1,(ntestes+1)]

#ordem <- nomes[order(erroabs)]

#errototchar <- matrix((as.character(errotot)),ncol=11)
#errosss<-cbind(errototchar,nomes)

#write.csv(erros,"erroCircle.csv")

#plot(erroabs,type='b')
# 1-errominimo
# 2-dist de mahalanobis media-conj
# 3-dist euc entre medias
# 4-relação de medias
# 5-relação de variancias
# 6-relação med-var
# 7-variancia classe 1 eixo 1
# 8-variancia classe 1 eixo 2
# 9-distancia reta unitaria
# 10-covariancia
  #15: norm, pima, spir, circle, breastcancer, housevotes
  subtot <- rbind(subbc,subcirc,subpima,subnorm,subspir,subhvotes)
#subtot <- subtot[,3:10]
medtotal <- colMeans(subtot)*100
#  submedsbc <- (colSums(subtot[2:6,])/nrow(subtot[2:6,]))*100

total <- rbind(subtot,medtotal)