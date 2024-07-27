output "frontdoor-endpoint-app" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint-app-service.host_name
}