# azurerm_resource_group.paloalto[0] will be created
resource "azurerm_resource_group" "paloalto" {
  location = "northeurope"
  name     = "paloalto-vmseries-standalone"
}

# random_password.paloalto[0] will be created
resource "random_password" "paloalto" {
  length           = 16
  lower            = true
  min_lower        = 12
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_%@"
  special          = true
  upper            = true
}

# module.vmseries["fw-1"].azurerm_linux_virtual_machine.paloalto will be created
resource "azurerm_linux_virtual_machine" "paloalto" {
  admin_password                                         = random_password.paloalto.result
  admin_username                                         = "panadmin"
  allow_extension_operations                             = false
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  custom_data                                            = "cGx1Z2luLW9wLWNvbW1hbmRzPWFkdmFuY2Utcm91dGluZzplbmFibGU7dHlwZT1kaGNwLWNsaWVudA==" # "plugin-op-commands=advance-routing:enable;type=dhcp-client"
  disable_password_authentication = false
  # disk_controller_type                                   = (known after apply)
  location              = "northeurope"
  name                  = "paloalto-firewall01"
  network_interface_ids = [azurerm_network_interface.paloalto.id]
  resource_group_name   = "paloalto-vmseries-standalone"
  size                  = "Standard_D3_v2"
  # vm_agent_platform_updates_enabled                      = (known after apply)

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = 60
    name                      = "paloalto-firewall01-osdisk"
    storage_account_type      = "StandardSSD_LRS"
    write_accelerator_enabled = false
  }

  plan {
    name      = "byol"
    product   = "vmseries-flex"
    publisher = "paloaltonetworks"
  }

  source_image_reference {
    offer     = "vmseries-flex"
    publisher = "paloaltonetworks"
    sku       = "byol"
    version   = "11.1.607"
  }
}

# module.vmseries["fw-1"].azurerm_network_interface.paloalto["paloalto-vm-mgmt"] will be created
resource "azurerm_network_interface" "paloalto" {
  accelerated_networking_enabled = false
  ip_forwarding_enabled          = false
  location                       = "northeurope"
  name                           = "paloalto-vm-mgmt"
  resource_group_name            = "paloalto-vmseries-standalone"

  ip_configuration {
    name                          = "primary-ip"
    primary                       = true
    private_ip_address            = "10.0.0.5"
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.paloalto.id
    subnet_id                     = azurerm_subnet.paloalto.id
  }
}

# module.vmseries["fw-1"].azurerm_public_ip.paloalto["paloalto-vm-mgmt-primary-ip"] will be created
resource "azurerm_public_ip" "paloalto" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  idle_timeout_in_minutes = 4
  ip_version              = "IPv4"
  location                = "northeurope"
  name                    = "paloalto-vm-mgmt-primary-ip-pip"
  resource_group_name     = "paloalto-vmseries-standalone"
  sku                     = "Standard"
  sku_tier                = "Regional"
}

# module.vnet["transit"].azurerm_network_security_group.paloalto["management"] will be created
resource "azurerm_network_security_group" "paloalto" {
  location            = "northeurope"
  name                = "paloalto-mgmt-nsg"
  resource_group_name = "paloalto-vmseries-standalone"
}

# module.vnet["transit"].azurerm_network_security_rule.paloalto["management-vmseries-management-allow-inbound"] will be created
resource "azurerm_network_security_rule" "paloalto" {
  access                      = "Allow"
  destination_address_prefix  = "10.0.0.0/28"
  destination_port_ranges     = ["22", "443"]
  direction                   = "Inbound"
  name                        = "vmseries-management-allow-inbound"
  network_security_group_name = azurerm_network_security_group.paloalto.name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = "paloalto-vmseries-standalone"
  source_address_prefixes     = ["1.1.1.1/32"]
  source_port_range           = "*"
}

# module.vnet["transit"].azurerm_subnet.paloalto["management"] will be created
resource "azurerm_subnet" "paloalto" {
  address_prefixes                              = ["10.0.0.0/28"]
  default_outbound_access_enabled               = false
  name                                          = "mgmt-snet"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_virtual_network.paloalto.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.paloalto.name
}

# module.vnet["transit"].azurerm_subnet_network_security_group_association.paloalto["management"] will be created
resource "azurerm_subnet_network_security_group_association" "paloalto" {
  network_security_group_id = azurerm_network_security_group.paloalto.id
  subnet_id                 = azurerm_subnet.paloalto.id
}

# module.vnet["transit"].azurerm_virtual_network.paloalto[0] will be created
resource "azurerm_virtual_network" "paloalto" {
  address_space                  = ["10.0.0.0/25"]
  location                       = "northeurope"
  name                           = "paloalto-transit"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.paloalto.name
}
