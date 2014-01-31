
remote_archive "shark-#{node[:sharkver]}" do
  source "https://github.com/amplab/shark/releases/download/v#{node[:sharkver]}-rc0/shark-#{node[:sharkver]}-bin-cdh4.tar.gz"
  dest node[:sharkdir]
  owner "hadoop"
  group "hadoop"
end

remote_archive "scala-#{node[:scalaver]}" do
  source "http://www.scala-lang.org/files/archive/scala-#{node[:scalaver]}.tgz"
  dest node[:scaladir]
  owner "hadoop"
  group "hadoop"
end

remote_archive "hive-for-shark" do
  source "https://github.com/amplab/shark/releases/download/v#{node[:sharkver]}-rc0/hive-#{node[:hive4sharkver]}-bin.tgz"
  dest node[:hive4sharkdir]
  owner "hadoop"
  group "hadoop"
end

# TODO: create /opt/shark-0.8.1/conf/shark-env.sh
