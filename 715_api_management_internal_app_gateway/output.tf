output "function_url" {
  value = azurerm_linux_function_app.function-linux-container.default_hostname
}

output "apim_gateway_url" {
  value = azurerm_api_management.apim.gateway_url
}

output "apim_developer_portal_url" {
  value = azurerm_api_management.apim.developer_portal_url
}

output "apim_management_url" {
  value = azurerm_api_management.apim.management_api_url
}

output "appgw_public_ip" {
  value = azurerm_public_ip.pip-appgateway.ip_address
}

output "custom_domain_name" {
  value = var.custom_domain_name
}