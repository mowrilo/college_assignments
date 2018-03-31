library(dplyr)
library(readr) 

rat <- read_csv("split_ratings.csv")
rat <- rat %>% select(-1)
names(rat)[1:2] <- c("User","Item")
rat_usr <- rat %>% group_by(User) %>% summarise(Prediction = mean(Prediction))
rat_itm <- rat %>% group_by(Item) %>% summarise(Prediction = mean(Prediction))

targ <- read_csv("targets.csv")
preds <- c()
mn_usr <- mean(rat_usr$Prediction)
mn_itm <- mean(rat_itm$Prediction)

for (i in targ$`UserId:ItemId`){
    user <- strsplit(i,':')[[1]][1]
    item <- strsplit(i,':')[[1]][2]
    pred_usr <- as.numeric(rat_usr %>% filter(User == user) %>% select(Prediction))
    if (is.na(pred_usr)){
        pred_usr <- mn_usr
    }
    pred_itm <- as.numeric(rat_itm %>% filter(Item == item) %>% select(Prediction))
    if (is.na(pred_itm)){
        pred_itm <- mn_itm
    }
    dev_itm <- (pred_itm - mn_itm)/mn_itm
    pred <- pred_usr + pred_usr*dev_itm
    if (pred > 10){pred <- 10}
    preds <- c(preds,pred)
}

preds[which(preds > 10)] <- 10

a <- targ
a$Prediction <- preds

write.csv(a,"mean.csv",
          row.names = F,quote = F)
