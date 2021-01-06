
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


CREATE TABLE IF NOT EXISTS sales ( fecha timestamp, monto decimal(10,2))
COMMENT 'Ventas por mes por anyo'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

insert into table sales select from_unixtime(unix_timestamp(fecha, 'MM/dd/yyyy')), monto from tmp_sales;
```

Testing
```
SELECT MONTH(fecha), YEAR(fecha), SUM(monto) from sales group by YEAR(fecha), MONTH(fecha);

SELECT anyo, MAX(monto) from (
    SELECT MONTH(fecha) mes, YEAR(fecha) anyo, SUM(monto) monto from sales group by YEAR(fecha), MONTH(fecha)
```