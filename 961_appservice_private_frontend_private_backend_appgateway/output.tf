output "app_service_frontend_url" {
  value = azurerm_linux_web_app.frontend.default_hostname
}

output "app_service_backend_url" {
  value = azurerm_linux_web_app.backend.default_hostname
}

output "app_service_frontend_outbound_ip_addresses" {
  value = azurerm_linux_web_app.frontend.outbound_ip_address_list
}

output "app_service_backend_outbound_ip_addresses" {
  value = azurerm_linux_web_app.backend.outbound_ip_address_list
}

output "app_gateway_public_ip" {
  value = azurerm_public_ip.pip-appgateway.ip_address
}
