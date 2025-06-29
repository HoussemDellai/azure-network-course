output "app_service_url" {
  value = azurerm_linux_web_app.webapp.default_hostname
}
