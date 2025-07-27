# Local values for OPNsense Terraform Deployment

locals {
  temp_username = "azureuser"
  temp_password = "TempPassword123!"

  untrusted_subnet_name     = "Untrusted-Subnet"
  trusted_subnet_name       = "Trusted-Subnet"
  windows_vm_subnet_name    = "Windows-VM-Subnet"

  # Determine subnet IDs based on whether using existing or new VNet
  untrusted_subnet_id = var.existing_virtual_network == "new" ? azurerm_subnet.untrusted[0].id : data.azurerm_subnet.existing_untrusted[0].id
  trusted_subnet_id   = var.existing_virtual_network == "new" ? azurerm_subnet.trusted[0].id : data.azurerm_subnet.existing_trusted[0].id
  windows_subnet_id   = var.deploy_windows ? (var.existing_virtual_network == "new" ? azurerm_subnet.windows[0].id : data.azurerm_subnet.existing_windows[0].id) : ""

  # Full subnet names for script parameters
  trusted_subnet_full_name = "${var.virtual_network_name}/${var.existing_virtual_network == "new" ? local.trusted_subnet_name : var.existing_trusted_subnet_name}"
  windows_subnet_full_name = var.deploy_windows ? "${var.virtual_network_name}/${var.existing_virtual_network == "new" ? local.windows_vm_subnet_name : var.existing_windows_subnet}" : ""

  # Get actual subnet CIDR for script parameters
  trusted_subnet_cidr_actual = var.existing_virtual_network == "new" ? var.trusted_subnet_cidr : (
    var.existing_virtual_network != "new" && var.deploy_windows ? data.azurerm_subnet.existing_trusted[0].address_prefixes[0] : ""
  )
  
  windows_subnet_cidr_actual = var.deploy_windows ? (
    var.existing_virtual_network == "new" ? var.deploy_windows_subnet : data.azurerm_subnet.existing_windows[0].address_prefixes[0]
  ) : "1.1.1.1/32"
}
