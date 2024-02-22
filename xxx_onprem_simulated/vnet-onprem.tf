resource "azurerm_virtual_network" "vnet-onprem" {
  name                = "vnet-onprem"
  location            = azurerm_resource_group.rg-onprem.location
  resource_group_name = azurerm_resource_group.rg-onprem.name
  address_space       = ["172.16.0.0/12"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-onprem-vm" {
  name                 = "subnet-onprem-vm"
  resource_group_name  = azurerm_virtual_network.vnet-onprem.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-onprem.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_subnet" "subnet-onprem-vpngateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.vnet-onprem.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-onprem.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_subnet" "subnet-onprem-dns-inbound" {
  name                 = "subnet-onprem-dns-inbound"
  resource_group_name  = azurerm_virtual_network.vnet-onprem.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-onprem.name
  address_prefixes     = ["172.16.2.0/24"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "subnet-onprem-dns-outbound" {
  name                 = "subnet-onprem-dns-outbound"
  resource_group_name  = azurerm_virtual_network.vnet-onprem.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-onprem.name
  address_prefixes     = ["172.16.3.0/24"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}
