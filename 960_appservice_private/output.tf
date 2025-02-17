output "app_service_frontend_url" {
  value = azurerm_linux_web_app.frontend.default_hostname
}

output "app_service_backend_url" {
  value = azurerm_linux_web_app.backend.default_hostname
}