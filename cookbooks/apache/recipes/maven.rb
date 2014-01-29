
remote_file "#{Chef::Config[:file_cache_path]}/apache-maven-#{node[:mavenver]}-bin.tar.gz" do
  source "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/maven/maven-3/#{node[:mavenver]}/binaries/apache-maven-#{node[:mavenver]}-bin.tar.gz"
  action :create
end

bash "extract-maven311" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/apache-maven-#{node[:mavenver]}-bin.tar.gz" -C /opt
    mv /opt/apache-maven-#{node[:mavenver]} #{node[:mavendir]}
EOH
  not_if {::File.exists?("#{node[:mavendir]}")}
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

