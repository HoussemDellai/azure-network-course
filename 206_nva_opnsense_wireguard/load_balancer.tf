resource "azurerm_public_ip" "pip-lb-inbound" {
  name                = "pip-lb-inbound"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip-lb-outbound" {
  name                = "pip-lb-outbound"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static" # "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb-public" {
  name                = "load-balancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard" # Standard and Gateway. Defaults to Basic
  sku_tier            = "Regional" # Global and Regional. Defaults to Regional

  frontend_ip_configuration {
    name                 = "inbound"
    public_ip_address_id = azurerm_public_ip.pip-lb-inbound.id
  }

  frontend_ip_configuration {
    name                 = "outbound"
    public_ip_address_id = azurerm_public_ip.pip-lb-outbound.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend-pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.lb-public.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-backenpool-association" {
  network_interface_id    = azurerm_network_interface.nic-vm-nva-untrusted.id
  ip_configuration_name   = azurerm_network_interface.nic-vm-nva-untrusted.ip_configuration.0.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-pool.id
}

# resource "azurerm_lb_backend_address_pool_address" "backend-pool-address" {
#   name                                = "backend-pool-address"
#   backend_address_pool_id             = azurerm_lb_backend_address_pool.backend-pool.id
#   backend_address_ip_configuration_id = azurerm_lb.lb-public.frontend_ip_configuration[0].id
# }

resource "azurerm_lb_rule" "lb-rule" {
  name                           = "lb-rule"
  loadbalancer_id                = azurerm_lb.lb-public.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb-public.frontend_ip_configuration.0.name
  idle_timeout_in_minutes        = 4 # between 4 and 30 minutes. Defaults to 4 minutes
  probe_id                       = azurerm_lb_probe.probe-http.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend-pool.id]
  load_distribution              = "Default" # Default, SourceIP, SourceIPProtocol. Defaults to Default
  disable_outbound_snat          = true      # Defaults to false
  # enable_tcp_reset               = false
  # enable_floating_ip             = false # Defaults to false
}

resource "azurerm_lb_probe" "probe-http" {
  name                = "probe-http"
  loadbalancer_id     = azurerm_lb.lb-public.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  probe_threshold     = 1 #  Possible values range from 1 to 100. The default value is 1
  interval_in_seconds = 5 # The default value is 15, the minimum value is 5 seconds.
  number_of_probes    = 2 # failed probe attempts after which the backend endpoint is removed from rotation. Default to 2
}

resource "azurerm_lb_outbound_rule" "outbound-rule" {
  name                    = "outbound-rule"
  loadbalancer_id         = azurerm_lb.lb-public.id
  protocol                = "All" # Udp, Tcp or All
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-pool.id
  idle_timeout_in_minutes = 4

  frontend_ip_configuration {
    name = azurerm_lb.lb-public.frontend_ip_configuration.1.name
  }
}

# resource "azurerm_lb_nat_rule" "nat-rdp" {
#   name                           = "RDP-access"
#   resource_group_name            = azurerm_resource_group.rg.name
#   loadbalancer_id                = azurerm_lb.lb-public.id
#   protocol                       = "Tcp"
#   frontend_port_start            = 3009
#   frontend_port_end              = 3009
#   backend_port                   = 3389
#   frontend_ip_configuration_name = azurerm_lb.lb-public.frontend_ip_configuration.0.name
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.backend-pool.id
# }

output "pip_lb_inbound" {
  value = azurerm_public_ip.pip-lb-inbound.ip_address
}

output "pip_lb_outbound" {
  value = azurerm_public_ip.pip-lb-outbound.ip_address
}
