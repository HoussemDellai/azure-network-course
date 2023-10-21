#!/bin/sh

#########################################
# Install auto complete
#########################################

sudo apt update

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

# change command line colors
PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

#########################################

# # Enable IPv4 and IPv6 forwarding
# sysctl -w net.ipv4.ip_forward=1
# sysctl -w net.ipv6.conf.all.forwarding=1
# sed -i "/net.ipv4.ip_forward=1/ s/# *//" /etc/sysctl.conf
# sed -i "/net.ipv6.conf.all.forwarding=1/ s/# *//" /etc/sysctl.conf

# https://github.com/dmauser/AzureVM-Router/blob/master/linuxrouter.sh
# Enable IPv4 and IPv6 forwarding / disable ICMP redirect
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sed -i "/net.ipv4.ip_forward=1/ s/# *//" /etc/sysctl.conf
sed -i "/net.ipv6.conf.all.forwarding=1/ s/# *//" /etc/sysctl.conf
sed -i "/net.ipv4.conf.all.accept_redirects = 0/ s/# *//" /etc/sysctl.conf
sed -i "/net.ipv6.conf.all.accept_redirects = 0/ s/# *//" /etc/sysctl.conf

echo "Updating repositories"
sudo apt-get update
echo "Installing IPTables-Persistent"
echo iptables-persistent iptables-persistent/autosave_v4 boolean false | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean false | sudo debconf-set-selections
sudo apt-get -y install iptables-persistent

# Enable NAT to Internet
iptables -t nat -A POSTROUTING -d 10.0.0.0/8 -j ACCEPT
iptables -t nat -A POSTROUTING -d 172.16.0.0/12 -j ACCEPT
iptables -t nat -A POSTROUTING -d 192.168.0.0/16 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Save to IPTables file for persistence on reboot
iptables-save > /etc/iptables/rules.v4