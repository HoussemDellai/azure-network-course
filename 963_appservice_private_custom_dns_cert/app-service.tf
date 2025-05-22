resource "azurerm_linux_web_app" "webapp" {
  name                          = "webapp-internal-${var.prefix}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.app_service_plan.id
  https_only                    = true
  public_network_access_enabled = false

  site_config {
    application_stack {
      docker_image_name   = "jelledruyts/inspectorgadget"
      docker_registry_url = "https://index.docker.io"
    }

    vnet_route_all_enabled = false
  }
}

resource "azurerm_app_service_custom_hostname_binding" "custom_domain_binding" {
  hostname            = trim(azurerm_dns_cname_record.dns_cname_record.fqdn, ".")
  app_service_name    = azurerm_linux_web_app.webapp.name
  resource_group_name = azurerm_linux_web_app.webapp.resource_group_name
  depends_on          = [azurerm_dns_txt_record.txt_record]

  # Ignore ssl_state and thumbprint as they are managed using
  # azurerm_app_service_certificate_binding.example
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}
