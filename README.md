# Data Bases II second project repository.
Readme that contains the inteded commands in order to setup and load the data into the datamart of the second project of the course Data Bases II.

## Setting up the enviroment.
Commands regarding the setup of the working enviroment.

### docker

Build the image, create an internal network and run the image using a local volume
path to share files and jars from the host computer
```
docker build . -t hadoop

docker network create --driver bridge --subnet 10.0.0.0/28 littlenet

docker run -it -p 9000:9000 -p 9092:9092 -p 22:22 -v [repository local path]\hadoop\dataLoading:/home/hadoopuser/mapr --name hadoopserver --net littlenet --ip 10.0.0.2 hadoop

docker run -it -p 9000:9000 -p 9092:9092 -p 22:22 -p 10000:10000 -v D:\Universidad\University-Databases2-Project2\hadoop\dataLoading:/home/hadoopuser/mapr --name hadoopserver --net littlenet --ip 10.0.0.2 hadoop
```

### ssh

The image includes a default user setup, the user "hadoopuser" must grant passwordless access by ssh, this is required for the hadoop server
This is run once per container.
```
su - hadoopuser
cd /home/hadoopuser
ssh-keygen -t rsa -P '' -f /home/hadoopuser/.ssh/id_rsa
ssh-copy-id hadoopuser@localhost
exit
```
A password is solicited while you're setting this part up. This password is `hadoop`.

### hadoop

Start the hadoop single node cluster with `start-all.sh`. To stop it, run `stop-all.sh`.

Setting up hdfs (hadoop file system).
```
hadoop fs -mkdir /data
hadoop fs -mkdir /data/input
cd mapr
cd DataSources
hadoop fs -copyFromLocal European_Rosters.csv /data/input
hadoop fs -copyFromLocal Player_Attributes.csv /data/input
hadoop fs -copyFromLocal Player.csv /data/input
cd ..
cd ..
```

### mapr

Running the map reduce.
```
cd mapr
hadoop jar MapReduceV1.jar main.program /data/input/European_Rosters.csv /data/output/marketvalues.csv
```

### hive
To setup the hive environment just run the `./hive-setup.sh` command.
Then access the hive console with `hive`

Create the schema and tables if they do not already exist.
This part only creates the schema and tables. Data loading commands are below on the Data Loading section.

Schema creation.
```
CREATE SCHEMA IF NOT EXISTS player_price_tracking;

USE player_price_tracking;
```

Create a temporal table to load the players personal information directly from the Player.csv file.
```
CREATE TABLE IF NOT EXISTS player_infoloader(
    id                 INT,
    player_api_id      INT,
    player_name        STRING,
    player_fifa_api_id INT,
    birthday           TIMESTAMP,
    height             DECIMAL(5,2),
    weight             DECIMAL(5,2)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

Create a temporal table to load the players stats data directly from the Player_Attributes.csv file.
```
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
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

