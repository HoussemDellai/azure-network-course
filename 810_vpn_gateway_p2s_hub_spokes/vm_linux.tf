module "vm-hub" {
  source = "./modules/vm_linux"

  vm_name             = "vm-linux-hub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet-vm.id
  enable_public_ip    = true
  install_webapp      = true
}