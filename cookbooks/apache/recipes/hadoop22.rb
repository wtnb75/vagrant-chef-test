
include_recipe "apache::base"

bash "addenvssh" do
  cwd "/etc/ssh"
  code <<-EOH
if ! grep -q JAVA_HOME sshd_config ; then
  echo "AcceptEnv JAVA_HOME HADOOP_HOME HIVE_HOME" >> sshd_config
fi
if ! grep -q JAVA_HOME ssh_config ; then
  echo "	SendEnv JAVA_HOME HADOOP_HOME HIVE_HOME" >> ssh_config
fi
EOH
end

service "sshd" do
  action :restart
end

remote_archive "hadoop-#{node[:hadoopver]}" do
  source "http://ftp.meisei-u.ac.jp/mirror/apache/dist/hadoop/common/hadoop-#{node[:hadoopver]}/hadoop-#{node[:hadoopver]}.tar.gz"
  dest node[:hadoopdir]
  owner "hadoop"
  group "hadoop"
end

file "/etc/profile.d/hadoop22.sh" do
  content <<-EOH
export HADOOP_HOME=#{node[:hadoopdir]}
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native
export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib"
export PATH=$PATH:${HADOOP_HOME}/bin
EOH
  mode 0644
  owner "root"
  group "root"
  action :create
end

file "/etc/sudoers.d/hadoop" do
  content <<-EOH
Defaults env_keep+="HADOOP_HOME HADOOP_CONF_DIR HADOOP_COMMON_LIB_NATIVE_DIR HADOOP_OPTS"
Defaults exempt_group = "wheel"
EOH
  owner "root"
  group "root"
  action :create
end

directory "#{node[:hadoopdir]}/etc" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/etc/hadoop" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "#{node[:hadoopdir]}/etc/hadoop/core-site.xml" do
  content <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:8020</value>
  </property>
  <property>
    <name>hadoop.proxyuser.httpfs.hosts</name>
    <value>*</value>
  </property>
  <property>
    <name>hadoop.proxyuser.httpfs.groups</name>
    <value>*</value>
  </property>
</configuration>
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/cache" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "#{node[:hadoopdir]}/etc/hadoop/mapred-site.xml" do
  content <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>mapred.job.tracker</name>
    <value>localhost:8021</value>
  </property>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  <property>
    <name>mapreduce.jobhistory.address</name>
    <value>localhost:10020</value>
  </property>
  <property>
    <name>mapreduce.jobhistory.webapp.address</name>
    <value>localhost:19888</value>
  </property>
  <property>
    <name>mapreduce.task.tmp.dir</name>
    <value>#{node[:hadoopdir]}/cache/${user.name}/tasks</value>
  </property>
</configuration>
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/hdfs" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/hdfs/cache" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "#{node[:hadoopdir]}/etc/hadoop/hdfs-site.xml" do
  content <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.safemode.extension</name>
    <value>0</value>
  </property>
  <property>
     <name>dfs.safemode.min.datanodes</name>
     <value>1</value>
  </property>
  <property>
     <name>hadoop.tmp.dir</name>
     <value>#{node[:hadoopdir]}/hdfs/cache/${user.name}</value>
  </property>
  <property>
     <name>dfs.namenode.name.dir</name>
     <value>file://#{node[:hadoopdir]}/hdfs/cache/${user.name}/dfs/name</value>
  </property>
  <property>
     <name>dfs.namenode.checkpoint.dir</name>
     <value>file://#{node[:hadoopdir]}/hdfs/cache/${user.name}/dfs/namesecondary</value>
  </property>
  <property>
     <name>dfs.datanode.data.dir</name>
     <value>file://#{node[:hadoopdir]}/hdfs/cache/${user.name}/dfs/data</value>
  </property>
  <property>
     <name>dfs.webhdfs.enabled</name>
     <value>true</value>
  </property>
</configuration>
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/yarn" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/yarn/cache" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/yarn/containers" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:hadoopdir]}/yarn/apps" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "#{node[:hadoopdir]}/etc/hadoop/yarn-site.xml" do
  content <<-EOH
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
  <property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
  </property>
  <property>
    <name>yarn.dispatcher.exit-on-error</name>
    <value>true</value>
  </property>
  <property>
    <name>yarn.nodemanager.local-dirs</name>
    <value>#{node[:hadoopdir]}/yarn/cache/${user.name}/nm-local-dir</value>
  </property>
  <property>
    <description>Where to store container logs.</description>
    <name>yarn.nodemanager.log-dirs</name>
    <value>#{node[:hadoopdir]}/yarn/containers</value>
  </property>
  <property>
    <description>Where to aggregate logs to.</description>
    <name>yarn.nodemanager.remote-app-log-dir</name>
    <value>#{node[:hadoopdir]}/yarn/apps</value>
  </property>
</configuration>
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create
end

file "/opt/boot/01-hadoop.sh" do
  content <<-EOH
#! /bin/sh

export HADOOP_HOME=#{node[:hadoopdir]}
HADOOP_BIN=${HADOOP_HOME}/bin
HADOOP_SBIN=${HADOOP_HOME}/sbin
export JAVA_HOME=/usr/lib/jvm/java

[ -d $HADOOP_HOME/hdfs/cache/${USER}/dfs/name ] || $HADOOP_BIN/hdfs namenode -format

$HADOOP_SBIN/start-dfs.sh &
$HADOOP_SBIN/start-yarn.sh &
EOH
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end
