output "appgateway_ip" {
  value = azurerm_public_ip.pip-appgateway.ip_address
}

output "custom_domain_name" {
  value = var.custom_domain_name
}