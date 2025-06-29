resource "azurerm_storage_account" "storage-account" {
  name                          = "storacc4app${var.prefix}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  shared_access_key_enabled     = true
  public_network_access_enabled = false
}

resource "azurerm_storage_share" "file-share" {
  name               = "fileshare"
  storage_account_id = azurerm_storage_account.storage-account.id
  access_tier        = "Hot" # Hot, Cool and TransactionOptimized, Premium
  quota              = 10
}