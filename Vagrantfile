# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 4000, host: 4001

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbooks/vagrant.yml"
    ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
    ansible.sudo = true
  end
end
