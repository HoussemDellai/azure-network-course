resource "azurerm_linux_web_app" "frontend" {
  name                          = "app-service-frontend-${var.prefix}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.app_service_plan.id
  https_only                    = true
  public_network_access_enabled = true
  virtual_network_subnet_id     = azurerm_subnet.snet-integration.id

  site_config {
    application_stack {
      docker_image_name   = "jelledruyts/inspectorgadget"
      docker_registry_url = "https://index.docker.io"
    }

    vnet_route_all_enabled = false

    # ip_restriction_default_action = "Deny"
    # ip_restriction {
    #   name                      = "Allow traffic from Front Door"
    #   service_tag               = "AzureFrontDoor.Backend"
    #   ip_address                = null
    #   virtual_network_subnet_id = null
    #   action                    = "Allow"
    #   priority                  = 100

    #   headers {
    #     x_azure_fdid      = [azurerm_cdn_frontdoor_profile.frontdoor.resource_guid]
    #     x_fd_health_probe = []
    #     x_forwarded_for   = []
    #     x_forwarded_host  = []
    #   }
    # }
  }

  # app_settings = {
  #   "WEBSITE_DNS_SERVER" : "168.63.129.16",
  #   "WEBSITE_VNET_ROUTE_ALL" : "1"
  # }
}
