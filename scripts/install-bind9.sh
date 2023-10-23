#!/bin/sh

sudo apt update

# install bind9
sudo apt install bind9 bind9utils bind9-doc -y

sudo nano /etc/bind/named.conf.options

# // allow only LAN traffic from 192.168.2.0-192.168.2.255
# acl LAN {
# 192.168.2.0/24;
# };
# options {
#         directory "/var/cache/bind"; // default directory
#         allow-query { localhost; LAN; }; // allow queries from localhost and 192.168.2.0-192.168.2.255
#         forwarders { 1.1.1.1; }; // use CloudFlare 1.1.1.1 DNS as a forwarder
#         recursion yes;  // allow recursive queries
# };

# worked for me

cat <<EOF > /etc/bind/named.conf.options
acl LAN  {
  10.0.0.0/8;
};

options {
directory "/var/cache/bind";

allow-query {
  localhost; LAN;
};

forwarders {
  8.8.8.8;
  8.8.4.4;
  1.1.1.1;
};

recursion yes;

//========================================================================
// If BIND logs error messages about the root key being expired,
// you will need to update your keys.  See https://www.isc.org/bind-keys
//========================================================================
dnssec-validation auto;

auth-nxdomain no;    # conform to RFC1035

listen-on-v6 { any; };

listen-on { any; };

};
EOF

# check syntax
named-checkconf /etc/bind/named.conf.options

sudo systemctl restart bind9

nslookup google.com 127.0.0.1

systemctl status bind9