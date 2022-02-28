# Simple K8s cluster setup in ACG Playground

- Create 1 admin server (i.e. k8s-control) - Ubuntu 20.04, Size Medium
- Create 2 admin servers (i.e. k8s-worker1, etc) - Ubuntu 20.04, Size Medium
- Copy the k8s-setup.sh script to the server, via sftp, copy and paste or whatever method works for you
- Add your default user to the admin sudoers group, if desired
    - `sudo usermod cloud_user -aG admin`
- Configure the hostname on each instance to be something useful (i.e. k8s-control)
    - `sudo hostnamectl set-hostname k8s-control`
- Configure /etc/hosts on all three instances to look something like this:
    - 172.31.x.1  k8s-control
    - 172.31.x.2  k8s-worker1
    - 172.31.x.3  k8s-worker2
- Run the k8s-setup.sh as root
    - `sudo ./k8s-setup.sh`
- On the admin server, setup networking
    - `sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0`
- On the admin server, apply a network pod (i.e. Calico)
    - `kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml`
- Setup basic kube config as your regular user
    - `mkdir -p $HOME/.kube`
    - `sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`
    - `sudo chown $(id -u):$(id -g) $HOME/.kube/config`
    - Or, if you are root, you can use the following:
        - `export KUBECONFIG=/etc/kubernetes/admin.conf`
- On the admin server, generate access tokens for worker nodes
    - `kubeadm token create --print-join-command`
- On the worker nodes, use the access token to join the cluster
    - `sudo kubeadm join 172.31.x.1:6443 --token c8mtvp.mlv0olb6xxxxxxxx --discovery-token-ca-cert-hash sha256:ab13a8d288632c26dedac2732e74e74cee8105ddb148b89b6e0xxxxxxxxxxxxx `

## Some useful K8s commands

- `kubectl get nodes`
- `kubectl get pods`
- `kubectl get service`
- `kubectl describe service <my-service>`