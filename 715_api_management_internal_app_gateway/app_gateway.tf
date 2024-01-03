locals {
  backend_address_pool_name      = "backend-address-pool"
  frontend_port_http_name        = "frontend-port-http"
  frontend_port_https_name       = "frontend-port-https"
  frontend_ip_configuration_name = "frontend_ip_configuration"
  listener_http_name             = "listener-http"
  listener_https_name            = "listener-https"
  request_routing_rule_name      = "request-routing-rule"
  redirect_configuration_name    = "redirect-configuration"
  http_probe_name                = "http-health-probe-apim"
  backend_http_settings_https    = "backend-http-settings-https"
}

resource "azurerm_public_ip" "pip-appgateway" {
  name                = "pip-appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgateway" {
  name                = "appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  enable_http2        = true

  sku {
    name     = "Standard_v2" # "WAF_v2"
    tier     = "Standard_v2" # "WAF_v2"
    capacity = 1
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity-appgw.id]
  }

  ssl_certificate {
    name                = var.custom_domain_name
    key_vault_secret_id = azurerm_key_vault_certificate.local_domain_certs.secret_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip-appgateway.id
  }

  frontend_port {
    name = local.frontend_port_http_name
    port = 80
  }

  frontend_port {
    name = local.frontend_port_https_name
    port = 443
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [replace(azurerm_api_management.apim.gateway_url, "https://", "")]
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet-appgw.id
  }

  backend_http_settings {
    name                                = "default"
    port                                = 80
    protocol                            = "Http"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = false
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    request_timeout                     = 20
  }

  backend_http_settings {
    name                                = local.backend_http_settings_https
    port                                = 443
    protocol                            = "Https"
    cookie_based_affinity               = "Disabled"
    host_name                           = replace(azurerm_api_management.apim.gateway_url, "https://", "")
    pick_host_name_from_backend_address = false
    request_timeout                     = 20
    probe_name                          = local.http_probe_name
  }

  http_listener {
    name                           = local.listener_http_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_http_name
    protocol                       = "Http"
    require_sni                    = false
  }

  http_listener {
    name                           = local.listener_https_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_https_name
    protocol                       = "Https"
    require_sni                    = false
    ssl_certificate_name           = var.custom_domain_name
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = local.listener_https_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_https
  }

  probe {
    name                                      = local.http_probe_name
    protocol                                  = "Https"
    pick_host_name_from_backend_http_settings = false
    host                                      = replace(azurerm_api_management.apim.gateway_url, "https://", "")
    path                                      = "/api"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    minimum_servers                           = 0

    match {
      status_code = ["200-399"]
    }
  }

  # waf_configuration {
  #   enabled                  = true
  #   firewall_mode            = "Detection"
  #   rule_set_type            = "OWASP"
  #   rule_set_version         = "3.0"
  #   request_body_check       = true
  #   max_request_body_size_kb = 128
  #   file_upload_limit_mb     = 100
  # }

  # autoscale_configuration {
  #   min_capacity = 2
  #   max_capacity = 3
  # }

  depends_on = [
    azurerm_key_vault_certificate.local_domain_certs,
    azurerm_role_assignment.identity-appgw-secret-user,
  ]
}

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic-assoc" {
#   count                   = 2
#   network_interface_id    = azurerm_network_interface.nic[count.index].id
#   ip_configuration_name   = "nic-ipconfig-${count.index+1}"
#   backend_address_pool_id = one(azurerm_application_gateway.main.backend_address_pool).id
# }
