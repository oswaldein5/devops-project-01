Vagrant.configure("2") do |config|
  # Set the VM box for all VMs
  config.vm.box = "bento/ubuntu-24.04"

  # Provider-specific [VirtualBox --> virtualbox, VMware --> vmware_desktop]
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  # VM Apache-PHP
  config.vm.define "srv_apache_php" do |srv_apache_php|
    srv_apache_php.vm.network :forwarded_port, guest: 80, host: 80
    srv_apache_php.vm.network :private_network, ip: "192.168.56.5", virtualbox__intnet: true
    
    # Shared folder
    srv_apache_php.vm.synced_folder "srv-web", "/home/vagrant/srv-web"
    srv_apache_php.vm.synced_folder "php-app", "/home/vagrant/php-app"

    # Shell to provision the Apache-PHP server
    srv_apache_php.vm.provision "shell", path: "srv-web/scripts/setup-srv-web.sh"
  end

  # VM MySQL
  config.vm.define "srv_mysql" do |srv_mysql|
    srv_mysql.vm.network :private_network, ip: "192.168.56.6", virtualbox__intnet: true
    
    # Shared folder
    srv_mysql.vm.synced_folder "srv-bd", "/home/vagrant/srv-bd"

    # Shell to provision the MySQL server
    srv_mysql.vm.provision "shell", path: "srv-bd/scripts/setup-srv-bd.sh"
    
  end
end