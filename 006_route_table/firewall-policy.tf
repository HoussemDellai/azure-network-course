resource "azurerm_firewall_policy" "firewall-policy" {
  name                = "firewall-policy"
  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location
  sku                 = "Standard" # "Basic" # "Standard" # "Premium" #
}

resource "azurerm_firewall_policy_rule_collection_group" "policy-group-allow" {
  name               = "policy-group-allow"
  firewall_policy_id = azurerm_firewall_policy.firewall-policy.id
  priority           = 100

  network_rule_collection {
    name     = "allow-spokes-traffic"
    priority = 400
    action   = "Allow"

    rule {
      name                  = "allow-spoke1-to-spoke2"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = azurerm_virtual_network.vnet-spoke-1.address_space
      destination_addresses = azurerm_virtual_network.vnet-spoke-2.address_space
      destination_ports     = ["*"]
    }

    rule {
      name                  = "allow-spoke2-to-spoke1"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = azurerm_virtual_network.vnet-spoke-2.address_space
      destination_addresses = azurerm_virtual_network.vnet-spoke-1.address_space
      destination_ports     = ["*"]
    }
  }
}
