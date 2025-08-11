#!/bin/sh

# Script Params
# $1 = OpnSense script URI
# $2 = OpnSense version
# $3 = Subnet GW IP

fetch $1config.xml

sed -i "" "s/yyy.yyy.yyy.yyy/$3/" config.xml
cp config.xml /usr/local/etc/config.xml

#Download OPNSense Bootstrap and Permit Root Remote Login
# fetch https://raw.githubusercontent.com/opnsense/update/master/src/bootstrap/opnsense-bootstrap.sh.in
#fetch https://raw.githubusercontent.com/opnsense/update/7ba940e0d57ece480540c4fd79e9d99a87f222c8/src/bootstrap/opnsense-bootstrap.sh.in
fetch https://raw.githubusercontent.com/opnsense/update/master/src/bootstrap/opnsense-bootstrap.sh.in
sed -i "" 's/#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config

#OPNSense
# Due to a recent change in pkg the following commands no longer finish with status code 0
#		pkg unlock -a
#		pkg delete -fa
# This resplace of set -e which force the script to finish in case of non status code 0 has to be inplace
sed -i "" "s/set -e/#set -e/g" opnsense-bootstrap.sh.in
sed -i "" "s/reboot/shutdown -r +1/g" opnsense-bootstrap.sh.in
sh ./opnsense-bootstrap.sh.in -y -r "$2"

# Installing bash - This is a requirement for Azure custom Script extension to run
pkg install -y bash
pkg install -y os-frr

# Remove wrong route at initialization
cat > /usr/local/etc/rc.syshook.d/start/22-remoteroute <<EOL
#!/bin/sh
route delete 168.63.129.16
EOL
chmod +x /usr/local/etc/rc.syshook.d/start/22-remoteroute

#Adds support to LB probe from IP 168.63.129.16
# Add Azure VIP on Arp table
echo # Add Azure Internal VIP >> /etc/rc.conf
echo static_arp_pairs=\"azvip\" >>  /etc/rc.conf
echo static_arp_azvip=\"168.63.129.16 12:34:56:78:9a:bc\" >> /etc/rc.conf
# Makes arp effective
service static_arp start
# To survive boots adding to OPNsense Autorun/Bootup:
echo service static_arp start >> /usr/local/etc/rc.syshook.d/start/20-freebsd

# Reset WebGUI certificate
echo #\!/bin/sh >> /usr/local/etc/rc.syshook.d/start/94-restartwebgui
echo configctl webgui restart renew >> /usr/local/etc/rc.syshook.d/start/94-restartwebgui
echo rm /usr/local/etc/rc.syshook.d/start/94-restartwebgui >> /usr/local/etc/rc.syshook.d/start/94-restartwebgui
chmod +x /usr/local/etc/rc.syshook.d/start/94-restartwebgui