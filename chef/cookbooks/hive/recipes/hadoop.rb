# install hadoop
execute "wget hadoop" do
  cwd "/tmp"
  command "wget http://ftp.tsukuba.wide.ad.jp/software/apache/hadoop/common/hadoop-#{node.hadoop.version}/hadoop-#{node.hadoop.version}.tar.gz"
  user "#{node.hadoop.user.name}"
  group "wheel"
  action :run
  notifies :run, "execute[tar hadoop]", :immediately
  not_if { File.exists?("#{node.hadoop.install_dir}/hadoop-#{node.hadoop.version}") }
end

execute "tar hadoop" do
  cwd "/tmp"
  command "tar zxf hadoop-1.2.1.tar.gz"
  user "#{node.hadoop.user.name}"
  group "wheel"
  action :run
  notifies :run, "execute[move hadoop]", :immediately
  not_if { File.exists?("#{node.hadoop.install_dir}/hadoop-#{node.hadoop.version}") }
end

execute "move hadoop" do
  cwd "/tmp"
  command <<-_EOF_
    mv hadoop-#{node.hadoop.version} #{node.hadoop.install_dir}
    ln -s #{node.hadoop.install_dir}/hadoop-#{node.hadoop.version} #{node.hadoop.install_dir}/hadoop
    chown -R #{node.hadoop.user.name}:wheel #{node.hadoop.install_dir}/
  _EOF_
  user "root"
  group "root"
  action :run
  not_if { File.exists?("#{node['hadoop']['install_dir']}/hadoop-#{node.hadoop.version}") }
end
