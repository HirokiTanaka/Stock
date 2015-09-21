#!/bin/bash

# install chef solo
curl -L http://www.opscode.com/chef/install.sh | sudo bash

# install git & clone cookbook
## set up git
sudo yum -y install git

## clone cookbook
git clone https://github.com/HirokiTanaka/Stock.git
here=$(cd $(dirname $0); pwd)/Stock/chef
echo 'file_cache_path "${here}/tmp"' > ${here}/setup.rb
echo "cookbook_path [\"${here}/\"]" >> ${here}/setup.rb

sudo chef-solo -c ${here}/setup.rb -j ${here}/setup.json