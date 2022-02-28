# Simple K8s cluster setup in ACG Playground

- Create 1 admin server (i.e. k8s-control) - Ubuntu 20.04, Size Medium
- Create 2 admin servers (i.e. k8s-worker1, etc) - Ubuntu 20.04, Size Medium
- Add your default user to the admin sudoers group, if desired
    - `sudo usermod cloud_user -aG admin`
- Configure the hostname on each instance to be something useful (i.e. k8s-control)
    - `sudo hostnamectl set-hostname k8s-control`
- Configure /etc/hosts on all three instances to look something like this:
    - `sudo vi /etc/hosts`
    - 172.31.x.1  k8s-control
    - 172.31.x.2  k8s-worker1
    - 172.31.x.3  k8s-worker2
- Run the k8s-setup.sh as root
    - `wget https://raw.githubusercontent.com/mbostic-test/Other-Learning/main/K8s-scripts/k8s-setup.sh`
    - `chmod +x k8s-setup.sh`
    - `sudo ./k8s-setup.sh`
- Run the k8s-admin-setup.sh as root on the admin server only
    - `wget https://raw.githubusercontent.com/mbostic-test/Other-Learning/main/K8s-scripts/k8s-admin-setup.sh`
    - `chmod +x k8s-admin-setup.sh`
    - `sudo ./k8s-admin-setup.sh`
- Alternatively, you can manually perform the following tasks:
    - On the admin server, setup networking
        - `sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0`
    - On the admin server, apply a network pod (i.e. Calico)
        - `kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml`
    - Setup basic kube config as your regular user
        - `mkdir -p $HOME/.kube`
        - `sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`
        - `sudo chown $(id -u):$(id -g) $HOME/.kube/config`
    - On the admin server, generate access tokens for worker nodes
        - `kubeadm token create --print-join-command`
- On the worker nodes, use the access token to join the cluster
    - `sudo kubeadm join 172.31.x.1:6443 --token c8mtvp.mlv0olb6xxxxxxxx --discovery-token-ca-cert-hash sha256:ab13a8d288632c26dedac2732e74e74cee8105ddb148b89b6e0xxxxxxxxxxxxx `

## Some useful K8s commands

- `kubectl get nodes`
- `kubectl get pods`
- `kubectl get pods -n kube-system`
- `kubectl get service`
- `kubectl describe service <my-service>`