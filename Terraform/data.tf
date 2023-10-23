data "aws_ami_ids" "amazon" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2"]
  }
}

# AWS AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Get the default VPC details
data "aws_vpc" "default_vpc" {
  default = true
}

# Get 3 subnets from default VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  filter {
    name = "availability-zone"
    values = [
      "${var.aws_region}a",
      "${var.aws_region}b",
      "${var.aws_region}c"
    ]
  }
}

data "local_file" "os_type" {
  depends_on = [null_resource.os_type]
  filename   = "${path.module}/os.txt"
}
data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")

  vars = {
    controlplane = join(",", [for instance in aws_instance.controlplane : instance.public_ip])
    workernode   = join(",", [for instance in aws_instance.workernode : instance.public_ip])
    loadbalancer = aws_instance.loadbalancer[0].public_ip
    key_name     = var.key_name
  }
}


