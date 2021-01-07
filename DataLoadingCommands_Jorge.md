
## Data loading
It assumes the single-node hadoop server container is all setup and started running.

## mapr

Running the map reduce.
```

```


## hive

Loading data into hive. Inside hive's console.
```
load data inpath '/data/input/Player.csv' into table player_infoloader;
load data inpath '/data/input/Player_Attributes.csv' into table playerstats_infoloader;
load data inpath '/data/output/part-r-00000' into table marketvalues_infoloader; //TODO: insert mapr's output file path.
```