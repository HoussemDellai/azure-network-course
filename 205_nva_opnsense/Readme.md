# OPNSense Firewall as Network Virtual Appliance (NVA) in Azure

This repository contains configuration files and instructions to set up an OPNsense firewall as a Network Virtual Appliance (NVA) in Azure. 

## Introduction to OPNsense

OPNsense is a powerful [open-source](https://github.com/opnsense/core) firewall that can be used to secure your virtual networks. It is a fork of the popular pfSense firewall which is also a fork of [m0n0wall](https://m0n0.ch/). It is based on `FreeBSD` and provides a user-friendly web interface for configuration and management.
OPNsense offers a wide range of features including: 

* VPN connectivity with P2S and P2P:
  * Wireguard
  * OpenVPN
* DNS Servers:
  * OpenDNS
  * Unbound DNS
* Support multiple networks: LAN and WAN.
* Forward Proxy with Squid proxy.
* Multiple official and community plugins.
* Intrusion detection.

Our objective is to demonstrate how to deploy and configure OPNsense as an NVA in Azure, providing a cost-effective alternative to Azure Firewall when used in POC environments.

## 

## Install Wireguard in Windows using Winget

```sh
winget install -e --id WireGuard.WireGuard --accept-package-agreements --accept-source-agreements
```

## More resources

Src: https://www.zenarmor.com/docs/network-security-tutorials/how-to-setup-wireguard-on-opnsense