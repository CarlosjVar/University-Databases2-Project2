setwd("C:\\Applications\\GitHub\\University-Databases2-Project2\\DataMart")


#install.packages("psych")
#install.packages("dplyr")
install.packages("tis")
library("psych")
library("dplyr")
classes_player_info = c('V1'='integer','V2'='Date','V3'='integer','V4'='integer')
classes_marketvalues= c('V7'='Date')
classes_player= c('V3'='Date')


###
### DATA LOADING
###
  

marketvalues <- read.csv("marketvalues.csv",
                         header=FALSE,colClasses = classes_marketvalues,
                         stringsAsFactors = FALSE)

marketvalues <- setNames(marketvalues,                  
                         c("PlayerName",
                           "League", 
                           "Nationality", 
                           "Citizenship", 
                           "MarketValue", 
                           "HighestMarketValue", 
                           "HighestMarketValueDate", 
                           "Team")
)

player <- read.csv("player.csv",
                         header=FALSE,colClasses = classes_player,
                         stringsAsFactors = FALSE)

player <- setNames(player,                  
                   c("PlayerId",
                     "PlayerName",
                     "BirthDate")
                  )

player_stats <- read.csv("player_stats.csv",
                         header=FALSE,colClasses = classes_player_info,
                         stringsAsFactors = FALSE)

player_stats <- setNames(player_stats,                  
                         c("PlayerId",
                           "RecordedDate",
                           "Overall",
                           "Potential",
                           "PreferredFoot") 
                         )

###
### DATA PROCESSING
###

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

sumatory <- setNames(aggregate(player_stats$V3,list(player_stats$V1) ,FUN=sum),c("PlayerId", "Sumatory"))

str(sumatory)