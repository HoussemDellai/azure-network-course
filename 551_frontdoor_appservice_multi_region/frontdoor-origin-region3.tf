resource "azurerm_cdn_frontdoor_origin" "origin-region3" {
  name                           = "origin-${var.location3}"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin-group.id
  enabled                        = true
  host_name                      = azurerm_linux_web_app.region3.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.region3.default_hostname
  priority                       = 1
  weight                         = 1
  certificate_name_check_enabled = true
}