# resource "azurerm_public_ip" "pip-bastion" {
#   name                = "pip-bastion"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "bastion-premium" {
#   name                      = "bastion-premium"
#   resource_group_name       = azurerm_resource_group.rg.name
#   location                  = azurerm_resource_group.rg.location
#   sku                       = "Premium" # "Standard" # "Basic", "Developer"
#   copy_paste_enabled        = true
#   file_copy_enabled         = true
#   shareable_link_enabled    = true
#   tunneling_enabled         = false # Session recording and native client cannot be enabled together. Disable one or the other to connect to VM
#   ip_connect_enabled        = true
#   session_recording_enabled = true

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.snet-bastion.id
#     public_ip_address_id = azurerm_public_ip.pip-bastion.id
#   }
# }

# resource "azurerm_storage_account" "storage-account-bastion-recordings" {
#   name                          = "storbastionrecordings"
#   resource_group_name           = azurerm_resource_group.rg.name
#   location                      = azurerm_resource_group.rg.location
#   account_kind                  = "StorageV2"
#   account_tier                  = "Standard"
#   account_replication_type      = "LRS"
#   https_traffic_only_enabled    = true
#   public_network_access_enabled = true
#   access_tier                   = "Hot"
#   min_tls_version               = "TLS1_2"
#   shared_access_key_enabled     = true
# }

# resource "azurerm_storage_container" "container-bastion-recordings" {
#   name                  = "container-bastion-recordings"
#   storage_account_id    = azurerm_storage_account.storage-account-bastion-recordings.id
#   container_access_type = "container" # "private", "blob", "container"
# }

# resource "azapi_resource" "blob_service" {
#   type      = "Microsoft.Storage/storageAccounts/blobServices@2024-01-01"
#   name      = "default"
#   parent_id = azurerm_storage_account.storage-account-bastion-recordings.id

#   body = {
#     properties = {
#       cors = {
#         corsRules = [
#           {
#             allowedOrigins  = ["https://${azurerm_bastion_host.bastion-premium.dns_name}"]
#             allowedMethods  = ["GET"]
#             maxAgeInSeconds = 86400
#             exposedHeaders  = ["*"]
#             allowedHeaders  = ["*"]
#           }
#         ]
#       }
#     }
#   }
# }

# data "azurerm_storage_account_blob_container_sas" "sas-container-bastion-recordings" {
#   connection_string = azurerm_storage_account.storage-account-bastion-recordings.primary_connection_string
#   container_name    = azurerm_storage_container.container-bastion-recordings.name
#   https_only        = true

#   # ip_address = "168.1.5.65"

#   start  = "2025-06-04"
#   expiry = "2026-06-04"

#   permissions {
#     read   = true
#     add    = false
#     create = true
#     write  = true
#     delete = false
#     list   = true
#   }

#   # cache_control       = "max-age=5"
#   # content_disposition = "inline"
#   # content_encoding    = "deflate"
#   # content_language    = "en-US"
#   # content_type        = "application/json"
# }

# output "sas_url_query_string" {
#   value     = "${azurerm_storage_account.storage-account-bastion-recordings.primary_blob_endpoint}${azurerm_storage_container.container-bastion-recordings.name}${data.azurerm_storage_account_blob_container_sas.sas-container-bastion-recordings.sas}"
#   sensitive = true
# }

# output "bastion_host_dns_name" {
#   value = azurerm_bastion_host.bastion-premium.dns_name
# }
