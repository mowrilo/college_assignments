library(mvtnorm)
library(cccd)
library(igraph)
n<-10
set.seed(5)
x1 <- rmvnorm(n, mean=c(2,2), sigma=diag(2))
x2 <- rmvnorm(n, mean=c(4,4), sigma=diag(2))

X<-rbind(x1,x2)
D<- c(rep(-1,n),rep(1,n))
graph <- gg(X)

V(graph)$color <- c(rep("red",n), rep("green",n))
plot(graph,vertex.color=V(graph)$color)

xx<-c(3,2)
X2<-rbind(X,xx)

graph <- gg(X2)
V(graph)$color <- c(rep("red",n), rep("green",n), "blue")
plot(graph, vertex.color=V(graph)$color)
