# resource "azapi_resource" "bastionHost" {
#   type      = "Microsoft.Network/bastionHosts@2024-05-01"
#   parent_id = azurerm_resource_group.rg.id
#   name      = "bastion-host"
#   location  = azurerm_resource_group.rg.location

#   body = {
#     sku = {
#       name = "Developer"
#     }
#     properties = {
#       virtualNetwork = {
#         id = azurerm_virtual_network.vnet-hub.id
#       }
#     }
#   }
# }