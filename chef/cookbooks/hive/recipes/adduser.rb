# add user for hadoop
user "#{node.hadoop.user.name}" do
  password "#{node.hadoop.user.password}"
  home "/home/#{node.hadoop.user.name}"
  supports :manage_home => true
  action :create
end

# add him to wheel group and let him be a sodoer.
bash "ec2-user" do
  code "sudo sh -c \"%echo \\\"%wheel ALL=(ALL) NOPASSWD: ALL\\\" >> /etc/sudoers\""
end

group "wheel" do
  action [:modify]
  members ["#{node.hadoop.user.name}"]
  append true
end

# ssh settings
directory "/home/#{node.hadoop.user.name}/.ssh" do
  owner "#{node.hadoop.user.name}"
  group "wheel"
  mode 00700
  action :create
end

bash "#{node.hadoop.user.name}" do
  code "aws s3 cp #{node.s3.root_dir}/pems/id_rsa ~/home/#{node.hadoop.user.name}/id_rsa"
end

bash "#{node.hadoop.user.name}" do
  code "aws s3 cp #{node.s3.root_dir}/pems/id_rsa.pub ~/home/#{node.hadoop.user.name}/id_rsa.pub"
end

bash "#{node.hadoop.user.name}" do
  code "cat ~/home/#{node.hadoop.user.name}/id_rsa.pub >> authorized_keys"
end

bash "#{node.hadoop.user.name}" do
  code "chmod 600 ~/home/#{node.hadoop.user.name}/*"
end
