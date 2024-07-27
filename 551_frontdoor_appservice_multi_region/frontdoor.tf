resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = "frontdoor-appservice-apps"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}