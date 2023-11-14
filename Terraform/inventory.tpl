# master kubernetes node
[masternode]
cluster1-controlplane01 ansible_ssh_host=${masternode}

# other controlplane nodes
[controlplane]
%{ for idx, ip in split(",", controlplane) ~}
cluster1-controlplane0${idx + 2} ansible_ssh_host=${ip}
%{ endfor ~}

# worker nodes
[workernode]
%{ for idx, ip in split(",", workernode) ~}
cluster1-workernode0${idx + 1} ansible_ssh_host=${ip}
%{ endfor ~}

# load balancer
[loadbalancer]
%{ for idx, ip in split(",", loadbalancer) ~}
loadbalancer0${idx + 1} ansible_ssh_host=${ip}
%{ endfor ~}

# Define variables for SSH connection
[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/.ssh/${key_name}

# Combined group for all kubernetes nodes
[kube_nodes:children]
masternode
controlplane
workernode

# Combined group of all kubernetes nodes except masternode
[join_nodes:children]
controlplane
workernode
