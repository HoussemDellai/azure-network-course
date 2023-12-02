module "vm-02" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-02"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet-frontend-servers.id
  install_webapp      = true
}