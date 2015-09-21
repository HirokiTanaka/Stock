# add user for hadoop
user "#{node.hadoop.user.name}" do
  password "#{node.hadoop.user.password}"
  home "/home/#{node.hadoop.user.name}"
  supports :manage_home => true
  action :create
end


# add him to wheel group in order to use sudo.
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


cookbook_file "/home/#{node.hadoop.user.name}/.ssh/authorized_keys" do
  source "#{node.hadoop.user.name}/authorized_keys"
  owner "#{node.hadoop.user.name}"
  group "wheel"
  mode 0600
end