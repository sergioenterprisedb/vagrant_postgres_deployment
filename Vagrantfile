# -*- mode: ruby -*-
# vi: set ft=ruby :

var_box = "generic/rocky8"

Vagrant.configure("2") do |config|

  config.vm.define "pg1" do |primary|
    primary.vm.box = var_box
    primary.vm.hostname= "pg1"
    primary.vm.network "private_network", ip: "192.168.56.11"
    primary.vm.provider "virtualbox" do |vmp|
      vmp.memory = "1024"
      vmp.cpus = "1"
      vmp.name = "vm_pg1"
    end
    primary.vm.synced_folder "./keys", "/vagrant_keys"
    primary.vm.synced_folder "./software", "/vagrant_software"
    primary.vm.provision "shell", inline: "cat ./.ssh/authorized_keys > /vagrant_keys/public_key.txt"
  end

  config.vm.define "pem1", primary: true  do |witness_pem|
    witness_pem.vm.box = var_box
    witness_pem.vm.hostname= "pem1"
    witness_pem.vm.network "private_network", ip: "192.168.56.10"
    witness_pem.vm.network "forwarded_port", guest: 8443, host: 8400
    witness_pem.vm.provider "virtualbox" do |vmw|
      vmw.memory = "1024"
      vmw.cpus = "1"
      vmw.name = "vm_pem1"
    end
    witness_pem.vm.synced_folder "./keys", "/vagrant_keys"
    witness_pem.vm.synced_folder "./software", "/vagrant_software"
    witness_pem.vm.provision "shell", path: "./keys/copy_keys.sh"
  end

  (2..3).each do |i|
     config.vm.define "pg#{i}" do |standby|
       standby.vm.box = var_box
       standby.vm.hostname = "standby#{i}"
       standby.vm.network "private_network", ip: "192.168.56.1#{i}"
       standby.vm.provider "virtualbox" do |v|
         v.memory = "1024"
         v.cpus = "1"
         v.name = "vm_pg#{i}"
       end
       standby.vm.synced_folder "./keys", "/vagrant_keys"
       standby.vm.synced_folder "./software", "/vagrant_software"
       standby.vm.provision "shell", path: "./keys/copy_keys.sh"
     end
  end

  config.vm.define "backup1" do |backup|
    backup.vm.box = var_box
    backup.vm.hostname = "backup1"
    backup.vm.network "private_network", ip: "192.168.56.14"
    backup.vm.provider "virtualbox" do |vms2|
      vms2.memory = "512"
      vms2.cpus = "1"
      vms2.name = "vm_backup1"
    end
    backup.vm.synced_folder "./keys", "/vagrant_keys"
    backup.vm.synced_folder "./software", "/vagrant_software"
    backup.vm.provision "shell", path: "./keys/copy_keys.sh"
  end

  (1..3).each do |i|
     config.vm.define "pooler#{i}" do |pooler|
      pooler.vm.box = var_box
      pooler.vm.hostname = "pooler#{i}"
      pooler.vm.network "private_network", ip: "192.168.56.2#{i}"
      pooler.vm.provider "virtualbox" do |v|
        v.memory = "512"
        v.cpus = "1"
        v.name = "vm_pooler#{i}"
      end
      pooler.vm.synced_folder "./keys", "/vagrant_keys"
      pooler.vm.synced_folder "./software", "/vagrant_software"
      pooler.vm.provision "shell", path: "./keys/copy_keys.sh"
    end
  end
end
