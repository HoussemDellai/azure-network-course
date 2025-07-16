resource "azurerm_virtual_network" "vnet-spoke01" {
  name                = "vnet-spoke01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.11.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-spoke01-vm" {
  name                 = "snet-spoke01-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke01.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke01.name
  address_prefixes     = ["10.11.0.0/24"]
}

module "vm_linux_spoke_01" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-spoke01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet-spoke01-vm.id
  install_webapp      = true
}

resource "azurerm_virtual_hub_connection" "connection-vhub-vnet01" {
  name                      = "connection-vhub-vnet01"
  virtual_hub_id            = azurerm_virtual_hub.vhub.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke01.id
  internet_security_enabled = false
}
