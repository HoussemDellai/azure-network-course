# module "vm-spoke2-test" {
#   source              = "../modules/vm_linux"
#   vm_name             = "vm-spoke2-test"
#   resource_group_name = "rg-spoke2-vm-test"
#   location            = azurerm_resource_group.rg-spoke2.location
#   subnet_id           = azurerm_subnet.subnet-spoke2-workload.id
#   enable_public_ip    = false
#   install_dev_tools   = true
#   tags                = var.tags
# }