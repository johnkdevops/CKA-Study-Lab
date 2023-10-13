#!/bin/bash

# Clone the tfenv repository into the .tfenv directory in the home directory
git clone https://github.com/tfutils/tfenv.git ~/.tfenv

# Create a bin directory in the home directory
mkdir ~/bin

# Create a symbolic link for every file in .tfenv/bin to ~/bin
ln -s ~/.tfenv/bin/* ~/bin

# Install and use a specific version of Terraform using tfenv
tfenv install 1.6.1
tfenv use 1.6.1

# Check the Terraform version
terraform -v


