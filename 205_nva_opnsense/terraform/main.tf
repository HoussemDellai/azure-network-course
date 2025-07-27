# OPNsense Firewall Terraform Deployment
# Converted from ARM template main.json - Single file configuration

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate random password for temp credentials
resource "random_uuid" "temp_password" {}

# Data source for resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

locals {
  temp_username = "azureuser"
  temp_password = random_uuid.temp_password.result

  untrusted_subnet_name  = "Untrusted-Subnet"
  trusted_subnet_name    = "Trusted-Subnet"
  windows_vm_subnet_name = "Windows-VM-Subnet"

  # Determine if using existing VNet
  use_existing_vnet = var.existing_virtual_network != "new"

  # Subnet IDs
  untrusted_subnet_id = local.use_existing_vnet ? data.azurerm_subnet.existing_untrusted[0].id : azurerm_subnet.untrusted[0].id
  trusted_subnet_id   = local.use_existing_vnet ? data.azurerm_subnet.existing_trusted[0].id : azurerm_subnet.trusted[0].id
  windows_subnet_id   = var.deploy_windows ? (local.use_existing_vnet ? data.azurerm_subnet.existing_windows[0].id : azurerm_subnet.windows[0].id) : ""

  # Full subnet names for script parameters
  trusted_subnet_full_name = "${var.virtual_network_name}/${local.use_existing_vnet ? var.existing_trusted_subnet_name : local.trusted_subnet_name}"
  windows_subnet_full_name = var.deploy_windows ? "${var.virtual_network_name}/${local.use_existing_vnet ? var.existing_windows_subnet : local.windows_vm_subnet_name}" : ""

  # Get subnet CIDR for script parameters
  trusted_subnet_cidr = local.use_existing_vnet ? data.azurerm_subnet.existing_trusted[0].address_prefixes[0] : var.trusted_subnet_cidr
  windows_subnet_cidr = var.deploy_windows ? (local.use_existing_vnet ? data.azurerm_subnet.existing_windows[0].address_prefixes[0] : var.deploy_windows_subnet) : "1.1.1.1/32"
}

# Data sources for existing VNet (if using existing)
data "azurerm_subnet" "existing_untrusted" {
  count                = local.use_existing_vnet ? 1 : 0
  name                 = var.existing_untrusted_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "existing_trusted" {
  count                = local.use_existing_vnet ? 1 : 0
  name                 = var.existing_trusted_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "existing_windows" {
  count                = local.use_existing_vnet && var.deploy_windows ? 1 : 0
  name                 = var.existing_windows_subnet
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.main.name
}

# Create Virtual Network (if new)
resource "azurerm_virtual_network" "main" {
  count               = local.use_existing_vnet ? 0 : 1
  name                = var.virtual_network_name
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.vnet_address

  tags = {
    Environment = "OPNsense"
  }
}

# Create Untrusted Subnet
resource "azurerm_subnet" "untrusted" {
  count                = local.use_existing_vnet ? 0 : 1
  name                 = local.untrusted_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.untrusted_subnet_cidr]
}

# Create Trusted Subnet
resource "azurerm_subnet" "trusted" {
  count                = local.use_existing_vnet ? 0 : 1
  name                 = local.trusted_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.trusted_subnet_cidr]
}

# Create Windows Subnet (if deploying Windows)
resource "azurerm_subnet" "windows" {
  count                = !local.use_existing_vnet && var.deploy_windows ? 1 : 0
  name                 = local.windows_vm_subnet_name
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = [var.deploy_windows_subnet]
}

# Public IP for OPNsense
resource "azurerm_public_ip" "opnsense" {
  name                = "${var.virtual_machine_name}-PublicIP"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = var.public_ip_address_sku

  tags = {
    Environment = "OPNsense"
  }
}

# Network Security Group
resource "azurerm_network_security_group" "opnsense" {
  name                = "${var.virtual_machine_name}-NSG"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "In-Any"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Out-Any"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# External Load Balancer (Active-Active scenario)
resource "azurerm_lb" "external" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "External-LoadBalance"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "FW"
    public_ip_address_id = azurerm_public_ip.opnsense.id
  }

  tags = {
    Environment = "OPNsense"
  }
}

# External Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "external" {
  count           = var.scenario_option == "Active-Active" ? 1 : 0
  loadbalancer_id = azurerm_lb.external[0].id
  name            = "OPNSense"
}

