# removal of overlapping data using Gabriel Graphs,
# to improve MLP performance on imbalanced data
#
# Author: Murilo V. F. Menezes

rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

library(plot3D)
library(rgl)
library(MASS)
library(cccd)
library(mlbench)
library(Rcpp)
source("~/Documentos/litc/rbf/RBF/newrbf/Modelos/dispAllScore.R")
sourceCpp("~/Documentos/litc/rbf/RBF/newrbf/Modelos/kde.cpp")
outputLayer <- "nlinear"

der_tanh <- function(x){
  return(1 - tanh(x)^2)
  # return(cos(x))
}

ident <- function(x){
  return(x)
}

der_lin <- function(x){
  return(rep(1,length(x)))
}

if (outputLayer == "nlinear"){
  der <- der_tanh
  finalFunc <- tanh
} else{
  der <- der_lin
  finalFunc <- ident
}

# th <- 0

data("PimaIndiansDiabetes")
dataAll <- PimaIndiansDiabetes
dataAll$diabetes <- (as.numeric(dataAll$diabetes)*2)-(min(as.numeric(dataAll$diabetes)*2))-1
# data("Glass")
# dataAll <- Glass
# dataAll$Type <- as.numeric(dataAll$Type)
# dataAll$Type[which(dataAll$Type != 6)] <- -1
# dataAll$Type[which(dataAll$Type == 6)] <- 1
for (i in 1:ncol(dataAll[,-ncol(dataAll)])){
  dataAll[,i] <- (dataAll[,i] - min(dataAll[,i]))/(max(dataAll[,i])-min(dataAll[,i]))
}
dataAll <- cbind(1,dataAll)


plot(matrix(c(3.9,4.1,4,4),ncol=2),xlab='X1',ylab='X2',xlim=c(3.7,4.3),ylim=c(3.7,4.2),
     col='red')
draw.circle(4,4,.1,nv=1000,border=NULL,col=NA,lty=1,lwd=1)




ncpos <- 50
ncneg <- 500
y <- c()
y <- c(y,rep(1,ncpos))
y <- c(y,rep(-1,ncneg))
xpos <- mvrnorm(ncpos, c(2.2,2.2),diag(.5,2))
xneg <- mvrnorm(ncneg, c(4,4),diag(1,2))
x <- rbind(xpos,xneg)

plot(x[which(y==-1),],xlim=c(-1,7),ylim=c(-1,7),col='red',xlab="X1",ylab="X2")
par(new=T)
plot(x[which(y==1),],xlim=c(-1,7),ylim=c(-1,7),col='blue',xlab="",ylab="")
# dataAll <- as.data.frame(cbind(1,x,y))
a <- sample(1:nrow(dataAll))
parts <- split(a,factor(sort(a %% 4)))
data <- dataAll[c(parts[[1]],parts[[3]],parts[[2]]),]
dataTest <- dataAll[parts[[4]],]
data2 <- data[,-c(1,ncol(data))]
# dataVal <- dataAll[parts[[4]],]

# G <- gg(data)
# adj <- get.adjacency(G)
# cls <- c(1,-1)#unique(data[,ncol(data)])
props <- c(1 - sum(data[,ncol(data)]==1)/nrow(data),1 - sum(data[,ncol(data)]==-1)/nrow(data))
# 
# # for (c in cls[order(props,decreasing = T)]){
# c <- cls[order(props,decreasing = T)][1]
#   quais <- which(data[,ncol(data)] == c)
#   sums <- rowSums(adj[which(data[,ncol(data)] == c),])
#   sumsN <- rowSums(adj[which(data[,ncol(data)] == c),which(data[,ncol(data)] != c)])
#   tira <- quais[(sumsN >= (sums/3))]
#   data <- data[-tira,]
# }



