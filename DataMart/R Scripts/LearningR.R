setwd("C:\\Applications\\GitHub\\University-Databases2-Project2\\DataMart")
setwd("D:\\Universidad\\University-Databases2-Project2\\DataMart")



###
### REQUIRED PACKAGES
###
#install.packages("psych")
#install.packages("dplyr")
#install.packages("data.table")
#install.packages("RJSONIO")  
install.packages("rjson")

###
##USED LIBRARIES
###
library("psych")
library("dplyr")
library("jsonlite")
library("RJSONIO")    
library(data.table)
library("rjson")
library(jsonlite)


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

#Function that gets a list with all the overall performances of a player an returns the growth value
CalcGrowthRate <- function(vec){
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
  
#Calculate the growth rate
sumatory <- setNames(aggregate(player_stats$Overall,list(player_stats$PlayerId) ,FUN=function(data)CalcGrowthRate(data)),c("PlayerId","GrowthRate"))
#Replace a list into a num
sumatory$GrowthRate <- as.numeric(as.character(sumatory$GrowthRate))

#Delete rows with null columns
sumatory = na.omit(sumatory)

#Merge the new calculations with the player info
final_player_stats = merge(sumatory,player,by = "PlayerId")

#Get the latest overall performance and foot preference
latestStats = player_stats %>% 
  group_by(PlayerId) %>%
  slice(which.max(RecordedDate))

#Merge player info with their marketvalue
playerANDvalues =  merge(final_player_stats,marketvalues,by = "PlayerName")

#Merge the latest player info with the latest overall performance and foot preference
FinalTable = merge(playerANDvalues,latestStats,by = "PlayerId")

#Growth rate predictions to 2019
FinalTable <- FinalTable %>% mutate(Overall2019 = Overall+GrowthRate*3)

#2017 MarketValue estimations based on 2019 marketvalue, 2019 predicted performance and 2017 predicted peformance
FinalTable <- FinalTable %>% mutate(MarketValue2017 = (MarketValue*(Overall+GrowthRate))/Overall2019)

#Removing useless columns
FinalTable <- subset( FinalTable, select = -c(RecordedDate,PlayerId,GrowthRate,Overall,Potential,Citizenship,Overall2019 ) )

#Organizing players by team
ByTeam<-split(FinalTable, FinalTable$Team)


da <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("Team", "Players")
colnames(da) <- x
da <- rbind(da)

changeColumnName <- function(vec){
  

  colnames(vec)<- c("Name","Birth","League","Nationality","MarketValue","HighestMarketValue","HighestMarketValueDate","Team","PreferredFoot","MarketValue2017")
  vec
  #print(vec)
  
}




for(i in 1:length(ByTeam))
{

  
  players <- lapply(as.list(1:dim((as.data.frame(ByTeam[i])))[1]), function(x) as.data.frame(ByTeam[i])[x[1],])
  players <- lapply(players, function(x)changeColumnName(x) )
  
  # colo <- colnames(as.data.frame(players))
  # 
  # print(colo)
  

  #players2 <- lapply(players, function(x)changeColumnName(x) )
  print(as.data.frame(players[1]))
  #print(c)
  columns = colnames(as.data.frame(players[1]))
  team= getElement((as.data.frame(players[1])),columns[8])
  dt = data.table(Team=c(team), Players=c(list(players)))
  da <- rbind(da,dt,fill=TRUE)
}

da = na.omit(da)


x <- toJSON(da)
write(x, "test.json")

L <- apply(da, 1, function(x) ((x)))
writeLines(toJSON(da), "Result.JSON")


