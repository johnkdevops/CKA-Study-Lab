#!/bin/bash

# Declare variables
ANSIBLE_PLAYBOOK_LOC="playbooks/ha-k8s-cluster-playbook/"
SUDO_COMMAND="sudo"
ROLES=("common" "masternode" "controlplane" "haproxy" "workernode")
FILES=("nodes_setup.yaml" "main_controlplane.yaml" "controlplane_nodes.yaml" "loadbalancer.yaml" "check_apiserver.sh" "handlers.yaml" "keepalived.conf.j2" "haproxy.cfg.j2" "workernodes.yaml")
DESTINATIONS=("roles/common/tasks/main.yml" "roles/main_controlplane/tasks/main.yml" "roles/controlplane_nodes/tasks/main.yml" "roles/haproxy/tasks/main.yml" "roles/haproxy/files/" "roles/haproxy/handlers/main.yml" "roles/haproxy/templates/keepalived.conf.j2" "roles/haproxy/templates/haproxy.cfg.j2" "roles/workernode/tasks/main.yml")

# Change to the /etc/ansible directory
cd /etc/ansible

# Install Ansible roles

# Loop through roles and create them
for role in "${ROLES[@]}"
do
    ${SUDO_COMMAND} ansible-galaxy init playbooks/ha-k8s-cluster-playbook/roles/${role}
done

# Loop through files and move them to their respective destinations
for i in "${!FILES[@]}"
do
    ${SUDO_COMMAND} mv ${ANSIBLE_PLAYBOOK_LOC}${FILES[$i]} ${ANSIBLE_PLAYBOOK_LOC}${DESTINATIONS[$i]}
done

echo "Listing contents of ansible directory /etc/ansible/"
${SUDO_COMMAND} ls -al /etc/ansible/${ANSIBLE_PLAYBOOK_LOC}/roles/*
