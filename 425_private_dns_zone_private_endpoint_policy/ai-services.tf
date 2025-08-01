resource "azurerm_ai_services" "ai-services" {
  name                               = "ai-services"
  location                           = azurerm_resource_group.rg.location
  resource_group_name                = azurerm_resource_group.rg.name
  sku_name                           = "S0"
  local_authentication_enabled       = true
  public_network_access              = "Disabled"
  outbound_network_access_restricted = false
  custom_subdomain_name              = "ai-services-${random_string.random.result}-${var.prefix}"
}