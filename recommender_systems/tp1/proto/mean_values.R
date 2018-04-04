library(dplyr)
library(readr) 
setwd("~/Documents/codes/materias/recommender_systems/tp1/data/")
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
    dev_usr <- (pred_usr - mn_usr)/mn_usr
    pred <- pred_itm + sign(dev_usr)*.3
    if (pred > 10){pred <- 10}
    # pred <- round(pred)
    preds <- c(preds,pred)
}

# preds[which(preds > 10)] <- 10

a <- targ
a$Prediction <- preds

write.csv(a,"mean_item_dev.csv",
          row.names = F,quote = F)
