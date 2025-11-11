resource "azurerm_service_plan" "plan-app-service" {
  name                = "plan-app-service"
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  location            = azurerm_resource_group.rg-spoke2.location
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "webapp" {
  name                          = "app-service-${var.prefix}"
  location                      = azurerm_resource_group.rg-spoke2.location
  resource_group_name           = azurerm_resource_group.rg-spoke2.name
  service_plan_id               = azurerm_service_plan.plan-app-service.id
  https_only                    = true
  public_network_access_enabled = false

  site_config {
    application_stack {
      docker_image_name   = "jelledruyts/inspectorgadget"
      docker_registry_url = "https://index.docker.io"
    }

    vnet_route_all_enabled        = false
  }
}

resource "azurerm_private_endpoint" "pe-appservice" {
  name                = "pe-appservice"
  location            = azurerm_resource_group.rg-spoke2.location
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  subnet_id           = azurerm_subnet.snet-spoke2-pe.id

  private_dns_zone_group {
    name                 = "group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns-appservice.id]
  }

  private_service_connection {
    name                           = "connection"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "dns-appservice" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg-spoke2.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-appservice-spoke2" {
  name                  = "link-dns-appservice-spoke2"
  resource_group_name   = azurerm_resource_group.rg-spoke2.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-appservice.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke2.id
}

output "appservice_fqdn" {
  value = azurerm_linux_web_app.webapp.default_hostname
}

# app service PE private IP
output "appservice_pe_ip" {
  value = azurerm_private_endpoint.pe-appservice.private_service_connection.0.private_ip_address
}