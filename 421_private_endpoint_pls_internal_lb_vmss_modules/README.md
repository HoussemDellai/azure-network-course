```sh
terraform init
terraform apply -auto-approve
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.80.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../modules/bastion | n/a |
| <a name="module_vm-jumpbox"></a> [vm-jumpbox](#module\_vm-jumpbox) | ../modules/vm_linux | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.lb-internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.backend-pool](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb_backend_address_pool) | resource | 
| [azurerm_lb_probe.probe-http](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.lb-rule](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine_scale_set.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_nat_gateway.nat-gateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.association](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_public_ip.pip-nat-gateway](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet-app](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet-bastion](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.subnet_natgw](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_virtual_network.vnet-app](https://registry.terraform.io/providers/hashicorp/azurerm/3.81.0/docs/resources/virtual_network) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer_ip"></a> [loadbalancer\_ip](#output\_loadbalancer\_ip) | n/a |

## Notes

Internal Load Balancer cannot use outbound rule to connect to internet. It should use Nat Gateway.

Src: [https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)