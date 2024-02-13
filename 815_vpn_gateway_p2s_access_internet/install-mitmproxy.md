#!/bin/bash

# sudo apt update -y

# wget https://downloads.mitmproxy.org/10.2.2/mitmproxy-10.2.2-linux-x86_64.tar.gz

# tar -xvf mitmproxy-10.2.2-linux-x86_64.tar.gz

# # start the proxy; this is also needed to generate the certificates

# ./mitmproxy

sudo apt update -y

sudo apt install python3-pip -y

pip3 install mitmproxy

# mitmproxy --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false

mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false

# screen -d -m mitmweb --listen-port 8080 --web-host 0.0.0.0 --web-port 8081 --set block_global=false

# install the cert in: mitm.it

# check if MITM Proxy is running:

apt install procps

ps -U root | grep mitm

ps -aux | grep mitm

http=4.175.209.16:8080;https=4.175.209.16:8080




systemctl status squid.service

http=23.97.240.27:3128