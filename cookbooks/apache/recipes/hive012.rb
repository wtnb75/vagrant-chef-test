
remote_file "#{Chef::Config[:file_cache_path]}/hive-0.12.0-bin.tar.gz" do
  source "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/hive/hive-0.12.0/hive-0.12.0-bin.tar.gz"
  action :create
end

bash "extract-hive012" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/hive-0.12.0-bin.tar.gz" -C /opt
    mv /opt/hive-0.12.0-bin /opt/hive-0.12.0
EOH
  not_if {::File.exists?("/opt/hive-0.12.0")}
end

file "/etc/profile.d/hive012.sh" do
  content <<-EOH
export HIVE_HOME=/opt/hive-0.12.0
export HIVE_CONF_DIR=/opt/hive-0.12.0/conf
EOH
  owner "root"
  group "root"
  mode 0644
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
  <description>JDBC connect string for a JDBC metastore</description>
</property>

<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>org.apache.derby.jdbc.EmbeddedDriver</value>
  <description>Driver class name for a JDBC metastore</description>
</property>

</configuration>
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

