
group "hadoop" do
  append true
  system true
  members "vagrant"
  action :create
end

user "hadoop" do
  shell "/bin/sh"
  gid  "hadoop"
  password ""
  home "/opt/hadoop-2.2.0"
  action :create
end

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

remote_file "#{Chef::Config[:file_cache_path]}/hadoop-2.2.0.tar.gz" do
  source "http://ftp.meisei-u.ac.jp/mirror/apache/dist/hadoop/common/hadoop-2.2.0/hadoop-2.2.0.tar.gz"
  action :create
end

bash "extract-hadoop22" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/hadoop-2.2.0.tar.gz" -C /opt
    chown -R hadoop:hadoop /opt/hadoop-2.2.0
EOH
  not_if {::File.exists?("/opt/hadoop-2.2.0")}
end

file "/etc/profile.d/hadoop22.sh" do
  content <<-EOH
export HADOOP_HOME=/opt/hadoop-2.2.0
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

file "/opt/hadoop-2.2.0/etc/hadoop/core-site.xml" do
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

directory "/opt/hadoop-2.2.0/cache" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "/opt/hadoop-2.2.0/etc/hadoop/mapred-site.xml" do
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
    <description>To set the value of tmp directory for map and reduce tasks.</description>
    <name>mapreduce.task.tmp.dir</name>
    <value>/opt/hadoop-2.2.0/cache/${user.name}/tasks</value>
  </property>
</configuration>
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "/opt/hadoop-2.2.0/hdfs" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "/opt/hadoop-2.2.0/hdfs/cache" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "/opt/hadoop-2.2.0/etc/hadoop/hdfs-site.xml" do
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
     <value>/opt/hadoop-2.2.0/hdfs/cache/${user.name}</value>
  </property>
  <property>
     <name>dfs.namenode.name.dir</name>
     <value>file:///opt/hadoop-2.2.0/hdfs/cache/${user.name}/dfs/name</value>
  </property>
  <property>
     <name>dfs.namenode.checkpoint.dir</name>
     <value>file:///opt/hadoop-2.2.0/hdfs/cache/${user.name}/dfs/namesecondary</value>
  </property>
  <property>
     <name>dfs.datanode.data.dir</name>
     <value>file:///opt/hadoop-2.2.0/hdfs/cache/${user.name}/dfs/data</value>
  </property>
</configuration>
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "/opt/hadoop-2.2.0/yarn" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "/opt/hadoop-2.2.0/yarn/cache" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "/opt/hadoop-2.2.0/yarn/containers" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "/opt/hadoop-2.2.0/yarn/apps" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "/opt/hadoop-2.2.0/etc/hadoop/yarn-site.xml" do
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
    <value>/opt/hadoop-2.2.0/yarn/cache/${user.name}/nm-local-dir</value>
  </property>
  <property>
    <description>Where to store container logs.</description>
    <name>yarn.nodemanager.log-dirs</name>
    <value>/opt/hadoop-2.2.0/yarn/containers</value>
  </property>
  <property>
    <description>Where to aggregate logs to.</description>
    <name>yarn.nodemanager.remote-app-log-dir</name>
    <value>/opt/hadoop-2.2.0/yarn/apps</value>
  </property>
</configuration>
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create
end

#bash "init-namenode" do
#  user "hadoop"
#  code <<-EOH
#/opt/hadoop-2.2.0/bin/hdfs namenode -format
#EOH
#end

directory "/opt/boot" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_not_exists
end

file "/opt/boot/01-hadoop.sh" do
  content <<-EOH
#! /bin/sh

export HADOOP_HOME=/opt/hadoop-2.2.0
HADOOP_BIN=${HADOOP_HOME}/bin
HADOOP_SBIN=${HADOOP_HOME}/sbin
export JAVA_HOME=/usr/lib/jvm/java

$HADOOP_SBIN/start-dfs.sh &
$HADOOP_SBIN/start-yarn.sh &
EOH
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_not_exists
end
