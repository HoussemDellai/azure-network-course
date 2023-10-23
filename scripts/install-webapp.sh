#!/bin/sh

sudo apt -qq update

# Install curl and traceroute and jq
sudo apt -qq install curl traceroute inetutils-traceroute jq -y

# Install NGINX web server
sudo apt -qq install nginx -y

# Change the default page of the NGINX web server
sudo -i
echo "This is [$HOSTNAME] virtual machine" > /var/www/html/index.html

# curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq