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
aws s3 cp ${workdir}/${target}.csv s3://hirokitanaka-stock/data/stocks/${target}.csv
rm ${workdir}/${target}.csv

