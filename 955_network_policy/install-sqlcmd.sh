#!/bin/bash

# Import the public repository GPG keys.
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc

# Add the Microsoft repository
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/22.04/prod.list)"

# Update the list of products
apt-get update

# Install sqlcmd (Go) with apt.

sudo apt-get install sqlcmd