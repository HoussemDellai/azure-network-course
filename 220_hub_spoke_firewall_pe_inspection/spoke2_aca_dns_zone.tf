
resource "azurerm_private_dns_zone" "private-dns-zone-aca-environment" {
  name                = "privatelink.${azurerm_container_app_environment.env.location}.azurecontainerapps.io"
  resource_group_name = azurerm_resource_group.rg-hub.name
}

# resource "azurerm_private_dns_a_record" "a-record" {
#   name                = split(".", azurerm_container_app_environment.env.default_domain)[0]
#   zone_name           = azurerm_private_dns_zone.private-dns-zone-aca-environment.name
#   resource_group_name = azurerm_private_dns_zone.private-dns-zone-aca-environment.resource_group_name
#   ttl                 = 300
#   records             = [azurerm_private_endpoint.pe-aca-environment.private_service_connection.0.private_ip_address] # [azurerm_container_app_environment.env.static_ip_address]
# }

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet-spoke1" {
  name                  = "link-dns-vnet-spoke1"
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-aca-environment.name
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-aca-environment.resource_group_name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke1.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet-spoke2" {
  name                  = "link-dns-vnet-spoke2"
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-aca-environment.name
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-aca-environment.resource_group_name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke2.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet-hub" {
  name                  = "link-dns-vnet-hub"
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-aca-environment.name
  resource_group_name   = azurerm_private_dns_zone.private-dns-zone-aca-environment.resource_group_name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
}
