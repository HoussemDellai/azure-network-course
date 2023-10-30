#!/bin/bash

sudo apt update

# Install curl and traceroute and jq
sudo apt install curl traceroute inetutils-traceroute jq -y

# Install NGINX web server
sudo apt install nginx -y

echo "This is [$HOSTNAME] virtual machine" > /var/www/html/index.html