# External Load Balancer Health Probe
resource "azurerm_lb_probe" "external" {
  count           = var.scenario_option == "Active-Active" ? 1 : 0
  loadbalancer_id = azurerm_lb.external[0].id
  name            = "HTTPs"
  protocol        = "Tcp"
  port            = 443
}

# External Load Balancer Rule
resource "azurerm_lb_rule" "external" {
  count                          = var.scenario_option == "Active-Active" ? 1 : 0
  loadbalancer_id                = azurerm_lb.external[0].id
  name                           = "RDP"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "FW"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.external[0].id]
  probe_id                       = azurerm_lb_probe.external[0].id
  enable_floating_ip             = true
  disable_outbound_snat          = true
}

# External Load Balancer Outbound Rule
resource "azurerm_lb_outbound_rule" "external" {
  count                   = var.scenario_option == "Active-Active" ? 1 : 0
  loadbalancer_id         = azurerm_lb.external[0].id
  name                    = "OutBound-OPNSense"
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.external[0].id

  frontend_ip_configuration {
    name = "FW"
  }
}

# External Load Balancer NAT Rules
resource "azurerm_lb_nat_rule" "primary_mgmt" {
  count                          = var.scenario_option == "Active-Active" ? 1 : 0
  resource_group_name            = data.azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.external[0].id
  name                           = "primary-nva-mgmt"
  protocol                       = "Tcp"
  frontend_port                  = 50443
  backend_port                   = 443
  frontend_ip_configuration_name = "FW"
}

resource "azurerm_lb_nat_rule" "secondary_mgmt" {
  count                          = var.scenario_option == "Active-Active" ? 1 : 0
  resource_group_name            = data.azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.external[0].id
  name                           = "secondary-nva-mgmt"
  protocol                       = "Tcp"
  frontend_port                  = 50444
  backend_port                   = 443
  frontend_ip_configuration_name = "FW"
}

# Internal Load Balancer (Active-Active scenario)
resource "azurerm_lb" "internal" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "Internal-LoadBalance"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "FW"
    subnet_id                     = local.trusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Internal Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "internal" {
  count           = var.scenario_option == "Active-Active" ? 1 : 0
  loadbalancer_id = azurerm_lb.internal[0].id
  name            = "OPNSense"
}

# Internal Load Balancer Health Probe
resource "azurerm_lb_probe" "internal" {
  count           = var.scenario_option == "Active-Active" ? 1 : 0
  loadbalancer_id = azurerm_lb.internal[0].id
  name            = "HTTPs"
  protocol        = "Tcp"
  port            = 443
}

# Internal Load Balancer Rule (HA Ports)
resource "azurerm_lb_rule" "internal" {
  count                          = var.scenario_option == "Active-Active" ? 1 : 0
  loadbalancer_id                = azurerm_lb.internal[0].id
  name                           = "Internal-HA-Port-Rule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "FW"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.internal[0].id]
  probe_id                       = azurerm_lb_probe.internal[0].id
  enable_floating_ip             = true
  disable_outbound_snat          = true
}

# Primary OPNsense VM NICs (Active-Active scenario)
resource "azurerm_network_interface" "primary_untrusted" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "${var.virtual_machine_name}-Primary-Untrusted-NIC"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.untrusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "OPNsense"
  }
}

resource "azurerm_network_interface" "primary_trusted" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "${var.virtual_machine_name}-Primary-Trusted-NIC"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.trusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Associate Primary NICs with NSG
resource "azurerm_network_interface_security_group_association" "primary_untrusted" {
  count                     = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id      = azurerm_network_interface.primary_untrusted[0].id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}

resource "azurerm_network_interface_security_group_association" "primary_trusted" {
  count                     = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id      = azurerm_network_interface.primary_trusted[0].id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}

# Associate Primary NICs with Load Balancers
resource "azurerm_network_interface_backend_address_pool_association" "primary_external" {
  count                   = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id    = azurerm_network_interface.primary_untrusted[0].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.external[0].id
}

resource "azurerm_network_interface_backend_address_pool_association" "primary_internal" {
  count                   = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id    = azurerm_network_interface.primary_trusted[0].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.internal[0].id
}

resource "azurerm_network_interface_nat_rule_association" "primary_mgmt" {
  count                 = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id  = azurerm_network_interface.primary_untrusted[0].id
  ip_configuration_name = "ipconfig1"
  nat_rule_id           = azurerm_lb_nat_rule.primary_mgmt[0].id
}