# plot(data[which(data[,ncol(data)]==-1),-c(1,4)],xlim=c(-1,7),ylim=c(-1,7),col='red')
# par(new=T)
# plot(data[which(data[,ncol(data)]==1),-c(1,4)],xlim=c(-1,7),ylim=c(-1,7),col='blue')

# props <- c(1-sum(data$diabetes==1)/nrow(data),1-sum(data$diabetes==-1)/nrow(data))
print(props)
nOutLayers <- 1
# hiddens <- c(3,5,7)
# nNeur <- c(8,10,12)
# accs <- matrix(nrow=length(hiddens),ncol=length(nNeur))
ch <- 0
nn <- 3#ncol(data)
nhid <- 1
# for (nhid in hiddens){
#   ch <- ch+1
#   cn <- 0
#   for (nn in nNeur){
#     cn <- cn+1
cat(sprintf("Number of hidden layers: %d\nNumber of neurons on each layer: %d\n",
            nhid,nn))
w <- list()
# nhidden <- rep(nn,nhid)
nhidden <- c(5,5,3)
nhidlayers <- length(nhidden)
set.seed(10)
for (i in 1:nhidlayers){
  if (i ==1){
    w[[i]] <- matrix(runif(nhidden[i]*(ncol(data)-1),min = -.5,max=.5),nrow=nhidden[i],ncol=ncol(data)-1)
  } else{
    w[[i]] <- matrix(runif(nhidden[i]*(nhidden[i-1]+1),min = -.5,max=.5),nrow=nhidden[i],ncol=nhidden[i-1]+1)
  }
}
w[[nhidlayers+1]] <- matrix(runif(nhidden[nhidlayers]+1,min = -.5,max=.5),nrow=nOutLayers,ncol=nhidden[nhidlayers]+1)


eta <- .01
count <- 0
maxcount <- 1000
error <- c(Inf)
ci <- 1
cont <- T

while ((count < maxcount) & (cont)){
  count <- count+1
  data <- data[sample(nrow(data)),]
  error2 <- numeric(nOutLayers)
  # cat(sprintf("Epoch: %d\n",count))
  
  for (i in 1:nrow(data)){
    # Propagating
    datum <- list(t(as.matrix(data[i,-ncol(data)])))
    for (j in 1:(length(w)-1)){
      datum[[j+1]] <- as.matrix(c(1,tanh(w[[j]] %*% datum[[j]])))
    }
    datum[[length(w)+1]] <- finalFunc(w[[length(w)]] %*% datum[[length(w)]])
    if (any(is.nan(datum[[j+1]]))){
      break()
    }
    resp <- datum[[length(datum)]]
    class <- numeric(nOutLayers)
    class[data[i,ncol(data)]] <- 1
    erro <- class  - resp
    if (class == 1){
      prop <- props[1]
    } else{
      prop <- props[2]
    }
    error2 <- error2 + erro^2
    delta <- list()
    delta[[nhidlayers+1]] <- erro*der(w[[length(w)]] %*% datum[[length(w)]])
    for (j in length(w):1){
      w[[j]] <- w[[j]] + eta* (delta[[j]] %*% t(datum[[j]]))#*log(prop+2)#exp(1)
      if (j != 1){
        a <- as.matrix(w[[j]][,-1])
        if (ncol(a) != 1){
          a <- t(a)
        }
        delta[[j-1]] <- (a %*% delta[[j]]) * der_tanh(w[[j-1]] %*% datum[[j-1]])
      }
    }
  }
  
  error2 <- error2/nrow(data)
  ci <- ci+1
  error <- c(error,sum(abs(error2)))
  
  if (sum(abs(error2)) < .01){
    cont <- F
  }
 if (!(count %% 10)){
   # plot(error,type='l',xlim=c(0,maxcount),xlab='epoch')
 }
}

seqth <- seq(1,-1,-.1)
fprate <- c()
tprate <- c()

