
remote_file "#{Chef::Config[:file_cache_path]}/apache-maven-3.1.1-bin.tar.gz" do
  source "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz"
  action :create
end

bash "extract-maven311" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/apache-maven-3.1.1-bin.tar.gz" -C /opt
    mv /opt/apache-maven-3.1.1 /opt/maven-3.1.1
EOH
  not_if {::File.exists?("/opt/maven-3.1.1")}
end

file "/etc/profile.d/maven.sh" do
  content <<-EOH
export PATH=$PATH:/opt/maven-3.1.1/bin
EOH
  owner "root"
  group "root"
  mode 0644
  action :create
end

