#!/bin/bash

sudo apt update

# Install NGINX web server
sudo apt install nginx -y

IP=$(hostname -i)

echo "Hello from virtual machine: $HOSTNAME, with IP address: $IP" > /var/www/html/index.html

# sudo apt update; sudo apt install nginx -y; IP=$(hostname -i); echo "Hello from virtual machine: $HOSTNAME, with IP address: $IP" > /var/www/html/index.html
