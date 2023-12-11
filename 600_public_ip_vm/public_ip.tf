resource "azurerm_public_ip" "pip" {
  name                = "pip-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  ip_version          = "IPv4" # "IPv6"
  sku                 = "Standard"
  zones               = ["1"]
}