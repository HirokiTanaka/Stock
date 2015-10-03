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
    group "#{node.hadoop.user.name}"
    owner "wheel"
    mode "0644"
end

template "#{node.hadoop.install_dir}/hadoop/etc/hadoop/core-site.xml" do
  source "core-site.xml"
  owner "#{node.hadoop.user.name}"
  group "wheel"
  mode "0644"
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
