
remote_file "#{Chef::Config[:file_cache_path]}/epel-release.rpm" do
  source "http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
  action :create
end

rpm_package "epel-releaseh" do
  source "#{Chef::Config[:file_cache_path]}/epel-release.rpm"
  action :install
end

