output "vm_linux_hub_private_ip" {
  value = module.vm-hub.vm_private_ip
}

output "storage_account_url" {
  value = azurerm_storage_account.sa.primary_blob_endpoint
}

output "storage_account_blob_url" {
  value = azurerm_storage_blob.blob.url
}

output "vm_linux_spoke1_private_ip" {
  value = module.spoke1.vm_linux_private_ip
}

output "vm_linux_spoke2_private_ip" {
  value = module.spoke2.vm_linux_private_ip
}

output "private_dns_zone_fqdn" {
  value = azurerm_private_dns_a_record.a-record.fqdn
}