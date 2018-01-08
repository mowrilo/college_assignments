rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

library(plot3D)

c1 <- cbind(1,matrix(c(0,0,0,1,1,0),ncol=2,byrow=T),1)
c2 <- cbind(1,matrix(c(1,1),ncol=2,byrow=T),0)

data <- rbind(c1,c2)
data <- data[sample(nrow(data)),]

eta <- .001

vec <- runif(3)
resps <- numeric(nrow(data))
errorCurve <- c()
nerro <- 1
count <- 0
while ((count  < 1000) & (nerro != 0)){
  nerro <- 0
  count <- count + 1
  for (i in 1:nrow(data)){
    resp <- 1*(vec %*% data[i,1:3] > 0)#1/(1+exp(-(vec %*% data[i,1:3])))#
    erro <- data[i,4] - c(resp)
    resps[i] <- resp
    nerro <- nerro + 1*(erro != 0)
    # print(erro)
    # print(vec)
    vec <- vec + eta*erro*data[i,1:3]
    # vec[1] <- vec[1] + eta*erro*vecx[[1]
    # vec[2] <- vec[2] + eta*erro*vec[2]
    # vec[3] <- vec[3] + eta*erro*vec[3]
  }
  # cat(sprintf("Erro na época %d: %f\n",count,nerro/nrow(data)))
  errorCurve <- c(errorCurve,nerro/nrow(data))
}
plot(1:count,errorCurve,'l')
range <- seq(0,5,.01)
mat <- matrix(0,ncol=length(range),nrow=length(range))

ci <- 0
for (i in range){
  ci <- ci+1
  cj <- 0
  for (j in range){
    cj <- cj + 1
    mat[ci,cj] <- 1*(vec %*% c(1,i,j) > 0)
  }
}

plot(c1[,-c(1,4)],col='blue',xlim = c(0,5),ylim=c(0,5))
par(new=T)
plot(x = c2[,2],y=c2[,3],col='red',xlim = c(0,5),ylim=c(0,5))
par(new=T)
contour(range,range,mat,drawlabels = F)

ribbon3D(range,range,mat)
