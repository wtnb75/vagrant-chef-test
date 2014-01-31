
include_recipe "apache::base"

remote_archive "ant-#{node[:antver]}" do
  source "http://ftp.meisei-u.ac.jp/mirror/apache/dist//ant/binaries/apache-ant-#{node[:antver]}-bin.tar.gz"
  dest node[:antdir]
  owner "root"
  group "root"
end

file "/etc/profile.d/ant.sh" do
  content <<-EOH
export PATH=$PATH:#{node[:antdir]}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

