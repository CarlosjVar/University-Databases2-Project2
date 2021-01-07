# Data Bases II second project repository.
Readme that contains the inteded commands in order to setup and load the data into the second project of the course Data Bases II.

## Setting up the enviroment.
Commands regarding the setup of the working enviroment.

### docker

Build the image, create an internal network and run the image using a local volume
path to share files and jars from the host computer
```
docker build . -t hadoop

docker network create --driver bridge --subnet 10.0.0.0/28 littlenet

docker run -it -p 9000:9000 -p 9092:9092 -p 22:22 -v [local repository path]\hadoop\dataLoading:/home/hadoopuser/mapr --name hadoopserver --net littlenet --ip 10.0.0.2 hadoop

```

This is an example of how to manually copy files from the host to the container 
```

docker cp maprexample.jar hadoopserver:/home/hadoopuser
docker cp datadates.csv  hadoopserver:/home/hadoopuser

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

### hadoop

Start the hadoop single node cluster with `start-all.sh`. To stop it, run `start-all.sh`.

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

### hive
To setup the hive environment just run the `./hive-setup.sh` command.
Then access the hive console with `hive`

Create the schema and tables if they do not already exist.
This part only creates the schema and tables. Data loading commands are below on the Data Loading section.
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
    player_team            STRING,
    player_citizenship     STRING,
    player_nationality     STRING,
    marketValue            INT,
    highestMarketValue     INT,
    highestMarketValueDate STRING,
    player_team            STRING       
) row format delimited fields terminated by ',';


CREATE TABLE IF NOT EXISTS marketvalues(
    player_name            STRING,
    player_league          STRING,
    player_team            STRING,
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
STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS player(
    player_api_id          INT,
    player_name            STRING,
    birthday               TIMESTAMP,
    player_league          STRING,
    player_citizenship     STRING,
    player_nationality     STRING,
    marketValue            INT,
    highestMarketValue     INT,
    highestMarketValueDate TIMESTAMP          
)
COMMENT 'Players personal info including market value data.'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS playerstats(
    player_api_id       INT,
    dateRecorded        TIMESTAMP,
    overall_rating      INT
)
COMMENT 'Players fifa overall ratings from 2006 to 2016.'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

```

### kakfa
To start the kafka server just run the command `./start-kafka.sh`.

To test your Kafka environment follow the [kafka quickstart guide](https://kafka.apache.org/quickstart) 

## Restarting container

Everytime you rerun the preexisting hadoopserver container you must run the `./start.sh` command.

Additionaly, remember to run `start-all.sh` to start the hadoop service.

## Data Loading
It assumes the single-node hadoop server container is all setup and started running.

### mapr

Running the map reduce.
```

cd mapr
hadoop jar MapReduceV1.jar main.program /data/input/European_Rosters.csv /data/output

```


### hive

Loading data from csv files into hive. Inside hive's console. It assumes the hive enviroment has been well created as told above in the setting up the enviroment section.

The map reduce has to be already runned for the last command to work.

The data from the three csv files is inserted into temporal tables.

```

load data inpath '/data/input/Player.csv' into table player_infoloader;
load data inpath '/data/input/Player_Attributes.csv' into table playerstats_infoloader;
load data inpath '/data/output/part-r-00000' into table marketvalues_infoloader; 

```

Insert the market values data to its final table, parsing the date to a Timestamp in the process (it was provided as a string).
```

insert into table marketvalues select player_name,player_league,player_citizenship , player_nationality, marketValue, highestMarketValue ,from_unixtime(unix_timestamp(highestMarketValueDate, 'MM/dd/yyyy')),player_team  from marketvalues_infoloader;

```

Insert the player stats data to its final table, filtering all the unnecesary columns in the process.
```

//TODO

```

Insert the player data to its final table, filtering all the unnecesary columns in the process.
```

//TODO

```

