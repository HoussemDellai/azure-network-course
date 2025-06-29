resource "azurerm_resource_group" "rg" {
  name     = "rg-app-service-storage-account-file-pe-${var.prefix}"
  location = "swedencentral"
}