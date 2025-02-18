resource "azurerm_service_plan" "app_service_plan" {
  name                = "plan-app-service"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "swedencentral"
  sku_name            = "B1"
  os_type             = "Linux"
}