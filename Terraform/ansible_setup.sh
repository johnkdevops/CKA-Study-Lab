#!/bin/bash

# Declare variables
SUDO_COMMAND="sudo"

# Create Ansible folder if it does not exist
if [ ! -d /etc/ansible ]; then echo 'Creating ansible directory'; ${SUDO_COMMAND} mkdir -p /etc/ansible; fi

# Move ansible configuration files to correct folders under /etc/ansible directory 
echo "Moving ansible config files under /etc/ansible directory"
${SUDO_COMMAND} mv ~/inventory.ini ~/playbooks /etc/ansible/ && echo "ansible files are successfully moved" || echo "Failed to move ansible files"

# Make & run ansible_role.sh
${SUDO_COMMAND} chmod +x ansible_roles.sh

echo "Listing contents of ansible directory /etc/ansible/"
${SUDO_COMMAND} ls -al /etc/ansible