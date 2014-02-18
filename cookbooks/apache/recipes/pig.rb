
include_recipe "apache::base"

remote_archive "pig-#{node[:pigver]}" do
  source "http://ftp.iij.ad.jp/pub/network/apache/pig/pig-#{node[:pigver]}/pig-#{node[:pigver]}.tar.gz"
  dest node[:pigdir]
  owner "hadoop"
  group "hadoop"
end

file "/etc/profile.d/pig.sh" do
  content <<-EOH
export PIG_HOME=#{node[:pigdir]}
export PATH=$PATH:${PIG_HOME}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

file "/etc/sudoers.d/hive" do
  content <<-EOH
Defaults env_keep+="PIG_HOME"
Defaults secure_path+="#{node[:pigdir]}/bin"
EOH
  owner "root"
  group "root"
  action :create
end
