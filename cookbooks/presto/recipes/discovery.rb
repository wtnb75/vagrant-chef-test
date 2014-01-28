#
# Cookbook Name:: presto
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/discovery-server-1.16.tar.gz" do
  source "http://central.maven.org/maven2/io/airlift/discovery/discovery-server/1.16/discovery-server-1.16.tar.gz"
  action :create
end

bash "extract-pd" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/discovery-server-1.16.tar.gz" -C /opt
    chown -R hadoop:hadoop /opt/discovery-server-1.16
EOH
  not_if {::File.exists?("/opt/discovery-server-1.16")}
end

directory "/opt/discovery-server-1.16/etc" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

directory "/opt/discovery-server-1.16/data" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

uuid=`uuidgen`.strip()

file "/opt/discovery-server-1.16/etc/node.properties" do
  content <<-EOH
node.environment=production
node.id=#{uuid}
node.data-dir=/opt/discovery-server-1.16/data
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "/opt/discovery-server-1.16/etc/jvm.config" do
  content <<-EOH
-server
-Xmx1G
-XX:+UseConcMarkSweepGC
-XX:+ExplicitGCInvokesConcurrent
-XX:+AggressiveOpts
-XX:+HeapDumpOnOutOfMemoryError
-XX:OnOutOfMemoryError=kill -9 %p
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "/opt/discovery-server-1.16/etc/config.properties" do
  content <<-EOH
http-server.http.port=8411
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

directory "/opt/boot" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_not_exists
end

file "/opt/boot/03-presto-discovery.sh" do
  content <<-EOH
#! /bin/sh

export JAVA_HOME=/usr/lib/jvm/java

/opt/discovery-server-1.16/bin/launcher start
EOH
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_not_exists
end
