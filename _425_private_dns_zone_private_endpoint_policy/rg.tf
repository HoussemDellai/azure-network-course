resource "azurerm_resource_group" "rg" {
  name     = "rg-private-dns-zone-pe-policy-${var.prefix}"
  location = "swedencentral" # "swedencentral" #  # "swedencentral"
}