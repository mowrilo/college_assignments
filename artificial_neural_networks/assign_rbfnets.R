rm(list=ls())

x <- data.matrix(seq(-10,10,.1))
N <- nrow(x)
y <- sin(x)/x + rnorm(N,0,.05)
y[which(x == 0)] <- 1

plot(x,y,xlim=c(-10,10),ylim=c(-.3,1.1))

nRBFs <- 40
centers <- data.matrix(seq(-10,10,(20/(nRBFs-1))))
sigma <- 1

H <- matrix(nrow=N,ncol=nRBFs)
for (rbf in 1:nRBFs){
    H[,rbf] <- exp(-1/2 * ((x-centers[rbf])^2/(sigma^2)))
}
lambda <- 1e-12
L <- lambda * diag(nRBFs)
A <- t(H) %*% H + L
print(A)
P <- (diag(N) - H %*% solve(A) %*% t(H))
print(P)
w <- (solve(A) %*% t(H)) %*% y

y_hat <- H %*% w
par(new=T)
plot(x,y_hat,'l',col='red',xlim=c(-10,10),ylim=c(-.3,1.1),ylab='')

lambda <- .5
L <- lambda * diag(nRBFs)
A <- t(H) %*% H + L
print(A)
P <- (diag(N) - H %*% solve(A) %*% t(H))
print(P)
w <- (solve(A) %*% t(H)) %*% y

y_hat <- H %*% w
par(new=T)
plot(x,y_hat,'l',col='blue',xlim=c(-10,10),ylim=c(-.3,1.1),ylab='')

#LOO

mode <- function(x){
    unique(x)[which.max(tabulate(match(x, unique(x))))]
}

seq_lambda <- c(0,2^seq(-3,4,1))
indexes <- 1:round(N/30)
smp <- split(sample(N),1:30)
lambdas_loo <- c()
lambdas_cv <- c()
for (i in 1:30){
    
    x_test <- x[smp[[i]]]
    y_test <- y[smp[[i]]]
    x_train <- x[-smp[[i]]]
    y_train <- y[-smp[[i]]]
    N_train <- length(x_train)
    
    loocv <- c()
    testmse <- c()
    
    for (lambda in seq_lambda){
        
        H_train <- matrix(nrow=N_train,ncol=nRBFs)
        H_test <- matrix(nrow=(N-N_train),ncol=nRBFs)
        for (rbf in 1:nRBFs){
            H_train[,rbf] <- exp(-1/2 * ((x_train-centers[rbf])^2/(sigma^2)))
            H_test[,rbf] <- exp(-1/2 * ((x_test-centers[rbf])^2/(sigma^2)))
        }
        
        L <- lambda * diag(nRBFs)
        A <- t(H_train) %*% H_train + L
        P <- (diag(N_train) - H_train %*% solve(A) %*% t(H_train))
        loo <- 1/N * (t(y_train) %*% P) %*% ((P %*% y_train)/(diag(P)^2))
        loocv <- c(loocv,loo)
        
        w <- (solve(A) %*% t(H_train)) %*% y_train
        y_hat <- H_test %*% w
        test_mse <- sum((y_test-y_hat)^2)/(N-N_train)
        testmse <- c(testmse,test_mse)
    }
    
    lambdas_cv <- c(lambdas_cv,seq_lambda[which.min(testmse)])
    lambdas_loo <- c(lambdas_loo,seq_lambda[which.min(loocv)])
}

#Numero efetivo de parametros

moda_loo <- mode(lambdas_loo)
lambda <- moda_loo
L <- lambda * diag(nRBFs)
A <- t(H) %*% H + L
gamma <- nRBFs - lambda*sum(diag(solve(A)))
nRBFs_eff <- round(gamma)

indexes <- 1:round(N/30)
smp <- split(sample(N),1:30)
reg <- c()
nao_reg <- c()
for (i in 1:30){
    
    x_test <- x[smp[[i]]]
    y_test <- y[smp[[i]]]
    x_train <- x[-smp[[i]]]
    y_train <- y[-smp[[i]]]
    N_train <- length(x_train)
    
    lambda_reg <- moda_loo
    lambda_naoreg <- 0
    
    H_train <- matrix(nrow=N_train,ncol=nRBFs)
    H_test <- matrix(nrow=(N-N_train),ncol=nRBFs)
    for (rbf in 1:nRBFs){
        H_train[,rbf] <- exp(-1/2 * ((x_train-centers[rbf])^2/(sigma^2)))
        H_test[,rbf] <- exp(-1/2 * ((x_test-centers[rbf])^2/(sigma^2)))
    }
    
    L <- lambda_reg * diag(nRBFs)
    A <- t(H_train) %*% H_train + L
    P <- (diag(N_train) - H_train %*% solve(A) %*% t(H_train))
    
    w <- (solve(A) %*% t(H_train)) %*% y_train
    y_hat <- H_test %*% w
    test_mse <- sum((y_test-y_hat)^2)/(N-N_train)
    reg <- c(reg,test_mse)
    
    #######################
    
    centers_eff <- data.matrix(seq(-10,10,(20/(nRBFs_eff-1))))
    
    H_train <- matrix(nrow=N_train,ncol=nRBFs_eff)
    H_test <- matrix(nrow=(N-N_train),ncol=nRBFs_eff)
    for (rbf in 1:nRBFs_eff){
        H_train[,rbf] <- exp(-1/2 * ((x_train-centers_eff[rbf])^2/(sigma^2)))
        H_test[,rbf] <- exp(-1/2 * ((x_test-centers_eff[rbf])^2/(sigma^2)))
    }
    
    L <- lambda_naoreg * diag(nRBFs_eff)
    A <- t(H_train) %*% H_train + L
    P <- (diag(N_train) - H_train %*% solve(A) %*% t(H_train))
    
    w <- (solve(A) %*% t(H_train)) %*% y_train
    y_hat <- H_test %*% w
    test_mse <- sum((y_test-y_hat)^2)/(N-N_train)
    nao_reg <- c(nao_reg,test_mse)
}

erro_regularizado <- mean(reg)
erro_naoregularizado <- mean(nao_reg)