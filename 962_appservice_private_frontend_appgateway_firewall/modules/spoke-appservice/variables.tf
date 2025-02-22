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

variable "private_dns_zone_id_appservice" {
  type = string
}

variable "dns_forwarding_ruleset_id" {
  type = string
}