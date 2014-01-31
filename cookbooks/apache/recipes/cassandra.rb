
include_recipe "apache::base"

remote_archive "cassandra-#{node[:csver]}" do
  source "http://ftp.tsukuba.wide.ad.jp/software/apache/cassandra/#{node[:csver]}/apache-cassandra-#{node[:csver]}-bin.tar.gz"
  dest node[:csdir]
  owner "hadoop"
  group "hadoop"
end

file "/etc/profile.d/cassandra.sh" do
  content <<-EOH
export PATH=$PATH:#{node[:csdir]}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

