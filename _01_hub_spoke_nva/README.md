https://github.com/dmauser/AzureVM-Router/


https://learn.microsoft.com/en-us/azure/virtual-network/tutorial-create-route-table-portal

iptables -I FORWARD 1 -s 10.2.0.0/16 ! -d 0.0.0.0/0 -j DROP

iptables -I FORWARD 1 -s 10.2.0.0/16 ! -d 0.0.0.0/0 -j ACCEPT


sudo iptables -L --line-numbers

sudo iptables --flush # delete all of the firewall rules