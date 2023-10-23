variable "aws_region" {
  type    = string
  default = "us-east-1"
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
  default     = 1
}

variable "ansible_controller_count" {
  description = "Number of Ansible master controller instances to launch"
  default     = 1
}

variable "username" {
  description = "Username for SSH connections"
  default     = "ec2-user"
}

