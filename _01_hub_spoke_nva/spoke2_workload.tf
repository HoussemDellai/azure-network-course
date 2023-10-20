module "vm-spoke2" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-spoke2"
  resource_group_name = "rg-spoke2-vm"
  location            = azurerm_resource_group.rg-spoke2.location
  subnet_id           = azurerm_subnet.subnet-spoke2-workload.id
  enable_public_ip    = false
  tags                = var.tags
}
