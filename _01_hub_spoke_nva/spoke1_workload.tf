module "vm-spoke1" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-spoke1"
  resource_group_name = "rg-spoke1-vm"
  location            = azurerm_resource_group.rg-spoke1.location
  subnet_id           = azurerm_subnet.subnet-spoke1-workload.id
  enable_public_ip    = false
  install_dev_tools   = true
  tags                = var.tags
}