Create a temporal table to load the players market values data directly from the European_Rosters.csv file.
```
CREATE TABLE IF NOT EXISTS marketvalues_infoloader(
    player_name            STRING,
    player_league          STRING,
    player_citizenship     STRING,
    player_nationality     STRING,
    marketValue            INT,
    highestMarketValue     INT,
    highestMarketValueDate STRING,
    player_team            STRING         
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

Create the market values final table. Set to load the data from the temporal table `marketvalues_infoloader` so we can parse the `highestMarketValueDate` field to a TIMESTAMP.
```
CREATE EXTERNAL TABLE IF NOT EXISTS marketvalues(
    player_name            STRING,
    player_league          STRING,
    player_citizenship     STRING,
    player_nationality     STRING,
    marketValue            INT,
    highestMarketValue     INT,
    highestMarketValueDate TIMESTAMP,
    player_team            STRING         
)
COMMENT 'Market values info per player.'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/data/marketvalues';
```

Create the players personal information final table. Set to load the data from the personal table `player_infoloader` filtering the unwanted fields. Created as an external table so we can later transfer the result outside of the
```
CREATE EXTERNAL TABLE IF NOT EXISTS player(
    player_api_id          INT,
    player_name            STRING,
    birthday               TIMESTAMP   
)
COMMENT 'Players personal info including market value data.'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/data/players';
```

Create the players stats data final table. Set to load the data from the personal table `playerstats_infoloader` filtering the unwanted fields.
```
CREATE EXTERNAL TABLE IF NOT EXISTS playerstats(
    player_api_id       INT,
    dateRecorded        TIMESTAMP,
    overall_rating      INT,
    potential           INT,           
    preferred_foot      STRING
)
COMMENT 'Players fifa overall ratings from 2006 to 2016.'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/data/player_stats';
```

### kakfa
To start the kafka server just run the command `./start-kafka.sh`.

To test your Kafka environment follow the [kafka quickstart guide](https://kafka.apache.org/quickstart) 

## Restarting container

Everytime you rerun the preexisting hadoopserver container you must run the `./start.sh` command.

Additionaly, remember to run `start-all.sh` to start the hadoop service.

## Data Loading
It assumes the single-node hadoop server container is all setup and started running.


### hive

Loading data from csv files into hive. Inside hive's console. It assumes the hive enviroment has been well created as told above in the Setting up the enviroment section.

The map reduce has to be already runned for the last command to work.

The data from the three csv files is inserted into their corresponding temporal tables.
```
load data inpath '/data/input/Player.csv' into table player_infoloader;
load data inpath '/data/input/Player_Attributes.csv' into table playerstats_infoloader;
load data inpath '/data/output/part-r-00000' into table marketvalues_infoloader; 
```

Insert the market values data to its final table, parsing the date to a Timestamp in the process (it was provided as a string).
```
INSERT INTO TABLE marketvalues 
(
    SELECT 
        regexp_replace(player_name, '\\t', ''),
        player_league, 
        player_citizenship, 
        player_nationality, 
        marketValue, 
        highestMarketValue, 
        from_unixtime(unix_timestamp(highestMarketValueDate, 'MM/dd/yyyy')),
        player_team 
    FROM 
        marketvalues_infoloader
    WHERE 
        player_name IS NOT NULL AND
        player_league IS NOT NULL AND
        player_citizenship IS NOT NULL AND
        player_nationality IS NOT NULL AND
        marketValue IS NOT NULL AND
        highestMarketValue IS NOT NULL AND
        highestMarketValueDate IS NOT NULL AND
        player_team IS NOT NULL
);
```

Insert the player stats data to its final table, filtering all the unnecesary columns and all the unwanted rows in the process.
```
INSERT INTO TABLE playerstats 
(
    SELECT 
        player_api_id,
        dateRecorded,
        overall_rating,
        potential,           
        preferred_foot
    FROM
        playerstats_infoloader
    WHERE
        player_api_id IS NOT NULL AND
        dateRecorded IS NOT NULL AND
        overall_rating IS NOT NULL AND
        potential IS NOT NULL AND
        preferred_foot IS NOT NULL AND 
        player_api_id IN (
                            SELECT 
                                stats.player_api_id
                            FROM
                                playerstats_infoloader as stats
                            WHERE
                                date_format(dateRecorded,'yyyy') = '2016'
                         )
    ORDER BY (player_api_id,dateRecorded)
);
```

Insert the player data to its final table, filtering all the unnecesary columns and merging the data with the marketvalues data in the process.
```
INSERT INTO TABLE player
(
    SELECT 
        player_api_id,
        player_name,
        birthday
    FROM 
        player_infoloader
    WHERE 
        player_api_id IS NOT NULL AND
        player_name IS NOT NULL AND
        birthday IS NOT NULL
);
```

Due to the final tables being external, there are files in de hadoop file system containing the data present in them, one per table.
Stored in the path `/data/`.

### hadoop
 
To retrieve the datamart tables from the HDFS into our docker container, use `hadoop fs -get /data/<output file name> /home/hadoopuser/`.

hadoop fs -get /data/player_stats/000000_0 /home/hadoopuser/player_stats.csv
hadoop fs -get /data/players/000000_0 /home/hadoopuser/players.csv
hadoop fs -get /data/marketvalues/000000_0 /home/hadoopuser/marketvalues.csv

Then you can directly download each file into your local machine for further processing.