rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

library(plot3D)

c1 <- cbind(1,matrix(c(0,0,1,1),ncol=2,byrow=T),0)
c2 <- cbind(1,matrix(c(0,1,1,0),ncol=2,byrow=T),1)

data <- rbind(c1,c2)
# data <- data[sample(nrow(data)),]

eta <- .01

vecs <- matrix(c(1,1,1,
                 .5,-1,-1,
                 1.5,-1,-1),nrow=3,byrow=T)#(rnorm(3)+1)*10
resps <- numeric(nrow(data))
for (count in 1:1000){
  nerro <- 0
  for (i in 1:nrow(data)){
    newdata <- c(1,1*(vecs[2,] %*% data[i,1:3] > 0),1*(vecs[3,] %*% data[i,1:3] > 0))
    resp <- 1*(vecs[1,] %*% newdata > 0)
    erro <- as.numeric(data[i,4] - resp)
    resps[i] <- resp
    nerro <- nerro + 1*(erro != 0)
    # print(erro)
    # print(vec)
    vecs[1,] <- vecs[1,] + eta*erro*newdata
    # vec[1] <- vec[1] + eta*erro*vecx[[1]
    # vec[2] <- vec[2] + eta*erro*vec[2]
    # vec[3] <- vec[3] + eta*erro*vec[3]
  }
  cat(sprintf("Erro na época %d: %f\n",count,nerro/nrow(data)))
}

range <- seq(0,5,.01)
mat <- matrix(0,ncol=length(range),nrow=length(range))

ci <- 0
for (i in range){
  ci <- ci+1
  cj <- 0
  for (j in range){
    cj <- cj + 1
    newdata <- c(1,1*(vecs[2,] %*% c(1,i,j) > 0),1*(vecs[3,] %*% c(1,i,j) > 0))
    mat[ci,cj] <- 1*(vecs[1,] %*% newdata > 0)
  }
}

plot(c1[,-c(1,4)],col='blue',xlim = c(0,5),ylim=c(0,5))
par(new=T)
plot(x = c2[,2],y=c2[,3],col='red',xlim = c(0,5),ylim=c(0,5))
par(new=T)
contour(range,range,mat,drawlabels = F)

ribbon3D(range,range,mat)