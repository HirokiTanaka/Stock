#!/bin/bash

cmdname=`basename $0`
if [ $# -ne 2 ]; then
  echo "Usage: $cmdname yyyy-mm-dd yyyy-mm-dd" 1>&2
  exit 1
fi

from=$1
to=$2

cur=$from

while [ 1 ]; do
  if [ `date -d "$to" '+%s'` -lt `date -d "$cur" '+%s'` ]; then
    break
  fi
  echo $cur 1>&2
  sh ./stocks.sh $cur
  cur=`date -d "$cur 1day" "+%Y-%m-%d"`
done

exit 0
