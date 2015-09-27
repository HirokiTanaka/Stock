#!/bin/bash

if [ $# -ne 1 ]; then
  target=`date -d '1 days ago' +%Y-%m-%d`
else
  target=$1
fi

echo "gonna remove ${target}..."

is_holiday=`wget -q -O - "http://s-proj.com/utils/checkHoliday.php?opt=market&kind=h&date=${target//-/}" | grep -c "holiday"`
if [ $is_holiday -ne 1 ]; then
  echo "this is not a holiday, so i will exit..."
  exit 2
fi


# remove from s3
hadoop fs -rm -r s3n://hirokitanaka-stock/hdfs/data/stocks/${target}
echo "finished hadoop fs rmr."

