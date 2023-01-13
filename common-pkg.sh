##!/usr/bin/env bash

OS=CentOS_8
CRIO_VERSION=$1
K8S_VERSION=$1

# add apt repositories
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.repo

# install cri-o
sudo yum update -y
sudo yum install -y cri-o

sudo systemctl daemon-reload
sudo systemctl enable --now crio

sudo yum install -y cri-tools

# install kubelet, kubeadm, kubectl
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo yum install -y kubelet-$K8S_VERSION.0 kubeadm-$K8S_VERSION.0 kubectl-$K8S_VERSION.0 --disableexcludes=kubernetes
sudo yum install -y python3-dnf-plugin-versionlock
sudo yum versionlock kubelet kubeadm kubectl

# set kubernetes node internal ip with eth1
cat << EOF | sudo tee /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS='--node-ip $(hostname -I | cut -d ' ' -f2)'
EOF
sudo systemctl enable --now kubelet

# install calicoctl
cd /usr/bin
sudo curl -L https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64 -o calicoctl
sudo chmod +x calicoctl
