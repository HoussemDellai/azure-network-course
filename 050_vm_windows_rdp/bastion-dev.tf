# resource "azurerm_bastion_host" "bastion-dev" {
#   name                = "bastion-dev"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku                 = "Developer" # "Standard" # "Basic", "Developer"
#   virtual_network_id  = azurerm_virtual_network.vnet-spoke-vm.id

#   copy_paste_enabled     = true
#   file_copy_enabled      = false
#   shareable_link_enabled = false
#   tunneling_enabled      = false
#   ip_connect_enabled     = false
#   session_recording_enabled = false
# }
