# DNS Zone to configure the domain name
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.custom_domain_name
  resource_group_name = azurerm_resource_group.rg.name
}

# CNAME record
resource "azurerm_dns_cname_record" "dns_cname_record" {
  name                = "app1"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_linux_web_app.webapp.default_hostname
}

resource "azurerm_dns_txt_record" "txt_record" {
  name                = "asuid.${azurerm_dns_cname_record.dns_cname_record.name}"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record {
    value = azurerm_linux_web_app.webapp.custom_domain_verification_id
  }
}