# Variables for OPNsense Terraform Deployment
# Converted from ARM template parameters

variable "resource_group_name" {
  description = "Name of the resource group to deploy resources into"
  type        = string
}

variable "location" {
  description = "Azure location/region for the resources"
  type        = string
  default     = null
}

variable "scenario_option" {
  description = "Deployment scenario - TwoNics for single firewall or Active-Active for HA pair"
  type        = string
  default     = "TwoNics"
  validation {
    condition     = contains(["TwoNics", "Active-Active"], var.scenario_option)
    error_message = "Scenario option must be either 'TwoNics' or 'Active-Active'."
  }
}

variable "virtual_machine_name" {
  description = "Name for the OPNsense virtual machine"
  type        = string
  default     = "OPNsenseWAF"
}

variable "virtual_machine_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "existing_virtual_network" {
  description = "Use existing virtual network or create new one (use 'new' to create new)"
  type        = string
  default     = "new"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "untrusted_subnet_cidr" {
  description = "CIDR block for the untrusted subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "trusted_subnet_cidr" {
  description = "CIDR block for the trusted subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "existing_untrusted_subnet_name" {
  description = "Name of existing untrusted subnet (if using existing VNet)"
  type        = string
  default     = ""
}

variable "existing_trusted_subnet_name" {
  description = "Name of existing trusted subnet (if using existing VNet)"
  type        = string
  default     = ""
}

variable "existing_windows_subnet" {
  description = "Name of existing Windows subnet (if using existing VNet and deploying Windows)"
  type        = string
  default     = ""
}

variable "deploy_windows" {
  description = "Whether to deploy a Windows test VM"
  type        = bool
  default     = false
}

variable "deploy_windows_subnet" {
  description = "CIDR block for the Windows VM subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "win_username" {
  description = "Username for the Windows VM"
  type        = string
  default     = "azureuser"
}

variable "win_password" {
  description = "Password for the Windows VM"
  type        = string
  sensitive   = true
}

variable "public_ip_address_sku" {
  description = "SKU for the public IP address"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_address_sku)
    error_message = "Public IP SKU must be either 'Basic' or 'Standard'."
  }
}

variable "opn_script_uri" {
  description = "Base URI for OPNsense configuration scripts"
  type        = string
  default     = "https://raw.githubusercontent.com/dmauser/azure-virtualwan/main/natvpn-over-er/opnsense/"
}

variable "shell_script_name" {
  description = "Name of the shell script for OPNsense configuration"
  type        = string
  default     = "configureopnsense.sh"
}

variable "opn_version" {
  description = "OPNsense version to install"
  type        = string
  default     = "24.1"
}

variable "wa_linux_version" {
  description = "Azure Linux Agent version"
  type        = string
  default     = "2.9.1.1"
}
