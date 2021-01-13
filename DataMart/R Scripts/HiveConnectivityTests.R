setwd("C:\\Applications\\GitHub\\University-Databases2-Project2\\DataMart")

install.packages("RJDBC")
install.packages("rJava")
install.packages("DBI")

library(DBI)
library(rJava)
library(RJDBC)


hive_jdbc_jar <- '/Connection drivers/hive-jdbc-3.1.2-standalone.jar'
hive_driver <- 'org.apache.hive.jdbc.HiveDriver'
hive_url <- 'jdbc:hive2://localhost:10000/ti'
drv <- JDBC(hive_driver, hive_jdbc_jar)
conn <- dbConnect(drv, hive_url)
show_databases <- dbGetQuery(conn, "show databases")

show_databases