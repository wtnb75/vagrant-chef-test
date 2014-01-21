yum_package "hadoop-conf-pseudo" do
  action :install
end

execute "hdfs-format" do
  user "hdfs"
  command "hdfs namenode -format"
  action :run
end

%w(hadoop-hdfs-datanode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode).each do |svc|
  service svc do
    action [:enable, :start]
  end
end

bash "hdfs-mktmp" do
  user "hdfs"
  cwd "/tmp"
  code <<-EOH
hadoop fs -rm -r /tmp
hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediatew
hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
hadoop fs -chmod -R 1777 /tmp
EOH
end

bash "hdfs-mkmr" do
  user "hdfs"
  cwd "/tmp"
  code <<-EOH
hadoop fs -mkdir -p /var/log/hadoop-yarn
hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
EOH
end

%w(hadoop-yarn-resourcemanager hadoop-yarn-nodemanager hadoop-mapreduce-historyserver).each do |svc|
  service svc do
    action [:enable, :start]
  end
end

bash "hdfs-home" do
  user "hdfs"
  cwd "/tmp"
  code <<-EOH
hadoop fs -mkdir /user/vagrant
hadoop fs -chown vagrant /user/vagrant
EOH
end
