output "pip-nat-gateway" {
  value = azurerm_public_ip.pip-nat-gateway.ip_address
}

# output "ssh-bastion" {
#   value = "az network bastion ssh -n ${azurerm_bastion_host.bastion.name} -g ${azurerm_bastion_host.bastion.resource_group_name} --target-resource-id ${azurerm_linux_virtual_machine.vm.id} --auth-type ssh --username azureuser"
# }