# Secondary OPNsense VM NICs (Active-Active scenario)
resource "azurerm_network_interface" "secondary_untrusted" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "${var.virtual_machine_name}-Secondary-Untrusted-NIC"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.untrusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "OPNsense"
  }
}

resource "azurerm_network_interface" "secondary_trusted" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "${var.virtual_machine_name}-Secondary-Trusted-NIC"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.trusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Associate Secondary NICs with NSG
resource "azurerm_network_interface_security_group_association" "secondary_untrusted" {
  count                     = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id      = azurerm_network_interface.secondary_untrusted[0].id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}

resource "azurerm_network_interface_security_group_association" "secondary_trusted" {
  count                     = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id      = azurerm_network_interface.secondary_trusted[0].id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}

# Associate Secondary NICs with Load Balancers
resource "azurerm_network_interface_backend_address_pool_association" "secondary_external" {
  count                   = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id    = azurerm_network_interface.secondary_untrusted[0].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.external[0].id
}

resource "azurerm_network_interface_backend_address_pool_association" "secondary_internal" {
  count                   = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id    = azurerm_network_interface.secondary_trusted[0].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.internal[0].id
}

resource "azurerm_network_interface_nat_rule_association" "secondary_mgmt" {
  count                 = var.scenario_option == "Active-Active" ? 1 : 0
  network_interface_id  = azurerm_network_interface.secondary_untrusted[0].id
  ip_configuration_name = "ipconfig1"
  nat_rule_id           = azurerm_lb_nat_rule.secondary_mgmt[0].id
}

# Single OPNsense VM NICs (TwoNics scenario)
resource "azurerm_network_interface" "single_untrusted" {
  count               = var.scenario_option == "TwoNics" ? 1 : 0
  name                = "${var.virtual_machine_name}-Untrusted-NIC"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.untrusted_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.opnsense.id
  }

  tags = {
    Environment = "OPNsense"
  }
}

