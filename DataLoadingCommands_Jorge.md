
## Data loading commands
It assumes the single-node hadoop server container is all setup and started running.

## hive

hive

create schema <name>; // to create an schema

create table tmp_sales(fecha string, monto decimal(10,2)) row format delimited fields terminated by ',';

load data inpath '/data/input/datasales.dat' into table tmp_sales;

CREATE TABLE IF NOT EXISTS sales ( fecha timestamp, monto decimal(10,2))
COMMENT 'Ventas por mes por anyo'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

insert into table sales select from_unixtime(unix_timestamp(fecha, 'MM/dd/yyyy')), monto from tmp_sales;
```

Once data is loaded, run some queries to test the performance 
```
SELECT MONTH(fecha), YEAR(fecha), SUM(monto) from sales group by YEAR(fecha), MONTH(fecha);

SELECT anyo, MAX(monto) from (
    SELECT MONTH(fecha) mes, YEAR(fecha) anyo, SUM(monto) monto from sales group by YEAR(fecha), MONTH(fecha)

## mapr

These are example of instructions to prepare hdfs folders and run a map reduce example
```
hadoop fs -mkdir /data
hadoop fs -mkdir /data/input
hadoop fs -copyFromLocal datadates.csv /data/input
hadoop fs -copyFromLocal datasales.dat /data/input
cd mapr
hadoop jar maprexampl.jar main.program /data/input/datadates.csv /data/output
hadoop fs -cat /data/output

```