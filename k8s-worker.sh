#!/usr/bin/env bash

K8S_APISERVER_IP=$1

sudo kubeadm join $K8S_APISERVER_IP:6443 --token 123456.1234567890123456 \
    --discovery-token-unsafe-skip-ca-verification
