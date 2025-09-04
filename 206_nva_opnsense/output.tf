output "vm_nva_public_ip" {
  value = azurerm_public_ip.pip-vm-nva.ip_address
}

output "vm_nva_private_ip_trusted" {
  value = azurerm_network_interface.nic-vm-nva-trusted.private_ip_address
}

output "vm_nva_private_ip_untrusted" {
  value = azurerm_network_interface.nic-vm-nva-untrusted.private_ip_address
}

output "vm_spoke1_private_ip" {
  value = module.vm-spoke1.vm_private_ip
}

output "vm_spoke2_private_ip" {
  value = module.vm-spoke2.vm_private_ip
}

output "vm_hub_jumpbox_private_ip" {
  value = module.vm-hub-jumpbox.vm_private_ip
}

output "vm_hub_jumpbox_public_ip" {
  value = module.vm-hub-jumpbox.vm_public_ip
}
