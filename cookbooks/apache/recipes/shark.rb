
remote_file "#{Chef::Config[:file_cache_path]}/shark-0.8.1-bin-cdh4.tar.gz" do
  source "https://github.com/amplab/shark/releases/download/v0.8.1-rc0/shark-0.8.1-bin-cdh4.tar.gz"
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/scala-2.9.3.tgz" do
  source "http://www.scala-lang.org/files/archive/scala-2.9.3.tgz"
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/=hive-0.9.0-bin.tgz" do
  source "https://github.com/amplab/shark/releases/download/v0.8.1-rc0/hive-0.9.0-bin.tgz"
  action :create
end

bash "extract" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}"/shark-0.8.1-bin-cdh4.tar.gz" -C /opt
    tar xfz "#{Chef::Config[:file_cache_path]}"/scala-2.9.3.tgz" -C /opt
    tar xfz "#{Chef::Config[:file_cache_path]}"/hive-0.9.0-bin.tgz" -C /opt
    mv /opt/shark-0.8.1-bin-cdh4 /opt/shark-0.8.1
    mv /opt/hive-0.9.0-bin /opt/hive-0.9.0
EOH
  not_if {::File.exists?("/opt/shark-0.8.1")}
end

# TODO: create /opt/shark-0.8.1/conf/shark-env.sh
