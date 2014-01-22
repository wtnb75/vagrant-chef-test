
execute "zoneinfo" do
  user "root"
  command "ln -sf /usr/share/zoneinfo/Japan /etc/localtime"
  action :run
end
