# OPNsense Firewall in a Hub and Spoke architecture

This repository contains configuration files and instructions to set up an OPNsense firewall in a Hub and Spoke architecture. The Hub and Spoke model allows multiple remote sites (spokes) to connect securely to a central site (hub).

Most of Microsoft documentation for Hub and Spoke highlights Azure Firewall as an NVA solution. However, OPNsense is a powerful open-source firewall that can be used as an alternative NVA solution in this architecture.

This is particularly useful for building demo or POC environments where cost is a concern, as OPNsense is free to use and offers robust features and most of all you can install it on a Spot VM that will cost around 30 $ per month instead of 900 $ for Azure Firewall. So huge cost saving for limited subscriptions' budgets.

Src: https://www.zenarmor.com/docs/network-security-tutorials/how-to-setup-wireguard-on-opnsense