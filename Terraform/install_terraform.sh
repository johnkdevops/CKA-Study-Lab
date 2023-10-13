#!/bin/bash

# Download the latest version of Terraform
curl -LO https://releases.hashicorp.com/terraform/1.6.1/terraform_1.6.1_linux_amd64.zip

# Unzip the downloaded file 
unzip terraform_1.6.1_linux_amd64.zip

# Move the executable into your PATH
sudo mv terraform /usr/local/bin/

# Remove the original download
rm terraform_1.6.1_linux_amd64.zip

# Verify the installation
terraform --version