
remote_archive "maven-#{node[:mavenver]}" do
  source "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/maven/maven-3/#{node[:mavenver]}/binaries/apache-maven-#{node[:mavenver]}-bin.tar.gz"
  dest node[:mavendir]
end

file "/etc/profile.d/maven.sh" do
  content <<-EOH
export PATH=$PATH:#{node[:mavendir]}/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

