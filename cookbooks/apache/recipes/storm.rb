
remote_archive "storm-#{node[:stormver]}" do
  source "https://dl.dropboxusercontent.com/s/tqdpoif32gufapo/storm-#{node[:stormver]}.tar.gz"
  dest node[:stormdir]
end

file "/etc/profile.d/storm.sh" do
  content <<-EOH
export PATH=$PATH:#{node[:stormdir]}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

