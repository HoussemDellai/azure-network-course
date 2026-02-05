resource "azurerm_network_security_group" "nsg_vm" {
  name                = "nsg-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "allow-rdp"
  network_security_group_name = azurerm_network_security_group.nsg_vm.name
  resource_group_name         = azurerm_network_security_group.nsg_vm.resource_group_name
  access                      = "Allow"
  priority                    = 100
  direction                   = "Inbound"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
}

resource "azurerm_subnet_network_security_group_association" "association-nsg-snet-vm" {
  subnet_id                 = azurerm_subnet.snet_vm.id
  network_security_group_id = azurerm_network_security_group.nsg_vm.id
}