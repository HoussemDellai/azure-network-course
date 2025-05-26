module "vm-spoke1" {
  source              = "../modules/vm_windows"
  vm_name             = "vm-win11-spoke1"
  resource_group_name = azurerm_resource_group.rg-spoke1.name
  location            = azurerm_resource_group.rg-spoke1.location
  subnet_id           = azurerm_subnet.subnet-spoke1-workload.id
  admin_username      = "azureuser"
  admin_password      = "@Aa123456789"
  install_webapp      = true
}
