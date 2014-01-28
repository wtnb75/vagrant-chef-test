# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "cent64"
  #config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect=true
  end
  # config.vm.network :forwarded_port, guest: 80, host: 8080
  # config.vm.network :private_network, ip: "192.168.33.10"
  # config.vm.network :public_network
  # config.ssh.forward_agent = true
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provider :virtualbox do |vb|
  #   vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  $once_chef = <<SCRIPT
rpm -q chef && exit
curl -L https://www.opscode.com/chef/install.sh | bash
SCRIPT
  # config.vm.provision "shell", inline: $once_chef 
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "base::tmpfs"
    chef.add_recipe "base::ntp"
    chef.add_recipe "base::timezone"
    chef.add_recipe "base::epel"
    chef.add_recipe "cloudera::prereq"
    chef.add_recipe "apache::hadoop22"
    chef.add_recipe "apache::hive012"
    chef.add_recipe "presto::server"
    chef.add_recipe "presto::discovery"
    chef.add_recipe "presto::cli"
    chef.add_recipe "apache::maven"
  #  chef.add_recipe "cloudera::cdh4"
  #  chef.add_recipe "cloudera::pseudo_yarn"
  #  chef.add_recipe "cloudera::hive"
  #  chef.add_recipe "cloudera::impala"
  #   chef.add_recipe "cloudera::hue"
  #   chef.cookbooks_path = "./cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #   chef.json = { :mysql_password => "foo" }
  end
end
