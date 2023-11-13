variable "vm_admin_username" {
  description = "The username for the VM"
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "The password for the VM"
  default     = "@Aa123456789"
}

variable "tags" {
  default = {
    topology = "hub-spoke"
  }
}
