variable "prefix" {
  type    = string
  default = "961"
}

variable "location" {
  type    = string
  default = "swedencentral"
}

variable "hub_vnet_id" {
  type = string
}

variable "hub_vnet_rg_name" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "spoke_vnet_cidr" {
  type = string
}

variable "firewall_private_ip" {
  type = string
}