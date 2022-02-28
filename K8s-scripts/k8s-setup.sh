#! /usr/bin/env bash
# K8s setup script - 0.1.0

# Update the OS
echo "Checking server packages are up to date"
apt-get update -y && apt-get upgrade -y

# Prep work for containerd to function appropriately
echo "Starting containerd setup"
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

cat << EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nr-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ipv6tables = 1
EOF

sysctl --system

# Installation of containerd
echo "Installing containerd and finishing it's setup"
apt-get update && sudo apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
systemctl restart containerd

# Disabling swap
echo "Disabling swap for proper functionality"
swapoff -a
sed -i ‘/ swap / s/^\(.*\)$/#\1/g’ /etc/fstab

# Preparatory work for K8s package installation
echo "Starting installation of K8s packages"
apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update && apt-get install -y kubelet=1.23.0-00 kubeadm=1.23.0-00 kubectl=1.23.0-00
sudo apt-mark hold kubelet kubeadm kubectl

# End of script
echo "This script is now done."
echo "If this is the admin server, you have a few more steps below:"
echo "  - Initialize networking."
echo "  - Basic k8s config."
echo "  - Generating tokens for workers to join cluster."
echo "  - Test all is working as expected."
echo "  - Have fun with your new setup."
echo "If this is a worker node, don't forget to join with the token provided from the admin server."
echo "Now have a great day."
