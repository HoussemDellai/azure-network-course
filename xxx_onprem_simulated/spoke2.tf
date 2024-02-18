resource "azurerm_resource_group" "rg-spoke2" {
  name     = "rg-spoke2-${var.prefix}"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet-spoke2" {
  name                = "vnet-spoke2"
  location            = azurerm_resource_group.rg-spoke2.location
  resource_group_name = azurerm_resource_group.rg-spoke2.name
  address_space       = ["10.2.0.0/16"]
  dns_servers         = null
}

resource "azurerm_subnet" "subnet-spoke2-vm" {
  name                 = "subnet-spoke2-vm"
  resource_group_name  = azurerm_virtual_network.vnet-spoke2.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke2.name
  address_prefixes     = ["10.2.0.0/24"]
}

resource "azurerm_network_interface" "nic-vm-spoke2" {
  name                 = "nic-vm-spoke"
  resource_group_name  = azurerm_resource_group.rg-spoke2.name
  location             = azurerm_resource_group.rg-spoke2.location
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-spoke2-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_linux_virtual_machine" "vm-spoke2" {
  name                            = "vm-linux-spoke2"
  resource_group_name             = azurerm_resource_group.rg-spoke2.name
  location                        = azurerm_resource_group.rg-spoke2.location
  size                            = "Standard_B2ats_v2"
  disable_password_authentication = false
  admin_username                  = "azureuser"
  admin_password                  = "@Aa123456789"
  network_interface_ids           = [azurerm_network_interface.nic-vm-spoke2.id]
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"

  custom_data = filebase64("./install-webapp.sh")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

resource "azurerm_route_table" "route-table-spoke2" {
  name                          = "route-table-spoke2"
  location                      = azurerm_resource_group.rg-spoke2.location
  resource_group_name           = azurerm_resource_group.rg-spoke2.name
  disable_bgp_route_propagation = true
}

resource "azurerm_route" "route-to-firewall-spoke2" {
  name                   = "route-to-firewal-spoke2"
  resource_group_name    = azurerm_resource_group.rg-spoke2.name
  route_table_name       = azurerm_route_table.route-table-spoke2.name
  address_prefix         = "0.0.0.0/0" # azurerm_virtual_network.vnet-spoke.address_space.0
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_linux_virtual_machine.vm-hub-nva.private_ip_address
}

resource "azurerm_subnet_route_table_association" "route-table-spoke2" {
  subnet_id      = azurerm_subnet.subnet-spoke2-vm.id
  route_table_id = azurerm_route_table.route-table-spoke2.id
}

resource "azurerm_virtual_network_peering" "peering-hub-to-spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = azurerm_resource_group.rg-hub.name
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}

resource "azurerm_virtual_network_peering" "peering-spoke2-to-hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = azurerm_resource_group.rg-spoke2.name
  virtual_network_name         = azurerm_virtual_network.vnet-spoke2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = true

  depends_on = [azurerm_virtual_network_gateway.vpngateway-hub]
}
