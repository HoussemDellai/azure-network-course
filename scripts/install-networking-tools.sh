#!/bin/bash

# enable IP forwarding
bash -c "echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf"
sysctl -p /etc/sysctl.conf

# install bind9
sudo apt update
sudo apt install bind9