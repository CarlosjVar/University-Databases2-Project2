setwd("C:\\Applications\\GitHub\\University-Databases2-Project2\\DataMart")
setwd("D:\\Universidad\\University-Databases2-Project2\\DataMart")



###
### REQUIRED PACKAGES
###
#install.packages("psych")
#install.packages("dplyr")



###
##USED LIBRARIES
###
library("psych")
library("dplyr")



###
### COLUMN CLASSES
###
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

calcGrowtRate <- function(vec){
  sumatoria = 0
  iteraciones = 0
  promedio = 0
  for (i in 2:(length(vec)-1)) {
    iteraciones = iteraciones + 1
    tasa = ((vec[i]-vec[i-1])/vec[i-1])*100
    promedio = promedio + tasa
  }
  promedio = promedio/iteraciones
  promedio

}
  

sumatory <- setNames(aggregate(player_stats$Overall,list(player_stats$PlayerId) ,FUN=function(data)calcGrowtRate(data)),c("PlayerId","GrowthRate"))

sumatory[,c(2)] <-    sapply(sumatory[,c(2)],as.numeric)

final_player_stats = merge(sumatory,player,by = "PlayerId")


latestStats = player_stats %>% 
  group_by(PlayerId) %>%
  slice(which.max(RecordedDate))

playerANDvalues =  merge(final_player_stats,marketvalues,by = "PlayerName")

FinalTable = merge(playerANDvalues,latestStats,by = "PlayerId")






FinalTable <- FinalTable %>% mutate(Overall2019 = Overall+GrowthRate)