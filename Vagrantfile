# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant/provisioners/chef'

#
# Before running vagrant, export the shell variable for the organization on Hosted Chef and
# make sure the validator certificate is in ~/.chef.
#
# export ORGNAME=your_platform_organization
#
# You can optionally export a shell variable for your Chef server username if it is different
# from your OS user export OPSCODE_USER=bofh

Vagrant::Config.run do |config|

  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
  config.vm.customize [ "modifyvm", :id, "--memory", 1024]
  config.vm.customize [ "modifyvm", :id, "--cpus", 2 ]
  config.vm.host_name = "alice.local"
  config.vm.network :hostonly, "172.16.20.125", :netmask => "255.255.255.0"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path    = [ '/tmp/alice-cookbooks' ]
    chef.provisioning_path = "/etc/chef"
    chef.log_level = :info

    chef.run_list = [
      "recipe[alice]"
    ]

    chef.json = { :nginx => { "version" => "1.0.14" } }
  end
end
