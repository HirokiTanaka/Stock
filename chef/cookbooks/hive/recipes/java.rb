# install jdk
## download rpm
jdk_file_name = "jdk-8u60-linux-x64.rpm"

execute "download_jdk" do
  user "#{node.hadoop.user.name}"
  group "wheel"
  cwd "/home/#{node.hadoop.user.name}"
  command "wget --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' http://download.oracle.com/otn-pub/java/jdk/8u60-b27/#{jdk_file_name} -0 #{jdk_file_name}"
  not_if { ::File.exists?("/home/#{node.hadoop.user.name}/#{jdk_file_name}") }
end

## install from rpm
package "install_jdk" do
  source "/home/#{node.hadoop.user.name}/#{jdk_file_name}"
  provider Chef::Provider::Package::Rpm
  action :install
end