
file "/etc/yum.repos.d/datastax.repo" do
  content <<-EOH
[datastax]
name = DataStax Repo for Apache Cassandra
baseurl = http://rpm.datastax.com/community
enabled = 1
gpgcheck = 0
EOH
  owner "root"
  group "root"
  mode 0644
end

yum_package "dsc20" do
  action :install
end

service "cassandra" do
  action [:enable, :start]
end
