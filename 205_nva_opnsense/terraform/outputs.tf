# Outputs for OPNsense Terraform Deployment

output "opnsense_public_ip" {
  description = "Public IP address of the OPNsense firewall"
  value       = azurerm_public_ip.opnsense.ip_address
}

output "opnsense_resource_group" {
  description = "Resource group name"
  value       = data.azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = var.virtual_network_name
}

output "scenario_deployed" {
  description = "Deployment scenario used"
  value       = var.scenario_option
}

# Primary VM outputs (Active-Active scenario)
output "primary_vm_untrusted_ip" {
  description = "Primary VM untrusted NIC IP address"
  value       = var.scenario_option == "Active-Active" ? module.opnsense_primary[0].untrusted_nic_ip : null
}

output "primary_vm_trusted_ip" {
  description = "Primary VM trusted NIC IP address"
  value       = var.scenario_option == "Active-Active" ? module.opnsense_primary[0].trusted_nic_ip : null
}

# Secondary VM outputs (Active-Active scenario)
output "secondary_vm_untrusted_ip" {
  description = "Secondary VM untrusted NIC IP address"
  value       = var.scenario_option == "Active-Active" ? module.opnsense_secondary[0].untrusted_nic_ip : null
}

output "secondary_vm_trusted_ip" {
  description = "Secondary VM trusted NIC IP address"
  value       = var.scenario_option == "Active-Active" ? module.opnsense_secondary[0].trusted_nic_ip : null
}

# Single VM outputs (TwoNics scenario)
output "single_vm_untrusted_ip" {
  description = "Single VM untrusted NIC IP address"
  value       = var.scenario_option == "TwoNics" ? module.opnsense_single[0].untrusted_nic_ip : null
}

output "single_vm_trusted_ip" {
  description = "Single VM trusted NIC IP address"
  value       = var.scenario_option == "TwoNics" ? module.opnsense_single[0].trusted_nic_ip : null
}

# Windows VM outputs (if deployed)
output "windows_vm_private_ip" {
  description = "Windows VM private IP address"
  value       = var.deploy_windows ? module.windows_vm[0].private_ip_address : null
}

output "windows_vm_public_ip" {
  description = "Windows VM public IP address"
  value       = var.deploy_windows ? module.windows_vm[0].public_ip_address : null
}

# Load balancer outputs (Active-Active scenario)
output "external_load_balancer_frontend_ip" {
  description = "External load balancer frontend IP"
  value       = var.scenario_option == "Active-Active" ? azurerm_public_ip.opnsense.ip_address : null
}

output "internal_load_balancer_frontend_ip" {
  description = "Internal load balancer frontend IP"
  value       = var.scenario_option == "Active-Active" ? module.internal_load_balancer[0].frontend_ip : null
}

# Management URLs
output "opnsense_management_urls" {
  description = "OPNsense management URLs"
  value = var.scenario_option == "Active-Active" ? {
    primary_vm   = "https://${azurerm_public_ip.opnsense.ip_address}:50443"
    secondary_vm = "https://${azurerm_public_ip.opnsense.ip_address}:50444"
  } : {
    single_vm = "https://${azurerm_public_ip.opnsense.ip_address}"
  }
}
