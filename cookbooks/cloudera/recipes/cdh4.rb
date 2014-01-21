
execute "rpmkey" do
  user "root"
  command "rpm --import http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera"
  action :run
end

rpm_package "cloudera-cdh" do
  source "http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm"
  action :install
end
