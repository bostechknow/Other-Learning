#! /usr/bin/env bash
# K8s admin setup script - 0.1.0

# Setup basic networking
echo "Creating basic K8s network"
kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0

# Setup kube for command line use
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Setup networking pod
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Checks that control node is only one available
kubectl get nodes

# Creates token for joining worker nodes to cluster
echo "Use the following output to join worker nodes to the cluster."
echo "Don't forget to use sudo when running the command."
kubeadm token create --print-join-command

# Script is now completed
echo "This script is now done."
echo "Use the token to join your workers to the cluster."
echo "After joining, wait about a minute to check that they are now ready."
