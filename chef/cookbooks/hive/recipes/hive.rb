# install hive
execute "wget hive" do
  cwd "/tmp"
  command "wget http://ftp.tsukuba.wide.ad.jp/software/apache/hive/hive-#{node.hive.version}/apache-hive-#{node.hive.version}-bin.tar.gz"
  user "#{node.hadoop.user.name}"
  group "wheel"
  action :run
  notifies :run, "execute[tar hive]", :immediately
  not_if { File.exists?("#{node.hive.install_dir}/apache-hive-#{node.hive.version}-bin") }
end

execute "tar hive" do
  cwd "/tmp"
  command "tar zxf apache-hive-#{node.hive.version}-bin.tar.gz"
  user "#{node.hadoop.user.name}"
  group "wheel"
  action :run
  notifies :run, "execute[move hive]", :immediately
  not_if { File.exists?("#{node.hive.install_dir}/apache-hive-#{node.hive.version}-bin") }
end

execute "move hive" do
  cwd "/tmp"
  command <<-_EOF_
      mv apache-hive-#{node.hive.version}-bin #{node.hive.install_dir}
      ln -s #{node.hive.install_dir}/apache-hive-#{node.hive.version}-bin #{node.hive.install_dir}/hive
      chown -R #{node.hadoop.user.name}:wheel #{node.hive.install_dir}/
  _EOF_
  user "root"
  group "root"
  action :run
  not_if { File.exists?("#{node.hive.install_dir}/apache-hive-#{node.hive.version}-bin") }
end
