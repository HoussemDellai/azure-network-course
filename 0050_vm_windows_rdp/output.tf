output "vm_windows_public_ip" {
  value = azurerm_public_ip.pip-vm-windows.ip_address
}