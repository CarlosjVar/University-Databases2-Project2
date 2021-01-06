## Setting up the workspace
This readme helps you to perform the intended labs in classroom regarding topics such as mapreduce with hadoop, hive, spark and kafka.

### docker related  

Everytime you rerun the preexisting hadoopserver container you must run the `./start.sh` command.

Build the image, create an internal network and run the image using a local volumen
path to share files and jars from the host computer
```
docker build . -t hadoop

docker network create --driver bridge --subnet 10.0.0.0/28 littlenet

docker run -it -p 9000:9000 -p 9092:9092 -p 22:22 -v D:\Universidad\University-Databases2-Project2\hadoop\dataLoading:/home/hadoopuser/mapr --name hadoopserver --net littlenet --ip 10.0.0.2 hadoop
```

This is an example of how to manually copy files from the host to the container 
```
docker cp maprexample.jar hadoopserver:/home/hadoopuser
docker cp datadates.csv  hadoopserver:/home/hadoopuser
```

### ssh related
The image includes a default user setup, the user "hadoopuser" must grant passwordless access by ssh, this is required for the hadoop server
This is run once per container.
```
su - hadoopuser
cd /home/hadoopuser
ssh-keygen -t rsa -P '' -f /home/hadoopuser/.ssh/id_rsa
ssh-copy-id hadoopuser@localhost
exit
```

### hadoop related
These are the commands to start/stop the hadoop single node cluster 
```
start-all.sh
stop-all.sh
```
Setting up hdfs
```
hadoop fs -mkdir /data
hadoop fs -mkdir /data/input
cd mapr
cd DataSources
hadoop fs -copyFromLocal European_Rosters.csv /data/input
hadoop fs -copyFromLocal Player_Attributes.csv /data/input
hadoop fs -copyFromLocal Player.csv /data/input
```

Running hadoop
```
hadoop jar MapReduceV1.jar main.program /data/input/European_Rosters.csv /data/output
```

### hive related
To setup the hive environment just run the `./hive-setup.sh` command.
Then access the hive console with `hive`

Create the schema and tables if they do not already exist.
```
CREATE SCHEMA IF NOT EXISTS player_price_tracking;

USE player_price_tracking;

CREATE TABLE IF NOT EXISTS player_infoloader(
    id                 INT,
    player_api_id      INT,
    player_name        STRING,
    player_fifa_api_id INT,
    birthday           TIMESTAMP,
    height             DECIMAL(5,2),
    weight             DECIMAL(5,2)
) row format delimited fields terminated by ',';

CREATE TABLE IF NOT EXISTS playerstats_infoloader(
    id                  INT,
    player_fifa_api_id  INT,
    player_api_id       INT,
    dateRecorded        TIMESTAMP,
    overall_rating      INT,
    potential           INT,           
    preferred_foot      STRING,      
    attacking_work_rate STRING, 
    defensive_work_rate STRING,
    crossing            INT,
    finishing           INT,
    heading_accuracy    INT,
    short_passing       INT,
    volleys             INT,
    dribbling           INT,
    curve               INT,
    free_kick_accuracy  INT,
    long_passing        INT,
    ball_control        INT,
    acceleration        INT,
    sprint_speed        INT,
    agility             INT,
    reactions           INT,
    balance             INT,
    shot_power          INT,
    jumping             INT,
    stamina             INT,
    strength            INT,
    long_shots          INT,
    aggression          INT,
    interceptions       INT,
    positioning         INT,
    vision              INT,
    penalties           INT,
    marking             INT,
    standing_tackle     INT,
    sliding_tackle      INT,
    gk_diving           INT,
    gk_handling         INT,
    gk_kicking          INT,
    gk_positioning      INT,
    gk_reflexes         INT
) row format delimited fields terminated by ',';

CREATE TABLE IF NOT EXISTS marketvalues_infoloader(
    player_name            STRING,
    player_league          STRING,
    player_citizenship     STRING,
    player_nationality     STRING,
    marketValue            INT,
    highestMarketValue     INT,
    highestMarketValueDate STRING           
) row format delimited fields terminated by ',';

CREATE TABLE IF NOT EXISTS playerstats(
       //TODO meterle los campos.
)
COMMENT 'Players personal info including stats from 2006 to 2016.'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS marketvalues(
    player_name            STRING,
    player_league          STRING,
    player_citizenship     STRING,
    player_nationality     STRING,
    marketValue            INT,
    highestMarketValue     INT,
    highestMarketValueDate TIMESTAMP           
)
COMMENT 'Market values info per player.'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

```

### Kakfa related
To start the kafka server just run the command `./start-kafka.sh`.

To test your Kafka environment follow the [kafka quickstart guide](https://kafka.apache.org/quickstart) 

