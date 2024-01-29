variable "name" {
  type    = string
  default = "bastion-host"
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type    = string
  default = "Standard"
  validation {
    condition     = can(regex("^(Developer|Basic|Standard)$", var.sku))
    error_message = "Valid values are Developer, Basic or Standard"
  }
}