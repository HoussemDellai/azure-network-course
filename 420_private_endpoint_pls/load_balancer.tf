resource "azurerm_lb" "lb-internal" {
  name                = "lb-internal"
  location            = azurerm_resource_group.rg-provider.location
  resource_group_name = azurerm_resource_group.rg-provider.name
  sku                 = "Standard" # Standard and Gateway. Defaults to Basic
  sku_tier            = "Regional" # Global and Regional. Defaults to Regional

  frontend_ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-provider.id
    private_ip_address_allocation = "Dynamic" # Static or Dynamic. Defaults to Dynamic
    # private_ip_address            = "10.1.0.100"
  }
}

resource "azurerm_lb_backend_address_pool" "backend-pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.lb-internal.id
}

resource "azurerm_lb_rule" "lb-rule" {
  name                           = "lb-rule"
  loadbalancer_id                = azurerm_lb.lb-internal.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb-internal.frontend_ip_configuration.0.name
  idle_timeout_in_minutes        = 4 # between 4 and 30 minutes. Defaults to 4 minutes
  probe_id                       = azurerm_lb_probe.probe-http.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend-pool.id]
  load_distribution              = "Default" # Default, SourceIP, SourceIPProtocol. Defaults to Default
  disable_outbound_snat          = true      # Defaults to false
  enable_tcp_reset               = false
  enable_floating_ip             = false # Defaults to false
}

resource "azurerm_lb_probe" "probe-http" {
  name                = "probe-http"
  loadbalancer_id     = azurerm_lb.lb-internal.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  probe_threshold     = 1 # Possible values range from 1 to 100. The default value is 1
  interval_in_seconds = 5 # The default value is 15, the minimum value is 5 seconds.
  number_of_probes    = 2 # failed probe attempts after which the backend endpoint is removed from rotation. Default to 2
}
