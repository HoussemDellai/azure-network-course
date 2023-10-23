#!/bin/sh

# wait for VM to connect to internet
while true; do
wget -T 5 -c https://github.com && break
done

sudo apt -qq update

# Install NGINX web server
sudo apt install nginx -y

# Change the default page of the NGINX web server
sudo echo "This is [$HOSTNAME] virtual machine" > /var/www/html/index.html

# Install curl and traceroute and jq
sudo apt install curl traceroute inetutils-traceroute jq -y

# curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq