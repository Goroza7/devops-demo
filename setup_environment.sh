#!/bin/bash

# Install Ansible if not present
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible
fi

# Run the Ansible playbook
ansible-playbook ansible/setup.yml