
remote_file "/etc/yum.repos.d/jenkins.repo" do
  source "http://pkg.jenkins-ci.org/redhat/jenkins.repo"
  owner "root"
  group "root"
  mode 0644
end

bash "jenkins-key" do
  code "rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key"
end

yum_package "jenkins" do
  action :install
end

iptables_open_tcp "jenkins-port" do
  port 8080
end

service "jenkins" do
  action [:enable, :start]
end
