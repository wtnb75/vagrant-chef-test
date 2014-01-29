
include_recipe "apache::base"

remote_file "#{Chef::Config[:file_cache_path]}/hbase-#{node[:hbasever]}.tar.gz" do
  source "http://ftp.kddilabs.jp/infosystems/apache/hbase/hbase-#{node[:hbasever]}/hbase-#{node[:hbasever]}.tar.gz"
  action :create
end

bash "extract-hbase" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/hbase-#{node[:hbasever]}.tar.gz" -C /opt
    chown -R hadoop:hadoop #{node[:hbasedir]}
EOH
  not_if {::File.exists?("#{node[:hbasedir]}")}
end

file "/etc/profile.d/hbase.sh" do
  content <<-EOH
export PATH=$PATH:#{node[:hbasedir]}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

