
include_recipe "apache::base"

remote_archive "hive-#{node[:hivever]}" do
  source "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/hive/hive-#{node[:hivever]}/hive-#{node[:hivever]}-bin.tar.gz"
  dest node[:hivedir]
  owner "hadoop"
  group "hadoop"
end

file "/etc/profile.d/hive012.sh" do
  content <<-EOH
export HIVE_HOME=#{node[:hivedir]}
export HIVE_CONF_DIR=${HIVE_HOME}/conf
export PATH=$PATH:${HIVE_HOME}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

file "/etc/sudoers.d/hive" do
  content <<-EOH
Defaults env_keep+="HIVE_HOME HIVE_CONF_DIR"
Defaults secure_path+="#{node[:hivedir]}/bin"
EOH
  owner "root"
  group "root"
  action :create
end

file "#{node[:hivedir]}/conf/hive-site.xml" do
  content <<-EOH
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:derby:;databaseName=#{node[:hivedir]}/metastore/metastore_db;create=true</value>
</property>
<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>org.apache.derby.jdbc.EmbeddedDriver</value>
</property>
<property>
  <name>hive.metastore.uris</name>
  <value>thrift://127.0.0.1:9083</value>
</property>
</configuration>
EOH
  owner "hadoop"
  group "hadoop"
  mode 0644
  action :create
end

file "/opt/boot/02-hive.sh" do
  content <<-EOH
#! /bin/sh

export HIVE_HOME=#{node[:hivedir]}
export JAVA_HOME=/usr/lib/jvm/java

[ -d $HIVE_HOME/log ] || mkdir $HIVE_HOME/log
$HIVE_HOME/bin/hive --server metastore >> $HIVE_HOME/log/metastore.log 2>&1 &
$HIVE_HOME/bin/hiveserver2 >> $HIVE_HOME/log/hiveserver.log 2>&1 &
EOH
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end
