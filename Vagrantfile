# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "cent65"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"
  # config.vm.network :forwarded_port, guest: 80, host: 8080
  # config.vm.network :private_network, ip: "192.168.33.10"
  # config.vm.network :public_network
  # config.ssh.forward_agent = true
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provider :virtualbox do |vb|
  #   vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  $once_chef = <<SCRIPT
rpm -q chef && exit
curl -L https://www.opscode.com/chef/install.sh | bash
SCRIPT
  config.vm.provision "shell", inline: $once_chef 
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "cloudera::prereq"
    chef.add_recipe "cloudera::cdh4"
    chef.add_recipe "cloudera::pseudo"
  #   chef.cookbooks_path = "./cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #   chef.json = { :mysql_password => "foo" }
  end
end
