
include_recipe "apache::base"

remote_archive "zookeeper-#{node[:zkver]}" do
  source "http://ftp.kddilabs.jp/infosystems/apache/zookeeper/zookeeper-#{node[:zkver]}/zookeeper-#{node[:zkver]}.tar.gz"
  dest node[:zkdir]
  owner "hadoop"
  group "hadoop"
end

file "/etc/profile.d/zookeeper.sh" do
  content <<-EOH
export PATH=$PATH:#{node[:zkdir]}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

