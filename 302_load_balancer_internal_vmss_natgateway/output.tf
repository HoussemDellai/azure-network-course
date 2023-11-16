output "loadbalancer_ip" {
  value = azurerm_lb.lb-internal.private_ip_address
}