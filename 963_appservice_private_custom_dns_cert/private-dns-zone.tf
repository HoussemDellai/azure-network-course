resource "azurerm_private_dns_zone" "dns-appservice" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-zone-link" {
  name                  = "dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-appservice.name
  virtual_network_id    = azurerm_virtual_network.vnet-app.id
}

resource "azurerm_private_dns_zone" "dns-appservice-custom" {
  name                = var.custom_domain_name
  resource_group_name = azurerm_resource_group.rg.name
}

# craete a CNAME record
resource "azurerm_private_dns_cname_record" "dns-cname-record" {
  name                = "app1"
  zone_name           = azurerm_private_dns_zone.dns-appservice-custom.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 60
  record              = azurerm_linux_web_app.webapp.default_hostname
}

# # create A record
# resource "azurerm_private_dns_a_record" "dns-a-record" {
#   name                = "app1"
#   zone_name           = azurerm_private_dns_zone.dns-appservice-custom.name
#   resource_group_name = azurerm_resource_group.rg.name
#   ttl                 = 60
#   records             = [azurerm_linux_web_app.webapp.private_ip_address]
# }

resource "azurerm_private_dns_zone_virtual_network_link" "dns-zone-link-custom" {
  name                  = "dns-zone-link-custom"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-appservice-custom.name
  virtual_network_id    = azurerm_virtual_network.vnet-app.id
}
