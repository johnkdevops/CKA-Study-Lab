output "home_directory" {
  value = data.localos_folders.folders.home
}

output "ssh_keys_directory" {
  value = data.localos_folders.folders.ssh
}

output "ansiblecontroller" {
  value = {
    for i in aws_instance.ansiblecontroller : i.id => {
      name      = i.tags["Name"]
      public_ip = i.public_ip
    }
  }
  description = "Details of EC2 instances"
}

output "ansible_controller_public_ip" {
  description = "Public IP of the Ansible Controller instance"
  value       = aws_instance.ansiblecontroller[0].public_ip
}

output "controlplane" {
  value = {
    for i in aws_instance.controlplane : i.id => {
      name      = i.tags["Name"]
      public_ip = i.public_ip
    }
  }
  description = "Details of EC2 instances"
}

output "controlplane_private_ips" {
  value = aws_instance.controlplane[*].private_ip
}

output "workernode" {
  value = {
    for i in aws_instance.workernode : i.id => {
      name      = i.tags["Name"]
      public_ip = i.public_ip
    }
  }
  description = "Details of EC2 instances"
}

output "workernode_private_ips" {
  value = aws_instance.workernode[*].private_ip
}

output "loadbalancer" {
  value = {
    for i in aws_instance.loadbalancer : i.id => {
      name      = i.tags["Name"]
      public_ip = i.public_ip
    }
  }
  description = "Details of EC2 instances"
}

output "loadbalancer_private_ips" {
  value = aws_instance.loadbalancer[*].private_ip
}