resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = "frontdoor-${var.prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "frontdoor-${var.prefix}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

resource "azurerm_cdn_frontdoor_origin_group" "origin-group" {
  name                     = "origin-group-apps"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 500
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 30
  }
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "route-apps"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin-group.id
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  link_to_default_domain        = true
  https_redirect_enabled        = true
  cdn_frontdoor_origin_path     = "/"
  cdn_frontdoor_rule_set_ids    = []

  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.origin-region1.id,
    azurerm_cdn_frontdoor_origin.origin-region2.id,
    azurerm_cdn_frontdoor_origin.origin-region3.id,
  ]
}
