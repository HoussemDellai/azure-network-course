resource "azurerm_storage_account" "sa" {
  name                     = "stor8flow8logs${var.prefix}"
  resource_group_name      = azurerm_resource_group.rg-hub.name
  location                 = azurerm_resource_group.rg-hub.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# resource "azurerm_storage_container" "container" {
#   name                  = "content"
#   storage_account_name  = azurerm_storage_account.sa.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "blob" {
#   name                   = "Readme.md"
#   storage_account_name   = azurerm_storage_account.sa.name
#   storage_container_name = azurerm_storage_container.container.name
#   type                   = "Block"
#   source                 = "Readme.md"
# }