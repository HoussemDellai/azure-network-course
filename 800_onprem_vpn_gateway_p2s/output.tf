output "vm_linux_hub_private_ip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "vm_windows_hub_private_ip" {
  value = azurerm_windows_virtual_machine.vm.private_ip_address
}

output "storage_account_url" {
  value = azurerm_storage_account.sa.primary_blob_endpoint
}

output "storage_account_blob_url" {
  value = azurerm_storage_blob.blob.url
}