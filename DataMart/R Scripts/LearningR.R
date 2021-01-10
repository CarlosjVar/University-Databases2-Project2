setwd("D:\\Universidad\\University-Databases2-Project2\\DataMart")


#install.packages("psych")
#install.packages("dplyr")
install.packages("tis")
library("psych")
library("dplyr")
classes_player_info = c('V1'='integer','V2'='Date','V3'='integer','V4'='integer')
classes_marketvalues= c('V7'='Date')
classes_player= c('V3'='Date')


marketvalues <- read.csv("marketvalues.csv",header=FALSE,colClasses = classes_marketvalues ,stringsAsFactors = FALSE)
player <- read.csv("player.csv",header=FALSE,colClasses =  classes_player,stringsAsFactors = FALSE)
player_info <- read.csv("player_info.csv",header=FALSE,colClasses =  classes_player_info ,stringsAsFactors = FALSE)

head(player,n=4)
tail(player,n=4)
str(player)
summary(player)
describe(player)


myfunc <- function(vec){
  x=0
  for (i in 1:(length(vec) - 1)) {
    
  }
  
}
  



aggregate(player_info$V3,list(player_info$V1) ,FUN=sum)

print("pepito")



