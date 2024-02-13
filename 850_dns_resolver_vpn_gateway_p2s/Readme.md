# Azure VPN Gateway

![](images/architecture.png)

```sh
terraform init
terraform apply -auto-approve
```

The terraform template will create a VPN Gateway with P2S configuration.
Make sure you install the VPN Client in your machine.

From `on-prem`, you can resolve domain names in Azure using `DNS Private Resolver`.

```sh
# the following should fail when you run it from on-prem
# because it is using machine's local DNS server
nslookup vm1.hub.internal
# DNS request timed out.
#     timeout was 2 seconds.
# Server:  UnKnown
# Address:  168.63.129.16

# add the DNS private resolver IP address
# this should work
nslookup vm1.hub.internal 10.0.3.4
# Server:  UnKnown
# Address:  10.0.3.4
# Non-authoritative answer:
# Name:    vm1.hub.internal
# Address:  10.0.0.100

# resolve Private DNS domain name linked to the Spoke
# note that there is no peering between Hub and Spoke here, that is not required for DNS resolution.
nslookup vm2.spoke.internal 10.0.3.4
# Server:  UnKnown
# Address:  10.0.3.4
# Non-authoritative answer:
# Name:    vm2.spoke.internal
# Address:  10.1.0.200
```

From the Azure VM on Hub, you can resolve the domain names in the `Private DNS Zones` linked to VNETs that are also linked to `DNS Private Resolver`.
Note that you don't need to specify the DNS address to `nslookup`.

```sh
nslookup vm1.hub.internal
# Server:         127.0.0.53
# Address:        127.0.0.53#53
# Non-authoritative answer:
# Name:   vm1.hub.internal
# Address: 10.0.0.100

nslookup vm2.spoke.internal
# Server:         127.0.0.53
# Address:        127.0.0.53#53

# Non-authoritative answer:
# Name:   vm2.spoke.internal
# Address: 10.1.0.200
```