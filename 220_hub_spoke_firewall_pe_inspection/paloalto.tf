# resource "azurerm_resource_group" "example" {
#   name     = "example-resource-group"
#   location = "westeurope"
# }

# resource "azurerm_public_ip" "example" {
#   name                = "example-public-ip"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_network_security_group" "example" {
#   name                = "example-nsg"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
# }

# resource "azurerm_virtual_network" "example" {
#   name                = "example-vnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   tags = {
#     environment = "Production"
#   }
# }

# resource "azurerm_subnet" "trust" {
#   name                 = "example-trust-subnet"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.1.0/24"]

#   delegation {
#     name = "trusted"

#     service_delegation {
#       name = "PaloAltoNetworks.Cloudngfw/firewalls"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#     }
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "trust" {
#   subnet_id                 = azurerm_subnet.trust.id
#   network_security_group_id = azurerm_network_security_group.example.id
# }

# resource "azurerm_subnet" "untrust" {
#   name                 = "example-untrust-subnet"
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.2.0/24"]

#   delegation {
#     name = "untrusted"

#     service_delegation {
#       name = "PaloAltoNetworks.Cloudngfw/firewalls"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#     }
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "untrust" {
#   subnet_id                 = azurerm_subnet.untrust.id
#   network_security_group_id = azurerm_network_security_group.example.id
# }

# resource "azurerm_palo_alto_local_rulestack" "example" {
#   name                = "example-rulestack"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location
# }

# resource "azurerm_palo_alto_local_rulestack_rule" "example" {
#   name         = "example-rulestack-rule"
#   rulestack_id = azurerm_palo_alto_local_rulestack.example.id
#   priority     = 1001
#   action       = "Allow"
#   protocol     = "application-default"

#   applications = ["any"]

#   destination {
#     cidrs = ["any"]
#   }

#   source {
#     cidrs = ["any"]
#   }

#   #   protocol = ""
# }

# resource "azurerm_palo_alto_next_generation_firewall_virtual_network_local_rulestack" "example" {
#   name                = "example-ngfwvn"
#   resource_group_name = azurerm_resource_group.example.name
#   rulestack_id        = azurerm_palo_alto_local_rulestack.example.id

#   network_profile {
#     public_ip_address_ids = [azurerm_public_ip.example.id]

#     vnet_configuration {
#       virtual_network_id  = azurerm_virtual_network.example.id
#       trusted_subnet_id   = azurerm_subnet.trust.id
#       untrusted_subnet_id = azurerm_subnet.untrust.id
#     }
#   }
# }
