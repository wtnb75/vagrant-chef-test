#
# Cookbook Name:: presto
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache::base"

remote_archive "presto-server-#{node[:prestosver]}" do
  source "http://central.maven.org/maven2/com/facebook/presto/presto-server/#{node[:prestosver]}/presto-server-#{node[:prestosver]}.tar.gz"
  dest node[:prestosdir]
  owner "hadoop"
  group "hadoop"
end

directory "#{node[:prestosdir]}/etc" do
  mode 0755
  owner "hadoop"
  group "hadoop"
end

directory "#{node[:prestosdir]}/data" do
  mode 0755
  owner "hadoop"
  group "hadoop"
end

uuid=`uuidgen`.strip()

file "#{node[:prestosdir]}/etc/node.properties" do
  content <<-EOH
node.environment=production
node.id=#{uuid}
node.data-dir=#{node[:prestosdir]}/data
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "#{node[:prestosdir]}/etc/jvm.config" do
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
-Xbootclasspath/p:#{node[:prestosdir]}/lib/floatingdecimal-0.1.jar
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "#{node[:prestosdir]}/etc/config.properties" do
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
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "#{node[:prestosdir]}/etc/log.properties" do
  content <<-EOH
com.facebook.presto=DEBUG
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

directory "#{node[:prestosdir]}/etc/catalog" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

file "#{node[:prestosdir]}/etc/catalog/jmx.properties" do
  content <<-EOH
connector.name=jmx
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "#{node[:prestosdir]}/etc/catalog/hive.properties" do
  content <<-EOH
connector.name=hive-hadoop2
hive.metastore.uri=thrift://localhost:9083
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "/opt/boot/03-presto-server.sh" do
  content <<-EOH
#! /bin/sh

export JAVA_HOME=/usr/lib/jvm/java

#{node[:prestosdir]}/bin/launcher start
EOH
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end
