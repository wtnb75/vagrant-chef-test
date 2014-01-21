yum_package "hadoop-0.20-conf-pseudo" do
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
hadoop fs -mkdir /tmp
hadoop fs -chmod -R 1777 /tmp
EOH
end

bash "hdfs-mkmr" do
  user "hdfs"
  cwd "/tmp"
  code <<-EOH
hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred
EOH
end

%w(hadoop-0.20-mapreduce-jobtracker hadoop-0.20-mapreduce-tasktracker).each do |svc|
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
