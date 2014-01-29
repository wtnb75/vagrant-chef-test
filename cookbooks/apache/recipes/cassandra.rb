
include_recipe "apache::base"

remote_file "#{Chef::Config[:file_cache_path]}/apache-cassandra-#{node[:csver]}-bin.tar.gz" do
  source "http://ftp.tsukuba.wide.ad.jp/software/apache/cassandra/#{node[:csver]}/apache-cassandra-#{node[:csver]}-bin.tar.gz"
  action :create
end

bash "extract-cassandra" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}/apache-cassandra-#{node[:csver]}-bin.tar.gz" -C /opt
    if [ "/opt/apache-cassandra-#{node[:csver]}" != "#{node[:csdir]}" ] ; then
      mv "/opt/apache-cassandra-#{node[:csver]}" #{node[:csdir]}
    fi
    chown -R hadoop:hadoop #{node[:csdir]}
EOH
  not_if {::File.exists?("#{node[:csdir]}")}
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

