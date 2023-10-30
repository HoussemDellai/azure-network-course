# module "vm-03" {
#   source              = "../modules/vm_linux"
#   vm_name             = "vm-03"
#   resource_group_name = "rg-vm-03"
#   location            = azurerm_resource_group.rg.location
#   subnet_id           = azurerm_subnet.subnet-frontend-servers.id
#   enable_public_ip    = false
#   install_webapp      = false
# }

# module "vm-04" {
#   source              = "../modules/vm_linux"
#   vm_name             = "vm-04"
#   resource_group_name = "rg-vm-04"
#   location            = azurerm_resource_group.rg.location
#   subnet_id           = azurerm_subnet.subnet-frontend-servers.id
#   enable_public_ip    = false
#   install_webapp      = true
# }