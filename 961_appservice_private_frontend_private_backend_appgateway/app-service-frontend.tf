resource "azurerm_linux_web_app" "frontend" {
  name                          = "app-service-frontend-${var.prefix}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.app_service_plan.id
  https_only                    = true
  public_network_access_enabled = false
  virtual_network_subnet_id     = azurerm_subnet.snet-integration.id

  site_config {
    application_stack {
      docker_image_name   = "jelledruyts/inspectorgadget"
      docker_registry_url = "https://index.docker.io"
    }

    vnet_route_all_enabled = false
  }

  # app_settings = {
  #   "WEBSITE_DNS_SERVER" : "168.63.129.16",
  #   "WEBSITE_VNET_ROUTE_ALL" : "1"
  # }
}
