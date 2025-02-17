resource "azurerm_cdn_frontdoor_endpoint" "endpoint-app-service" {
  name                     = "endpoint-${var.prefix}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

resource "azurerm_cdn_frontdoor_origin_group" "origin-group-app-service" {
  name                     = "origin-group-app-service"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin-app-service" {
  name                          = "origin-app-service"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin-group-app-service.id

  enabled                        = true
  host_name                      = azurerm_linux_web_app.app.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.app.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "route-app-service" {
  name                          = "route-app-service"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint-app-service.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin-group-app-service.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin-app-service.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  link_to_default_domain        = true
  https_redirect_enabled        = false
  cdn_frontdoor_origin_path     = "/"
}
