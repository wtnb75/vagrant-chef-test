
%w(hue hue-server).each do |pkg|
  yum_package pkg do
    action :install
  end
end


service "hue" do
  action [:enable, :start]
end

