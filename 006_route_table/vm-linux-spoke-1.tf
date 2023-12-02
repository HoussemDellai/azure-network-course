module "vm-linux-spoke-1" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-spoke-1"
  resource_group_name = azurerm_resource_group.rg-spoke-1.name
  location            = azurerm_resource_group.rg-spoke-1.location
  subnet_id           = azurerm_subnet.subnet-vm-spoke-1.id
  install_webapp      = true
}