#
# Cookbook Name:: presto
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache::base"

remote_file "#{Chef::Config[:file_cache_path]}/discovery-server-#{node[:prestodver]}.tar.gz" do
  source "http://central.maven.org/maven2/io/airlift/discovery/discovery-server/#{node[:prestodver]}/discovery-server-#{node[:prestodver]}.tar.gz"
  action :create
end

bash "extract-pd" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/discovery-server-#{node[:prestodver]}.tar.gz" -C /opt
    chown -R hadoop:hadoop #{node[:prestoddir]}
EOH
  not_if {::File.exists?("#{node[:prestoddir]}")}
end

directory "#{node[:prestoddir]}/etc" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

directory "#{node[:prestoddir]}/data" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

uuid=`uuidgen`.strip()

file "#{node[:prestoddir]}/etc/node.properties" do
  content <<-EOH
node.environment=production
node.id=#{uuid}
node.data-dir=#{node[:prestoddir]}/data
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "#{node[:prestoddir]}/etc/jvm.config" do
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

file "#{node[:prestoddir]}/etc/config.properties" do
  content <<-EOH
http-server.http.port=8411
EOH
  mode 0644
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

file "/opt/boot/03-presto-discovery.sh" do
  content <<-EOH
#! /bin/sh

export JAVA_HOME=/usr/lib/jvm/java

#{node[:prestoddir]}/bin/launcher start
EOH
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create_if_missing
end

