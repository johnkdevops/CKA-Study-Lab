variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "key_name" {
  description = "Key pair name"
  default     = "cka-key"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of instances to launch"
  default     = 3
}

variable "username" {
  description = "Username for SSH connections"
  default     = "ec2-user"
}

