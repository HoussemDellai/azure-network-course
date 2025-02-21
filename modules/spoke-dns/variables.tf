variable "prefix" {
  type    = string
  default = "962"
}

variable "location" {
  type    = string
  default = "swedencentral"
}

variable "vnet_ids" {
  type = set(string)
}

variable "spoke_dns_vnet_cidr" {
  type = string
}