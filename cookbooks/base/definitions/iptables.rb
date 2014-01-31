
define :iptables_open_tcp, :port => -1 do
  if params[:port]>0 then
    bash "iptables-#{params[:port]}" do
      code <<-EOH
sed -i.bak -e '/--dport 22/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport #{params[:port]} -j ACCEPT' /etc/sysconfig/iptables
EOH
      not_if "grep -q -- \"--dport #{params[:port]} \" /etc/sysconfig/iptables"
    end
    service "iptables-restart-#{params[:port]}" do
      service_name "iptables"
      action :restart
    end
  end
end
