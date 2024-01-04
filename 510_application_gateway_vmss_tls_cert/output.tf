output "appgateway_ip" {
  value = azurerm_public_ip.pip-appgateway.ip_address
}