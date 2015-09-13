#!/bin/bash

if [ $# -ne 1 ]; then
  target=`date -d '1 days ago' +%Y-%m-%d`
else
  target=$1
fi

echo "gonna download ${target}..."


workdir=./tmp

# download csv file
wget http://k-db.com/stocks/${target}?download=csv -O ${workdir}/${target}.sjis.csv

# convert charactor code sjis to utf-8
iconv -f Shift-JIS -t UTF-8 ${workdir}/${target}.sjis.csv -o ${workdir}/${target}.csv
rm ${workdir}/${target}.sjis.csv

# remove header lines
sed -i -e '1,2d' ${workdir}/${target}.csv

# upload to s3
hadoop fs -mkdir s3n://hirokitanaka-stock/hdfs/data/stocks/${target}
hadoop fs -put ${workdir}/${target}.csv s3n://hirokitanaka-stock/hdfs/data/stocks/${target}/${target}.csv
rm ${workdir}/${target}.csv

