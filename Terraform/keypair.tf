# Create AWS Key Pairs
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
  lifecycle {
    ignore_changes = [public_key]
  }
}
locals {
  home_path = data.localos_folders.folders.home
  key_path  = "${data.localos_folders.folders.ssh}/${var.key_name}"
}
# Copy the private key to the user's home directory
resource "local_sensitive_file" "private_key" {
  filename        = local.key_path
  content         = tls_private_key.rsa_4096.private_key_pem
  file_permission = "0600"
  lifecycle {
    ignore_changes = [content, filename]
  }
}



