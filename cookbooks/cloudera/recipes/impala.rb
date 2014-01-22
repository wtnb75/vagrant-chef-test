
include_recipe "cloudera::pseudo_yarn"

remote_file "/etc/yum.repos.d/cloudera-impala.repo" do
  source "http://archive.cloudera.com/impala/redhat/6/x86_64/impala/cloudera-impala.repo"
  action :create
end

execute "rpmkey" do
  user "root"
  command "rpm --import http://archive.cloudera.com/impala/redhat/6/x86_64/impala/RPM-GPG-KEY-cloudera"
  action :run
end

file "/etc/hadoop/conf/hdfs-site.xml" do
# FIXME
#  <property>
#     <name>dfs.client.read.shortcircuit</name>
#     <value>true</value>
#  </property>
#  <property>
#     <name>dfs.client.file-block-storage-locations.timeout</name>
#     <value>6000</value>
#  </property>
end

%w(impala impala-shell impala-server impala-catalog impala-state-store).each do |pkg|
  yum_package pkg do
    action :install
  end
end

