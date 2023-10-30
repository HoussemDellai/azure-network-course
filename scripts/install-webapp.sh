#!/bin/bash

sudo apt update

# Install curl and traceroute and jq
sudo apt install curl traceroute inetutils-traceroute jq -y

# Install NGINX web server
sudo apt install nginx -y

IP=$(hostname -i)

echo "Hello from virtual machine: $HOSTNAME, with IP address: $IP" > /var/www/html/index.html

################################################################
# Optional, change command line style
################################################################

sudo apt install bash-completion -y

cat <<EOF > ~/.inputrc
set show-all-if-ambiguous on
set show-all-if-unmodified on
set menu-complete-display-prefix on
"/t": menu-complete
"\e[Z": menu-complete-backward
"\e[A": history-search-backward
"\e[B": history-search-forward
"\eOA": history-search-backward
"\eOB": history-search-forward
EOF

# Script to force enable color prompt on Ubuntu and other Linux distros.
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc

# change the default color of the prompt.
# sed -i 's/1;32m/1;\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$/g' ~/.bashrc

# Reload the .bashrc file
source ~/.bashrc