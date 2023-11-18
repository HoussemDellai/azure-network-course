module "vm-jumpbox" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-jumpbox"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet-app.id
}