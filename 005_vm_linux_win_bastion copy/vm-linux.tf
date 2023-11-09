module "vm-linux" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux"
  resource_group_name = "rg-vm-linux"
  location            = azurerm_resource_group.rg-spoke.location
  subnet_id           = azurerm_subnet.subnet-vm.id
  install_webapp      = true
}