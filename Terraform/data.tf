
# Canonical, Ubuntu, 20.04 LTS, amd64 focal image
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# # Get all Availability zones in region
# data "aws_availability_zones" "available_zones" {}

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
      "${var.aws_region[0]}a",
      "${var.aws_region[0]}b",
      "${var.aws_region[0]}c"
    ]
  }
}

# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default_vpc.id]
#   }
#   filter {
#     name = "availability-zone"
#     values = [
#       "${var.aws_region[0]}a",
#       "${var.aws_region[0]}b",
#       "${var.aws_region[0]}c"
#     ]
#   }
# }

data "aws_instance" "loadbalancer_instances" {
  count = var.load_balancer_count

  instance_id = aws_instance.loadbalancer[count.index].id
}

data "aws_instance" "controlplane_instances" {
  count = var.control_plane_count

  instance_id = aws_instance.controlplane[count.index].id
}

data "aws_instance" "workernode_instances" {
  count = var.worker_node_count

  instance_id = aws_instance.workernode[count.index].id
}


data "localos_folders" "folders" {}

data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")

  vars = {
    masternode   = join(",", [for instance in aws_instance.controlplane : instance.public_ip if instance.tags.Name == "cluster1-controlplane01"])
    controlplane = join(",", [for instance in aws_instance.controlplane : instance.public_ip if instance.id != aws_instance.controlplane[0].id])
    workernode   = join(",", [for instance in aws_instance.workernode : instance.public_ip])
    loadbalancer = join(",", [for instance in aws_instance.loadbalancer : instance.public_ip])
    key_name     = var.key_name
  }
}



