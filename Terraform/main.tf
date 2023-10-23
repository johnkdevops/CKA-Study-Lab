# Controlplane Nodes
resource "aws_instance" "controlplane" {
  count                  = var.control_plane_count
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "cluster1-controlplane${count.index + 1}"
  }
}

# Worker Node
resource "aws_instance" "workernode" {
  count                  = var.worker_node_count
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "cluster1-workernode0${count.index + 1}"
  }
}

# Load Balancer
resource "aws_instance" "loadbalancer" {
  count                  = var.load_balancer_count
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "loadbalancer${count.index + 1}"
  }
}

# Ansible_controller
resource "aws_instance" "ansiblecontroller" {
  count                  = var.ansible_controller_count
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "ansiblecontroller${count.index}"
  }
  user_data = file("install_ansible_yum.sh")
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = local.key_path # Replace with the path to your private key
    host        = self.public_ip
  }
}

# Use the provisioner block to copy the inventory file
resource "null_resource" "copy_inventory" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.rsa_4096.private_key_pem
    host        = aws_instance.ansiblecontroller[0].public_ip
  }
  provisioner "file" {
    source      = "inventory.ini"
    destination = "/home/ec2-user/inventory.ini"
  }
  provisioner "remote-exec" {
    inline = ["sudo mkdir -p /etc/ansible",
      "sudo mv /home/ec2-user/inventory.ini /etc/ansible/"
    ]
  }
}
resource "local_file" "inventory" {
  filename = "${path.module}/inventory.ini"
  content  = data.template_file.inventory.rendered
}

# resource "null_resource" "update_inventory" {
#   triggers = {
#     # Use a unique trigger to force the script to run each time.
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     command = "runas /user:Admin python3 update_inventory_ini.py"
#   }
# }
