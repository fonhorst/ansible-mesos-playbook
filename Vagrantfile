# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # for building we use the same files as for the regular run
  config.ssh.forward_agent = true
  config.vm.synced_folder Dir.getwd, "/home/vagrant/ansible-mesos-playbook"

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxy.ifmo.ru:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,"
  end

  # read data for vagrant run
  nds = File.open("hosts","r") do |hosts|
	nodes = {}
	while(line = hosts.gets) do
		if line.start_with?("###")
			break
		end
		strs = line.strip().split(" ")
		params = {}
		for s in strs[1..-1] do
			pair = s.split("=")
			params[pair[0]]=pair[1]
		end
		nodes[strs[0]] = params
	end
	nodes
  end

  # ubuntu
  nds.keys.sort.each.map do |name|
    ip = nds[name]["ansible_ssh_host"]

    config.vm.define name, primary: true do |c|
      c.vm.network "public_network", ip: ip, netmask: "255.255.0.0"
      #c.vm.box = "build/mesos-ubuntu"
      c.vm.box = "ubuntu/trusty64"
      c.vm.hostname = name
      c.vm.provision "shell" do |s|
        s.inline = "apt-add-repository ppa:ansible/ansible -y; apt-get update -y; apt-get install ansible -y;"
        s.privileged = true
      end
      config.vm.provision "ansible" do |ansible|
          ansible.playbook = "playbook.yml"
          ansible.inventory_path="hosts"
          ansible.verbose = "vvvv"
      end
    end
  end
end
