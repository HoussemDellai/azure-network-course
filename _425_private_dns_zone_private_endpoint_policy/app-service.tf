resource "azurerm_service_plan" "plan" {
  name                = "plan-appservice"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "web-app" {
  name                = "webapp-${random_string.random.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
  }
}

resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}