resource "azurerm_virtual_network" "vnet-spoke01" {
  name                = "vnet-spoke01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-spoke01-vm" {
  name                 = "snet-spoke01-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke01.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke01.name
  address_prefixes     = ["10.1.0.0/24"]
}

module "vm_linux_spoke01" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-spoke01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet-spoke01-vm.id
  install_webapp      = true
}

resource "azapi_resource" "connection-vhub01-vnet01" {
  type      = "Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2020-05-01"
  parent_id = azurerm_virtual_hub.vhub01.id
  name      = "connection-vhub01-vnet01"
  body = {
    properties = {
      allowHubToRemoteVnetTransit         = true
      allowRemoteVnetToUseHubVnetGateways = true
      enableInternetSecurity              = true
      remoteVirtualNetwork = {
        id = azurerm_virtual_network.vnet-spoke01.id
      }
    }
  }
}

# # The following commented-out section is an alternative way to define the connection
# # But doesn't yet support the new features like `allowHubToRemoteVnetTransit` and `allowRemoteVnetToUseHubVnetGateways`.
# resource "azurerm_virtual_hub_connection" "connection-vhub-01-vnet-01" {
#   name                      = "connection-vhub-01-vnet-01"
#   virtual_hub_id            = azurerm_virtual_hub.vhub-01.id
#   remote_virtual_network_id = azurerm_virtual_network.vnet-hub-01-spoke-01.id
#   internet_security_enabled = false
#   # "allowHubToRemoteVnetTransit": true,
#   # "allowRemoteVnetToUseHubVnetGateways": true,

#   routing {
#     associated_route_table_id = azurerm_virtual_hub_route_table.vhub-01-routetable.id
#     # static_vnet_local_route_override_criteria = ""
#     # inbound_route_map_id                      = ""
#     # outbound_route_map_id                     = ""
#     # static_vnet_route {
#     #   address_prefixes    = [""]
#     #   next_hop_ip_address = ""
#     # }
#     propagated_route_table {
#       route_table_ids = [azurerm_virtual_hub_route_table.vhub-01-routetable.id]
#     }
#   }
# }
