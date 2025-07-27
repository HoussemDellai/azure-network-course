# Variables for OPNsense Terraform Deployment

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "scenario_option" {
  description = "Select a valid scenario. Active-Active: Two OPNSenses deployed in HA mode using SLB and ILB. TwoNics: Single OPNSense deployed with two Nics."
  type        = string
  default     = "TwoNics"
  validation {
    condition     = contains(["Active-Active", "TwoNics"], var.scenario_option)
    error_message = "Scenario option must be either 'Active-Active' or 'TwoNics'."
  }
}

variable "virtual_machine_size" {
  description = "VM size, please choose a size which allow 2 NICs."
  type        = string
  default     = "Standard_B2s"
}

variable "virtual_machine_name" {
  description = "OPN NVA Machine Name"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual Network Name. This is a required parameter to build a new VNet or find an existing one."
  type        = string
  default     = "OPN-VNET"
}

variable "existing_virtual_network" {
  description = "Use Existing Virtual Network. The value must be new or existing."
  type        = string
  default     = "new"
}

variable "vnet_address" {
  description = "Virtual Network Address Space. Only required if you want to create a new VNet."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "untrusted_subnet_cidr" {
  description = "Untrusted-Subnet Address Space. Only required if you want to create a new VNet."
  type        = string
  default     = "10.0.0.0/24"
}

variable "trusted_subnet_cidr" {
  description = "Trusted-Subnet Address Space. Only required if you want to create a new VNet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "existing_untrusted_subnet_name" {
  description = "Untrusted-Subnet Name. Only required if you want to use an existing VNet and Subnet."
  type        = string
  default     = ""
}

variable "existing_trusted_subnet_name" {
  description = "Trusted-Subnet Name. Only required if you want to use an existing VNet and Subnet."
  type        = string
  default     = ""
}

variable "public_ip_address_sku" {
  description = "Specify Public IP SKU either Basic (lowest cost) or Standard (Required for HA LB)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.public_ip_address_sku)
    error_message = "Public IP SKU must be either 'Basic' or 'Standard'."
  }
}

variable "opn_script_uri" {
  description = "URI for Custom OPN Script and Config"
  type        = string
  default     = "https://raw.githubusercontent.com/dmauser/opnazure/master/scripts/"
}

variable "shell_script_name" {
  description = "Shell Script to be executed"
  type        = string
  default     = "configureopnsense.sh"
}

variable "opn_version" {
  description = "OPN Version"
  type        = string
  default     = "25.1"
}

variable "wa_linux_version" {
  description = "Azure WALinux agent Version"
  type        = string
  default     = "2.12.0.4"
}

variable "deploy_windows" {
  description = "Deploy Windows VM Trusted Subnet"
  type        = bool
  default     = false
}

variable "win_username" {
  description = "Only required in case of Deploying Windows VM. Windows Admin username (Used to login in Windows VM)."
  type        = string
  default     = ""
}

variable "win_password" {
  description = "Only required in case of Deploying Windows VM. Windows Password (Used to login in Windows VM)."
  type        = string
  default     = ""
  sensitive   = true
}

variable "existing_windows_subnet" {
  description = "Existing Windows Subnet Name. Only required in case of deploying Windows in an existing subnet."
  type        = string
  default     = ""
}

variable "deploy_windows_subnet" {
  description = "In case of deploying Windows in a New VNet this will be the Windows VM Subnet Address Space"
  type        = string
  default     = "10.0.2.0/24"
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = null
}
