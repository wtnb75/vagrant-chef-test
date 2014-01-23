
# include_recipe "cloudera::pseudo_yarn"

remote_file "/etc/yum.repos.d/cloudera-impala.repo" do
  source "http://archive.cloudera.com/impala/redhat/6/x86_64/impala/cloudera-impala.repo"
  action :create
  owner "root"
  group "root"
  mode 0644
end

execute "rpmkey" do
  user "root"
  command "rpm --import http://archive.cloudera.com/impala/redhat/6/x86_64/impala/RPM-GPG-KEY-cloudera"
  action :run
end

%w(impala impala-shell impala-server impala-catalog impala-state-store).each do |pkg|
  yum_package pkg do
    action :install
  end
end

#ruby_block "hdfs-site.xml" do
#  block do
#    fe=Chef::Util::FileEdit.new("/etc/hadoop/conf/hdfs-site.xml")
#    fe.search_file_delete_line("/configuration")
#    fe.insert_line_if_no_match("dfs.client.read.shortcircuit", <<EOF)
#  <property>
#     <name>dfs.client.read.shortcircuit</name>
#     <value>true</value>
#  </property>
#EOF
#    fe.insert_line_if_no_match("dfs.client.file-block-storage-locations.timeout", <<EOF)
#  <property>
#     <name>dfs.client.file-block-storage-locations.timeout</name>
#     <value>6000</value>
#  </property>
#EOF
#    fe.insert_line_if_no_match("/configuration", "</configuration>")
#    fe.write_file
#  end
#end

execute "modify-hdfs-site.xml" do
  command <<SCRIPT
sed -i.bak -e 's,^</configuration>.*$,,g;' /etc/hadoop/conf/hdfs-site.xml
grep -q dfs.client.read.shortcircuit /etc/hadoop/conf/hdfs-site.xml || 
  cat <<EOF >> /etc/hadoop/conf/hdfs-site.xml
  <property>
     <name>dfs.client.read.shortcircuit</name>
     <value>true</value>
  </property>
EOF
grep -q dfs.client.file-block-storage-locations.timeout /etc/hadoop/conf/hdfs-site.xml || 
  cat <<EOF >> /etc/hadoop/conf/hdfs-site.xml
  <property>
     <name>dfs.client.file-block-storage-locations.timeout</name>
     <value>6000</value>
  </property>
EOF
grep -q dfs.webhdfs.enabled /etc/hadoop/conf/hdfs-site.xml || 
  cat <<EOF >> /etc/hadoop/conf/hdfs-site.xml
  <property>
     <name>dfs.webhdfs.enabled</name>
     <value>true</value>
  </property>
EOF
  echo "</configuration>" >> /etc/hadoop/conf/hdfs-site.xml
SCRIPT
  user "root"
  action :run
end

%w(hadoop-yarn-resourcemanager hadoop-yarn-nodemanager hadoop-mapreduce-historyserver).each do |svc|
  service svc do
    action :restart
  end
end

%w(impala-server impala-catalog impala-state-store).each do |svc|
  service svc do
    action [:enable, :start]
  end
end
