variable "prefix" {
  description = "Prefix for resources"
  type        = string
  default     = "210"
}

variable "spoke_vnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "hub_firewall_private_ip_address" {
  description = "Private IP address of the hub firewall"
  type        = string
}

variable "snet_hub_firewall_cidr" {
  description = "CIDR for the hub firewall subnet"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
  default     = "vnet-hub"
}

variable "hub_vnet_rg_name" {
  description = "Resource group name for the hub virtual network"
  type        = string
}

variable "hub_vnet_id" {
  description = "ID of the hub virtual network"
  type        = string
}