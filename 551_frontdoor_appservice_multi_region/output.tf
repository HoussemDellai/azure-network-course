output "frontdoor-endpoint-app" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}