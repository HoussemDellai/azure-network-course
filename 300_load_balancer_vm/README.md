## Introduction

This sample terraform template shows how to deploy and configure a Load Balancer to distribute traffic into a web application running in an Azure VM.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.81.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../modules/bastion | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.lb-public](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.backend-pool](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb_backend_address_pool) | resource | 
| [azurerm_lb_outbound_rule.outbound-rule](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb_outbound_rule) | resource |
| [azurerm_lb_probe.probe-http](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.lb-rule](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.nic_vm](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.nic-backenpool-association](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.rule-allow-http](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/network_security_rule) | resource |  
| [azurerm_public_ip.pip-lb](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet-app](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet-bastion](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet-app](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/virtual_network) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_ip"></a> [loadbalancer\_ip](#output\_loadbalancer\_ip) | n/a |

## Notes

Standard load balancers and standard public IP addresses are closed to inbound connections unless opened by Network Security Groups. NSGs are used to explicitly permit allowed traffic. If you don't have an NSG on a subnet or NIC of your virtual machine resource, traffic isn't allowed to reach this resource.

Src: [https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)