for (th in seqth){
  
  tp <- 0
  fp <- 0
  
  for (i in 1:nrow(dataTest)){
    datum <- list(t(as.matrix(dataTest[i,-ncol(dataTest)])))
    for (j in 1:(length(w)-1)){
      datum[[j+1]] <- as.matrix(c(1,tanh(w[[j]] %*% datum[[j]])))
    }
    resp <- finalFunc(w[[length(w)]] %*% datum[[length(w)]])
    # opts <- c(-1,1)
    class <- (resp > th)*1
    if (class == 0){class <- -1}
    # print(class)
    
  #   nerror <- nerror + 1*(class != dataTest[i,ncol(dataTest)])
    if ((dataTest[i,ncol(dataTest)] == 1) & (class == 1)){
      tp <- tp + 1
    }
    if ((dataTest[i,ncol(dataTest)] == -1) & (class == 1)){
      fp <- fp + 1
    }
  }
  
  tprate <- c(tprate, tp/sum(dataTest[,ncol(dataTest)] == 1))
  fprate <- c(fprate, fp/sum(dataTest[,ncol(dataTest)] == -1))
  
  # acc <- 1 - nerror/nrow(dataTest)
  # print(acc)
}
plot(fprate,tprate,type='l',xlim=c(-.2,1.2),ylim=c(-.2,1.2))

# fprate <- rev(fprate)
# tprate <- rev(tprate)

auc <- 0

for (i in 1:(length(fprate)-1)){
  auc <- auc + (fprate[i+1] - fprate[i])*(tprate[i] + tprate[i+1])/2
}

# cat(sprintf("AUC: %f\n",auc))
aucSo <- auc
#     accs[ch,cn] <- acc
#   }
# }

G <- gg(data)
adj <- get.adjacency(G)
cls <- c(1,-1)#unique(data[,ncol(data)])
props <- c(1 - sum(data[,ncol(data)]==1)/nrow(data),1 - sum(data[,ncol(data)]==-1)/nrow(data))

# for (c in cls[order(props,decreasing = T)]){
c <- cls[order(props)][1]
quais <- which(data[,ncol(data)] == c)
sums <- rowSums(adj[which(data[,ncol(data)] == c),])
sumsN <- rowSums(adj[which(data[,ncol(data)] == c),which(data[,ncol(data)] != c)])
tira <- quais[(sumsN >= (sums/2))]
data <- data[-tira,]
# D <- data[,ncol(data)]
# data2 <- data[,-c(1,ncol(data))]
# datacp <- data2[which(D==1),]
# datacn <- data2[which(D==-1),]
# databkp <- data
# sig <- findSigmaALL(as.matrix(data2),as.numeric(D))
# quais <- order(myKde(as.matrix(datacn),as.matrix(datacn),sig),decreasing = T)[1:(nrow(datacp)*2)]
# datacn <- datacn[quais,]
# data <- cbind(1,rbind(cbind(datacp,Type=1),cbind(datacn,Type=-1)))
# data <- data[sample(nrow(data)),]

# plot(data[which(data[,ncol(data)] == -1),-c(1,ncol(data))],xlim=c(-1,7),ylim=c(-1,7),col='red')
# par(new=T)
# plot(data[which(data[,ncol(data)] == 1),-c(1,ncol(data))],xlim=c(-1,7),ylim=c(-1,7),col='blue')

w <- list()
# nhidden <- rep(nn,nhid)
nhidden <- c(5,5,3)
nhidlayers <- length(nhidden)
set.seed(10)
for (i in 1:nhidlayers){
  if (i ==1){
    w[[i]] <- matrix(runif(nhidden[i]*(ncol(data)-1),min = -.5,max=.5),nrow=nhidden[i],ncol=ncol(data)-1)
  } else{
    w[[i]] <- matrix(runif(nhidden[i]*(nhidden[i-1]+1),min = -.5,max=.5),nrow=nhidden[i],ncol=nhidden[i-1]+1)
  }
}
w[[nhidlayers+1]] <- matrix(runif(nhidden[nhidlayers]+1,min = -.5,max=.5),nrow=nOutLayers,ncol=nhidden[nhidlayers]+1)


