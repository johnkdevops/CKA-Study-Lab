# AWS Key-Pairs
resource "aws_key_pair" "ckakey" {
  public_key = file("/home/cloud-user/cka_key.pub")
}

# Controlplane Nodes
resource "aws_instance" "controlplane" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.cka-subnet.id
  vpc_security_group_ids = [aws_security_group.cka-sg.id]
  key_name               = aws_key_pair.ckakey.id
  associate_public_ip_address = true

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
  key_name               = aws_key_pair.ckakey.id
  associate_public_ip_address = true

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
  key_name               = aws_key_pair.ckakey.id
  associate_public_ip_address = true

  tags = {
    Name = "loadbalancer-${count.index}"
  }
}