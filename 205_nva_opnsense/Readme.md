# OPNSense Firewall as Network Virtual Appliance (NVA) in Azure

This repository contains configuration files and instructions to set up an OPNsense firewall as a Network Virtual Appliance (NVA) in Azure. 

![](images/wireguard-vpn-to-opnsense.png)

## Introduction to OPNsense

In today’s cloud-driven world, securing your infrastructure is more critical than ever. One powerful solution is OPNsense. OPNsense is a powerful [open-source](https://github.com/opnsense/core) firewall that can be used to secure your virtual networks. Originally forked from pfSense, which itself evolved from [m0n0wall](https://m0n0.ch/), OPNsense is based on `FreeBSD` and provides a user-friendly web interface for configuration and management.
What makes OPNsense Firewall stand out is its rich feature set:

* **VPN Support** for point-to-site and site-to-site connections using technologies like WireGuard and OpenVPN.
* **DNS Management** with options such as OpenDNS and Unbound DNS.
* **Multi-network handling**, enabling you to manage different LANs seamlessly.
* **Advanced security features**, including intrusion detection and forward proxy integration.
* **Plugin ecosystem**, supporting official and community extensions for third-party integrations.

In this guide, you’ll learn how to install and configure OPNsense Firewall on an Azure Virtual Machine, leveraging its capabilities to secure your cloud resources effectively. We'll have three demonstrations:

1. Installing OPNsense on an Azure virtual machine
2. Setting up point-to-site VPN using WireGuard
3. Using OPNsense as an NVA in a Hub and Spoke topology

## 1. Installing OPNsense on an Azure Virtual Machine

There are mainly two ways to have OPNsense in a virtual machine. Either you can create a VM from scratch and install OPNsense or just [install using the pre-packaged ISO image](https://opnsense.org/get-started/) created by `Deciso` the company that maintains OPNsense. In this demo, we will use the first approach to have more control over the installation and configuration. We will create an Azure VM with `FreeBSD OS` and then install OPNsense using a shell script through the `Custom Script Extension`.

All the required files are in this repository: https://github.com/HoussemDellai/azure-network-course/tree/main/205_nva_opnsense.

The shell script `configureopnsense.sh` will install OPNsense and apply a predefined configuration file `config.xml` to set up the firewall rules, VPN, and DNS settings. It will take 4 parameters:

*   GitHub path where the script and config file are hosted, in our case it is `https://raw.githubusercontent.com/HoussemDellai/azure-network-course/refs/heads/main/205_nva_opnsense/scripts/`.
*   OPNsense version to install, currently set to `25.7`.
*   Gateway IP address for the trusted subnet.
*   Public IP address of the untrusted subnet.

This shell script is executed after the VM creation usingthe `Custom Script Extension` in Terraform represented in the file `vm_extension_install_opnsense.tf`.

OPNsense is intended to be used an `NVA` so it would be good to apply some of the good practices. One of these practices is to have two network interfaces:

*   **Trusted Interface**: Connected to the internal network (spokes).
*   **Untrusted Interface**: Connected to the internet (WAN).

This setup allows OPNsense to effectively manage and secure traffic between the internal network and the internet.

Another good practice is to start with a predefined configuration file (`config.xml`) that includes the basic settings for the firewall, VPN, and DNS. This approach saves time and ensures consistency across deployments. It is recommended to start with closed firewall rules and then open them as needed based on your security requirements. But for demo purposes, we will allow all traffic.

Let's take a look at the resources that will be created by Terraform using the **AzureRM provider**:

*   **Resource Group**
*   **Virtual Network (VNET)** named `vnet-hub` with two subnets:
    *   **Trusted Subnet**: Internal traffic between spokes.
    *   **Untrusted Subnet**: Exposes the firewall to the internet.
*   **Network Security Group (NSG)**: attached to the untrusted subnet, with rules allowing traffic to the VPN, OPNsense website and to the internet.
*   **Virtual Machine**:
    *   Two NICs (trusted and untrusted) with **IP forwarding enabled**.
    *   **FreeBSD OS image** using version `14.1`.
    *   VM size: `Standard_D4ads_v6` with NVMe disk for better performance.
    *   Admin credentials: feel free to change the username and password with more security.
*   **NAT Gateway**: attached to the untrusted subnet for outbound internet connectivity.

### **Step 3: Install OPNsense**

We use an **Azure VM Extension** to run a shell script that:

*   Downloads and installs OPNsense.
*   Applies the `config.xml` file for firewall configuration.

The script parameters include:

*   GitHub path
*   OPNsense version (currently **25.7**)
*   Gateway IP and public IP address

These values are passed as local variables in Terraform.

***

### **Step 4: Apply Terraform**

Deploy the resources by running:

```bash
terraform apply -auto-approve
```

Terraform provisions the infrastructure and outputs resource details.

***

### **Step 5: Access the OPNsense Dashboard**

1.  Copy the VM’s public IP from the Azure portal.
2.  Paste it into your browser. Accept the TLS warning (TLS is not configured yet).
3.  Log in:
    *   **Username**: `root`
    *   **Password**: `opnsense`

You now have access to the OPNsense dashboard where you can:

*   Monitor traffic and reports.
*   Configure firewall rules for LAN, WAN, and VPN.
*   Set up VPNs (WireGuard, OpenVPN, IPsec).
*   Configure DNS services (OpenDNS, Unbound).

***

## **Next Steps**

In the next article, we’ll demonstrate how to establish a **WireGuard VPN connection** to your OPNsense firewall.

***

### **Resources**

*   <https://opnsense.org>
*   <https://developer.hashicorp.com/terraform/docs>
*   <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs>

***

✅ Do you want me to **add code snippets for the Terraform configuration and shell script** inside this Markdown file? Or should I **include diagrams (network topology) and screenshots for better visualization**?

## Install Wireguard in Windows using Winget

```sh
winget install -e --id WireGuard.WireGuard --accept-package-agreements --accept-source-agreements
```

## More resources

Src: https://www.zenarmor.com/docs/network-security-tutorials/how-to-setup-wireguard-on-opnsense

## Important note

>You will encounter the following error the first time you create a `FreeBSD` VM in your subscription: ResourcePurchaseValidationFailed: User failed validation to purchase resources. Error message: 'You have not accepted the legal terms on this subscription for this plan. Before the subscription can be used, you need to accept the legal terms of the image. To read and accept legal terms, use the Azure CLI commands described at https://go.microsoft.com/fwlink/?linkid=2110637 or the PowerShell commands available at https://go.microsoft.com/fwlink/?linkid=862451. Alternatively, deploying via the Azure portal provides a UI experience for reading and accepting the legal terms. Offer details: publisher='thefreebsdfoundation' offer = 'freebsd-14_2', sku = '14_2-release-amd64-gen2-zfs',
The solution is to create a `FreeBSD` VM using the Azure Portal first, accept the legal terms, and then you can proceed with Terraform deployments.