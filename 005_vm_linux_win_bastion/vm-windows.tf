module "vm-windows" {
  source              = "../modules/vm_windows"
  vm_name             = "vm-windows"
  resource_group_name = azurerm_resource_group.rg-spoke.name
  location            = azurerm_resource_group.rg-spoke.location
  subnet_id           = azurerm_subnet.subnet-vm.id
  install_webapp      = true
}