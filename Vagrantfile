# -*- mode: ruby -*-
# vi: set ft=ruby :''

# variables
IMAGE_NAME = "generic/centos8"
K8S_VERSION = "1.25"
MASTER_IP = "192.168.100.10"
WORKER_CNT = 3

cluster = {
  "master" => { :cpu => 2, :mem => 2048 },
  "worker" => { :cpu => 1, :mem => 1536 },
}

Vagrant.configure("2") do |config|

  # config.ssh.username = "root"
  # config.ssh.password = "vagrant"
  # config.ssh.insert_key = true

  # master node
  config.vm.define "m-k8s" do |cfg|
    cfg.vm.box = IMAGE_NAME
    cfg.vm.provider "virtualbox" do |vb|
      vb.name = "m-k8s-#{K8S_VERSION}"
      vb.cpus = cluster['master'][:cpu]
      vb.memory = cluster['master'][:mem]
      vb.gui = true
    end
    cfg.vm.host_name = "m-k8s"
    cfg.vm.network "private_network", ip: MASTER_IP
    # cfg.vm.network "forwarded_port", guest: 22, host: 10022, auto_correct: true, id: "ssh"
    cfg.vm.provision "shell", path: "common-env.sh"
    cfg.vm.provision "shell", path: "common-pkg.sh", args: K8S_VERSION
    cfg.vm.provision "shell", path: "k8s-master.sh", args: MASTER_IP
  end

  # worker node
  (1..WORKER_CNT).each do |i|
    config.vm.define "w#{i}-k8s" do |cfg|
      cfg.vm.box = IMAGE_NAME
      cfg.vm.provider "virtualbox" do |vb|
        vb.name = "w#{i}-k8s-#{K8S_VERSION}"
        vb.cpus = cluster['worker'][:cpu]
        vb.memory = cluster['worker'][:mem]
        vb.gui = true
      end
      cfg.vm.host_name = "w#{i}-k8s"
      cfg.vm.network "private_network", ip: "192.168.100.1#{i}"
      cfg.vm.provision "shell", path: "common-env.sh"
      cfg.vm.provision "shell", path: "common-pkg.sh", args: K8S_VERSION
      cfg.vm.provision "shell", path: "k8s-worker.sh", args: MASTER_IP
    end
  end
    
end