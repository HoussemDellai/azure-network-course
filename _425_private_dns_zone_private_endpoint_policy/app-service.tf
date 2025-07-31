resource "azurerm_service_plan" "plan" {
  name                = "plan-appservice"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "web-app" {
  name                          = "webapp-${random_string.random.result}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_service_plan.plan.location
  service_plan_id               = azurerm_service_plan.plan.id
  public_network_access_enabled = false
  virtual_network_subnet_id     = null

  site_config {
    application_stack {
      docker_image_name   = "jelledruyts/inspectorgadget"
      docker_registry_url = "https://index.docker.io"
    }

    vnet_route_all_enabled        = false
    ip_restriction_default_action = "Deny"
  }
}

resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}
