resource "azurerm_virtual_network" "vnet-spoke-02" {
  name                = "vnet-spoke-02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.12.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "snet-spoke-02-vm" {
  name                 = "snet-spoke-02-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke-02.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-02.name
  address_prefixes     = ["10.12.0.0/24"]
}

module "vm_linux_spoke_02" {
  source              = "../modules/vm_linux"
  vm_name             = "vm-linux-${azurerm_subnet.snet-spoke-02-vm.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snet-spoke-02-vm.id
  install_webapp      = true
}

resource "azurerm_virtual_hub_connection" "connection-vhub-vnet-02" {
  name                      = "connection-vhub-vnet-02"
  virtual_hub_id            = azurerm_virtual_hub.vhub.id
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke-02.id
  internet_security_enabled = false
}
