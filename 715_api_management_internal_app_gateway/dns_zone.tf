resource "azurerm_private_dns_zone" "appgw" {
  name                = var.custom_domain_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "appgw_a_record" {
  name                = "@"
  zone_name           = azurerm_private_dns_zone.appgw.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 360
  records             = ["74.234.213.22"] # [azurerm_application_gateway.appgateway.frontend_ip_configuration.0.public_ip_address_id]
}

resource "azurerm_private_dns_zone_virtual_network_link" "appgw_vnetlink" {
  name                  = "appgw-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.appgw.name
  virtual_network_id    = azurerm_virtual_network.vnet-app.id
}