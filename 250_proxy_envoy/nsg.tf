resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-snet-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.snet-vm.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "rule-allow-all-outbound" {
  name                        = "rule-allow-all-outbound"
  access                      = "Allow"     # Allow
  priority                    = 900        # between 100 and 4096, must be unique, The lower the priority number, the higher the priority of the rule.
  direction                   = "Outbound" # Inbound
  protocol                    = "*"      # Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
  source_address_prefix       = "*"        # CIDR or source IP range or * to match any IP, Supports Tags like VirtualNetwork, AzureLoadBalancer and Internet.
  source_port_range           = "*"        # between 0 and 65535 or * to match any
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "rule-allow-all-inbound" {
  name                        = "rule-allow-all-inbound"
  access                      = "Allow"
  priority                    = 800
  direction                   = "Inbound"
  protocol                    = "*"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
