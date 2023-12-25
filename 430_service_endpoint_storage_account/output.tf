output "blob_url" {
  value = azurerm_storage_blob.blob.url
}

output "blob_url_sas" {
  value     = "${azurerm_storage_blob.blob.url}${data.azurerm_storage_account_blob_container_sas.blob_sas.sas}"
  sensitive = true
}
