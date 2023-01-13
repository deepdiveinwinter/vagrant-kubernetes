#!/usr/bin/env bash

K8S_APISERVER_IP=$1

# install kubernetes master (default cri-o CIDR: 10.85.0.0/16)
sudo kubeadm config images pull
sudo kubeadm init --token 123456.1234567890123456 --token-ttl 0 \
    --apiserver-advertise-address=$K8S_APISERVER_IP --pod-network-cidr=10.85.0.0/16 --cri-socket=unix:///var/run/crio/crio.sock

# make kubeconfig files to default directory
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install calico CNI (default calico CIDR: 192.168.0.0/16)
sudo kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml
sudo curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml -O
sudo sed -i 's/192.168.0.0/10.85.0.0/g' custom-resources.yaml
sudo kubectl create -f custom-resources.yaml
