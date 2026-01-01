#!/bin/bash

# https://learn.microsoft.com/en-us/azure/virtual-machines/linux/use-remote-desktop?tabs=azure-cli

# Install all the required packages using apt
sudo apt update -y
sudo apt install xfce4 xfce4-session xrdp -y
sudo systemctl enable xrdp

# give certificate access to an xrdp user
sudo adduser xrdp ssl-cert

# Tell xrdp what desktop environment to use when you start your session. Configure xrdp to use xfce as your desktop environment as follows:
echo xfce4-session >~/.xsession

# Restart the xrdp service for the changes to take effect as follows:
sudo systemctl restart xrdp

# Set a local user account password
# This requires interactive input
sudo passwd azureuser