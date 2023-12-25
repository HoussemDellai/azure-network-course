output "webapp_url" {
  value = azurerm_linux_web_app.web-app.default_hostname
}