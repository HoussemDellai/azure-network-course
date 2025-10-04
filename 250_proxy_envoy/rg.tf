resource "azurerm_resource_group" "rg" {
  name     = "rg-vm-linux-envoy-${var.prefix}"
  location = "swedencentral" #  # "swedencentral"
}