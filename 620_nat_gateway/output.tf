output "pip-nat-gateway" {
  value = azurerm_public_ip.pip-nat-gateway.ip_address
}

output "ssh-bastion" {
  value = "az network bastion ssh -n ${try(azurerm_bastion_host.bastion.name, "<bastion host name>")} -g ${try(azurerm_bastion_host.bastion.resource_group_name, "<bastion resource group>")} --target-resource-id ${try(azurerm_linux_virtual_machine.vm.id, "<virtual machine id>")} --auth-type ssh --username azureuser"
}
