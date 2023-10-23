# controlplane nodes
[controlplane]
%{ for idx, ip in split(",", controlplane) ~}
cluster1-controlplane${idx + 1} ansible_ssh_host=${ip}
%{ endfor ~}

# worker nodes
[workernode]
%{ for idx, ip in split(",", workernode) ~}
cluster1-workernode${idx + 1} ansible_ssh_host=${ip}
%{ endfor ~}

# load balancer
[load_balancer]
loadbalancer1 ansible_ssh_host=${loadbalancer}

# Define variables for SSH connection
[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=/home/ec2-user/${key_name}