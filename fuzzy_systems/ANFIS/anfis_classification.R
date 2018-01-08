rm(list=ls())

require(e1071)
require(R.matlab)
setwd("/home/murilo/Documentos/Nebulosos/tp3")

mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

bellFunc <- function(x,m,sig){
  return(exp(-.5 * (x-m)^2/(sig)^2))
}

der_bellFunc_m <- function(x,m,sig){
  return((x-m)*bellFunc(x,m,sig)/(sig^2))
}

der_bellFunc_sig <- function(x,m,sig){
  return((x-m)^2 *bellFunc(x,m,sig)/(sig^3))
}

eval_sugeno <- function(x,input_mfs,output_mfs){
  # resp <- c()
  # for (i in 1:nrow(x)){
    # ind_c1 <- which(output_mfs==1)
    # sum_c1 <- 0
    # sum_c0 <- 0
    ws <- c()
    cons <- c()
    # print(input_mfs)
    # print(output_mfs)
    for (j in 1:nrow(input_mfs[[1]])){
      thisRule <- bellFunc(x[1],input_mfs[[1]][j,1],input_mfs[[1]][j,2]) *
        bellFunc(x[2],input_mfs[[2]][j,1],input_mfs[[2]][j,2])
      ws <- c(ws,thisRule)
      cons <- c(cons,x[1]*output_mfs[j,1] + x[2]*output_mfs[j,2] + output_mfs[j,3])
      # if (output_mfs[j] == 1){
      #   sum_c1 <- sum_c1 + thisRule
      # } else{
      #   sum_c0 <- sum_c0 + thisRule
      # }
    }
    ans <- (cons %*% ws)/sum(ws)
    # ans <- 1*(ans > .5)
    # resp <- c(resp,ans)
  # }
  return(ans)
}

anfis <- function(data,params,lr){
  in1 <- params[[1]]
  in2 <- params[[2]]
  out <- params[[3]]
  
  for (count in 1:200){
    for (i in 1:nrow(data)){
      
      resp <- eval_sugeno(data[i,-ncol(data)],list(in1,in2),out)
      
      erro <- data[i,ncol(data)] - resp
      
      # cat(sprintf("Resposta: %f; Verdadeiro: %f\n",resp,data[i,ncol(data)]))
      newin1 <- in1
      newin2 <- in2
      newout <- out
      
      ws <- c()
      cons <- c()
      for (j in 1:nrow(in1)){
        
        thisRule <- bellFunc(x[i,1],in1[j,1],in1[j,2]) *
          bellFunc(x[i,2],in2[j,1],in2[j,2])
        ws <- c(ws,thisRule)
        cons <- c(cons,x[i,1]*out[j,1] + x[i,2]*out[j,2] + out[j,3])
      }
      # if (count == 1){
      #   print(resp)
      #   print(erro)
      # }
      for (rl in 1:nrow(in1)){
        f <- ws %*% cons#sum_c1
        g <- sum(ws)
        
        g_linha_m1 <- der_bellFunc_m(x[i,1],in1[rl,1],in1[rl,2]) * 
          bellFunc(x[i,2],in2[rl,1],in2[rl,2])
        g_linha_m2 <- bellFunc(x[i,1],in1[rl,1],in1[rl,2]) * 
          der_bellFunc_m(x[i,2],in2[rl,1],in2[rl,2])
        g_linha_sig1 <- der_bellFunc_sig(x[i,1],in1[rl,1],in1[rl,2]) * 
          bellFunc(x[i,2],in2[rl,1],in2[rl,2])
        g_linha_sig2 <- bellFunc(x[i,1],in1[rl,1],in1[rl,2]) * 
          der_bellFunc_sig(x[i,2],in2[rl,1],in2[rl,2])
        
        consequente <- out[rl,1]*x[i,1] + out[rl,2]*x[i,2] + out[rl,3]
        
        # if (resp_this == 1){
          f_linha_m1 <- g_linha_m1*consequente
          f_linha_m2 <- g_linha_m2*consequente
          f_linha_sig1 <- g_linha_sig1*consequente
          f_linha_sig2 <- g_linha_sig2*consequente
        # }
        
        newin1[rl,1] <- newin1[rl,1] + lr*erro*((g*f_linha_m1 - f*g_linha_m1)/(g^2))
        newin1[rl,2] <- newin1[rl,2] + lr*erro*((g*f_linha_sig1 - f*g_linha_sig1)/(g^2))
        newin2[rl,1] <- newin2[rl,1] + lr*erro*((g*f_linha_m2 - f*g_linha_m2)/(g^2))
        newin2[rl,2] <- newin2[rl,2] + lr*erro*((g*f_linha_sig2 - f*g_linha_sig2)/(g^2))
        
        newout[rl,1] <- newout[rl,1] + lr*erro*(ws[rl]*x[i,1]/sum(ws))
        newout[rl,2] <- newout[rl,2] + lr*erro*(ws[rl]*x[i,2]/sum(ws))
        newout[rl,3] <- newout[rl,3] + lr*erro*(ws[rl]/sum(ws))
      }
      
      in1 <- newin1
      in2 <- newin2
      out <- newout
      
    }
  }
  return(list(in1,in2,out))
}
  
dataset <- readMat("dataset_2d.mat")
x <- dataset$x
y <- dataset$y

indexes <- sample(nrow(x))
x_test <- x[indexes[1:30],]
x_train <- x[indexes[31:100],]
y_test <- y[indexes[1:30]]
y_train <- y[indexes[31:100]]

n_folds <- 10
folds_cv <- split(sample(nrow(x_train)),1:n_folds)
lr_range <- 2^seq(-10,0,1)
nrules_range <- seq(2,10,1)
best_tune <- c(0,0)
best_acc <- 0

for (lr in lr_range){
  for (nr in nrules_range){
    this_acc <- c()
    for (fold in 1:n_folds){
      xTrain <- x_train[-folds_cv[[fold]],]
      xTest <- x_train[folds_cv[[fold]],]
      yTrain <- y_train[-folds_cv[[fold]]]
      yTest <- y_train[folds_cv[[fold]]]
      
      clust <- cmeans(xTrain,nr)
      centers <- clust$centers
      members <- clust$cluster
      
      var1_mfs <- matrix(nrow=nr,ncol=2)
      var2_mfs <- matrix(nrow=nr,ncol=2)
      
      out_funcs <- matrix(nrow=nr,ncol=3)
      
      for (i in 1:nr){
        ici <- which(members == i)
        major <- mode(yTrain[ici])
        dispersion1 <- sd(xTrain[ici,1])
        dispersion2 <- sd(xTrain[ici,2])
        var1_mfs[i,1] <- centers[i,1]
        var1_mfs[i,2] <- dispersion1
        var2_mfs[i,1] <- centers[i,2]
        var2_mfs[i,2] <- dispersion2
        
        out_funcs[i,] <- c(0,0,major)
      }
      
      opt_params <- anfis(cbind(xTrain,yTrain),list(var1_mfs,var2_mfs,out_funcs),lr)
      var1_mfs <- opt_params[[1]]
      var2_mfs <- opt_params[[2]]
      out_funcs <- opt_params[[3]]
      
      preds <- apply(xTest,1,eval_sugeno,input_mfs=list(var1_mfs,var2_mfs),output_mfs=out_funcs)
      preds <- 1*(preds > .5)
      acc <- sum(preds == yTest)/length(preds)
      this_acc <- c(this_acc,acc)
    }
    if (mean(this_acc) > best_acc){
      best_acc <- mean(this_acc)
      best_tune <- c(lr,nr)
    }
  }
}
