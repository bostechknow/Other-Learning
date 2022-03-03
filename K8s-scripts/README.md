# Some information about K8s for learning

## Some useful K8s sites

- https://kubernetes.io/docs/
- https://github.com/kubernetes/
- https://kubernetes.io/blog/
- https://hackr.io/tutorials/learn-kubernetes?sort=upvotes&type_tags%5B%5D=1

## Some useful K8s commands

- `kubectl get nodes`
- `kubectl get pods`
- `kubectl get pods -n kube-system`
- `kubectl get service`
- `kubectl describe service <my-service>`

## Files in this folder

- k8s-setup.md  - Walkthrough for setting up a k8s cluster in ACG's Playground using their Cloud Server option
- k8s-setup.sh  - Bash script to be run on all three nodes in the ACG's Playground setup
- k8s-admin-setup.sh - Bash script for admin node setup in the ACG's Playground setup