resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "endpoint-app-service13"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

resource "azurerm_cdn_frontdoor_origin_group" "origin-group" {
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

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin-group.id
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  link_to_default_domain        = true
  https_redirect_enabled        = false
  cdn_frontdoor_origin_path     = "/"

  cdn_frontdoor_origin_ids      = [
    azurerm_cdn_frontdoor_origin.origin-region1.id,
    azurerm_cdn_frontdoor_origin.origin-region2.id,
    azurerm_cdn_frontdoor_origin.origin-region3.id,
    ]
}

resource "azurerm_cdn_frontdoor_origin" "origin-region1" {
  name                           = "region1"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin-group.id
  enabled                        = true
  host_name                      = azurerm_linux_web_app.region1.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.region1.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "origin-region2" {
  name                           = "region2"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin-group.id
  enabled                        = true
  host_name                      = azurerm_linux_web_app.region2.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.region2.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "origin-region3" {
  name                           = "region3"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin-group.id
  enabled                        = true
  host_name                      = azurerm_linux_web_app.region3.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.region3.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}