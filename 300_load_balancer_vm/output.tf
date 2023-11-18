output "loadbalancer_ip" {
  value = azurerm_public_ip.pip-lb.ip_address
}