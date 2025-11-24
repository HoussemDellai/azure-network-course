resource "azurerm_network_security_group" "nsg-vm" {
  name                = "nsg-vm-nva"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow-inbound-website" {
  network_security_group_name = azurerm_network_security_group.nsg-vm.name
  resource_group_name         = azurerm_network_security_group.nsg-vm.resource_group_name
  name                        = "allow-inbound-website"
  access                      = "Allow"
  priority                    = 100
  direction                   = "Inbound"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
}

resource "azurerm_network_security_rule" "allow-inbound-wireguard" {
  network_security_group_name = azurerm_network_security_group.nsg-vm.name
  resource_group_name         = azurerm_network_security_group.nsg-vm.resource_group_name
  name                        = "allow-inbound-wireguard"
  access                      = "Allow"
  priority                    = 101
  direction                   = "Inbound"
  protocol                    = "Udp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "51820"
}

resource "azurerm_network_security_rule" "allow-inbound-dns" {
  network_security_group_name = azurerm_network_security_group.nsg-vm.name
  resource_group_name         = azurerm_network_security_group.nsg-vm.resource_group_name
  name                        = "allow-inbound-dns"
  access                      = "Allow"
  priority                    = 102
  direction                   = "Inbound"
  protocol                    = "Udp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "53"
}

# resource "azurerm_network_security_rule" "allow-all-inbound" {
#   network_security_group_name = azurerm_network_security_group.nsg-vm.name
#   resource_group_name         = azurerm_network_security_group.nsg-vm.resource_group_name
#   name                        = "allow-all-inbound"
#   access                      = "Allow"
#   priority                    = 100
#   direction                   = "Inbound"
#   protocol                    = "*"
#   source_address_prefix       = "*"
#   source_port_range           = "*"
#   destination_address_prefix  = "*"
#   destination_port_range      = "*"
# }

resource "azurerm_network_security_rule" "allow-all-outbound" {
  network_security_group_name = azurerm_network_security_group.nsg-vm.name
  resource_group_name         = azurerm_network_security_group.nsg-vm.resource_group_name
  name                        = "allow-all-outbound"
  access                      = "Allow"
  priority                    = 101
  direction                   = "Outbound"
  protocol                    = "*"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
}

# resource "azurerm_network_interface_security_group_association" "association-nsg-nic-vm-nva-trusted" {
#   network_interface_id      = azurerm_network_interface.nic-vm-nva-trusted.id
#   network_security_group_id = azurerm_network_security_group.nsg-vm.id
# }

resource "azurerm_network_interface_security_group_association" "association-nsg-nic-vm-nva-untrusted" {
  network_interface_id      = azurerm_network_interface.nic-vm-nva-untrusted.id
  network_security_group_id = azurerm_network_security_group.nsg-vm.id
}
