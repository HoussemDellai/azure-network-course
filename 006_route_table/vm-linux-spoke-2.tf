module "vm-linux-spoke-2" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-spoke-2"
  resource_group_name = azurerm_resource_group.rg-spoke-2.name
  location            = azurerm_resource_group.rg-spoke-2.location
  subnet_id           = azurerm_subnet.subnet-vm-spoke-2.id
  install_webapp      = true
}