#!/bin/bash

# Update the system
sudo apt-get update -y

# Upgrade packages
sudo apt-get upgrade -y

# enable IP forwarding
bash -c "echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf"
sysctl -p /etc/sysctl.conf

# install bind9
sudo apt-get install bind9 -y