# resource "azurerm_network_security_group" "nsg" {
#   name                = "nsg-snet-app"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_network_security_rule" "rule-allow-all-inbound" {
#   resource_group_name          = azurerm_resource_group.rg.name
#   network_security_group_name  = azurerm_network_security_group.nsg.name
#   name                         = "rule-allow-all-inbound"
#   access                       = "Allow"
#   priority                     = 100
#   direction                    = "Inbound"
#   protocol                     = "*"
#   source_address_prefix        = "*" # "Internet"
#   source_port_range            = "*"
#   destination_address_prefixes = azurerm_subnet.snet-vm.address_prefixes
#   destination_port_range       = "*" # "8080"
# }

# resource "azurerm_network_security_rule" "rule-allow-all-outbound" {
#   resource_group_name          = azurerm_resource_group.rg.name
#   network_security_group_name  = azurerm_network_security_group.nsg.name
#   name                         = "rule-allow-all-outbound"
#   access                       = "Allow"
#   priority                     = 100
#   direction                    = "Outbound"
#   protocol                     = "*"
#   source_address_prefix        = "*" # "Internet"
#   source_port_range            = "*"
#   destination_address_prefixes = azurerm_subnet.snet-vm.address_prefixes
#   destination_port_range       = "*" # "8080"
# }

# resource "azurerm_subnet_network_security_group_association" "nsg_association" {
#   subnet_id                 = azurerm_subnet.snet-vm.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }
