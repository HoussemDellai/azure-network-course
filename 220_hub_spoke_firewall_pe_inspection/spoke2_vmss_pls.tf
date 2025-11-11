resource "azurerm_lb" "ilb-vmss" {
  name                = "ilb-vmss"
  location            = azurerm_resource_group.rg-spoke2.location
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  sku                 = "Standard" # Standard and Gateway. Defaults to Basic
  sku_tier            = "Regional" # Global and Regional. Defaults to Regional

  frontend_ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-spoke2-vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "backend-pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.ilb-vmss.id
}

resource "azurerm_lb_rule" "lb-rule" {
  name                           = "lb-rule"
  loadbalancer_id                = azurerm_lb.ilb-vmss.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.ilb-vmss.frontend_ip_configuration.0.name
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
  loadbalancer_id     = azurerm_lb.ilb-vmss.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  probe_threshold     = 1 #  Possible values range from 1 to 100. The default value is 1
  interval_in_seconds = 5 # The default value is 15, the minimum value is 5 seconds.
  number_of_probes    = 2 # failed probe attempts after which the backend endpoint is removed from rotation. Default to 2
}

# resource "azurerm_lb_outbound_rule" "outbound-rule" {
#   name                    = "OutboundRule"
#   loadbalancer_id         = azurerm_lb.lb-internal.id
#   protocol                = "All" # Udp, Tcp or All
#   backend_address_pool_id = azurerm_lb_backend_address_pool.backend-pool.id
#   idle_timeout_in_minutes = 4

#   frontend_ip_configuration {
#     name = azurerm_lb.lb-internal.frontend_ip_configuration.0.name
#   }
# }

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = "vmss-inspector-gadget"
  resource_group_name             = azurerm_resource_group.rg-spoke2.name
  location                        = azurerm_resource_group.rg-spoke2.location
  instances                       = 2
  sku                             = "Standard_D2ads_v6"
  zones                           = ["1", "2", "3"]
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  priority                        = "Spot"
  eviction_policy                 = "Delete"

  custom_data = filebase64("../scripts/install-docker-inspector-gadget.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts" # "0001-com-ubuntu-server-jammy"
    sku       = "server"           # "22_04-lts"
    version   = "latest"
  }

  network_interface {
    name                      = "nic-vmss"
    primary                   = true
    enable_ip_forwarding      = false
    network_security_group_id = null

    ip_configuration {
      name                                         = "internal"
      primary                                      = true
      subnet_id                                    = azurerm_subnet.snet-spoke2-vm.id
      load_balancer_backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend-pool.id]
      application_gateway_backend_address_pool_ids = null
      load_balancer_inbound_nat_rules_ids          = null
    }
  }
}

# resource "azurerm_private_dns_zone" "private-dns-zone-consumer" {
#   name                = "internal.corp"
#   resource_group_name = azurerm_resource_group.rg-consumer.name
# }

# resource "azurerm_private_dns_a_record" "a-record" {
#   name                = "app"
#   zone_name           = azurerm_private_dns_zone.private-dns-zone-consumer.name
#   resource_group_name = azurerm_resource_group.rg-consumer.name
#   ttl                 = 300
#   records             = [azurerm_private_endpoint.pe-consumer.private_service_connection.0.private_ip_address]
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "link-dns-vnet" {
#   name                  = "link-dns-vnet"
#   resource_group_name   = azurerm_resource_group.rg-consumer.name
#   private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone-consumer.name
#   virtual_network_id    = azurerm_virtual_network.vnet-consumer.id
# }

resource "azurerm_private_link_service" "pls-vmss" {
  name                = "pls-vmss"
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  location            = azurerm_resource_group.rg-spoke2.location

  auto_approval_subscription_ids              = [data.azurerm_subscription.current.subscription_id]
  visibility_subscription_ids                 = [data.azurerm_subscription.current.subscription_id]
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.ilb-vmss.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name      = "primary"
    subnet_id = azurerm_subnet.snet-spoke2-vm.id
    primary   = true
    # private_ip_address         = "10.5.1.17"
    # private_ip_address_version = "IPv4"

  }
}

data "azurerm_subscription" "current" {
}

resource "azurerm_private_endpoint" "pe-vmss" {
  name                          = "pe-vmss"
  location                      = azurerm_resource_group.rg-spoke2.location
  resource_group_name           = azurerm_resource_group.rg-spoke2.name
  subnet_id                     = azurerm_subnet.snet-spoke2-pe.id
  custom_network_interface_name = "nic-pe-vmss"

  private_service_connection {
    name                           = "pls-connection"
    private_connection_resource_id = azurerm_private_link_service.pls-vmss.id
    is_manual_connection           = false
  }

  #   DNS configuration is not available for private endpoints connected to a private link service.
  #   private_dns_zone_group {
  #     name                 = "private-dns-zone-group"
  #     private_dns_zone_ids = [azurerm_private_dns_zone.private-dns-zone.id]
  #   }
}

output "vmss_pe_ip" {
  value = azurerm_private_endpoint.pe-vmss.private_service_connection.0.private_ip_address
}

output "vmss_ilb_ip" {
  value = azurerm_lb.ilb-vmss.frontend_ip_configuration.0.private_ip_address
}