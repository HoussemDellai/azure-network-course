output "apim_gateway_url" {
  value = azurerm_api_management.apim.gateway_url
}

output "function_url" {
  value = azurerm_linux_function_app.function-linux-container.default_hostname
}