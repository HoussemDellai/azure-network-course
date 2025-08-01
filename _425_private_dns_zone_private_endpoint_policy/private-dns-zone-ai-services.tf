locals {
  private-dns-zone-names-ai-services = [
    "privatelink.cognitiveservices.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.services.ai.azure.com"
  ]
}

resource "azurerm_private_dns_zone" "private-dns-zone-ai-services" {
  for_each = toset(local.private-dns-zone-names-ai-services)

  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-vnet-dns-ai-services" {
  for_each = toset(local.private-dns-zone-names-ai-services)

  name                  = "link-vnet-dns-${each.key}"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-ai-services[each.key].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
