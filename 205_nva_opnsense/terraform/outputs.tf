# Output values for OPNsense deployment

output "opnsense_public_ip" {
  description = "Public IP address of the OPNsense firewall"
  value       = azurerm_public_ip.opnsense.ip_address
}

output "opnsense_fqdn" {
  description = "FQDN of the OPNsense firewall public IP"
  value       = azurerm_public_ip.opnsense.fqdn
}

output "opnsense_web_interface" {
  description = "URL to access OPNsense web interface"
  value = var.scenario_option == "Active-Active" ? {
    primary   = "https://${azurerm_public_ip.opnsense.ip_address}:50443"
    secondary = "https://${azurerm_public_ip.opnsense.ip_address}:50444"
  } : "https://${azurerm_public_ip.opnsense.ip_address}"
}

output "internal_load_balancer_ip" {
  description = "Internal load balancer IP address (Active-Active scenario only)"
  value       = var.scenario_option == "Active-Active" ? azurerm_lb.internal[0].frontend_ip_configuration[0].private_ip_address : null
}

output "windows_vm_public_ip" {
  description = "Public IP address of the Windows test VM"
  value       = var.deploy_windows ? azurerm_public_ip.windows[0].ip_address : null
}

output "windows_vm_rdp" {
  description = "RDP connection string for Windows test VM"
  value       = var.deploy_windows ? "mstsc /v:${azurerm_public_ip.windows[0].ip_address}" : null
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = local.use_existing_vnet ? data.azurerm_resource_group.main.id : azurerm_virtual_network.main[0].id
}

output "subnet_ids" {
  description = "IDs of the created/used subnets"
  value = {
    untrusted = local.untrusted_subnet_id
    trusted   = local.trusted_subnet_id
    windows   = var.deploy_windows ? local.windows_subnet_id : null
  }
}

output "deployment_scenario" {
  description = "Deployment scenario used"
  value       = var.scenario_option
}

output "vm_names" {
  description = "Names of the deployed OPNsense VMs"
  value = var.scenario_option == "Active-Active" ? [
    azurerm_linux_virtual_machine.primary[0].name,
    azurerm_linux_virtual_machine.secondary[0].name
  ] : [azurerm_linux_virtual_machine.single[0].name]
}

output "resource_group" {
  description = "Resource group information"
  value = {
    name     = data.azurerm_resource_group.main.name
    location = data.azurerm_resource_group.main.location
  }
}
