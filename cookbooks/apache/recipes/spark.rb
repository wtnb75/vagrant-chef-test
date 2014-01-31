
remote_archive "spark-0.8.1" do
  source "http://d3kbcqa49mib13.cloudfront.net/spark-0.8.1-incubating-bin-cdh4.tgz"
  dest "/opt/spark-0.8.1"
  owner "hadoop"
  group "hadoop"
end
