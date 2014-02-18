
remote_archive "spark-#{node[:sparkver]}" do
  source "http://d3kbcqa49mib13.cloudfront.net/spark-#{node[:sparkver]}-incubating-bin-hadoop2.tgz"
  dest "#{node[:sparkdir]}"
  owner "hadoop"
  group "hadoop"
end
