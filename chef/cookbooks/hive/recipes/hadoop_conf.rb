# prepare hadoop directories
directory "home/#{node.hadoop.user.name}/dfs/name/" do
    owner "#{node.hadoop.user.name}"
    group "wheel"
    recursive true
    mode "0755"
    action :create
    not_if { File.exists?("home/#{node.hadoop.user.name}/dfs/name/") }
end

directory "home/#{node.hadoop.user.name}/dfs/data" do
    owner "#{node.hadoop.user.name}"
    group "wheel"
    recursive true
    mode "0755"
    action :create
    not_if { File.exists?("home/#{node.hadoop.user.name}/dfs/data") }
end

directory "/home/#{node.hadoop.user.name}/mapred" do
    owner "#{node.hadoop.user.name}"
    group "wheel"
    recursive true
    mode "0755"
    action :create
    not_if { File.exists?("/home/#{node.hadoop.user.name}/mapred") }
end

# hosts settings
cookbook_file "/etc/hosts" do
  source "hosts"
  owner "root"
  group "root"
  mode "0644"
end

# hadoop configurations
template "#{node.hadoop.install_dir}/hadoop/etc/hadoop/hadoop-env.sh" do
    source "hadoop-env.sh"
    owner "#{node.hadoop.user.name}"
    group "wheel"
    mode "0644"
end

# set env variables from s3 json formated setting file.
## install jq
package "jq" do
  action :install
end

## set env variables from a s3 secret file.
aws_access_key_id = `echo $(aws s3 cp s3://hirokitanaka-stock/pems/credentials.json - | jq 'map(select( .["User_Name"] = "hadoop"))' | jq -r '.[].Access_Key_Id')`
aws_secret_access_key = `echo $(aws s3 cp s3://hirokitanaka-stock/pems/credentials.json - | jq 'map(select( .["User_Name"] = "hadoop"))' | jq -r '.[].Secret_Access_Key')`

template "#{node.hadoop.install_dir}/hadoop/etc/hadoop/core-site.xml" do
  source "core-site.xml"
  owner "#{node.hadoop.user.name}"
  group "wheel"
  mode "0644"
  variables({
    :aws_access_key_id => aws_access_key_id,
    :aws_secret_access_key => aws_secret_access_key
  })
end

template "#{node.hadoop.install_dir}/hadoop/etc/hadoop/mapred-site.xml" do
  source "mapred-site.xml"
  owner "#{node.hadoop.user.name}"
  group "wheel"
  mode "0644"
end

template "#{node.hadoop.install_dir}/hadoop/etc/hadoop/hdfs-site.xml" do
  source "hdfs-site.xml"
  owner "#{node.hadoop.user.name}"
  group "wheel"
  mode "0644"
end

cookbook_file "#{node.hadoop.install_dir}/hadoop/etc/hadoop/slaves" do
  source "slaves"
  owner "#{node.hadoop.user.name}"
  group "wheel"
  mode "0644"
end
