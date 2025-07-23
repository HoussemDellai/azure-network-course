resource "azurerm_virtual_network" "vnet-spoke-bastion" {
  name                = "vnet-spoke-bastion"
  location            = var.region1
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.100.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-spoke-bastion-vm" {
  name                 = "snet-spoke-bastion-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke-bastion.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-bastion.name
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_subnet" "snet-spoke-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_virtual_network.vnet-spoke-bastion.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-bastion.name
  address_prefixes     = ["10.100.1.0/24"]
}

module "vm_linux_spoke_bastion" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-spoke-bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region1
  subnet_id           = azurerm_subnet.snet-spoke-bastion-vm.id
  install_webapp      = true
}

resource "azapi_resource" "connection-vhub01-vnetbastion" {
  type      = "Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2020-05-01"
  parent_id = azurerm_virtual_hub.vhub01.id
  name      = "connection-vhub01-vnetbastion"
  body = {
    properties = {
      allowHubToRemoteVnetTransit         = true
      allowRemoteVnetToUseHubVnetGateways = true
      # Disabling Internet Security is important for Bastion to work.
      # This will disable the propagation of routes by the Secure VHUB into the Bastion VNET.
      # We need that behaviour in order to not inject route '0.0.0.0/0' to the VNET Gateway. 
      # It should route to Internet. 
      # Details: https://blog.cloudtrooper.net/2022/09/17/azure-bastion-routing-in-virtual-wan/
      enableInternetSecurity = false

      remoteVirtualNetwork = {
        id = azurerm_virtual_network.vnet-spoke-bastion.id
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

resource "azurerm_public_ip" "pip-bastion" {
  name                = "pip-bastion"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                      = "bastion"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  sku                       = "Standard" # "Basic", "Developer"
  copy_paste_enabled        = true
  file_copy_enabled         = true
  shareable_link_enabled    = true
  tunneling_enabled         = true
  ip_connect_enabled        = true
  session_recording_enabled = false
  scale_units               = "2" # Number of scale units for the Bastion Host, minimum is 2 for Standard SKU

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet-spoke-bastion.id
    public_ip_address_id = azurerm_public_ip.pip-bastion.id
  }
}
