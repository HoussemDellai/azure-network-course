#!/bin/bash

sudo apt -qq update

sudo apt -qq install nginx -y

IP=$(hostname -i)

echo "Hello from virtual machine: $HOSTNAME, with IP address: $IP" > /var/www/html/index.html