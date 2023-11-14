# Create LoadBalancers to use as HAProxy to balance the load between controlplane nodes
resource "aws_instance" "loadbalancer" {
  count                  = var.load_balancer_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-lb-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "loadbalancer0${count.index + 1}"
  }
}

# Create 3 Controlplane Nodes for Kubernetes Cluster
resource "aws_instance" "controlplane" {
  count                  = var.control_plane_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-master-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "cluster1-controlplane0${count.index + 1}"
  }
}

# Create 2 Worker Nodes for Kubernetes Cluster
resource "aws_instance" "workernode" {
  count                  = var.worker_node_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-worker-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "cluster1-workernode0${count.index + 1}"
  }
}

# Create Ansible_controller used to configure Controlplane nodes, worker nodes, and loadbalancer
resource "aws_instance" "ansiblecontroller" {
  count                  = var.ansible_controller_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.public.ids)[count.index % length(data.aws_subnets.public.ids)]
  vpc_security_group_ids = [aws_security_group.cka-ansible-sg.id]
  key_name               = aws_key_pair.key_pair.key_name
  tags = {
    Name = "ansiblecontroller0${count.index + 1}"
  }

  # Install updates and ansible onto ansible controller
  user_data = file("install_ansible.sh")
  connection {
    type        = "ssh"
    user        = var.username
    private_key = local.key_path
    host        = self.public_ip
  }
}

# Copying the private key to Ansible Controller used to SSH into controlplane, workernodes, and Loadbalancer
resource "null_resource" "copy_private_key" {
  provisioner "file" {
    source      = "~/.ssh/${var.key_name}"
    destination = "/home/ubuntu/.ssh/${var.key_name}"
  }
  provisioner "remote-exec" {
    inline = ["sudo chmod 600 /home/ubuntu/.ssh/${var.key_name}"]
  }
  connection {
    type        = "ssh"
    user        = var.username
    private_key = file(local.key_path)
    host        = aws_instance.ansiblecontroller[0].public_ip
  }
}

# Dynamically create the inventory.ini
resource "local_file" "inventory" {
  filename = "${path.module}/../Ansible/inventory.ini"
  content  = data.template_file.inventory.rendered
}

# Use the provisioner block to copy all files inside Ansible on Local PC
resource "null_resource" "copy_ansible_config_files" {
  depends_on = [aws_instance.ansiblecontroller]
  connection {
    type        = "ssh"
    user        = var.username
    private_key = tls_private_key.rsa_4096.private_key_pem
    host        = aws_instance.ansiblecontroller[0].public_ip
  }

  provisioner "file" {
    source      = var.ansible_local_path
    destination = "/home/ubuntu/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ansible_setup.sh",
      "./ansible_setup.sh"
    ]
  }
}







