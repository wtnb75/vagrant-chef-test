
group "hadoop" do
  append true
  system true
  members "vagrant"
  action :create
end

user "hadoop" do
  shell "/bin/sh"
  gid  "hadoop"
  password ""
  home "#{node[:hadoopdir]}"
  action :create
end

directory "/opt/boot" do
  mode 0755
  owner "hadoop"
  group "hadoop"
  action :create
end

bash "optboot-init" do
  cwd "/etc/rc.d"
  code <<-EOH
if ! grep -q /opt/boot rc.local ; then
  echo sudo -u hadoop run-parts /opt/boot >> rc.local
fi
EOH
end

bash "sshhostkeycheck" do
  cwd "/etc/ssh"
  code <<-EOH
if ! grep -q '^[ \t]*StrictHostKeyChecking' ssh_config ; then
  echo "	StrictHostKeyChecking no" >> ssh_config
fi
EOH
end
