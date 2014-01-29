#
# Cookbook Name:: presto
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/presto-cli-#{node[:prestocver]}-executable.jar" do
  source "http://central.maven.org/maven2/com/facebook/presto/presto-cli/#{node[:prestocver]}/presto-cli-#{node[:prestocver]}-executable.jar"
  action :create
end

bash "install-prestocli" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    cp "#{Chef::Config[:file_cache_path]}/presto-cli-#{node[:prestocver]}-executable.jar" /usr/local/bin/presto
    chmod +x /usr/local/bin/presto
EOH
  not_if {::File.exists?("/usr/local/bin/presto")}
end

