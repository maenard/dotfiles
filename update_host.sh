#!/bin/bash

# Define the hostname and the IP address
HOSTNAME="maenard.local"
CURRENT_IP=$(hostname -I | awk '{print $1}')

# Backup the current /etc/hosts file
sudo cp /etc/hosts /etc/hosts.bak

# Remove existing entries for the hostname
sudo sed -i "/$HOSTNAME/d" /etc/hosts

# Add the new entry
echo "$CURRENT_IP $HOSTNAME" | sudo tee -a /etc/hosts
