# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Set to use bare-bones CentOS 6.4 box
  
  config.vm.box = "centos64-x86_64-20131030"
  config.vm.box_url = "http://192.168.184.216/chockablock/vm/centos64-x86_64-20131030.box"
  config.vm.hostname = "localhost"
  
  config.vm.provider "virtualbox" do |v|
    # Override default memory allocation (512mb)
    v.name = "elasticsearch-couchbase"
    v.customize ["modifyvm", :id, "--memory", "2048"]    
  end

  config.vm.provision :shell, :path => "install_puppet.sh"
  
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
    puppet.manifest_file  = "init.pp"
    puppet.working_directory = "/vagrant"
    
    # custom facts provided to Puppet
    
    puppet.facter = {
      # tells default.pp that we're running in Vagrant
      "is_vagrant" => true,
    }
  end

  # couchbase
  config.vm.network :forwarded_port, host: 8091, guest: 8091
  config.vm.network :forwarded_port, host: 8092, guest: 8092
  # plugin
  config.vm.network :forwarded_port, host: 9091, guest: 9091
  # http testing
  config.vm.network :forwarded_port, host: 9100, guest: 9100
  # elasticsearch transport
  config.vm.network :forwarded_port, host: 9200, guest: 9200
  config.vm.network :forwarded_port, host: 9300, guest: 9300
  config.vm.network :forwarded_port, host: 9400, guest: 9400
  
  config.vm.network :forwarded_port, host: 5601, guest: 5601
end
