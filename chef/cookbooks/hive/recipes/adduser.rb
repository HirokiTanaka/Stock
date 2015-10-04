# add user for hadoop
if !File.exists?("/home/#{node.hadoop.user.name}")
  user "#{node.hadoop.user.name}" do
    password "#{node.hadoop.user.password}"
    home "/home/#{node.hadoop.user.name}"
    supports :manage_home => true
    action :create
  end

  # add him to wheel group and let him be a sodoer.
  bash "root" do
    code "echo \"%wheel ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"
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
    code   <<-_EOF_
      aws s3 cp #{node.s3.root_dir}/pems/id_rsa /home/#{node.hadoop.user.name}/.ssh/id_rsa
      aws s3 cp #{node.s3.root_dir}/pems/id_rsa.pub /home/#{node.hadoop.user.name}/.ssh/id_rsa.pub
      cat /home/#{node.hadoop.user.name}/.ssh/id_rsa.pub >> /home/#{node.hadoop.user.name}/.ssh/authorized_keys
    _EOF_
  end

  bash "root" do
    code  <<-_EOF_
      chown hadoop:wheel /home/#{node.hadoop.user.name}/.ssh/*
      chmod 600 /home/#{node.hadoop.user.name}/.ssh/*
    _EOF_
  end
end