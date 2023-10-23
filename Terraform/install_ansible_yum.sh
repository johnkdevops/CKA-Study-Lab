#!/bin/bash

# Update all packages
sudo yum -y update

# Install EPEL repository
sudo amazon-linux-extras install epel -y

# Install Ansible
sudo yum install ansible -y

# Check the Ansible version
ansible --version