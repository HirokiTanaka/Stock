# hive_table_defs

## Description
echo create table definition for hive.

run

```
node index --table=stocks --from=2015-09-10 --to=2015-09-11
```

and you can get

```
CREATE EXTERNAL TABLE IF NOT EXISTS stocks (
  code string,
  market string,
  brand string,
  industry string,
  opening int,
  high int,
  low int,
  closing int,
  turnover int,
  sales int
)
PARTITIONED BY (dt string)
ROW FORMAT
  DELIMITED
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY 'n'
;
   
ALTER TABLE stocks ADD PARTITION ( dt='2015-09-10' ) LOCATION 's3n://hirokitanaka-stock/hdfs/data/stocks/2015-09-10';
ALTER TABLE stocks ADD PARTITION ( dt='2015-09-11' ) LOCATION 's3n://hirokitanaka-stock/hdfs/data/stocks/2015-09-11';
```


## Requirement

node runnable env.


## Install

```
cd hive_table_defs && npm install
```
