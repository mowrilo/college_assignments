# Method of regularization of RBF Networks, inspired by Support Vector
# Machines.
# All of the samples are used as centers, with different regularization
# intensity for each one.
#
# Author: Murilo V. F. Menezes

rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

source("/home/murilo/Documentos/litc/rbf/RBF/newrbf/CScore.R")
source("/home/murilo/Documentos/litc/rbf/RBF/newrbf/dispAllScore.R")
library(MASS)
library(mlbench)

rbf <- function(dataTrain,dataTest,lambda,norm=0,useScores=0){
  
  norm <- function(x){return(sqrt(sum(x^2)))}
  
  rbf_func <- function(x,c,sig){
    return(exp(-1/2 * (norm(x-c)/(2*sig))^2))
  }
  N <- nrow(dataTrain)
  
  y_train <- dataTrain[,ncol(dataTrain)]
  
  ############################ Definição de centros ##################################################
  
  centros <- dataTrain[,-ncol(dataTrain)]
  labelsTrain <- dataTrain[,ncol(dataTrain)]
  sigma <- findSigmaALL(centros,labelsTrain)
  n_neurons <- nrow(centros)
  
  scores <- scoreC(centros,labelsTrain,sigma)
  # centros <- dataTrain[order(scores,decreasing = T)[1:n_neurons],-ncol(dataTrain)]
  
  scores <- 1 - ((scores-min(scores))/(max(scores)-min(scores)))
  ############################### Treinamento da segunda camada #################################################
  saidas <- matrix(nrow=N,ncol=n_neurons)
  for (i in 1:N){ #Mapeia os neurônios
    for (j in 1:n_neurons){
      saidas[i,j] <- rbf_func(dataTrain[i,-ncol(dataTrain)],centros[j,],sigma)
    }
  }
  # saidas <- cbind(saidas,dataTrain[,ncol(dataTrain)])
  lambda <- 30
  L <- lambda * diag(scores)#diag(n_neurons)#
  A <- t(saidas) %*% saidas + L
  # tr(L)
  # gamma <- n_neurons - lambda*sum(diag(solve(A)))
  
  w <- solve(A) %*% t(saidas) %*% y_train
  y_test <- dataTest[,ncol(dataTest)]
  Nt <- nrow(dataTest)
  H_test <- matrix(nrow=Nt,ncol=n_neurons)
  for (i in 1:Nt){ #Mapeia os neurônios
    for (j in 1:n_neurons){
      H_test[i,j] <- rbf_func(dataTest[i,-ncol(dataTest)],centros[j,],sigma)
    }
  }
  
  resp <- H_test %*% w
  predictions <- sign(resp)
  return(predictions)
}
# sum(predictions == y_test)/length(y_test)
# gamma