eta <- .01
count <- 0
maxcount <- 1000
error <- c(Inf)
ci <- 1
cont <- T

while ((count < maxcount) & (cont)){
  count <- count+1
  data <- data[sample(nrow(data)),]
  error2 <- numeric(nOutLayers)
  # cat(sprintf("Epoch: %d\n",count))
  
  for (i in 1:nrow(data)){
    # Propagating
    datum <- list(t(as.matrix(data[i,-ncol(data)])))
    for (j in 1:(length(w)-1)){
      datum[[j+1]] <- as.matrix(c(1,tanh(w[[j]] %*% datum[[j]])))
    }
    datum[[length(w)+1]] <- finalFunc(w[[length(w)]] %*% datum[[length(w)]])
    if (any(is.nan(datum[[j+1]]))){
      break()
    }
    resp <- datum[[length(datum)]]
    class <- numeric(nOutLayers)
    class[data[i,ncol(data)]] <- 1
    erro <- class  - resp
    if (class == 1){
      prop <- props[1]
    } else{
      prop <- props[2]
    }
    error2 <- error2 + erro^2
    delta <- list()
    delta[[nhidlayers+1]] <- erro*der(w[[length(w)]] %*% datum[[length(w)]])
    for (j in length(w):1){
      w[[j]] <- w[[j]] + eta* (delta[[j]] %*% t(datum[[j]]))#*log2(prop+1.5)#exp(1)
      if (j != 1){
        a <- as.matrix(w[[j]][,-1])
        if (ncol(a) != 1){
          a <- t(a)
        }
        delta[[j-1]] <- (a %*% delta[[j]]) * der_tanh(w[[j-1]] %*% datum[[j-1]])
      }
    }
  }
  
  error2 <- error2/nrow(data)
  ci <- ci+1
  error <- c(error,sum(abs(error2)))
  
  if (sum(abs(error2)) < .001){
    cont <- F
  }
  if (!(count %% 10)){
    # plot(error,type='l',xlim=c(0,maxcount),xlab='epoch')
  }
}

seqth <- seq(1,-1,-.1)
fprate <- c()
tprate <- c()

for (th in seqth){
  
  tp <- 0
  fp <- 0
  
  for (i in 1:nrow(dataTest)){
    datum <- list(t(as.matrix(dataTest[i,-ncol(dataTest)])))
    for (j in 1:(length(w)-1)){
      datum[[j+1]] <- as.matrix(c(1,tanh(w[[j]] %*% datum[[j]])))
    }
    resp <- finalFunc(w[[length(w)]] %*% datum[[length(w)]])
    # opts <- c(-1,1)
    class <- (resp > th)*1
    if (class == 0){class <- -1}
    # print(class)
    
    #   nerror <- nerror + 1*(class != dataTest[i,ncol(dataTest)])
    if ((dataTest[i,ncol(dataTest)] == 1) & (class == 1)){
      tp <- tp + 1
    }
    if ((dataTest[i,ncol(dataTest)] == -1) & (class == 1)){
      fp <- fp + 1
    }
  }
  
  tprate <- c(tprate, tp/sum(dataTest[,ncol(dataTest)] == 1))
  fprate <- c(fprate, fp/sum(dataTest[,ncol(dataTest)] == -1))
  
  # acc <- 1 - nerror/nrow(dataTest)
  # print(acc)
}
plot(fprate,tprate,type='l',xlim=c(-.2,1.2),ylim=c(-.2,1.2))

# fprate <- rev(fprate)
# tprate <- rev(tprate)

auc <- 0

for (i in 1:(length(fprate)-1)){
  auc <- auc + (fprate[i+1] - fprate[i])*(tprate[i] + tprate[i+1])/2
}

cat(sprintf("AUC: %f\nAUC enhanced: %f\n",aucSo,auc))
