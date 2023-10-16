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

# If Terraform installation succeeded, install Ansible
if terraform -v | grep -q 'Terraform v'; then
    sudo yum -y update
    sudo amazon-linux-extras install epel -y
    sudo yum install ansible -y
    ansible --version
else
    echo "Terraform installation failed."
    exit 1
fi


