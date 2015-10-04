#!/bin/bash

# install chef solo
curl -L http://www.opscode.com/chef/install.sh | sudo bash

# install git & clone cookbook
## set up git
sudo yum -y install git

## clone cookbook
git clone https://github.com/HirokiTanaka/Stock.git
here=$(cd $(dirname $0); pwd)/Stock/chef
echo "file_cache_path \"${here}/tmp\"" > ${here}/setup.rb
echo "cookbook_path [\"${here}/cookbooks\"]" >> ${here}/setup.rb

# set env variables from s3 json formated setting file.
## install jq
sudo yum -y install jq
## set env variables from a s3 secret file.
AWS_ACCESS_KEY_ID=$(aws s3 cp s3://hirokitanaka-stock/pems/credentials.json - | jq 'map(select( .["User_Name"] = "hadoop"))' | jq -r '.[].Access_Key_Id')
AWS_SECRET_ACCESS_KEY=$(aws s3 cp s3://hirokitanaka-stock/pems/credentials.json - | jq 'map(select( .["User_Name"] = "hadoop"))' | jq -r '.[].Secret_Access_Key')

sudo chef-solo -c ${here}/setup.rb -j ${here}/setup.json