resource "azurerm_storage_account" "storage-account" {
  name                      = "storacc4app${var.prefix}"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = true

  # network_rules {
  #   default_action             = "Deny"
  #   ip_rules                   = [local.machine_ip]
  #   virtual_network_subnet_ids = [azurerm_subnet.subnet-app.id]
  # }
}

# resource "azurerm_storage_container" "container" {
#   name                  = "content"
#   storage_account_id    = azurerm_storage_account.sa.id
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "blob" {
#   name                   = "file.txt"
#   storage_account_name   = azurerm_storage_account.sa.name
#   storage_container_name = azurerm_storage_container.container.name
#   type                   = "Block"
#   source                 = "file.txt"
# }

# resource "azurerm_role_assignment" "ra" {
#   scope                = azurerm_storage_account.storage-account.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = data.azurerm_client_config.current.object_id
# }

# file share

resource "azurerm_storage_share" "file-share" {
  name               = "fileshare"
  storage_account_id = azurerm_storage_account.storage-account.id
  access_tier        = "Hot" # Hot, Cool and TransactionOptimized, Premium
  quota              = 10
}

# resource "azurerm_storage_share_file" "file" {
#   name             = "my-awesome-content.zip"
#   storage_share_id = azurerm_storage_share.file-share.id
#   source           = "some-local-file.zip"
# }
