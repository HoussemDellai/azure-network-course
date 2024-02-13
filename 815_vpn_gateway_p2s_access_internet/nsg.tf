resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-subnet-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "rule-allow-http" {
  resource_group_name          = azurerm_resource_group.rg.name
  network_security_group_name  = azurerm_network_security_group.nsg.name
  name                         = "rule-allow-http"
  access                       = "Allow"
  priority                     = 1000
  direction                    = "Inbound"
  protocol                     = "*"
  source_address_prefix        = "*" # "Internet"
  source_port_range            = "*"
  destination_address_prefixes = azurerm_subnet.subnet-vm.address_prefixes
  destination_port_range       = "*" # "8080"
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet-vm.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
