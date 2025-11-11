#!/bin/bash

sudo apt -qq update

# Install curl and traceroute and jq
sudo apt -qq install curl traceroute inetutils-traceroute iputils-ping jq -y

# Install NGINX web server
sudo apt -qq install nginx -y

IP=$(hostname -i)

echo "Hello from virtual machine: $HOSTNAME, with IP address: $IP" > /var/www/html/index.html