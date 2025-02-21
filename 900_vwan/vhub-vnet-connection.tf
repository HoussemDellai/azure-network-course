resource "azurerm_virtual_hub_connection" "connection-vhub-01-vnet-01" {
  name                      = "connection-vhub-01-vnet-01"
  virtual_hub_id            = azurerm_virtual_hub.vhub-01.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub-01-spoke-01.id
  internet_security_enabled = false

  #   routing {
  #     associated_route_table_id                 = ""
  #     static_vnet_local_route_override_criteria = ""
  #     inbound_route_map_id                      = ""
  #     outbound_route_map_id                     = ""
  #     static_vnet_route {
  #       address_prefixes    = [""]
  #       next_hop_ip_address = ""
  #     }
  #     propagated_route_table {
  #       route_table_ids = [""]
  #     }
  #   }
}

resource "azurerm_virtual_hub_connection" "connection-vhub-01-vnet-02" {
  name                      = "connection-vhub-01-vnet-02"
  virtual_hub_id            = azurerm_virtual_hub.vhub-01.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub-02-spoke-01.id
  internet_security_enabled = false
}

resource "azurerm_virtual_hub_connection" "connection-vhub-02-vnet-01" {
  name                      = "connection-vhub-02-vnet-01"
  virtual_hub_id            = azurerm_virtual_hub.vhub-02.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub-01-spoke-02.id
  internet_security_enabled = false
}
