resource "aws_default_vpc" "default" {}

resource "aws_security_group" "cka-sg" {
  name        = "cka-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cka-sg"
  }
}

## Create AWS Key Pairs
resource "tls_private_key" "rsa_4096" {
 algorithm = "RSA"
 rsa_bits = 4096
}

resource "aws_key_pair" "key_pair" {
 key_name  = var.key_name
 public_key = tls_private_key.rsa_4096.public_key_openssh
 lifecycle {
  ignore_changes = ["public_key"]
 }
}

# Checks what OS Terraform is running on and creates a text with variable
resource "null_resource" "os_type" {
 triggers = {
  always_run = "${timestamp()}"
 }
 provisioner "local-exec" {
  command = <<EOC
  @echo off
  echo Checking OS type...
  if "%OS%" == "Windows_NT" (
    echo Detected Windows
    echo windows > os.txt
  ) else (
    echo Detected Linux
    echo linux > os.txt
  )
  EOC
 }
}

locals {
 os_type  = trim(data.local_file.os_type.content, "\n")
 home_path = local.os_type == "windows" ? "C:/Users/Home" : "/root"
 key_path = "${local.home_path}/${var.key_name}"
}

# Copy the private key to my Home folder on my Local PC
resource "local_file" "private_key" {
 filename    = local.key_path
 content     = tls_private_key.rsa_4096.private_key_pem
 file_permission = "0600"
#  lifecycle {
#    ignore_changes = [content]
#  }
}

resource "null_resource" "copy_private_key" {
 depends_on = [aws_instance.ansiblecontroller]
 # Assumes you have the correct connection set up
 connection {
  type    = "ssh"
  user    = "ec2-user"
  private_key = file(local.key_path)
  host    = aws_instance.ansiblecontroller[0].public_ip
 }
}