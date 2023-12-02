module "vm-2" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-2"
  resource_group_name = azurerm_resource_group.rg-2.name
  location            = azurerm_resource_group.rg-2.location
  subnet_id           = azurerm_subnet.subnet-2.id
  install_webapp      = true
}