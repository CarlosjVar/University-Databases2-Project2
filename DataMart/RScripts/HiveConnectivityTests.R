setwd("C:\\Applications\\GitHub\\University-Databases2-Project2\\DataMart")

if(!"RJDBC" %in% rownames(installed.packages())) {
  install.packages("RJDBC")
}

# initialize rJava
#rJava::.jinit()
#hive_classpath <- list.files(path = jdbc_path, pattern = "\\.jar$", full.names = TRUE)
#rJava::.jinit(classpath = hive_classpath,  parameters="-Xmx8g")

rJava::.jinit()
dir = "C:\\Applications\\GitHub\\University-Databases2-Project2\\DataMart\\ConnectionDriver\\Standalone"
for(l in list.files(path = dir, pattern = "\\.jar$", full.names = TRUE)) {
  rJava::.jaddClassPath(paste( dir ,l,sep="")) }
options( java.parameters = "-Xmx8g" ) 

library(DBI)
drv <- RJDBC::JDBC("org.apache.hive.jdbc.HiveDriver",
            "C:\\Applications\\GitHub\\University-Databases2-Project2\\DataMart\\ConnectionDriver\\ProjectsHive\\hive-jdbc-3.1.2-standalone.jar")

conn <- dbConnect(drv,  "jdbc:hive2://localhost:10000/test;AuthMech=0;transportMode=binary;")

