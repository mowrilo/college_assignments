rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

library(plot3D)

range <- seq(0,2*pi,.01)
x <- sample(range)[1:100]
yreal <- -pi + .565*sin(x) + 2.657*cos(x) + .674*x
y <- yreal + rnorm(length(x),0,.8)
plot(x,y)

data <- cbind(sin(x),cos(x),x,1)
# data <- cbind(x,1)
vec <- runif(4)
resps <- numeric(nrow(data))
errorCurve <- c()
rmse <- 1
count <- 0
while ((count  < 10000) & (rmse > 0)){
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
range <- seq(0,2*pi,.01)
rangedata <- cbind(sin(range),cos(range),range,1)
# rangedata <- cbind(range,1)
# ci <- 0
for (i in 1:nrow(rangedata)){
  # ci <- ci+1
  # newdata <- c(1,1*(vecs[2,] %*% c(1,i,j) > 0),1*(vecs[3,] %*% c(1,i,j) > 0))
  ys <- c(ys,(vec %*% rangedata[i,]))
}

plot(x,y,ylim=c(-4.5,4.5),xlim=c(0,2*pi))
par(new=T)
plot(range,ys,'l',ylim=c(-4.5,4.5), xlab='',ylab='',col='red',xlim=c(0,2*pi))
par(new=T)
plot(x[order(x)],yreal[order(x)],'l',ylim=c(-4.5,4.5), xlab='',ylab='',col='blue',xlim=c(0,2*pi))
