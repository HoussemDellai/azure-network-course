# Virtual Network Routing Appliance

This repository contains the implementation and configuration of a Virtual Network Routing Appliance in Azure. The appliance is used to manage and control network traffic within a virtual network, providing advanced routing capabilities beyond the default Azure routing.

Unlike an NVA/Firewall, which typically focuses on security and traffic filtering, a Virtual Network Routing Appliance primarily handles advanced routing and traffic management within the virtual network. It only manages east-west traffic between subnets and does not provide security enforcement like a firewall.

## Features
- Custom routing for virtual networks
- Traffic inspection and filtering
- Integration with Azure Network Security Groups
- Support for multiple routing protocols

## Prerequisites
- An active Azure subscription
- Basic knowledge of Azure Virtual Networks
- Familiarity with network routing concepts

## Implementation
The implementation involves deploying a virtual machine or a set of virtual machines configured as a routing appliance within an Azure Virtual Network. The appliance will handle traffic routing based on custom route tables and policies defined by the user.

## Configuration
1. Deploy the virtual machine(s) in the desired subnet within the virtual network.
2. Configure the network interfaces and IP addresses for the appliance.
3. Set up the routing protocols and policies on the appliance.
4. Create and associate custom route tables with the relevant subnets.
5. Verify the routing and traffic flow to ensure the appliance is functioning correctly.

## Troubleshooting
- Check the network interface configurations and IP addresses.
- Review the routing tables and ensure the correct routes are applied.
- Inspect the appliance logs for any errors or misconfigurations.
- Use network diagnostic tools like `ping` and `traceroute` to test connectivity.
- Ensure that any Network Security Groups or firewalls are not blocking the traffic.