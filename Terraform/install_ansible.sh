#!/bin/bash

# Declare variables
SUDO_COMMAND="sudo"

# Update Package Lists
${SUDO_COMMAND} apt update -y

# Install Pip3
${SUDO_COMMAND} apt install python3-pip -y

# Install Ansible
${SUDO_COMMAND} apt install ansible -y

# Verify the installation
ansible --version




