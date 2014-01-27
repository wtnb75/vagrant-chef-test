#
# Cookbook Name:: presto
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/presto-server-0.58.tar.gz" do
  source "http://central.maven.org/maven2/com/facebook/presto/presto-server/0.58/presto-server-0.58.tar.gz"
  action :create
end

bash "extract-ps" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/presto-server-0.58.tar.gz" -C /opt
EOH
  not_if {::File.exists?("/opt/presto-server-0.58")}
end

directory "/opt/presto-server-0.58/etc" do
  mode 0755
  owner "root"
  group "root"
end

directory "/opt/presto-server-0.58/data" do
  mode 0755
  owner "root"
  group "root"
end

uuid=`uuidgen`

file "/opt/presto-server-0.58/etc/node.properties" do
  content <<-EOH
node.environment=production
node.id=#{uuid}
node.data-dir=/opt/presto-server-0.58/data
EOH
  mode 0644
  owner "root"
  group "root"
  action :create
end

file "/opt/presto-server-0.58/etc/jvm.config" do
  content <<-EOH
-server
-Xmx1G
-XX:+UseConcMarkSweepGC
-XX:+ExplicitGCInvokesConcurrent
-XX:+CMSClassUnloadingEnabled
-XX:+AggressiveOpts
-XX:+HeapDumpOnOutOfMemoryError
-XX:OnOutOfMemoryError=kill -9 %p
-XX:PermSize=150M
-XX:MaxPermSize=150M
-XX:ReservedCodeCacheSize=150M
-Xbootclasspath/p:/opt/presto-server-0.58/lib/floatingdecimal-0.1.jar
EOH
  mode 0644
  owner "root"
  group "root"
  action :create
end

file "/opt/presto-server-0.58/etc/config.properties" do
  content <<-EOH
coordinator=true
datasources=jmx,hive
http-server.http.port=8080
presto-metastore.db.type=h2
presto-metastore.db.filename=var/db/MetaStore
task.max-memory=1GB
discovery-server.enabled=true
discovery.uri=http://localhost:8080
EOH
  mode 0644
  owner "root"
  group "root"
  action :create
end

file "/opt/presto-server-0.58/etc/log.properties" do
  content <<-EOH
com.facebook.presto=DEBUG
EOH
  mode 0644
  owner "root"
  group "root"
  action :create
end

directory "/opt/presto-server-0.58/etc/catalog" do
  mode 0755
  owner "root"
  group "root"
  action :create
end

file "/opt/presto-server-0.58/etc/catalog/jmx.properties" do
  content <<-EOH
connector.name=jmx
EOH
  mode 0644
  owner "root"
  group "root"
  action :create
end

file "/opt/presto-server-0.58/etc/catalog/hive.properties" do
  content <<-EOH
connector.name=hive-hadoop2
hive.metastore.uri=thrift://localhost:9083
EOH
  mode 0644
  owner "root"
  group "root"
  action :create
end
