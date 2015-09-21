# install hadoop
## add cloudera stable repo
execute "add_repo_for_cloudera" do
    user "root"
    group "root"
    command "wget http://archive-primary.cloudera.com/redhat/cdh/cloudera-stable.repo -O /etc/yum.repos.d/cloudera-stable.repo"
    not_if { ::File.exists?("/etc/yum.repos.d/cloudera-stable.repo") }
end

# install hadoop, hadoop-conf-pseudo, hadoop-hive
%w(
    hadoop
    hadoop-conf-pseudo
    hadoop-hive
).each do |package_name|
    package package_name do
        action :install
    end
end