resource "azurerm_network_interface" "single_trusted" {
  count               = var.scenario_option == "TwoNics" ? 1 : 0
  name                = "${var.virtual_machine_name}-Trusted-NIC"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.trusted_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Associate Single NICs with NSG
resource "azurerm_network_interface_security_group_association" "single_untrusted" {
  count                     = var.scenario_option == "TwoNics" ? 1 : 0
  network_interface_id      = azurerm_network_interface.single_untrusted[0].id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}

resource "azurerm_network_interface_security_group_association" "single_trusted" {
  count                     = var.scenario_option == "TwoNics" ? 1 : 0
  network_interface_id      = azurerm_network_interface.single_trusted[0].id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}

# Primary OPNsense VM (Active-Active scenario)
resource "azurerm_linux_virtual_machine" "primary" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "${var.virtual_machine_name}-Primary"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = var.virtual_machine_size
  admin_username      = local.temp_username
  admin_password      = local.temp_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.primary_untrusted[0].id,
    azurerm_network_interface.primary_trusted[0].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "14_1-release-amd64-gen2-zfs"
    product   = "freebsd-14_1"
    publisher = "thefreebsdfoundation"
  }

  source_image_reference {
    publisher = "thefreebsdfoundation"
    offer     = "freebsd-14_1"
    sku       = "14_1-release-amd64-gen2-zfs"
    version   = "latest"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Secondary OPNsense VM (Active-Active scenario)
resource "azurerm_linux_virtual_machine" "secondary" {
  count               = var.scenario_option == "Active-Active" ? 1 : 0
  name                = "${var.virtual_machine_name}-Secondary"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = var.virtual_machine_size
  admin_username      = local.temp_username
  admin_password      = local.temp_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.secondary_untrusted[0].id,
    azurerm_network_interface.secondary_trusted[0].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "14_1-release-amd64-gen2-zfs"
    product   = "freebsd-14_1"
    publisher = "thefreebsdfoundation"
  }

  source_image_reference {
    publisher = "thefreebsdfoundation"
    offer     = "freebsd-14_1"
    sku       = "14_1-release-amd64-gen2-zfs"
    version   = "latest"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# Single OPNsense VM (TwoNics scenario)
resource "azurerm_linux_virtual_machine" "single" {
  count               = var.scenario_option == "TwoNics" ? 1 : 0
  name                = var.virtual_machine_name
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = var.virtual_machine_size
  admin_username      = local.temp_username
  admin_password      = local.temp_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.single_untrusted[0].id,
    azurerm_network_interface.single_trusted[0].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "14_1-release-amd64-gen2-zfs"
    product   = "freebsd-14_1"
    publisher = "thefreebsdfoundation"
  }

  source_image_reference {
    publisher = "thefreebsdfoundation"
    offer     = "freebsd-14_1"
    sku       = "14_1-release-amd64-gen2-zfs"
    version   = "latest"
  }

  tags = {
    Environment = "OPNsense"
  }
}

# VM Extensions for OPNsense configuration
resource "azurerm_virtual_machine_extension" "primary_config" {
  count                = var.scenario_option == "Active-Active" ? 1 : 0
  name                 = "CustomScript"
  virtual_machine_id   = azurerm_linux_virtual_machine.primary[0].id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"
  auto_upgrade_minor_version = false

  settings = jsonencode({
    fileUris = [
      "${var.opn_script_uri}${var.shell_script_name}"
    ]
    commandToExecute = "sh ${var.shell_script_name} ${var.opn_script_uri} ${var.opn_version} ${var.wa_linux_version} Primary ${local.trusted_subnet_cidr} ${local.windows_subnet_cidr} ${azurerm_public_ip.opnsense.ip_address} ${var.scenario_option == "Active-Active" ? azurerm_network_interface.secondary_trusted[0].private_ip_address : ""}"
  })
}

resource "azurerm_virtual_machine_extension" "secondary_config" {
  count                = var.scenario_option == "Active-Active" ? 1 : 0
  name                 = "CustomScript"
  virtual_machine_id   = azurerm_linux_virtual_machine.secondary[0].id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"
  auto_upgrade_minor_version = false

  settings = jsonencode({
    fileUris = [
      "${var.opn_script_uri}${var.shell_script_name}"
    ]
    commandToExecute = "sh ${var.shell_script_name} ${var.opn_script_uri} ${var.opn_version} ${var.wa_linux_version} Secondary ${local.trusted_subnet_cidr} ${local.windows_subnet_cidr} ${azurerm_public_ip.opnsense.ip_address} "
  })
}

resource "azurerm_virtual_machine_extension" "single_config" {
  count                = var.scenario_option == "TwoNics" ? 1 : 0
  name                 = "CustomScript"
  virtual_machine_id   = azurerm_linux_virtual_machine.single[0].id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"
  auto_upgrade_minor_version = false

  settings = jsonencode({
    fileUris = [
      "${var.opn_script_uri}${var.shell_script_name}"
    ]
    commandToExecute = "sh ${var.shell_script_name} ${var.opn_script_uri} ${var.opn_version} ${var.wa_linux_version} TwoNics ${local.trusted_subnet_cidr} ${local.windows_subnet_cidr}  "
  })
}

# Windows VM Resources (optional)
resource "azurerm_public_ip" "windows" {
  count               = var.deploy_windows ? 1 : 0
  name                = "VM-Win11Client-PublicIP"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "OPNsense"
  }
}

resource "azurerm_network_security_group" "windows" {
  count               = var.deploy_windows ? 1 : 0
  name                = "VM-Win11Client-NSG"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "OPNsense"
  }
}

resource "azurerm_route_table" "windows" {
  count               = var.deploy_windows ? 1 : 0
  name                = "winvmroutetable"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = {
    Environment = "OPNsense"
  }
}

resource "azurerm_subnet_route_table_association" "windows" {
  count          = var.deploy_windows ? 1 : 0
  subnet_id      = local.windows_subnet_id
  route_table_id = azurerm_route_table.windows[0].id
}

resource "azurerm_network_interface" "windows" {
  count               = var.deploy_windows ? 1 : 0
  name                = "VM-Win11Client-NIC"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.windows_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows[0].id
  }

  tags = {
    Environment = "OPNsense"
  }
}

resource "azurerm_network_interface_security_group_association" "windows" {
  count                     = var.deploy_windows ? 1 : 0
  network_interface_id      = azurerm_network_interface.windows[0].id
  network_security_group_id = azurerm_network_security_group.windows[0].id
}

resource "azurerm_windows_virtual_machine" "windows" {
  count               = var.deploy_windows ? 1 : 0
  name                = "VM-Win11Client"
  location            = var.location != null ? var.location : data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = "Standard_B2s"
  admin_username      = var.win_username
  admin_password      = var.win_password

  network_interface_ids = [
    azurerm_network_interface.windows[0].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-22h2-pro"
    version   = "latest"
  }

  tags = {
    Environment = "OPNsense"
  }
}
