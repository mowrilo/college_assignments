rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

library(plot3D)

x <- as.numeric(as.matrix(read.table("ex2x.dat")))#sample(range)[1:100]
y <- as.numeric(as.matrix(read.table("ex2y.dat")))#.075*x + .75 + rnorm(length(x),0,.04)

plot(x,y)

# data <- cbind(sin(x),cos(x),x,1)
data <- cbind(x,1)
vec <- runif(2)
resps <- numeric(nrow(data))
errorCurve <- c()
rmse <- 1
count <- 0
while ((count  < 10000) & (rmse != 0)){
  rmse <- 0
  count <- count + 1
  for (i in 1:nrow(data)){
    resp <- vec %*% data[i,]#1/(1+exp(-(vec %*% data[i,1:3])))#
    erro <- y[i] - c(resp)
    # resps[i] <- resp
    rmse <- rmse + erro^2#nerro + 1*(erro != 0)
    # print(erro)
    # print(vec)
    vec <- vec + eta*erro*data[i,]
    # vec[1] <- vec[1] + eta*erro*vecx[[1]
    # vec[2] <- vec[2] + eta*erro*vec[2]
    # vec[3] <- vec[3] + eta*erro*vec[3]
  }
  # cat(sprintf("Erro na época %d: %f\n",count,nerro/nrow(data)))
  errorCurve <- c(errorCurve,rmse)#nerro/nrow(data))
}

ys <- c()
range <- seq(2,8,.01)
# rangedata <- cbind(sin(range),cos(range),range,1)
rangedata <- cbind(range,1)
# ci <- 0
for (i in 1:nrow(rangedata)){
  # ci <- ci+1
  # newdata <- c(1,1*(vecs[2,] %*% c(1,i,j) > 0),1*(vecs[3,] %*% c(1,i,j) > 0))
  ys <- c(ys,(vec %*% rangedata[i,]))
}

plot(x,y,ylim=c(.8,1.4),xlim=c(2,8))
par(new=T)
plot(range,ys,'l',ylim=c(.8,1.4), xlab='',ylab='',col='red',xlim=c(2,8))
