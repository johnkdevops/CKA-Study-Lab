
# Controlplane Nodes
resource "aws_instance" "controlplane" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cka-subnet.id
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = var.key_name

  tags = {
    Name = "controlplane-${count.index}"
  }

  provisioner "file" {
    source      = var.public_key_path
    destination = "~/.ssh/id_rsa.pub"

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

# Worker Node
resource "aws_instance" "workernode" {
  count                  = 1
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cka-subnet.id
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = var.key_name

  tags = {
    Name = "workernode-${count.index}"
  }

  provisioner "file" {
    source      = var.public_key_path
    destination = "~/.ssh/id_rsa.pub"

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

# Load Balancer
resource "aws_instance" "loadbalancer" {
  count                  = 1
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cka-subnet.id
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = var.key_name

  tags = {
    Name = "loadbalancer-${count.index}"
  }

  provisioner "file" {
    source      = var.public_key_path
    destination = "~/.ssh/id_rsa.pub"

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}