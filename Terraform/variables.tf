variable "aws_region" {
  type = list(string)
  default = [
    "us-east-1",
    "us-east-2"
  ]
}

variable "key_name" {}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "control_plane_count" {
  description = "Number of control plane instances to launch"
  default     = 3
}

variable "worker_node_count" {
  description = "Number of worker node instances to launch"
  default     = 2
}

variable "load_balancer_count" {
  description = "Number of load balancer instances to launch"
  default     = 2
}

variable "ansible_controller_count" {
  description = "Number of Ansible master controller instances to launch"
  default     = 1
}

variable "loadbalancer_private_ips" {
  description = "Private IP addresses for the load balancers"
  type        = list(string)
  default     = ["172.31.31.50", "172.31.31.51"]
}

variable "controlplane_private_ips" {
  description = "Private IP addresses for the controlplane nodes"
  type        = list(string)
  default     = ["172.31.31.101", "172.31.31.102"]
}

variable "workernode_private_ips" {
  description = "Private IP addresses for the worker nodes"
  type        = list(string)
  default     = ["172.31.31.201", "172.31.31.202"]
}

variable "username" {
  description = "Username for SSH connections"
  default     = "ubuntu"
}

variable "ansible_local_path" {
  description = "Folder Path of Local PC Ansible folder"
  default     = "C:/DevOps/KodeKloudEngineer/Kubernetes/CKA/My-CKA-Study/CKA-Test-Lab/Ansible/"
}


