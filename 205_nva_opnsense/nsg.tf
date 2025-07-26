resource "azurerm_network_security_group" "nsg-vm" {
  name                = "nsg-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow-me-rdp" {
  network_security_group_name  = azurerm_network_security_group.nsg-vm.name
  resource_group_name          = azurerm_network_security_group.nsg-vm.resource_group_name
  name                         = "allow-me-rdp"
  access                       = "Allow"
  priority                     = 1000
  direction                    = "Inbound"
  protocol                     = "Tcp"
  source_address_prefix        = "176.177.25.47"
  source_port_range            = "*"
  destination_address_prefixes = ["0.0.0.0/0"]
  destination_port_range       = "3389"
}

resource "azurerm_network_security_rule" "allow-all-tcp" {
  network_security_group_name  = azurerm_network_security_group.nsg-vm.name
  resource_group_name          = azurerm_network_security_group.nsg-vm.resource_group_name
  name                         = "allow-all-tcp"
  access                       = "Allow"
  priority                     = 100
  direction                    = "Inbound"
  protocol                     = "Tcp"
  source_address_prefix        = "*"
  source_port_range            = "*"
  destination_address_prefixes = ["0.0.0.0/0"]
  destination_port_range       = "*"
}

resource "azurerm_network_security_rule" "allow-all-udp" {
  network_security_group_name  = azurerm_network_security_group.nsg-vm.name
  resource_group_name          = azurerm_network_security_group.nsg-vm.resource_group_name
  name                         = "allow-all-udp"
  access                       = "Allow"
  priority                     = 101
  direction                    = "Inbound"
  protocol                     = "Udp"
  source_address_prefix        = "*"
  source_port_range            = "*"
  destination_address_prefixes = ["0.0.0.0/0"]
  destination_port_range       = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.snet-trusted.id
  network_security_group_id = azurerm_network_security_group.nsg-vm.id
}
