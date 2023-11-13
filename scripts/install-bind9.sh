#!/bin/sh

sudo apt update

# install bind9
sudo apt install bind9 bind9utils bind9-doc -y

sudo -i

cat <<EOF >/etc/bind/named.conf.options
options {  
    directory "/var/cache/bind";  
    recursion yes;            # enables resursive queries  
    allow-recursion { any; }; # allows recursive queries from "any" clients
    forward only;
    forwarders {  
        168.63.129.16; # Azure DNS
        8.8.8.8;       # google DNS
        8.8.4.4;       # google DNS
        1.1.1.1;       # CloudFlare DNS
    };  
};  

EOF

# check syntax
named-checkconf /etc/bind/named.conf.options

systemctl restart bind9

nslookup google.com 127.0.0.1

systemctl status bind9
