resource "azurerm_service_plan" "plan" {
  name                = "plan-appservice"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1" #"P0v3"
}

resource "azurerm_linux_web_app" "web-app" {
  name                = "webapp-service-endpoint-${random_string.random.result}-431"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {

    ip_restriction {
      action                    = "Allow"
      priority                  = 1000
      virtual_network_subnet_id = azurerm_subnet.subnet-app.id
      # One and only one of ip_address, service_tag or virtual_network_subnet_id must be specified.
    }
    ip_restriction {
      action     = "Allow"
      priority   = 1001
      ip_address = local.machine_ip_cidr
      # One and only one of ip_address, service_tag or virtual_network_subnet_id must be specified.
    }
  }
}