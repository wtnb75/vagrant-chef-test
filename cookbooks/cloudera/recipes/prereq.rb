
%w(java-1.7.0-openjdk java-1.7.0-openjdk-devel).each do |pkg|
  yum_package pkg do
    action :install
  end
end

file "/etc/profile.d/java.sh" do
  content "export JAVA_HOME=/usr/lib/jvm/java\n"
  mode 0644
  owner "root"
  group "root"
  action :create
end

file "/etc/sudoers.d/java" do
  content "Defaults env_keep+=JAVA_HOME\n"
  mode 0644
  owner "root"
  group "root"
  action :create
end

template "/etc/hosts" do
  source "hosts.erb"
  mode 0644
  owner "root"
  group "root"
end

bash "ssh-nopass" do
  cwd "/etc/ssh"
  code <<-EOH
sed -i.bak 's/^.*PermitEmpty.*$/PermitEmptyPasswords yes/g;' sshd_config
EOH
  user "root"
end
