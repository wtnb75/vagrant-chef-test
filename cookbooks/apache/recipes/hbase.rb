
include_recipe "apache::base"

remote_archive "hbase-#{node[:hbasever]}" do
  source "http://ftp.kddilabs.jp/infosystems/apache/hbase/hbase-#{node[:hbasever]}/hbase-#{node[:hbasever]}-hadoop2-bin.tar.gz"
  dest node[:hbasedir]
  owner "hadoop"
  group "hadoop"
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

