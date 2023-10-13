# AWS Key-Pairs
resource "tls_private_key" "cka-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.cka-key.public_key_openssh
}

# Controlplane Nodes
resource "aws_instance" "controlplane" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cka-subnet.id
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "controlplane-${count.index}"
  }
}
 
# Worker Node
resource "aws_instance" "workernode" {
  count                  = 1
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cka-subnet.id
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "workernode-${count.index}"
  }
}

# Load Balancer
resource "aws_instance" "loadbalancer" {
  count                  = 1
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cka-subnet.id
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "loadbalancer-${count.index}"
  }
}