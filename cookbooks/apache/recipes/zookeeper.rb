
include_recipe "apache::base"

remote_file "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zkver]}.tar.gz" do
  source "http://ftp.kddilabs.jp/infosystems/apache/zookeeper/zookeeper-#{node[:zkver]}/zookeeper-#{node[:zkver]}.tar.gz"
  action :create
end

bash "extract-zookeeper" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zkver]}.tar.gz" -C /opt
    chown -R hadoop:hadoop #{node[:zkdir]}
EOH
  not_if {::File.exists?("#{node[:zkdir]}")}
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

