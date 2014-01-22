
yum_package "ntp" do
  action :install
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/ntp/step-tickers" do
  source "step-tickers.erb"
  owner "root"
  group "root"
  mode 0644
end

%w(ntpdate ntpd).each do |svc|
  service svc do
    action [:enable, :stop]
  end
end

%w(ntpdate ntpd).each do |svc|
  service svc do
    action :start
  end
end
