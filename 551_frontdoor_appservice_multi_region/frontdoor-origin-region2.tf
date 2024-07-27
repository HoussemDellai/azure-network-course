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