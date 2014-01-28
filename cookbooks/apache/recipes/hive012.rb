
remote_file "#{Chef::Config[:file_cache_path]}/hive-0.12.0-bin.tar.gz" do
  source "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/hive/hive-0.12.0/hive-0.12.0-bin.tar.gz"
  action :create
end

bash "extract-hive012" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/hive-0.12.0-bin.tar.gz" -C /opt
    mv /opt/hive-0.12.0-bin /opt/hive-0.12.0
    chown -R hadoop:hadoop /opt/hive-0.12.0
EOH
  not_if {::File.exists?("/opt/hive-0.12.0")}
end

file "/etc/profile.d/hive012.sh" do
  content <<-EOH
export HIVE_HOME=/opt/hive-0.12.0
export HIVE_CONF_DIR=/opt/hive-0.12.0/conf
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
Defaults secure_path+="/opt/hive-0.12.0/bin"
EOH
  owner "root"
  group "root"
  action :create
end

file "/opt/hive-0.12.0/conf/hive-site.xml" do
  content <<-EOH
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:derby:;databaseName=/opt/hive-0.12.0/metastore/metastore_db;create=true</value>
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

directory "/opt/boot" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_not_exists
end

file "/opt/boot/02-hive.sh" do
  content <<-EOH
#! /bin/sh

export HIVE_HOME=/opt/hive-0.12.0
export JAVA_HOME=/usr/lib/jvm/java

[ -d $HIVE_HOME/log ] || mkdir $HIVE_HOME/log
$HIVE_HOME/bin/hive --server metastore > $HIVE_HOME/log/metastore.log 2>&1 &
EOH
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_not_exists
end
