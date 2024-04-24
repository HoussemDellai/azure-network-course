resource "azurerm_network_security_group" "nsg-hub" {
  name                = "nsg-snet-hub"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
}

resource "azurerm_network_security_rule" "allow-all-hub" {
  network_security_group_name  = azurerm_network_security_group.nsg-hub.name
  resource_group_name          = azurerm_network_security_group.nsg-hub.resource_group_name
  name                         = "allow-all"
  access                       = "Allow"
  priority                     = 1000
  direction                    = "Inbound"
  protocol                     = "Tcp"
  source_address_prefix        = "Internet"
  source_port_range            = "*"
  destination_address_prefixes = ["0.0.0.0/0"]
  destination_port_range       = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg-association-hub" {
  subnet_id                 = azurerm_subnet.subnet-hub-vm.id
  network_security_group_id = azurerm_network_security_group.nsg-hub.id
}

resource "azurerm_network_security_group" "nsg-spoke1" {
  name                = "nsg-snet-spoke1"
  location            = azurerm_resource_group.rg-spoke1.location
  resource_group_name = azurerm_resource_group.rg-spoke1.name
}

resource "azurerm_network_security_rule" "allow-all-spoke1" {
  network_security_group_name  = azurerm_network_security_group.nsg-spoke1.name
  resource_group_name          = azurerm_network_security_group.nsg-spoke1.resource_group_name
  name                         = "allow-all"
  access                       = "Allow"
  priority                     = 1000
  direction                    = "Inbound"
  protocol                     = "Tcp"
  source_address_prefix        = "Internet"
  source_port_range            = "*"
  destination_address_prefixes = ["0.0.0.0/0"]
  destination_port_range       = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg-association-spoke1" {
  subnet_id                 = azurerm_subnet.subnet-spoke1-vm.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke1.id
}

resource "azurerm_network_security_group" "nsg-spoke2" {
  name                = "nsg-snet-spoke2"
  location            = azurerm_resource_group.rg-spoke2.location
  resource_group_name = azurerm_resource_group.rg-spoke2.name
}

resource "azurerm_network_security_rule" "allow-all-spoke2" {
  network_security_group_name  = azurerm_network_security_group.nsg-spoke2.name
  resource_group_name          = azurerm_network_security_group.nsg-spoke2.resource_group_name
  name                         = "allow-all"
  access                       = "Allow"
  priority                     = 1000
  direction                    = "Inbound"
  protocol                     = "Tcp"
  source_address_prefix        = "Internet"
  source_port_range            = "*"
  destination_address_prefixes = ["0.0.0.0/0"]
  destination_port_range       = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg-association-spoke2" {
  subnet_id                 = azurerm_subnet.subnet-spoke2-vm.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke2.id
}