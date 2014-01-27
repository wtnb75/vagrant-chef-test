
remote_file "#{Chef::Config[:file_cache_path]}/spark-0.8.1-incubating-bin-cdh4.tgz" do
  source "http://d3kbcqa49mib13.cloudfront.net/spark-0.8.1-incubating-bin-cdh4.tgz"
  action :create
end

bash "extract" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xfz "#{Chef::Config[:file_cache_path]}"/spark-0.8.1-incubating-bin-cdh4.tgz" -C /opt
    mv /opt/spark-0.8.1-incubating-bin-cdh4 /opt/spark-0.8.1
EOH
  not_if {::File.exists?("/opt/spark-0.8.1")}
end
