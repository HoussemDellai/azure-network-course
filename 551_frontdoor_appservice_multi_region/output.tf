output "frontdoor_endpoint_url" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}

output "appservice_url_region1" {
  value = azurerm_linux_web_app.region1.default_hostname
}

output "appservice_url_region2" {
  value = azurerm_linux_web_app.region2.default_hostname
}

output "appservice_url_region3" {
  value = azurerm_linux_web_app.region3.default_hostname
}